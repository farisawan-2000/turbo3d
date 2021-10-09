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


clean: build/t3d.bin
	rm tools/armips build/ -r
