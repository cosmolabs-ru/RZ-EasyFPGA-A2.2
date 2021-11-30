# RZ-EasyFPGA-A2.2
A library of snippets for beginners, to interact with EasyFPGA's on-board devices

Hello!
I am an electronics engineer (stm32-based automation). Recently I decided to dive into FPGA. 
I will publish verilog modules I developed to drive the devices pre-soldered on the PCB.
Some useful things my lib currently contains:

+ dynamically configurable clock prescaler (all following modules need it to work)
+ nibble to 7-seg static decoder
+ byte to 2x 7-seg dynamic indicator
+ button debouncer
+ d-trigger, or as you call it, a 'flip-flop'
