#!/bin/bash
DIR=$(dirname "$0")
vivado -nolog -nojournal $DIR/work/riscv/riscv.xpr 
