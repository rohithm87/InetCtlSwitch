#!/usr/bin/perl
use Device::BCM2835;
use strict;

# call set_debug(1) to do a non-destructive test on non-RPi hardware
#Device::BCM2835::set_debug(1);
Device::BCM2835::init() 
 || die "Could not init library";

# Blink pin 11:
# Set RPi pin 11 to be an output
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_11, 
                            &Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);

while (1)
{
    # Turn it on
    Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_11, 1);
    Device::BCM2835::delay(1500); # Milliseconds
    # Turn it off
    Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_11, 0);
    Device::BCM2835::delay(1500); # Milliseconds
}
