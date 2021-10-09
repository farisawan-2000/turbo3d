default: all

DUMMY != mkdir -p build

all: build/t3d.bin
	@sha1sum -c t3d.sha1
	@sha1sum -c t3d.data.sha1

tools/armips: tools/armips.cpp
	$(CXX) $(CXXFLAGS) -fno-exceptions -fno-rtti -pipe $^ -o $@ -lpthread $(ARMIPS_FLAGS)
	chmod +x $@

build/t3d.bin: turbo3d.s tools/armips
	$(info $*.data.bin)
	tools/armips -strequ CODE_FILE $@ -strequ DATA_FILE build/t3d.data.bin -temp scratch_space/.t3d  $<
	mips-linux-gnu-ld -r -b binary build/t3d.bin -o build/turbo3d_text.o
	mips-linux-gnu-ld -r -b binary build/t3d.data.bin -o build/turbo3d_data.o


dump_binary:
	mkdir -p dump
	cpp -P ucode.ld -o build/ucode.cp.ld -DTEXT
	mips-linux-gnu-ld -o dump/text.elf -Tbuild/ucode.cp.ld /usr/lib/n64/PR/gspTurbo3D.fifo.o
	mips-linux-gnu-objcopy dump/text.elf dump/text.bin -O binary
	cpp -P ucode.ld -o build/ucode.cp.ld -DDATA
	mips-linux-gnu-ld -o dump/data.elf -Tbuild/ucode.cp.ld /usr/lib/n64/PR/gspTurbo3D.fifo.o
	mips-linux-gnu-objcopy dump/data.elf dump/data.bin -O binary


clean: build/t3d.bin
	rm tools/armips build/ -r
