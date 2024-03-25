BUILD_DIR = bin
SOURCE_DIR = src

all: build $(BUILD_DIR)/bootSect.bin $(BUILD_DIR)/kernel.bin \
	$(BUILD_DIR)/os.bin $(BUILD_DIR)/fileTable.bin run

$(BUILD_DIR)/bootSect.bin: $(SOURCE_DIR)/asm/bootSect.asm
	fasm $(SOURCE_DIR)/asm/bootSect.asm $(BUILD_DIR)/bootSect.bin

$(BUILD_DIR)/kernel.bin: $(SOURCE_DIR)/asm/kernel.asm
	fasm $(SOURCE_DIR)/asm/kernel.asm $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/os.bin: $(BUILD_DIR)/bootSect.bin $(BUILD_DIR)/fileTable.bin $(BUILD_DIR)/kernel.bin
	cat $(BUILD_DIR)/bootSect.bin $(BUILD_DIR)/fileTable.bin $(BUILD_DIR)/kernel.bin > $(BUILD_DIR)/os.bin

$(BUILD_DIR)/fileTable.bin: $(SOURCE_DIR)/asm/fileTable.asm
	fasm $(SOURCE_DIR)/asm/fileTable.asm $(BUILD_DIR)/fileTable.bin

run:
	qemu-system-i386 -boot a -fda $(BUILD_DIR)/os.bin

build:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)/*

install:
	sudo apt-get install qemu fasm