#ifndef _LED_H_
#define _LED_H_

/**
\file led.h
\brief 
\author tyranno
\warning 
\date 2012/10/10
*/

/*Revision history ******************************************
*
*        Author             :
*        Dept            :
*        Revision Date    :
*        Version           :
*
*/

#ifdef __cplusplus
extern "C"
{
#endif	


typedef enum
{
	LED_RSSI,
	LED_STATE,
	LED_MAX
}led_type;


typedef enum
{
	LED_COL_0=0, //led off
	LED_COL_1=1, //orange
	LED_COL_2=2, //blue
	LED_COL_3=3, //violet
	LED_COL_MAX
}led_color_type;



/**
\fn int led_color(led_type t, led_color_type c)
\brief On/Off Led
\param id : control id
\param c : color
\return 0 : No Error, Other : error
\date 2012/10/10
\author tyranno
\version 1
*/
extern int led_color(led_type t, led_color_type c);


/**
\fn int led_aquire_control()
\brief aquire led control to handle led
\param t : led type(RSSI, STATE)
\param ctl : 0:shared, 1:exclusive
\return -1 : error Other: Control id
\date 2012/10/10
\author tyranno
\version 1
*/
extern int led_set_exclusive(led_type t, int ctl);



/**
int main()
{
	//set led exclusive mode (other process doesn't control led)
	//if process quit, other proesses are able to handle led
	led_set_exclusive(LED_RSSI, 1);

	//Set RSSI led to red
	led_onoff(LED_RSSI, LED_1);
	
	return 0;
}
*/

#ifdef __cplusplus
}
#endif

#endif//_LED_H_

