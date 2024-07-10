# Tools for assembling C into RISCV hex files, usable by Verilog readmemh

## Dependencies

* Ubuntu library `gcc-riscv64-unknown-elf` (for program `riscv64-unknown-elf-gcc`)
* Ubuntu library `binutils-riscv64-unknown-elf` (for program `riscv64-unknown-elf-objdump`)

* g++ compiler to build the `elf2hex` tool

## Usage

* Write C files in `src/`
* run `make`
* Access hex files in `hex/`, dump files in `dump/`, ELF files in `build/`

## Credit
This is basically an exact copy of the system used by 6.192 for building source code--I just slightly modified the Makefile to also always give dump files.
