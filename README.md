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
There are two different main branches:
  - `master` - for simulation purposes
  - `master_fpga` - for synthesis/implementation purposes

<br/>

**For simulation purposes:**
- Make sure Vivado is installed and the vivado binary is in your `$PATH` 
- `$ git clone git@zenon.cs.hs-rm.de:vhdl-cpu/riscv.git`
- `$ cd riscv`
- `$ ./build.sh`
- `$ ./start.sh`

<br/>
**Synthesis/Implementation purposes:**

If you intend to program a FPGA device with the CPU you need to follow
the follow steps:
- `$ git clone git@zenon.cs.hs-rm.de:vhdl-cpu/riscv.git`
- `$ cd riscv`
- `$ git checkout master_fpga`  (!)
- `$ ./build.sh`
- `$ ./start.sh`

In order to synthesize and implement the RISC-V-CPU you need to specify a RAM
file which contains the machine code instructions as a binary bit vector. Each
line of the file must be a 32 bit binary string.

For example:
```
00000000010000000000010100010011
...
```

Before synthesis you need to set the RAM file in Vivados general project
settings (Generics/Parameters):
- `RAM_FILE = "/path/to/file/ramfile.bin"`

![screenshot](https://gitlab.cs.hs-rm.de/vhdl-cpu/riscv/uploads/1af129f853f54d1722bbd3ebd5ffeb69/Screenshot_from_2017-03-09_14-24-24.png)

New files
=====
If new files are created run the following commands to rebuild your
working directory of vivado
- `$ cd riscv`
- `$ rm -rf work/`
- `$ ./build.sh`

 
License and Copyright
=====
Licensed under the GNU General Public License 3.

(C) Nils Geiselhart, Andreas Rollbühler, Jens Nazarenus, 2017
