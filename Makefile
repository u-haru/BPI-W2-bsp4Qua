.PHONY: all clean help
.PHONY: kernel kernel-config
.PHONY: linux pack

include chosen_board.mk

SUDO=sudo
CROSS_COMPILE?=arm-linux-gnueabi-
AARCH64_CROSS_COMPILE?=$(COMPILE_TOOL)/aarch64-linux-gnu-
U_CROSS_COMPILE=$(AARCH64_CROSS_COMPILE)
K_CROSS_COMPILE=$(AARCH64_CROSS_COMPILE)

OUTPUT_DIR=$(CURDIR)/linux-rt/output
TARGET_KDIR=$(CURDIR)
RTKDIR=$(TOPDIR)/phoenix/system/src/drivers

K_O_PATH=linux-rt
K_DOT_CONFIG=$(K_O_PATH)/.config

ROOTFS=$(CURDIR)/rootfs/linux/default_linux_rootfs.tar.gz

Q=
J=$(shell expr `grep ^processor /proc/cpuinfo  | wc -l` \* 2)

all: bsp

clean: kernel-clean
	rm -f chosen_board.mk env.sh

pack: rt-pack
	$(Q)scripts/mk_pack.sh

$(K_DOT_CONFIG): linux-rt
	$(Q)$(MAKE) -C linux-rt ARCH=arm64 $(KERNEL_CONFIG)

kernel: $(K_DOT_CONFIG)
#	$(Q)$(MAKE) -C linux-rt ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} -j$J INSTALL_MOD_PATH=output UIMAGE_LOADADDR=0x40008000 uImage dtbs
	$(Q)$(MAKE) -C linux-rt ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} -j$J INSTALL_MOD_PATH=output UIMAGE_LOADADDR=0x40008000 Image dtbs
	$(Q)$(MAKE) -C linux-rt ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} -j$J INSTALL_MOD_PATH=output modules
	$(Q)$(MAKE) -C linux-rt ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} -j$J INSTALL_MOD_PATH=output modules_install
	mkdir $(OUTPUT_DIR)/lib/modules/4.9.119-BPI-W2-Kernel/kernel/extra
	$(Q)$(MAKE) -C phoenix/system/src/drivers ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} TARGET_KDIR=$(TARGET_KDIR) -j$J INSTALL_MOD_PATH=output
	$(Q)$(MAKE) -C phoenix/system/src/drivers ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} TARGET_KDIR=$(TARGET_KDIR) -j$J INSTALL_MOD_PATH=output install
	$(Q)$(MAKE) -C linux-rt ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} -j$J INSTALL_MOD_PATH=output _depmod
#	$(Q)$(MAKE) -C linux-rt ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} -j$J headers_install

kernel-clean:
	$(Q)$(MAKE) -C phoenix/system/src/drivers ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} TARGET_KDIR=$(TARGET_KDIR) -j$J INSTALL_MOD_PATH=output clean
	$(Q)$(MAKE) -C linux-rt ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} -j$J distclean
	rm -rf linux-rt/output/

kernel-config: $(K_DOT_CONFIG)
	$(Q)$(MAKE) -C linux-rt ARCH=arm64 CROSS_COMPILE=${K_CROSS_COMPILE} -j$J menuconfig
	cp linux-rt/.config linux-rt/arch/arm64/configs/$(KERNEL_CONFIG)

bsp: kernel

help:
	@echo ""
	@echo "Usage:"
	@echo "  make bsp             - Default 'make'"
	@echo "  make pack            - pack the images and rootfs to a PhenixCard download image."
	@echo "  make clean"
	@echo ""
	@echo "Optional targets:"
	@echo "  make kernel           - Builds linux kernel"
	@echo "  make kernel-config    - Menuconfig"
	@echo ""

