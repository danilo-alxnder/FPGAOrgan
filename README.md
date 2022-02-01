# FPGA Organ 🎹
__[Updated: 1 Feb 2022] More detailed explanation to come...__


Welcome to the README of FPGA Organ, a musical coding representation of an organ based on VHDL code in a DE1-SoC board.

## The Challenge
Connect the board to a PS/2 keyboard and produce 12 full half-tones that resembles an organ. 
```
Three main functions are:
1. Recognize and generate a tone
2. Study the communication protocol of PS/2 keyboard
3. Use a synchronous system using VHDL code 
4. Understand combination logic by enabling sound per each tone
```


## Images
<p align="center">
<img src="https://user-images.githubusercontent.com/70687643/152025901-faefcce2-9302-479f-a18d-11757a1d6b15.png" width="665">
</p>

# Demo
The following picture shows tone A generated at a frequency of 440Hz derived from the 50 MHz clock required for audio interface for the WM8731 audio codec given. The signal can be heard connecting a pair of heaphone to the DE1-SoC  
<p align="center">
<img src="https://user-images.githubusercontent.com/70687643/152025406-ff1de447-c2db-437a-bac7-372627f405f7.png"  width="765">
</p>







