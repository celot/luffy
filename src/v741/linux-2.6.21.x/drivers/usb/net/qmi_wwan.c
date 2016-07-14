/*
 * Copyright (c) 2012  Bjørn Mork <bjorn@mork.no>
 *
 * The probing code is heavily inspired by cdc_ether, which is:
 * Copyright (C) 2003-2005 by David Brownell
 * Copyright (C) 2006 by Ole Andre Vadla Ravnas (ActiveSync)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 */

#include <linux/module.h>
#include <linux/netdevice.h>
#include <linux/ethtool.h>
#include <linux/mii.h>
#include <linux/usb.h>
#include <linux/usb/cdc.h>
#include "usbnet.h"
#include <linux/usb/cdc-wdm.h>
#include <linux/ctype.h>
#include <linux/input.h>

/* This driver supports wwan (3G/LTE/?) devices using a vendor
 * specific management protocol called Qualcomm MSM Interface (QMI) -
 * in addition to the more common AT commands over serial interface
 * management
 *
 * QMI is wrapped in CDC, using CDC encapsulated commands on the
 * control ("master") interface of a two-interface CDC Union
 * resembling standard CDC ECM.  The devices do not use the control
 * interface for any other CDC messages.  Most likely because the
 * management protocol is used in place of the standard CDC
 * notifications NOTIFY_NETWORK_CONNECTION and NOTIFY_SPEED_CHANGE
 *
 * Alternatively, control and data functions can be combined in a
 * single USB interface.
 *
 * Handling a protocol like QMI is out of the scope for any driver.
 * It is exported as a character device using the cdc-wdm driver as
 * a subdriver, enabling userspace applications ("modem managers") to
 * handle it.
 *
 * These devices may alternatively/additionally be configured using AT
 * commands on a serial interface
 */

#if 0
#undef dbg
#undef dev_dbg
#undef dev_info
#undef dev_err
#undef dev_warn
#undef dev_notice
#define dbg(format,arg...) printk("%s: " format "\n",__FILE__,##arg)
#define dev_dbg(dev, format, arg...)	 dev_printk(KERN_ERR , dev , format , ## arg)
#define dev_info(dev, format, arg...) dev_printk(KERN_ERR , dev , format , ## arg)
#define dev_err(dev, format, arg...) dev_printk(KERN_ERR , dev , format , ## arg)
#define dev_warn(dev, format, arg...) dev_printk(KERN_ERR , dev , format , ## arg)
#define dev_notice(dev, format, arg...) dev_printk(KERN_ERR , dev , format , ## arg)
#endif

/* using a counter to merge subdriver requests with our own into a combined state */
static int qmi_wwan_manage_power(struct usbnet *dev, int on)
{
	atomic_t *pmcount = (void *)&dev->data[1];
	struct usb_interface *intf = (void *)&dev->data[2];
	int rv = 0;

	dev_dbg(&intf->dev, "%s() pmcount=%d, on=%d\n", __func__, atomic_read(pmcount), on);

	if ((on && atomic_add_return(1, pmcount) == 1) || (!on && atomic_dec_and_test(pmcount))) {
		/* need autopm_get/put here to ensure the usbcore sees the new value */
		rv = usb_autopm_get_interface(intf);
		if (rv < 0)
			goto err;
		intf->needs_remote_wakeup = on;
		usb_autopm_put_interface(intf);
	}
err:
	return rv;
}


static int qmi_wwan_cdc_wdm_manage_power(struct usb_interface *intf, int on)
{
	struct usbnet *dev = usb_get_intfdata(intf);
	return qmi_wwan_manage_power(dev, on);
}


static int qmi_wwan_bind_shared(struct usbnet *dev, struct usb_interface *intf)
{
	int rv;
	struct usb_driver *subdriver = NULL;
	atomic_t *pmcount = (void *)&dev->data[1];

	if(dev->udev->descriptor.idVendor== 0x10A9 && dev->udev->descriptor.idProduct==0x6053)
	{
		if(intf->cur_altsetting->desc.bInterfaceNumber == 4)
		{
			if(intf->cur_altsetting->desc.bInterfaceClass == 0xFF && intf->cur_altsetting->desc.bInterfaceSubClass == 0xF0)
			{
				;// OK
			}
			else
			{
				dev_info(&intf->dev, "not on our whitelist - ignored\n");
				rv = -ENODEV;
				goto err;
			}
		}
		else if(intf->cur_altsetting->desc.bInterfaceNumber ==5 )
		{
			;// OK
		}
		else
		{
			dev_info(&intf->dev, "not on our whitelist - ignored\n");
			rv = -ENODEV;
			goto err;
		}
	}
	else
	{
		if (dev->driver_info->data &&
		    !test_bit(intf->cur_altsetting->desc.bInterfaceNumber, &dev->driver_info->data)) {
			dev_info(&intf->dev, "not on our whitelist - ignored\n");
			rv = -ENODEV;
			goto err;
		}
	}

	atomic_set(pmcount, 0);

	/* collect all three endpoints */
	rv = usbnet_get_endpoints(dev, intf);
	if (rv < 0)
		goto err;

	/* require interrupt endpoint for subdriver */
	if (!dev->status) {
		rv = -EINVAL;
		goto err;
	}

	subdriver = usb_cdc_wdm_register(intf, &dev->status->desc, 512, &qmi_wwan_cdc_wdm_manage_power);
	if (IS_ERR(subdriver)) {
		rv = PTR_ERR(subdriver);
		goto err;
	}

	/* can't let usbnet use the interrupt endpoint */
	dev->status = NULL;

	/* save subdriver struct for suspend/resume wrappers */
	dev->data[0] = (unsigned long)subdriver;
	dev->data[2] = (unsigned long)intf;

err:
	return rv;
}

static void qmi_wwan_unbind_shared(struct usbnet *dev, struct usb_interface *intf)
{
	struct usb_driver *subdriver = (void *)dev->data[0];

	if (subdriver && subdriver->disconnect)
		subdriver->disconnect(intf);

	dev->data[0] = (unsigned long)NULL;
}

#ifdef CONFIG_PM
/* suspend/resume wrappers calling both usbnet and the cdc-wdm
 * subdriver if present.
 *
 * NOTE: cdc-wdm also supports pre/post_reset, but we cannot provide
 * wrappers for those without adding usbnet reset support first.
 */
static int qmi_wwan_suspend(struct usb_interface *intf, pm_message_t message)
{
	struct usbnet *dev = usb_get_intfdata(intf);
	struct qmi_wwan_state *info = (void *)&dev->data;
	int ret;

	ret = usbnet_suspend(intf, message);
	if (ret < 0)
		goto err;

	if (intf == info->control && info->subdriver && info->subdriver->suspend)
		ret = info->subdriver->suspend(intf, message);
	if (ret < 0)
		usbnet_resume(intf);
err:
	return ret;
}

static int qmi_wwan_resume(struct usb_interface *intf)
{
	struct usbnet *dev = usb_get_intfdata(intf);
	struct qmi_wwan_state *info = (void *)&dev->data;
	int ret = 0;
	bool callsub = (intf == info->control && info->subdriver && info->subdriver->resume);

	if (callsub)
		ret = info->subdriver->resume(intf);
	if (ret < 0)
		goto err;
	ret = usbnet_resume(intf);
	if (ret < 0 && callsub && info->subdriver->suspend)
		info->subdriver->suspend(intf, PMSG_SUSPEND);
err:
	return ret;
}
#endif


static const struct driver_info	qmi_wwan_shared = {
	.description	= "WWAN/QMI device",
	.flags		= 0x0400,
	.bind		= qmi_wwan_bind_shared,
	.unbind		= qmi_wwan_unbind_shared,
//	.manage_power	= qmi_wwan_manage_power,
	.data		= BIT(4), /* interface whitelist bitmap */
};

static const struct driver_info	qmi_wwan_5_shared = {
	.description	= "WWAN/QMI device",
	.flags		= 0x0400,
	.bind		= qmi_wwan_bind_shared,
	.unbind		= qmi_wwan_unbind_shared,
//	.manage_power	= qmi_wwan_manage_power,
	.data		= BIT(5), /* interface whitelist bitmap */
};

static const struct driver_info	qmi_wwan_7_shared = {
	.description	= "WWAN/QMI device",
	.flags		= 0x0400,
	.bind		= qmi_wwan_bind_shared,
	.unbind		= qmi_wwan_unbind_shared,
//	.manage_power	= qmi_wwan_manage_power,
	.data		= BIT(7), /* interface whitelist bitmap */
};

static const struct driver_info	qmi_wwan_pantech_shared = {
	.description	= "WWAN/QMI device",
	.flags		= 0x0400,
	.bind		= qmi_wwan_bind_shared,
	.unbind		= qmi_wwan_unbind_shared,
//	.manage_power	= qmi_wwan_manage_power,
	.data		= BIT(4)|BIT(5), /* interface whitelist bitmap */
};

#define QMI_GOBI_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod),\
	.bInterfaceClass	= 0xFF,\
	.bInterfaceSubClass	= 0xFF,\
	.bInterfaceProtocol	= 0xFF,\
	.driver_info = (unsigned long)&qmi_wwan_shared


#define QMI_GOBI_5_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod),\
	.bInterfaceClass	= 0xFF,\
	.bInterfaceSubClass	= 0xFF,\
	.bInterfaceProtocol	= 0xFF,\
	.driver_info = (unsigned long)&qmi_wwan_5_shared

#define QMI_GOBI_7_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod),\
	.bInterfaceClass	= 0xFF,\
	.bInterfaceSubClass	= 0xFF,\
	.bInterfaceProtocol	= 0xFF,\
	.driver_info = (unsigned long)&qmi_wwan_7_shared

#define QMI_PANTECH_DEVICE(vend, prod) \
	USB_DEVICE(vend, prod),\
	.driver_info = (unsigned long)&qmi_wwan_pantech_shared

static const struct usb_device_id products[] = 
{
	{QMI_GOBI_DEVICE(0x05c6, 0x9025)},	/* AME522 */
	{QMI_GOBI_DEVICE(0x1ECB, 0x03E8)},	/* AME5210 */
	{QMI_GOBI_7_DEVICE(0x1ECB, 0x03E1)},	/* AME5210? */
	{QMI_GOBI_DEVICE(0x05c6, 0x9002)},
	{QMI_GOBI_DEVICE(0x05c6, 0x9003)},
	{QMI_GOBI_DEVICE(0x1E2D, 0x0053)},  //CINTERION-WCDMA
	{QMI_GOBI_DEVICE(0x1E2D, 0x0060)},  //CINTERION-LTE
	{QMI_GOBI_5_DEVICE(0x16D5, 0x9201)},	//ANYDATA-LTE	
	{QMI_GOBI_5_DEVICE(0x10A9, 0x1104)},	//Pantech PM-L300
	{QMI_PANTECH_DEVICE(0x10A9, 0x6053)},	//Pantech PM-L300

	{QMI_GOBI_5_DEVICE(0x1e0e, 0x9001)},	//SIMTECH SIM7100
	{ }					/* END */
};
MODULE_DEVICE_TABLE(usb, products);


static struct usb_driver qmi_wwan_driver = {
	.name		      = "qmi_wwan",
	.id_table	      = products,
	.probe		      = usbnet_probe,
	.disconnect	      = usbnet_disconnect,
#ifdef CONFIG_PM
	.suspend	      = qmi_wwan_suspend,
	.resume		      =	qmi_wwan_resume,
#endif	
//	.reset_resume         = qmi_wwan_resume,
	.supports_autosuspend = 1,
	//b.disable_hub_initiated_lpm = 1,
};

static int __init qmi_wwan_init(void)
{
 	return usb_register(&qmi_wwan_driver);
}
module_init(qmi_wwan_init);

static void __exit qmi_wwan_exit(void)
{
 	usb_deregister(&qmi_wwan_driver);
}
module_exit(qmi_wwan_exit);


MODULE_AUTHOR("Bjørn Mork <bjorn@mork.no>");
MODULE_DESCRIPTION("Qualcomm MSM Interface (QMI) WWAN driver");
MODULE_LICENSE("GPL");
