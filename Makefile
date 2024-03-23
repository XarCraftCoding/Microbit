BUILD_DIR = build
SOURCE_DIR = src

all: build $(BUILD_DIR)/bootSect.bin $(BUILD_DIR)/kernel.bin $(BUILD_DIR)/os.bin run

$(BUILD_DIR)/bootSect.bin: $(SOURCE_DIR)/bootSect.asm
	fasm $(SOURCE_DIR)/bootSect.asm $(BUILD_DIR)/bootSect.bin

$(BUILD_DIR)/kernel.bin: $(SOURCE_DIR)/kernel.asm
	fasm $(SOURCE_DIR)/kernel.asm $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/os.bin: $(BUILD_DIR)/bootSect.bin $(BUILD_DIR)/kernel.bin
	cat $(BUILD_DIR)/bootSect.bin $(BUILD_DIR)/kernel.bin > $(BUILD_DIR)/os.bin

run:
	qemu-system-i386 -boot a -fda $(BUILD_DIR)/os.bin

build:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*

install:
	sudo apt-get install qemu fasm