msgpack_object.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object.vhd

msgpack_object_code_compare.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_compare.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_compare.vhd

msgpack_object_components.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_components.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_components.vhd

msgpack_kvmap_components.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_components.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_components.vhd

msgpack_kvmap_key_compare.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_key_compare.vhd msgpack_object.o msgpack_object_components.o msgpack_object_code_compare.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_key_compare.vhd

test_sample.o : ../../../src/msgpack_kvmap_key_compare/vhdl/test_sample.vhd msgpack_object.o msgpack_kvmap_components.o msgpack_kvmap_key_compare.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../src/msgpack_kvmap_key_compare/vhdl/test_sample.vhd

test_bench.o : ../../../src/msgpack_kvmap_key_compare/vhdl/test_bench.vhd msgpack_object.o test_sample.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../src/msgpack_kvmap_key_compare/vhdl/test_bench.vhd

