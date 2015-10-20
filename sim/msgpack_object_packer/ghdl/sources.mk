msgpack_object.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object.vhd

pipework_components.o : ../../../msgpack-vhdl/src/msgpack/pipework/pipework_components.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/pipework/pipework_components.vhd

reducer.o : ../../../msgpack-vhdl/src/msgpack/pipework/reducer.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/pipework/reducer.vhd

msgpack_object_code_reducer.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_reducer.vhd msgpack_object.o pipework_components.o reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_reducer.vhd

msgpack_object_components.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_components.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_components.vhd

msgpack_object_packer.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_packer.vhd msgpack_object.o pipework_components.o reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_packer.vhd

test_bench.o : ../../../src/msgpack_object_packer/vhdl/test_bench.vhd msgpack_object.o msgpack_object_components.o msgpack_object_code_reducer.o msgpack_object_packer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../src/msgpack_object_packer/vhdl/test_bench.vhd

