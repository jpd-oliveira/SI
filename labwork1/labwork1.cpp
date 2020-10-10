#include <stdio.h>
#include <conio.h>
#include <stdio.h>
#include <windows.h>


extern "C" {

	#include <interface.h>
	#include <warehouse.h>
}






int main()
{
    initializeHardwarePorts();
    int t = 0;
    while (t != '0') {
        
        t = _getch();
        switch (t) {
            case 'q': moveXRight(); break;
            case 'a': moveXLeft(); break;
            case 'z': stopX(); break;
            case 'w': moveYInside(); break;
            case 's': moveYOutside(); break;
            case 'x': stopY(); break;
            case 'e': moveZUp(); break;
            case 'd': moveZDown(); break;
            case 'c': stopZ(); break;
            case 'r': moveLeftStationInside(); break;
            case 'f': moveLeftStationOutside(); break;
            case 'v': stopLeftStation(); break;
            case 't': moveRightStationInside(); break;
            case 'g': moveRightStationOutside(); break;
            case 'b': stopRightStation(); break;

        }

    }   
    closeChannels();
    return 0;
}