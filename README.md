RISC-V ISA Implementation
=====

Project structure
=====
```
riscv/
  script/       -- Arbitrary project scripts
  src/          -- Source files
  test/         -- Test source files
  work/         -- work files/folders for the Vivado project
  build.sh      -- build script to create the Vivado project
  build.sh      -- start script for Vivado 
  build.tcl     -- Tcl project generation file
```


Project Initialization
=====
- Make sure Vivado is installed and the vivado binary is in your `$PATH` 
- `$ git clone git@zenon.cs.hs-rm.de:vhdl-cpu/riscv.git`
- `$ cd riscv`
- `$ ./build.sh`
- `$ ./start.sh`

New files
=====
If new files are created run the following commands to rebuild your
working directory of vivado
- `$ cd riscv`
- `$ rm -rf work/`
- `$ ./build.sh`
