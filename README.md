RISC-V ISA Implementation
=====

Project structure
=====
```
riscv/
  doc/          -- Documentation files
  script/       -- Arbitrary project scripts
  src/          -- Source files
  synth/        -- FPGA synthesiszing files
  test/         -- Test source files
  work/         -- work files/folders for the Vivado project
  build.sh      -- build script to create the Vivado project
  build.tcl     -- Tcl project generation file
```


Project Initialization
=====
- Make sure Vivado is installed and the vivado binary is in your `$PATH` 
- `$ git clone git@zenon.cs.hs-rm.de:vhdl-cpu/riscv.git`
- `$ cd riscv`
- `$ ./build.sh`
- When Vivado is started, immediatly switch to the Tcl console:  `Window > Tcl console`
- In the Tcl console you need to type the following:
  - `cd project_root`, where project root is the folder where `build.sh` is located.
  - `source build.tcl`
- Afterwards your vivado project is created in project_root/work/riscv
