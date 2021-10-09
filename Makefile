default: all


all: t3d.bin

tools/armips: tools/armips.cpp
	$(CXX) $(CXXFLAGS) -fno-exceptions -fno-rtti -pipe $^ -o $@ -lpthread $(ARMIPS_FLAGS)
	chmod +x $@

t3d.bin: turbo3d.s tools/armips
	tools/armips -strequ CODE_FILE $@ -temp scratch_space/.t3d  $<


clean: t3d.bin
	rm tools/armips t3d.bin
