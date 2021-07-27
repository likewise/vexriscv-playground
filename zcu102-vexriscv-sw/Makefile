
CROSS_COMPILE := /opt/riscv64-unknown-elf-gcc-20171231-x86_64-linux-centos6/bin/riscv64-unknown-elf-
CC := $(CROSS_COMPILE)gcc
GDB := $(CROSS_COMPILE)gdb
OBJDUMP := $(CROSS_COMPILE)objdump
OPENOCD := $(PWD)/openocd.sh

debug-build: clean
	mkdir -p build
	$(CC) -c -march=rv32i  -mabi=ilp32 -g3 -O0  -MD -fstrict-volatile-bitfields -o build/main.o main.c
	$(CC) -c -march=rv32i  -mabi=ilp32 -g3 -O0  -MD -fstrict-volatile-bitfields -o build/crt.o crt.S -D__ASSEMBLY__=1
	$(CC) -mabi=ilp32 -g3 -O0  -MD -fstrict-volatile-bitfields -o build/demo.elf build/main.o build/crt.o -march=rv32i  -mabi=ilp32 -nostdlib -lgcc -mcmodel=medany -nostartfiles -ffreestanding -Wl,-Bstatic,-T,linker.ld,-Map,build/demo.map,--print-memory-usage 
#	$(OBJDUMP) -S -l -d ${PROGRAM}.elf > ${PROGRAM}.S

clean:
	rm -rf build

# Debug the program using GDB, which starts OpenOCD (0.11.0+ required) with GDB pipe
debug: debug-build
	$(GDB) \
	-ex "set remotetimeout 5" \
	-ex "target extended-remote | $(OPENOCD)" \
	-ex "set pagination off" \
	-ex "layout split" \
	-ex "load" \
	-ex "echo \\n" \
	-ex "echo >>> GDB will break at main. Type 'next' <enter> to proceed to the next C line. <<<\\n" \
	-ex "echo \\n" \
	-ex "break crtStart" \
	build/demo.elf

# Upload the program using GDB, which starts OpenOCD (0.11.0+ required) with GDB pipe
upload-debug-build: debug-build
	$(GDB) -batch -q \
	-ex "set remotetimeout 5" \
	-ex "target extended-remote | $(OPENOCD)" \
	-ex "load" \
	build/demo.elf

release-build: clean all

# Upload the program using GDB, which starts OpenOCD (0.11.0+ required) with GDB pipe
upload-release-build: release-build
	$(GDB) -batch -q \
	-ex "set remotetimeout 3" \
	-ex "target extended-remote | $(OPENOCD)" \
	-ex "load" \
	-ex "disconnect" \
	build/demo.elf

