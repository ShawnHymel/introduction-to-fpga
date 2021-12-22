// Count on LEDs as long as button is pressed.
//
// Date: December 19, 2021
// Author: Shawn Hymel
// License: 0BSD

#include <femtorv32.h>

int main() {
    int count = 0;
    while (1) {
        if ((IO_IN(IO_BUTTONS) & 1) == 0) {
            count = (count + 1) % 16;
            IO_OUT(IO_LEDS, count);
            delay(250);
        }
    }
    return 0;
}

