#include <stdio.h>
#include <conio.h>
#include <stdio.h>
#include <windows.h>

#include <interface.h>



void initializeHardwarePorts()
{
	// INPUT PORTS
	createDigitalInput(0);
	createDigitalInput(1);
	createDigitalInput(2);
	createDigitalInput(3);
	// OUTPUT PORTS
	createDigitalOutput(4);
	createDigitalOutput(5);

	writeDigitalU8(4, 0);
	writeDigitalU8(5, 0);
}


bool x_moving = false;
bool y_moving = false;
bool z_moving = false;
bool left_station_moving = false;
bool right_station_moving = false;

void setBitValue(uInt8* variable, int n_bit, int new_value_bit)
// given a byte value, set the n bit to value
{
	uInt8  mask_on = (uInt8)(1 << n_bit);
	uInt8  mask_off = ~mask_on;
	if (new_value_bit)  *variable |= mask_on;
	else                *variable &= mask_off;
}


int getBitValue(uInt8 value, uInt8 n_bit)
// given a byte value, returns the value of bit n
{
	return(value & (1 << n_bit));
}



/********************** Move X Funtions ********************************/
int getXPosition()
{
	int pp[10] = { 0,0,0,0,0,0,0,0,1,1 };
	int bb[10] = { 0,1,2,3,4,5,6,7,0,1 };
	int ports[2];
	ports[0] = readDigitalU8(0);
	ports[1] = readDigitalU8(1);
	for (int i = 0; i < 10; i++) {
		if (!getBitValue(ports[pp[i]], bb[i]))
			return i + 1;
	}
	return(-1);
}

void moveXRight()
{
	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 0, 1);
	writeDigitalU8(4, p);
	x_moving = true;
}

void moveXLeft() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 1, 1);
	setBitValue(&p, 0, 0);
	writeDigitalU8(4, p);
	x_moving = true;


}

void stopX() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 0, 0);
	writeDigitalU8(4, p);
	x_moving = false;
}

int getXMoving() {

	if (x_moving) {
		return 1;
	}
	else if (!x_moving) {
		return 0;
	}
	else {
		return -1;

	}

}




/********************* Move Z functions*************************/
int getZPosition() {

	uInt8 p2 = readDigitalU8(2);
	uInt8 p1 = readDigitalU8(1);

	if (!getBitValue(p2, 6) || !getBitValue(p2, 5)) {

		return 1;
	}
	if (!getBitValue(p2, 4) || !getBitValue(p2, 3)) {

		return 2;
	}
	if (!getBitValue(p2, 2) || !getBitValue(p2, 1)) {

		return 3;
	}

	if (!getBitValue(p2, 0) || !getBitValue(p1, 7)) {

		return 4;
	}
	if (!getBitValue(p2, 6) || !getBitValue(p1, 5)) {

		return 5;
	}

	return (-1);

}

void moveZUp() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 5, 1);
	setBitValue(&p, 6, 0);
	writeDigitalU8(4, p);
	bool z_moving = true;
}

void moveZDown() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 5, 0);
	setBitValue(&p, 6, 1);
	writeDigitalU8(4, p);
	bool z_moving = true;

}

void stopZ() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 5, 0);
	setBitValue(&p, 6, 0);
	writeDigitalU8(4, p);
	bool z_moving = false;

}

int getZMoving() {

	if (z_moving) {
		return 1;
	}
	else if (!z_moving) {
		return 0;
	}
	return (-1);
}

bool isAtZUp() {

	uInt8 p2 = readDigitalU8(2);
	uInt8 p1 = readDigitalU8(1);
	if (!getBitValue(p2, 5) || !getBitValue(p2, 3) || !getBitValue(p2, 1) || !getBitValue(p1, 7) || !getBitValue(p1, 5))
		return true;
	return false;
}

bool isAtZDown() {

	uInt8 p2 = readDigitalU8(2);
	uInt8 p1 = readDigitalU8(1);
	if (!getBitValue(p2, 6) || !getBitValue(p2, 4) || !getBitValue(p2, 2) || !getBitValue(p2, 0) || !getBitValue(p1, 6))
		return true;
	return false;


}





/*******************  Move Y functions ***************************/


int getYPosition() {


	int bb[3] = {2,3,4};
	uInt8 p = readDigitalU8(0);
	for (int i = 0; i < 10; i++) {
		if (!getBitValue(p, bb[i]))
			return i + 1;
	}
	return(-1);

}


void moveYInside() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 4, 1);
	setBitValue(&p, 3, 0);
	writeDigitalU8(4, p);
	y_moving = true;

}

void moveYOutside() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 4, 0);
	setBitValue(&p, 3, 1);
	writeDigitalU8(4, p);
	y_moving = true;

}

void stopY() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 4, 0);
	setBitValue(&p, 3, 0);
	writeDigitalU8(4, p);
	y_moving = false;
}

int getYMoving() {

	if (y_moving) {
		return 1;
	}
	else if (!y_moving) {
		return 0;
	}
	return (-1);

}

/*******************  Move Left Station functions ***************************/

void moveLeftStationInside() {

	uInt8 p = readDigitalU8(4);
	uInt8 p2 = readDigitalU8(5);
	setBitValue(&p, 7, 1);
	setBitValue(&p2, 0, 0);
	writeDigitalU8(4, p);
	writeDigitalU8(5, p2);
	left_station_moving = true;
}

void moveLeftStationOutside(){

	uInt8 p = readDigitalU8(4);
	uInt8 p2 = readDigitalU8(5);
	setBitValue(&p, 7, 0);
	setBitValue(&p2, 0, 1);
	writeDigitalU8(4, p);
	writeDigitalU8(5, p2);
	left_station_moving = true;
}

void stopLeftStation() {

	uInt8 p = readDigitalU8(4);
	uInt8 p2 = readDigitalU8(5);
	setBitValue(&p, 7, 0);
	setBitValue(&p2, 0, 0);
	writeDigitalU8(4, p);
	writeDigitalU8(5, p2);
	left_station_moving = false;

}

int getLeftStationMoving() {

	if (left_station_moving) {
		return 1;
	}
	else if (!left_station_moving) {
		return 0;
	}
	return (-1);

}

bool isPartOnLeftStation() {

	uInt8 p = readDigitalU8(3);
	if (getBitValue(p, 0))
		return true;
	return false;

}




/*******************  Move Right Station functions ***************************/

moveRightStationInside() {

	uInt8 p = readDigitalU8(5);
	setBitValue(&p, 1, 1);
	setBitValue(&p, 2, 0);
	writeDigitalU8(5, p);
	right_station_moving = true;

}

moveRightStationOutside(){

	uInt8 p = readDigitalU8(5);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 2, 1);
	writeDigitalU8(5, p);
	right_station_moving = true;

}

stopRightStation() {

	uInt8 p = readDigitalU8(5);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 2, 0);
	writeDigitalU8(5, p);
	right_station_moving = false;

}

int getRightStationMoving() {

	if (right_station_moving) {
		return 1;
	}
	else if (!right_station_moving) {
		return 0;
	}
	return (-1);

}

bool isPartOnRightStation() {

	uInt8 p = readDigitalU8(3);
	if (getBitValue(p, 0))
		return true;
	return false;

}

/////////////////////////// Cage ////////


bool isPartInCage() {


	uInt8 p = readDigitalU8(2);
	if (!getBitValue(p, 7))
		return true;
	return false;




}