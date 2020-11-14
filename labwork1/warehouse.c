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
	
}

void moveXLeft() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 1, 1);
	setBitValue(&p, 0, 0);
	writeDigitalU8(4, p);
	


}

void stopX() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 0, 0);
	writeDigitalU8(4, p);
	
}

int getXMoving() {

	uInt8 p = readDigitalU8(4);

	if (getBitValue(p, 0)==1) {
		return 1;
	}
	else if (getBitValue(p, 0)==0 && getBitValue(p, 1)==0) {
		return 0;
	}
	else if(getBitValue(p, 1)==1){
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
	
}

void moveZDown() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 5, 0);
	setBitValue(&p, 6, 1);
	writeDigitalU8(4, p);
	

}

void stopZ() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 5, 0);
	setBitValue(&p, 6, 0);
	writeDigitalU8(4, p);
	

}

int getZMoving() {

	uInt8 p = readDigitalU8(4);

	if (getBitValue(p, 5) == 1) {
		return 1;
	}
	else if (getBitValue(p, 5) == 0 && getBitValue(p, 6) == 0) {
		return 0;
	}
	else if (getBitValue(p, 6) == 1) {
		return -1;
	}
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
	uInt8 p = readDigitalU8(1);
	for (int i = 0; i < 3; i++) {
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
	

}

void moveYOutside() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 4, 0);
	setBitValue(&p, 3, 1);
	writeDigitalU8(4, p);
	

}

void stopY() {

	uInt8 p = readDigitalU8(4);
	setBitValue(&p, 4, 0);
	setBitValue(&p, 3, 0);
	writeDigitalU8(4, p);
	
}

int getYMoving() {

	uInt8 p = readDigitalU8(4);

	if (getBitValue(p, 4) == 1) {
		return 1;
	}
	else if (getBitValue(p, 3) == 0 && getBitValue(p, 4) == 0) {
		return 0;
	}
	else if (getBitValue(p, 3) == 1) {
		return -1;
	}

}

/*******************  Move Left Station functions ***************************/

void moveLeftStationInside() {

	uInt8 p = readDigitalU8(4);
	uInt8 p2 = readDigitalU8(5);
	setBitValue(&p, 7, 1);
	setBitValue(&p2, 0, 0);
	writeDigitalU8(4, p);
	writeDigitalU8(5, p2);
	
}

void moveLeftStationOutside(){

	uInt8 p = readDigitalU8(4);
	uInt8 p2 = readDigitalU8(5);
	setBitValue(&p, 7, 0);
	setBitValue(&p2, 0, 1);
	writeDigitalU8(4, p);
	writeDigitalU8(5, p2);
	
}

void stopLeftStation() {

	uInt8 p = readDigitalU8(4);
	uInt8 p2 = readDigitalU8(5);
	setBitValue(&p, 7, 0);
	setBitValue(&p2, 0, 0);
	writeDigitalU8(4, p);
	writeDigitalU8(5, p2);
	

}

int getLeftStationMoving() {

	uInt8 p4 = readDigitalU8(4);
	uInt8 p5 = readDigitalU8(4);

	if (getBitValue(p4, 7) == 1) {
		return 1;
	}
	else if (getBitValue(p5, 0) == 0 && getBitValue(p4, 7) == 0) {
		return 0;
	}
	else if (getBitValue(p5, 0) == 1) {
		return -1;
	}

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
	

}

moveRightStationOutside(){

	uInt8 p = readDigitalU8(5);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 2, 1);
	writeDigitalU8(5, p);
	

}

stopRightStation() {

	uInt8 p = readDigitalU8(5);
	setBitValue(&p, 1, 0);
	setBitValue(&p, 2, 0);
	writeDigitalU8(5, p);
	

}

int getRightStationMoving() {

	uInt8 p = readDigitalU8(4);

	if (getBitValue(p, 1) == 1) {
		return 1;
	}
	else if (getBitValue(p, 1) == 0 && getBitValue(p, 2) == 0) {
		return 0;
	}
	else if (getBitValue(p, 2) == 1) {
		return -1;
	}

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
	if (getBitValue(p, 7))
		return true;
	return false;

}