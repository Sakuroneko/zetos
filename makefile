# Lolita OS version string
BIN = zetos.bin
ISO = zetos.iso

# Directories that need to be built
DIRS = $(patsubst src/%,build/%,$(shell find src/ -type d))
ISO_DIRS = iso iso/boot iso/boot/grub

# Objects
SRC = $(shell find src/ -type f -name '*.s')
OBJ = $(patsubst src/%.s,build/%.o,$(SRC))

# The compilers used
AS = i686-elf-as
LINK = i686-elf-gcc
# Compilation flags
LD = src/linker.ld
LD_F = -T $(LD) -ffreestanding -O2 -nostdlib -lgcc


$(ISO): $(BIN) src/grub.cfg
	cp $(BIN) iso/boot/zetos.bin
	cp src/grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) iso

iso: $(ISO)

$(BIN): $(OBJ) $(LD)
	$(LINK) $(OBJ) -o $(BIN) $(LD_F)

bin: $(BIN)

all: clean $(ISO)

build/%.o: src/%.s
	$(AS) $< -o $@

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

clean: clean-bin clean-iso
	rm -rf build
	rm -f $(DEPS)
	mkdir -p $(DIRS)

clean-bin:
	rm -f $(BIN)

clean-iso:
	rm -rf iso
	rm -f $(ISO)
	mkdir -p $(ISO_DIRS)
