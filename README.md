# Morse-Decoder
Reads Morse code input through a button, automatically detects the speed, and outputs the resulting text to a screen.   
Implemented on a [Digilent Arty A7 FPGA Development board](https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board/) with a [Pmod OLED graphic display](https://store.digilentinc.com/pmod-oled-128-x-32-pixel-monochromatic-oled-display/).

[Demonstration - YouTube Link](https://youtu.be/lpAaF3Yb4CQ)
<br>  

[![Demonstration - YouTube Link](https://i.ytimg.com/vi/lpAaF3Yb4CQ/hqdefault.jpg)](https://youtu.be/lpAaF3Yb4CQ)

The LED turns on when the input button is pressed to make it easier to see the button's current state.

## Block_schematic.pdf
The elaborated design schematic of the project.  
Downloading the pdf will result in a much more clear image and allow you to zoom in.

## Current-Code Folder
VHDL used in the current version of the project.

### Decoder_instantiation_one_button_to_oled.vhd
Top level instantiation for this version of the project.  
Connects the Xilinx clocking wizard IP, decoder_block, input_converter, image_data_storage, and oled_communication blocks to each other and the dev board's buttons, switches, leds, and Pmod IO.

### Decoder_block.vhd   
Takes a stream of on-off Morse input and converts it to a number that represents a character.

* #### Filter.vhd  
The first stage of the decoder_block. Automatically detects the speed of the incoming Morse code and converts groups of input to on-off signals.

* #### Dot_dash_decoder.vhd
Converts input from the filter to dots (1-2 groups on), dashes (3-5 groups on), dot-dash gaps (1-2 groups off), character-gaps (3-5 groups off), or spaces (>5 groups off).

* #### FSM.vhd
A finite state machine that process series of dots and dashes to their appropriate character.

### Input_converter.vhd
Takes the character representation from the decoder_block and converts it to a series of pixels.

### Image_data_storage.vhd
Receives new characters from the input_converter, and inserts them into the bottom part of the screen. Shifts all lines of text upward when the bottom line is full.

### OLED_communication.vhd  
Handles all communication with the OLED screen.

* #### SPI.vhd  
Sends bytes to and from the screen over SPI.

* #### Screen_control.vhd  
Drives the OLED's startup and shutdown procedures, sends the contents of image_data_storage to the the SPI block when a new character is available.

## Testbenches Folder  
The testbenches used to simulate segments of the project.

## Unused Folder
VHDL that was previously used for input and output schemes that were easier to implement. These allowed for testing segments of the project on hardware.  
These files are not currently in use.
