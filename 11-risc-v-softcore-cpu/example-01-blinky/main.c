// Blink 2 LEDs and print info to the serial terminal.
//
// Date: December 19, 2021
// Author: Shawn Hymel
// License: 0BSD

#include <femtorv32.h>

int main() {
        while(1) {
                printf("Hello, world!\r\n");
                printf("Freq: %d MHz\r\n", FEMTORV32_FREQ);
                *(volatile uint32_t*)(0x400004) = 3;
                delay(500);
                *(volatile uint32_t*)(0x400004) = 0;
		delay(500);
	}
	return 0;
}

