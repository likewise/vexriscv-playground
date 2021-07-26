
.ONESHELL:

all: murax

vexriscv:
	# 5fc4125763a1b66758c387c0abea32e602b2e4e5
	git clone https://github.com/SpinalHDL/VexRiscv.git vexriscv
	cd vexriscv
	patch -i ../vexriscv.patch -p1

murax: vexriscv
	cd vexriscv
	sbt "runMain vexriscv.demo.MuraxWithRamInit"

axi4: vexriscv
	cd vexriscv
	sbt "runMain vexriscv.demo.VexRiscvAxi4WithIntegratedJtag"

DmaUnit:
	# 74f8a2f930b3e88fcea9cd7d940b1fc34b8b7e0a
	git clone https://github.com/c-thaler/DmaUnit

.PHONY:
dmaunit: DmaUnit
	cd DmaUnit
	sbt "runMain dma_unit.DmaUnit"

VexRiscvSocSoftware:
	# 2310c4a3b0f179ea163059ff02788d54bad001d0
	git clone https://github.com/SpinalHDL/VexRiscvSocSoftware

muraxsw: VexRiscvSocSoftware
	cd VexRiscvSocSoftware/projects/murax/demo
	make
	/opt/riscv/bin/riscv64-unknown-elf-gdb -ex "target remote :3333" -ex "load"   ./build/demo.elf

toolchain:
	@echo "Downloading and extracting RISC-V toolchain to /tmp/..."
	curl --output - https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-20171231-x86_64-linux-centos6.tar.gz | tar xz -C /tmp/

monitor:
	# Dangerous Prototypes Busblaster (v2.5)
	sudo /opt/openocd-riscv/bin/openocd -d3 -f interface/ftdi/dp_busblaster.cfg -c "set MURAX_CPU0_YAML vexriscv/cpu0.yaml" -f target/murax.cfg \
	-c "gdb_breakpoint_override hard" &

openocd: /tmp/openocd-spiral/bin/openocd

# pkg-config libtool libyaml-dev
/tmp/openocd-spiral/bin/openocd:
	# c974c1b70348b59146bb87a1cfb829296240a509
	git clone https://github.com/SpinalHDL/openocd_riscv
	cd openocd_riscv
	rm -rf /tmp/openocd && ./bootstrap
	./configure --prefix=/tmp/openocd
	make -j16 install
	cd ..
