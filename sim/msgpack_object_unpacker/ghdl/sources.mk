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

msgpack_structure_stack.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_structure_stack.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_structure_stack.vhd

chopper.o : ../../../msgpack-vhdl/src/msgpack/pipework/chopper.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/pipework/chopper.vhd

msgpack_object_unpacker.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_unpacker.vhd msgpack_object.o pipework_components.o msgpack_object_components.o reducer.o chopper.o msgpack_structure_stack.o msgpack_object_code_reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_unpacker.vhd

test_bench.o : ../../../src/msgpack_object_unpacker/vhdl/test_bench.vhd msgpack_object.o msgpack_object_components.o msgpack_object_unpacker.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../src/msgpack_object_unpacker/vhdl/test_bench.vhd

