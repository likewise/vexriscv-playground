#!/bin/sh

set +e

killall openocd || true

/opt/openocd-riscv/bin/openocd -c "gdb_port pipe; log_output openocd.log" \
-d3 \
-f interface/ftdi/dp_busblaster.cfg \
-c "set MURAX_CPU0_YAML /home/vexriscv/project/vexriscv/cpu0.yaml" \
-f "target/murax.cfg"
