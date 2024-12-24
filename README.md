# Flappy_bird_basys3

## Summary of the project

This Vivado vhdl project uses the Basys3 VGA connector to display a flappy bird and its buttons to play.

## Features

- VGA driver and clock divider to get output to a screen
- game logic (gravity, collision, score, game over) and inputs (jump button and reset)
- image handling (background, flappy, pipes, score, game over) : image to vhdl array (python script), storing image in memory (xilinx vhdl template), displaying images (go through parts of the images to save space) 

## Demonstration
<video src="https://github.com/user-attachments/assets/303843be-8dbd-4b11-833a-f6ace4718d7a.mp4"></video>
## How to use
- create Vivado project
- add all sources files, set language to vhdl in gui
- add constraint file (.xdc)
- select board xc7a35tcpg236-1
- set vhdl version to VHDL 2008 using the tcl console (Window -> tclConsole):
```tcl
set_property FILE_TYPE {VHDL 2008} [get_files *.vhd]
```
- generate bitstream using the maximum number of core to save time
