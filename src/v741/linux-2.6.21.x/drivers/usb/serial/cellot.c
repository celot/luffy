/*
  USB Driver for Celot Wireless

  Copyright (C) 2006, 2007, 2008  
 
  IMPORTANT DISCLAIMER: This driver is not commercially supported by
  Celot Wireless. Use at your own risk.

  This driver is free software; you can redistribute it and/or modify
  it under the terms of Version 2 of the GNU General Public License as
  published by the Free Software Foundation.

  Portions based on the option driver by Matthias Urlichs <smurf@smurf.noris.de>
  Whom based his on the Keyspan driver by Hugh Blemings <hugh@blemings.org>

  Back ported to kernel 2.6.21
*/
/* Uncomment to log function calls */
/* #define DEBUG  */
#define DRIVER_VERSION "v.1.7.40"
#define DRIVER_AUTHOR "Kevin Lloyd, Elina Pasheva, Matthew Safar, Rory Filer"
#define DRIVER_DESC "USB Driver for Celot Wireless USB modems"

#include <linux/kernel.h>
#include <linux/jiffies.h>
#include <linux/errno.h>
#include <linux/tty.h>
#include <linux/tty_flip.h>
#include <linux/module.h>
#include <linux/usb.h>
#include <linux/usb/serial.h>
#include <asm/unaligned.h>

#if 0
#undef dbg
#undef dev_dbg
#undef dev_err
#undef dev_info
#undef dev_warn
#undef dev_notice
#define dbg(format, arg...) do { printk("%s: " format "\n" , __FILE__ , ## arg); } while (0)
//#define dbg(format, arg...)
//#define dev_dbg(dev, format, arg...) do { printk("%s: " format "\n" , __FILE__ , ## arg); } while (0)
#define dev_dbg(dev, format, arg...)
#define dev_err(dev, format, arg...) do { printk("%s: " format "\n" , __FILE__ , ## arg); } while (0)
#define dev_info(dev, format, arg...) do { printk("%s: " format "\n" , __FILE__ , ## arg); } while (0)
#define dev_warn(dev, format, arg...) do { printk("%s: " format "\n" , __FILE__ , ## arg); } while (0)
#define dev_notice(dev, format, arg...) do { printk("%s: " format "\n" , __FILE__ , ## arg); } while (0)
#endif

#define SWIMS_USB_REQUEST_SetPower	0x00
#define SWIMS_USB_REQUEST_SetNmea	0x07
#define SWIMS_USB_REQUEST_SetMode	0x0B
#define SWIMS_SET_MODE_Modem		0x0001
#define USB_REQUEST_TYPE_CLASS		0xA1
#define USB_REQUEST_IFACE		0x20

#define N_IN_URB_HM	8
#define N_OUT_URB_HM	64
#define N_IN_URB	4
#define N_OUT_URB	4
#define IN_BUFLEN	4096

#define MAX_TRANSFER		(PAGE_SIZE - 512)
/* MAX_TRANSFER is chosen so that the VM is not stressed by
   allocations > PAGE_SIZE and the number of packets in a page
   is an integer 512 is the largest possible packet on EHCI */


static int debug;
static int nmea;
static int truinstall = 1;

enum devicetype {
	DEVICE_MODEM =		0,
	DEVICE_INSTALLER =	1,
};

/* Used in interface blacklisting */
struct celot_iface_info {
	const u32 infolen;	/* number of interface numbers on blacklist */
	const u8  *ifaceinfo;	/* pointer to the array holding the numbers */
};

/* static device type specific data */
struct celot_device_static_info {
	const enum devicetype		dev_type;
	const struct celot_iface_info	iface_blacklist;
};

static inline u16 get_unaligned_le16(const void *p)
{
	return le16_to_cpu(get_unaligned((const u16*)p));
}

static int celot_set_power_state(struct usb_device *udev, __u16 swiState)
{
	int result;
	dev_dbg(&udev->dev, "%s\n", __func__);
	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
			SWIMS_USB_REQUEST_SetPower,	/* __u8 request      */
			USB_TYPE_VENDOR,		/* __u8 request type */
			swiState,			/* __u16 value       */
			0,				/* __u16 index       */
			NULL,				/* void *data        */
			0,				/* __u16 size 	     */
			100/*USB_CTRL_SET_TIMEOUT*/);		/* int timeout 	     */
	return result;
}

static int celot_set_ms_mode(struct usb_device *udev, __u16 eSWocMode)
{
	int result;
	dev_dbg(&udev->dev, "%s\n", "DEVICE MODE SWITCH");
	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
			SWIMS_USB_REQUEST_SetMode,	/* __u8 request      */
			USB_TYPE_VENDOR,		/* __u8 request type */
			eSWocMode,			/* __u16 value       */
			0x0000,				/* __u16 index       */
			NULL,				/* void *data        */
			0,				/* __u16 size 	     */
			100/*USB_CTRL_SET_TIMEOUT*/);		/* int timeout       */
	return result;
}

static int celot_vsc_set_nmea(struct usb_device *udev, __u16 enable)
{
	int result;
	dev_dbg(&udev->dev, "%s\n", __func__);
	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
			SWIMS_USB_REQUEST_SetNmea,	/* __u8 request      */
			USB_TYPE_VENDOR,		/* __u8 request type */
			enable,				/* __u16 value       */
			0x0000,				/* __u16 index       */
			NULL,				/* void *data        */
			0,				/* __u16 size 	     */
			100/*USB_CTRL_SET_TIMEOUT*/);		/* int timeout       */
	return result;
}

static int celot_calc_num_ports(struct usb_serial *serial)
{
	int num_ports = 0;
	u8 ifnum, numendpoints;
	
	dev_dbg(&serial->dev->dev, "%s\n", __func__);
	
	ifnum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
	numendpoints = serial->interface->cur_altsetting->desc.bNumEndpoints;
	
	/* Dummy interface present on some SKUs should be ignored */
	if (ifnum == 0x99)
		num_ports = 0;
	else if (numendpoints <= 3)
		num_ports = 1;
	else
		num_ports = (numendpoints-1)/2;
	return num_ports;
}

static int is_blacklisted(const u8 ifnum,
				const struct celot_iface_info *blacklist)
{
	const u8  *info;
	int i;
	if (blacklist) 
	{
		info = blacklist->ifaceinfo;
		for (i = 0; i < blacklist->infolen; i++) 
		{
			if (info[i] == ifnum)
				return 1;
		}
	}
	return 0;
}

#if 0
static int is_himemory(const u8 ifnum,
				const struct celot_iface_info *himemorylist)
{
	const u8  *info;
	int i;

	if (himemorylist) {
		info = himemorylist->ifaceinfo;

		for (i=0; i < himemorylist->infolen; i++) {
			if (info[i] == ifnum)
				return 1;
		}
	}
	return 0;
}
#endif

static int celot_calc_interface(struct usb_serial *serial)
{
	int interface;
	struct usb_interface *p_interface;
	struct usb_host_interface *p_host_interface;
	dev_dbg(&serial->dev->dev, "%s\n", __func__);

	/* Get the interface structure pointer from the serial struct */
	p_interface = serial->interface;

	/* Get a pointer to the host interface structure */
	p_host_interface = p_interface->cur_altsetting;

	/* read the interface descriptor for this active altsetting
	 * to find out the interface number we are on
	*/
	interface = p_host_interface->desc.bInterfaceNumber;

	return interface;
}

static int celot_probe(struct usb_serial *serial,
			const struct usb_device_id *id)
{
	const struct celot_device_static_info *info;
	int result = 0;
	struct usb_device *udev;
	u8 ifnum, ifclass; 

	udev = serial->dev;
	dev_dbg(&udev->dev, "%s\n", __func__);

	/* Check TRU-Install first */
	info = (const struct celot_device_static_info *)id->driver_info;
	ifclass = serial->interface->cur_altsetting->desc.bInterfaceClass;

	if (ifclass == USB_CLASS_MASS_STORAGE) {
		/* If TRU-Install support is enabled, force to modem mode */
		if (truinstall && info && info->dev_type == DEVICE_INSTALLER) {
			dev_dbg(&udev->dev, "%s\n", "FOUND TRU-INSTALL DEVICE");
			result = celot_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
		}
		return -ENODEV;
	}

	ifnum = celot_calc_interface(serial);
	if (info && is_blacklisted(ifnum, &info->iface_blacklist)) 
	{
		dev_dbg(&serial->dev->dev,
			"Ignoring blacklisted interface #%d\n", ifnum);
		return -ENODEV;
	}
	/*
	 * If this interface supports more than 1 alternate
	 * select the 2nd one
	 */
	if (serial->interface->num_altsetting == 2) {
		dev_dbg(&udev->dev, "Selecting alt setting for interface %d\n",
			ifnum);
		/* We know the alternate setting is 1 for the MC8785 */
		usb_set_interface(udev, ifnum, 1);
	}
	/* Be careful here, The ifnum, ifclass etc. might be incorrect, because
	 * of the usb_set_interface call. (all obtained using 
	 * serial->interface->cur_altsetting that was changed by that call)
	 */
	
	return result;
}

#if 0
static const struct celot_device_static_info tru_inst_info = {
	.dev_type = DEVICE_INSTALLER,
};

/* interfaces with higher memory requirements */
static const u8 hi_memory_typeA_ifaces[] = { 0, 2 };
static const struct celot_iface_info typeA_interface_list = {
	.infolen = ARRAY_SIZE(hi_memory_typeA_ifaces),
	.ifaceinfo = hi_memory_typeA_ifaces,
};

static const u8 hi_memory_typeB_ifaces[] = { 3, 4, 5, 6 };
static const struct celot_iface_info typeB_interface_list = {
	.infolen = ARRAY_SIZE(hi_memory_typeB_ifaces),
	.ifaceinfo = hi_memory_typeB_ifaces,
};

/* 'blacklist' of interfaces not served by this driver */
static const u8 direct_ip_non_serial_ifaces[] = { 7, 8, 9, 10, 11 };
static const struct celot_device_static_info direct_ip_interface_blacklist = {
	.dev_type = DEVICE_MODEM,
	.iface_blacklist = {
		.infolen = ARRAY_SIZE( direct_ip_non_serial_ifaces ),
		.ifaceinfo = direct_ip_non_serial_ifaces,
	},
};
#endif


static const u8 qmi_non_serial_ifaces[] = { 4,5,6,7,8 };
static const struct celot_device_static_info qmi_interface_blacklist = {
	.dev_type = DEVICE_MODEM,
	.iface_blacklist = {
		.infolen = ARRAY_SIZE( qmi_non_serial_ifaces ),
		.ifaceinfo = qmi_non_serial_ifaces,
	},
};
#define CELOT_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod), \
	.driver_info = (unsigned long)&qmi_interface_blacklist

static const u8 qmi_non_serial_5_ifaces[] = { 6,7,8 };
static const struct celot_device_static_info qmi_interface_5_blacklist = {
	.dev_type = DEVICE_MODEM,
	.iface_blacklist = {
		.infolen = ARRAY_SIZE( qmi_non_serial_5_ifaces ),
		.ifaceinfo = qmi_non_serial_5_ifaces,
	},
};
#define CELOT_5_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod), \
	.driver_info = (unsigned long)&qmi_interface_5_blacklist


static const u8 qmi_pantech_pm_l300_ifaces[] = { 1,2,3,4,5};
static const struct celot_device_static_info qmi_pantech_pm_l300_blacklist = {
	.dev_type = DEVICE_MODEM,
	.iface_blacklist = {
		.infolen = ARRAY_SIZE( qmi_pantech_pm_l300_ifaces ),
		.ifaceinfo = qmi_pantech_pm_l300_ifaces,
	},
};
#define CELOT_PM_L300_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod), \
	.driver_info = (unsigned long)&qmi_pantech_pm_l300_blacklist

static const u8 kddi_kym11_ifaces[] = { 0,1,2,3,6};
static const struct celot_device_static_info kddi_kym11_blacklist = {
	.dev_type = DEVICE_MODEM,
	.iface_blacklist = {
		.infolen = ARRAY_SIZE( kddi_kym11_ifaces ),
		.ifaceinfo = kddi_kym11_ifaces,
	},
};
#define CELOT_KYM11_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod), \
	.driver_info = (unsigned long)&kddi_kym11_blacklist

static const u8 kddi_7100_ifaces[] = { 4,5,6};
static const struct celot_device_static_info kddi_sim7100_blacklist = {
	.dev_type = DEVICE_MODEM,
	.iface_blacklist = {
		.infolen = ARRAY_SIZE( kddi_7100_ifaces ),
		.ifaceinfo = kddi_7100_ifaces,
	},
};
#define CELOT_SIM7100_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod), \
	.driver_info = (unsigned long)&kddi_sim7100_blacklist

static const struct usb_device_id id_table [] = {
	{ CELOT_DEVICE(0x211f, 0x6801) }, 
	{ CELOT_DEVICE(0x211f, 0x6801) }, 
	{ CELOT_DEVICE(0x211f, 0x6802) }, 			
	{ CELOT_DEVICE(0x211f, 0x6803) }, 
	{ CELOT_DEVICE(0x211f, 0x6804) }, 
	{ CELOT_DEVICE(0x211f, 0x6805) }, 
	{ CELOT_DEVICE(0x211f, 0x6806) }, 
	{ CELOT_DEVICE(0x211f, 0x6807) },
	{ CELOT_DEVICE(0x211f, 0x6808) }, 	
	{ CELOT_DEVICE(0x211f, 0x6809) }, 	
	{ CELOT_DEVICE(0x05c6, 0x9001) }, 
	{ CELOT_DEVICE(0x05c6, 0x9002) }, 
	{ CELOT_DEVICE(0x05c6, 0x9003) }, 
	{ CELOT_DEVICE(0x05c6, 0x9004) }, 
	{ CELOT_DEVICE(0x05c6, 0x9025) }, 	/* AME522 */
	{ CELOT_DEVICE(0x1ECB, 0x03E8) }, 	/* AME5210 */	

	{ USB_DEVICE(0x1ECB, 0x03E1) }, 	/* AME5210? */	

	{ CELOT_DEVICE(0x16d5, 0x6294) }, 	
	{ CELOT_DEVICE(0x1e2d, 0x0053) }, 	//CINTERION
	{ CELOT_DEVICE(0x1e2d, 0x0060) }, 	//CINTERION

	{ CELOT_5_DEVICE(0x16D5, 0x9201) }, 	//ANYDATA DTM920
	{ CELOT_PM_L300_DEVICE(0x10A9, 0x1104) }, 	//Pantech PM-L300
	{ CELOT_PM_L300_DEVICE(0x10A9, 0x6053) },	//Pantech PM-L300	

	{ CELOT_SIM7100_DEVICE(0x1E0E, 0x9001) }, 	//SIM7100, simtech
	
	{ }
};
MODULE_DEVICE_TABLE(usb, id_table);

static struct usb_driver celot_driver = {
	.name       = "celot",
	.probe      = usb_serial_probe,
	.disconnect = usb_serial_disconnect,
	.id_table   = id_table,
};

struct celot_port_private {
	spinlock_t lock;	/* lock the structure */
	int outstanding_urbs;	/* number of out urbs in flight */

	int num_out_urbs;
	int num_in_urbs;
	/* Input endpoints and buffers for this port */
	struct urb *in_urbs[N_IN_URB_HM];

	/* Settings for the port */
	int rts_state;	/* Handshaking pins (outputs) */
	int dtr_state;
	int cts_state;	/* Handshaking pins (inputs) */
	int dsr_state;
	int dcd_state;
	int ri_state;
};

static int celot_send_setup(struct usb_serial_port *port)
{
	struct usb_serial *serial = port->serial;
	struct celot_port_private *portdata;
	__u16 interface = 0;

	dev_dbg(&port->dev, "%s\n", __func__);

	portdata = usb_get_serial_port_data(port);

	if (port->tty) {

		int val = 0;
		if (portdata->dtr_state)
			val |= 0x01;
		if (portdata->rts_state)
			val |= 0x02;

		/* If composite device then properly report interface */
		if (serial->num_ports == 1) {
			interface = celot_calc_interface(serial);
			/* Control message is send only to interfaces with 
			 * interrupt_in endpoints
			 */
			if(port->interrupt_in_urb) {
				/* send control message */
				return usb_control_msg(serial->dev,
					usb_rcvctrlpipe(serial->dev, 0),
					0x22, 0x21, val, interface,
					NULL, 0, 100/*USB_CTRL_SET_TIMEOUT*/);
			}
		}

		/* Otherwise the need to do non-composite mapping */
		else {
			if (port->bulk_out_endpointAddress == 2)
				interface = 0;
			else if (port->bulk_out_endpointAddress == 4)
				interface = 1;
			else if (port->bulk_out_endpointAddress == 5)
				interface = 2;

			return usb_control_msg(serial->dev,
				usb_rcvctrlpipe(serial->dev, 0),
				0x22, 0x21, val, interface,
				NULL, 0, 100/*USB_CTRL_SET_TIMEOUT*/);

		}
	}

	return 0;
}

static void celot_set_termios(struct usb_serial_port *port,
			struct ktermios *old_termios)
{
	dev_dbg(&port->dev, "%s\n", __func__);
	celot_send_setup(port);
}

static int celot_tiocmget(struct usb_serial_port *port, struct file *file)
{
	unsigned int value;
	struct celot_port_private *portdata;

	dev_dbg(&port->dev, "%s\n", __func__);
	portdata = usb_get_serial_port_data(port);

	value = ((portdata->rts_state) ? TIOCM_RTS : 0) |
		((portdata->dtr_state) ? TIOCM_DTR : 0) |
		((portdata->cts_state) ? TIOCM_CTS : 0) |
		((portdata->dsr_state) ? TIOCM_DSR : 0) |
		((portdata->dcd_state) ? TIOCM_CAR : 0) |
		((portdata->ri_state) ? TIOCM_RNG : 0);

	return value;
}

static int celot_tiocmset(struct usb_serial_port *port, struct file *file,
			unsigned int set, unsigned int clear)
{
	struct celot_port_private *portdata;

	portdata = usb_get_serial_port_data(port);

	if (set & TIOCM_RTS)
		portdata->rts_state = 1;
	if (set & TIOCM_DTR)
		portdata->dtr_state = 1;

	if (clear & TIOCM_RTS)
		portdata->rts_state = 0;
	if (clear & TIOCM_DTR)
		portdata->dtr_state = 0;
	return celot_send_setup(port);
}
static void celot_release_urb(struct urb *urb)
{
	struct usb_serial_port *port;
	if (urb) {
		port =  urb->context;
		dev_dbg(&port->dev, "%s: %p\n", __func__, urb); 
		if (urb->transfer_buffer)
			kfree(urb->transfer_buffer);
		usb_free_urb(urb);
	}
}

static void celot_outdat_callback(struct urb *urb)
{
	struct usb_serial_port *port = urb->context;
	struct celot_port_private *portdata = usb_get_serial_port_data(port);
	int status = urb->status;
	unsigned long flags;

	dev_dbg(&port->dev, "%s - port %d\n", __func__, port->number);

	/* free up the transfer buffer, as usb_free_urb() does not do this */
	kfree(urb->transfer_buffer);

	if (status)
		dev_dbg(&port->dev, "%s - nonzero write bulk status "
		    "received: %d\n", __func__, status);

	spin_lock_irqsave(&portdata->lock, flags);
	--portdata->outstanding_urbs;
	spin_unlock_irqrestore(&portdata->lock, flags);

	usb_serial_port_softint(port);
}

/* Write */
static int celot_write(struct usb_serial_port *port,
			const unsigned char *buf, int count)
{
	struct celot_port_private *portdata = usb_get_serial_port_data(port);
	struct usb_serial *serial = port->serial;
	unsigned long flags;
	unsigned char *buffer;
	struct urb *urb;
	size_t writesize = min((size_t)count, (size_t)MAX_TRANSFER);
	int retval = 0;

	/* verify that we actually have some data to write */
	if (count == 0)
		return 0;

	dev_dbg(&port->dev, "%s: write (%zu bytes)\n", __func__, writesize);

	spin_lock_irqsave(&portdata->lock, flags);
	if (portdata->outstanding_urbs > portdata->num_out_urbs) {
		spin_unlock_irqrestore(&portdata->lock, flags);
		dev_dbg(&port->dev, "%s - write limit hit\n", __func__);
		return 0;
	}
	portdata->outstanding_urbs++;
	spin_unlock_irqrestore(&portdata->lock, flags);

	buffer = kmalloc(writesize, GFP_ATOMIC);
	if (!buffer) {
		dev_err(&port->dev, "out of memory\n");
		retval = -ENOMEM;
		goto error_no_buffer;
	}

	urb = usb_alloc_urb(0, GFP_ATOMIC);
	if (!urb) {
		dev_err(&port->dev, "no more free urbs\n");
		retval = -ENOMEM;
		goto error_no_urb;
	}

	memcpy(buffer, buf, writesize); 

	usb_serial_debug_data(debug, &port->dev, __func__, writesize, buffer);

	usb_fill_bulk_urb(urb, serial->dev,
			  usb_sndbulkpipe(serial->dev,
					  port->bulk_out_endpointAddress),
			  buffer, writesize, celot_outdat_callback, port);

        /* Handle the need to send a zero length packet */
        urb->transfer_flags |= URB_ZERO_PACKET;

	/* send it down the pipe */
	retval = usb_submit_urb(urb, GFP_ATOMIC);
	if (retval) {
		dev_err(&port->dev, "%s - usb_submit_urb(write bulk) failed "
			"with status = %d\n", __func__, retval);
		goto error;
	}

	/* we are done with this urb, so let the host driver
	 * really free it when it is finished with it */
	usb_free_urb(urb);
	
	return writesize;
error:
	usb_free_urb(urb);
error_no_urb:
	kfree(buffer);
error_no_buffer:
	spin_lock_irqsave(&portdata->lock, flags);
	--portdata->outstanding_urbs;
	spin_unlock_irqrestore(&portdata->lock, flags);
	return retval;
}

static void celot_indat_callback(struct urb *urb)
{
	int err;
	int endpoint;
	struct usb_serial_port *port = urb->context;
	struct tty_struct *tty;
	unsigned char *data = urb->transfer_buffer;
	int status = urb->status;

	endpoint = usb_pipeendpoint(urb->pipe);

	dev_dbg(&port->dev, "%s: %p\n", __func__, urb); 

	if (status) {
		dev_dbg(&port->dev, "%s: nonzero status: %d on"
			" endpoint %02x\n", __func__, status, endpoint);
	} else {
		tty = port->tty;
		if (tty) {
			if (urb->actual_length) {
				tty_buffer_request_room(tty,
					urb->actual_length);
				tty_insert_flip_string(tty, data,
					urb->actual_length);
				tty_flip_buffer_push(tty);
				usb_serial_debug_data(debug, &port->dev,
					__func__, urb->actual_length, data);
			} else {
				dev_dbg(&port->dev, "%s: empty read urb"
					" received\n", __func__);
			}
		}
	}

	/* Resubmit urb so we continue receiving */
	if (port->open_count && status != -ESHUTDOWN && status != -ENOENT) {
		err = usb_submit_urb(urb, GFP_ATOMIC);
		if (err)
			dev_err(&port->dev, "resubmit read urb failed."
				"(%d)\n", err);
	}
	
	return;
}

static void celot_instat_callback(struct urb *urb)
{
	int err;
	int status = urb->status;
	struct usb_serial_port *port =  urb->context;
	struct celot_port_private *portdata = usb_get_serial_port_data(port);
	struct usb_serial *serial = port->serial;

	dev_dbg(&port->dev, "%s: urb %p port %p has data %p\n", __func__,
		urb, port, portdata);

	if (status == 0) {
		struct usb_ctrlrequest *req_pkt =
				(struct usb_ctrlrequest *)urb->transfer_buffer;

		const u16 *sigp = (u16 *)(req_pkt + 1);
		/* usb_ctrlrequest we parsed is followed by two bytes of data
		 * make sure we received that many bytes
		 */
		if (urb->actual_length >= sizeof(*req_pkt) + sizeof(*sigp) &&
			req_pkt->bRequestType == USB_REQUEST_TYPE_CLASS && 
			req_pkt->bRequest == USB_REQUEST_IFACE) {
			int old_dcd_state;
			const u16 signals = get_unaligned_le16(sigp);

			dev_dbg(&port->dev, "%s: signal x%x\n", __func__,
				signals);

			old_dcd_state = portdata->dcd_state;
			/* Note: CTS from modem is in reverse logic! */
			portdata->cts_state = ((signals & 0x100) ? 0 : 1);
			portdata->dcd_state = ((signals & 0x01) ? 1 : 0);
			portdata->dsr_state = ((signals & 0x02) ? 1 : 0);
			portdata->ri_state = ((signals & 0x08) ? 1 : 0);

			if (port->tty && !C_CLOCAL(port->tty) &&
					old_dcd_state && !portdata->dcd_state)
				tty_hangup(port->tty);
		} else {
			/* dump the data we don't understand to log */
			usb_serial_debug_data(1, &port->dev, __func__,
				urb->actual_length, urb->transfer_buffer);
		}
	} else
		dev_dbg(&port->dev, "%s: error %d\n", __func__, status);

	/* Resubmit urb so we continue receiving IRQ data */
	if (port->open_count &&
		status != -ESHUTDOWN && status != -ENOENT && status != -ENODEV) {
		urb->dev = serial->dev;
		err = usb_submit_urb(urb, GFP_ATOMIC);
		if (err && err != -ENODEV)
			dev_err(&port->dev, "%s: resubmit intr urb "
				"failed. (%d)\n", __func__, err);
	}
}

static int celot_write_room(struct usb_serial_port *port)
{
	struct celot_port_private *portdata = usb_get_serial_port_data(port);
	unsigned long flags;
	int retval;

	dev_dbg(&port->dev, "%s - port %d\n", __func__, port->number);

	/* try to give a good number back based on if we have any free urbs at
	 * this point in time */
	retval = MAX_TRANSFER;

	spin_lock_irqsave(&portdata->lock, flags);
	if (portdata->outstanding_urbs >= portdata->num_out_urbs) {
		retval = 0;
	}
	spin_unlock_irqrestore(&portdata->lock, flags);

	return retval;
}

static void celot_stop_rx_urbs(struct usb_serial_port *port)
{
	int i;
	struct celot_port_private *portdata = usb_get_serial_port_data(port);
	
	for (i = 0; i < portdata->num_in_urbs; i++) {
		usb_kill_urb(portdata->in_urbs[i]);
	}
	usb_kill_urb(port->interrupt_in_urb);
}

static int celot_submit_rx_urbs(struct usb_serial_port *port)
{
	int ok_cnt;
	int err = -EINVAL;
	int i;
	struct urb * urb;
	struct celot_port_private *portdata = usb_get_serial_port_data(port);

	ok_cnt = 0;
	for (i = 0; i < portdata->num_in_urbs; i++) {
		urb = portdata->in_urbs[i];
		if (!urb)
			continue;
		err = usb_submit_urb(urb, GFP_KERNEL);
		if (err) {
			dev_err(&port->dev, "%s: submit urb failed: %d\n",
				__func__, err );
		} else {
			ok_cnt ++;
		}
	}

	if (ok_cnt && port->interrupt_in_urb) {
		err = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
		if (err) {
			dev_err(&port->dev, "%s: submit intr urb failed: %d\n",
				__func__, err );
		}
	}

	if (ok_cnt > 0) /* at least one rx urb submitted */
		return 0;
	else
		return err;
}

static struct urb *celot_setup_urb(struct usb_serial *serial, int endpoint,
					int dir, void *ctx, int len,
					usb_complete_t callback)
{
	struct urb	*urb;
	u8		*buf;
	
	if (endpoint == -1)
		return NULL;

	urb = usb_alloc_urb( 0, GFP_KERNEL );
	if (urb == NULL) {
		dev_dbg(&serial->dev->dev, "%s: alloc for endpoint %d failed\n", 
			__func__, endpoint);
		return NULL;
	}
	
	buf = kmalloc(len, GFP_KERNEL);
	if (buf)
	{
		/* Fill URB using supplied data */
		usb_fill_bulk_urb(urb, serial->dev,
			usb_sndbulkpipe(serial->dev, endpoint) | dir,
			buf, len, callback, ctx);

		/* debug */
		dev_dbg(&serial->dev->dev,"%s %c u:%p d:%p\n", __func__, 
				dir == USB_DIR_IN?'i':'o', urb, buf );
	} else {
		dev_dbg(&serial->dev->dev,"%s %c u:%p d:%p\n", __func__, 
				dir == USB_DIR_IN?'i':'o', urb, buf );

		celot_release_urb(urb);
		urb = NULL;
	}
	
	return urb;
}

static void celot_close(struct usb_serial_port *port, struct file *filp)
{
	int i;
	struct usb_serial *serial = port->serial;
	struct celot_port_private *portdata;

	dev_dbg(&port->dev, "%s\n", __func__);
	portdata = usb_get_serial_port_data(port);

	portdata->rts_state = 0;
	portdata->dtr_state = 0;

	if (serial->dev) {
			celot_send_setup(port);

		/* Stop reading urbs */
		celot_stop_rx_urbs(port);
		/* .. and release them */
		for (i = 0; i < portdata->num_in_urbs; i++) {
			celot_release_urb(portdata->in_urbs[i]);
			portdata->in_urbs[i] = NULL;
		}
	}

	port->tty = NULL;
}

static int celot_open(struct usb_serial_port *port, struct file *filp)
{
	struct celot_port_private *portdata;
	struct usb_serial *serial = port->serial;
	int i;
	int err;
	int endpoint;
	struct urb *urb;
	//char data[10]={0,};

	portdata = usb_get_serial_port_data(port);

	dev_dbg(&port->dev, "%s\n", __func__);

	/* Set some sane defaults */
	portdata->rts_state = 1;
	portdata->dtr_state = 1;

	endpoint = port->bulk_in_endpointAddress;

	for (i = 0; i < portdata->num_in_urbs; i++) {
		urb = celot_setup_urb(serial, endpoint, USB_DIR_IN, port,
					IN_BUFLEN, celot_indat_callback);
		portdata->in_urbs[i] = urb;
	}
	/* clear halt condition */
	usb_clear_halt(serial->dev, 
			usb_sndbulkpipe(serial->dev, endpoint) | USB_DIR_IN);
		
	err = celot_submit_rx_urbs(port);
	if (err) {
		/* get rid of everything as in close */
		celot_close(port, filp);
		return err;
	}

	/* Start up the interrupt endpoint if we have one */
	if(port->interrupt_in_urb) {
		port->interrupt_in_urb->dev = port->serial->dev;
		err = usb_submit_urb(port->interrupt_in_urb, GFP_ATOMIC);
		if (err)
			dbg("%s: submit irq_in urb failed %d",
				__FUNCTION__, err);
	}
	
	celot_send_setup(port);

	return 0;
}

static int celot_startup(struct usb_serial *serial)
{
	struct usb_serial_port *port = NULL;
	struct celot_port_private *portdata = NULL;
//	struct celot_iface_info *himemoryp = NULL;
	int i;
	u8 ifnum;

	dev_dbg(&serial->dev->dev, "%s\n", __func__);

	/* Set Device mode to D0 */
	celot_set_power_state(serial->dev, 0x0000);

	/* Check NMEA and set */
	if (nmea)
		celot_vsc_set_nmea(serial->dev, 1);

	if (serial->num_ports) {
		/* Note: One big piece of memory is allocated for all ports 
		 * private data in one shot. This memory is split into equal 
		 * pieces for each port. 
		 */
		portdata = (struct celot_port_private *)kzalloc
			(sizeof(*portdata) * serial->num_ports, GFP_KERNEL);
		if (!portdata) {
			dev_dbg(&serial->dev->dev, "%s: No memory!\n", __func__);
			return -ENOMEM;
		}
	}

	/* Now setup per port private data */
	/* Note that the private space for each port is accessed by 
	 * advancing the private data pointer accordingly
	 */
	for (i = 0; i < serial->num_ports; i++, portdata++) {
		port = serial->port[i];
		/* initialize selected members of private data because these 
		 * may be referred to right away */
		spin_lock_init(&portdata->lock);
		portdata->cts_state = 1;
		ifnum = i;
		/* Assume low memory requirements */
		portdata->num_out_urbs = N_OUT_URB;
		portdata->num_in_urbs  = N_IN_URB;

#if 0
		/* Determine actual memory requirements */
		if (serial->num_ports == 1) {
			/* Get interface number for composite device */
			ifnum = celot_calc_interface(serial);
			himemoryp =
			    (struct celot_iface_info *)&typeB_interface_list;
			if (is_himemory(ifnum, himemoryp)) {
				portdata->num_out_urbs = N_OUT_URB_HM;
				portdata->num_in_urbs  = N_IN_URB_HM;
			}
		}
		else {
			himemoryp =
			    (struct celot_iface_info *)&typeA_interface_list;
			if (is_himemory(i, himemoryp)) {
				portdata->num_out_urbs = N_OUT_URB_HM;
				portdata->num_in_urbs  = N_IN_URB_HM;
			}
		}
#endif		
		dev_dbg(&serial->dev->dev, 
			"Memory usage (urbs) interface #%d, in=%d, out=%d\n",
			ifnum,portdata->num_in_urbs, portdata->num_out_urbs );
		/* Set the port private data pointer */
		usb_set_serial_port_data(port, portdata);
	}

	return 0;
}

static void celot_shutdown(struct usb_serial *serial)
{
	int i;
	struct usb_serial_port *port;

	dev_dbg(&serial->dev->dev, "%s\n", __func__);
	if (serial->num_ports > 0) {
		port = serial->port[0];
		if (port)
			/* Note: The entire piece of memory that was allocated 
			 * in the startup routine can be released by passing
			 * a pointer to the beginning of the piece.
			 * This address corresponds to the address of the chunk
			 * that was given to port 0.
		 	 */
			kfree(usb_get_serial_port_data(port));
	}

	for (i = 0; i < serial->num_ports; ++i) {
		port = serial->port[i];
		if (!port)
			continue;
		usb_set_serial_port_data(port, NULL);
	}
}


static int celot_ioctl(struct usb_serial_port *port, struct file *file,
	unsigned int cmd, unsigned long arg)
{
	int pid=0;
	int vid=0;
	int ifnum=-1;
	int iftype =-1; 

	dbg("%s: port %d cmd = 0x%04x", __FUNCTION__, port->number, cmd);

	switch (cmd) 
	{
		case 0xCE10: //get vid
			vid = port->serial->dev->descriptor.idVendor;
			if (copy_to_user((unsigned int *)arg, &vid, sizeof(int)))
				return -EFAULT;
			return 0;

		case 0xCE11: //get pid
			pid = port->serial->dev->descriptor.idProduct;
			if (copy_to_user((unsigned int *)arg, &pid, sizeof(int)))
				return -EFAULT;
			return 0;	

		case 0xCE12: //get mi	
			ifnum = celot_calc_interface(port->serial);
			if (copy_to_user((unsigned int *)arg, &ifnum, sizeof(int)))
				return -EFAULT;
			return 0;	

		case 0xCE13: //get interface type	
			vid = port->serial->dev->descriptor.idVendor;
			pid = port->serial->dev->descriptor.idProduct;
			ifnum = celot_calc_interface(port->serial);

			if(vid == 0x211f )
			{
				if(port->serial->dev->product
						  && strcmp(port->serial->dev->product,"CELOT CDMA Products")==0) //CTM-680
				{
					if(ifnum==0)
					{
						iftype = 0;//DATA
					}
					else if(ifnum==1)
					{
						iftype = 1;//DM
					}
					else if(ifnum==2)
					{
						iftype = 4;//NMEA, DATA2
					}
				}
				else //CTM-700
				{
					if(ifnum==0)
					{
						iftype = 0;//DATA
					}
					else if(ifnum==1)
					{
						iftype = 1;//DM
					}
					else if(ifnum==2)
					{
						iftype = 2;//NMEA
					}
					else if(ifnum==3)
					{
						iftype = 4;//DATA2
					}
				}
			}
			else if(vid == 0x16d5 ) //anydata
			{
				if(pid==0x9201)
				{
					if(ifnum==0)
					{
						iftype = 1;//DM
					}
					else if(ifnum==2)
					{
						iftype = 0;//DATA
					}
					else if(ifnum==3)
					{
						iftype = 2;//NMEA
					}
					else if(ifnum==4)
					{
						iftype = 4;//DATA2
					}
				}
				else
				{
				if(ifnum==0)
				{
					iftype = 0;//DATA
				}
				else if(ifnum==1)
				{
					iftype = 1;//DM
				}
				else if(ifnum==2)
				{
					iftype = 2;//NMEA
				}
				else if(ifnum==3)
				{
					iftype = 4;//DATA2
				}
			}
			}
			else if(vid == 0x05c6 )
			{
				if(pid==0x9001 || pid==0x9002 || pid==0x9003 || pid==0x9004)
				{
					if(ifnum==2)
					{
						iftype = 0;//DATA
					}
					else if(ifnum==0)
					{
						iftype = 1;//DM
					}
					else if(ifnum==1)
					{
						iftype = 2;//NMEA
					}
				}
				else  if(pid==0x9025) /* AME522 */
				{
					if(ifnum==2)
					{
						iftype = 0;//DATA
					}
					else if(ifnum==0)
					{
						iftype = 1;//DM
					}
					else if(ifnum==3)
					{
						iftype = 2;//NMEA
					}
				}
			}
			else if(vid == 0x1ECB ) /* AME5210 */
			{
				if(pid==0x03E8)
				{
					if(ifnum==1)
					{
						iftype = 0;//DATA
					}
					else if(ifnum==2)
					{
						iftype = 1;//DM
					}
					else if(ifnum==3)
					{
						iftype = 2;//NMEA
					}
				}
				else if(pid==0x03E1)
				{
					if(ifnum==3)
					{
						iftype = -1;//DATA
					}
					if(ifnum==4)
					{
						iftype = 4;//DATA2
					}
					else if(ifnum==2)
					{
						iftype = 1;//DM
					}
					else if(ifnum==6)
					{
						iftype = 2;//NMEA
					}
				}
			}
			else if(vid == 0x1e2d ) //CINTERION
			{
				if(pid == 0x0053)
				{
					if(ifnum==1)
					{
						iftype = 2;//NMEA
					}
					else if(ifnum==2)
					{
						iftype = 4;//DATA2
					}
					else if(ifnum==3)
					{
						iftype = 0;//DATA
					}
				}
				else if(pid == 0x0060)
				{
					if(ifnum==2)
					{
						iftype = 0;//data
					}
					else if(ifnum==3)
					{
						iftype = 2;//nmea
					}
				}
			}
			else if(vid == 0x10A9 ) //pantech
			{
				if(pid == 0x1104) //PM-L300
				{
					if(ifnum==0)
					{
						iftype = 1;//DM
					}						
				}
				else if(pid == 0x6053) //PM-L300P
				{
					if(ifnum==0)
					{
						iftype = 1;//DM
					}						
				}
			}
			else if(vid == 0x1E0E ) //simtech
			{
				if(pid == 0x9001) //PM-L300
				{
					if(ifnum==0)
					{
						iftype = 1;//DM
					}
					else if(ifnum==1)
					{
						iftype = 2;//NMEA
					}
					else if(ifnum==2)
					{
						iftype = 4;//DATA2
					}
					else if(ifnum==3)
					{
						iftype = 0;//Modem(data)
					}
				}
			}

			if (copy_to_user((unsigned int *)arg, &iftype, sizeof(int)))
				return -EFAULT;
			return 0;	
		

		default:
			break;
	}
	
	return -ENOIOCTLCMD;
}



static struct usb_serial_driver celot_device = {
	.driver = {
		.owner =	THIS_MODULE,
		.name =		"celot",
	},
	.description       = "Celot USB modem",
	.id_table          = id_table,
	.usb_driver        = &celot_driver,
	.num_interrupt_in  = NUM_DONT_CARE,
	.num_bulk_in       = NUM_DONT_CARE,
	.num_bulk_out      = NUM_DONT_CARE,
	.calc_num_ports	   = celot_calc_num_ports,
	.probe		   = celot_probe,
	.open              = celot_open,
	.close             = celot_close,
	.write             = celot_write,
	.write_room        = celot_write_room,
	.set_termios       = celot_set_termios,
	.tiocmget          = celot_tiocmget,
	.tiocmset          = celot_tiocmset,
	.attach            = celot_startup,
	.shutdown          = celot_shutdown,
	.read_int_callback = celot_instat_callback,
	.ioctl             = celot_ioctl,
};

/* Functions used by new usb-serial code. */
static int __init celot_init(void)
{
	int retval;
	retval = usb_serial_register(&celot_device);
	if (retval)
		goto failed_device_register;


	retval = usb_register(&celot_driver);
	if (retval)
		goto failed_driver_register;

	info(DRIVER_DESC ": " DRIVER_VERSION);

	return 0;

failed_driver_register:
	usb_serial_deregister(&celot_device);
failed_device_register:
	return retval;
}

static void __exit celot_exit(void)
{
	usb_deregister(&celot_driver);
	usb_serial_deregister(&celot_device);
}

module_init(celot_init);
module_exit(celot_exit);

MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_DESCRIPTION(DRIVER_DESC);
MODULE_VERSION(DRIVER_VERSION);
MODULE_LICENSE("GPL");

module_param(truinstall, bool, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(truinstall, "TRU-Install support");

module_param(nmea, bool, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(nmea, "NMEA streaming");

module_param(debug, bool, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(debug, "Debug messages");
