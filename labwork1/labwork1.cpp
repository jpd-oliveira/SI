#include <stdio.h>
#include <conio.h>
#include <stdio.h>
#include <windows.h>


extern "C" {
    // observe your project contents.  We are mixing C files with cpp ones.
    // Therefore, inside cpp files, we need to tell which functions are written in C.
    // That is why we use extern "C"  directive
#include <interface.h>
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


int main()
{
    // INPUT PORTS
    printf("\ngo to browser and open address: http://localhost:8081/ss.html");
    createDigitalInput(0);
    createDigitalInput(1);
    createDigitalInput(2);
    createDigitalInput(3);
    // OUTPUT PORTS
    createDigitalOutput(4);
    createDigitalOutput(5);

    writeDigitalU8(4, 0);
    writeDigitalU8(5, 0);
    printf("\ncallibrate kit manually and press    enter...");
    // writeDigitalU8(4, 0x21);
    int tecla = 0;
    while (tecla != 27) {
        tecla = _getch();
        if (tecla == 'd')
            moveXRight();
        if (tecla == 'a')
            moveXLeft();
        if (tecla == 's')
            stopX();
        // show every storage state
    }   //goto_xz(3, 3);    goto_xz(4, 5); // for illustrative purposes only
   //goto_xz(5, 2);    goto_xz(8, 2);
    closeChannels();
    return 0;
}