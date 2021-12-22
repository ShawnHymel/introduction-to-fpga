// Slowly increase the brightness of the PWM-controlled LED over and over.
//
// Date: December 19, 2021
// Author: Shawn Hymel
// License: 0BSD

#include <femtorv32.h>

int main() {
	while (1) {
		for (int i = 0; i < 4096; i++) {
			*(volatile uint32_t*)(0x404000) = i;
                        delay(1);
		}
	}
	return 0;
}
