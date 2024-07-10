# kiranv 2024-07-10 :: adapted from 6.192 source-building makefile

.PHONY: all clean

SRCDIR=src
BUILDDIR=build
HEXDIR=hex
DUMPDIR=dump

SOURCE_PATHS=$(wildcard $(SRCDIR)/*.c)
SOURCES=$(SOURCE_PATHS:src/%=%)

TESTS=$(basename $(SOURCES))
ELF=$(addsuffix .elf,$(addprefix $(BUILDDIR)/,$(TESTS)))
HEX=$(addsuffix .hex,$(addprefix $(HEXDIR)/,$(TESTS)))
DUMP=$(addsuffix .dump,$(addprefix $(DUMPDIR)/,$(TESTS)))

ELF2HEX=tools/elf2hex

RISCV=riscv64-unknown-elf-

COMPILER_ARGS= -march=rv32i -mabi=ilp32 -static -nostdlib -nostartfiles -mcmodel=medany
OBJDUMP_ARGS = -D

all: $(SOURCE_PATHS)

$(ELF2HEX)/elf2hex:
	$(MAKE) -C $(ELF2HEX)

base/init.o: base/init.S
	$(RISCV)gcc $(COMPILER_ARGS) -c base/init.S -o base/init.o

base/mmio.o: base/mmio.c
	$(RISCV)gcc $(COMPILER_ARGS) -c base/mmio.c -o base/mmio.o

$(SRCDIR)/%.c: $(ELF2HEX)/elf2hex base/init.o base/mmio.o base/mmio.ld
	mkdir -p $(BUILDDIR)
	mkdir -p $(HEXDIR)
	mkdir -p $(DUMPDIR)
	$(RISCV)gcc $(COMPILER_ARGS) -O2 -c $(SRCDIR)/$*.c -o intermediate.o
	$(RISCV)gcc $(COMPILER_ARGS) -o $(BUILDDIR)/$*.elf -T base/mmio.ld intermediate.o base/init.o base/mmio.o
	$(ELF2HEX)/elf2hex $(BUILDDIR)/$*.elf 0 16G $(HEXDIR)/$*.hex
	$(RISCV)objdump $(OBJDUMP_ARGS) $(BUILDDIR)/$*.elf > $(DUMPDIR)/$*.dump
	rm -f intermediate.o

clean:
	rm -f base/*.o
	rm -f intermediate.o
	rm -rf build
	rm -rf hex
	rm -rf dump
