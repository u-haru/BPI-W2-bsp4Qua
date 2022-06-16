# BPI-W2-bsp4Qua

Overview
------------
This project is for quastation forked from [BPI-SINOVOIP/BPI-W2-bsp](https://github.com/BPI-SINOVOIP/BPI-W2-bsp), including Linux Kernel 4.9.119

u-boot source is removed.

How to build Linux kernel
------------------------------------------
1. Clone this repository and cd
2. Run ```./build.sh```
3. Select 4 to initialize and make kernel config
4. Overwrite kernel config with correct one
```
cp ./linux-rt-config linux-rt/.config
```
5. Run ```./build.sh``` again
6. Select 1 to build kernel
7. Kernel will be generated in folder SD when it completes
8. Run ```./copy.sh``` to copy kernel, dtb, and modules to ~/Desktop/Images
