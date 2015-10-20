
add_files.tcl : add_files.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config add_files.yml > add_files.tcl

all:
	../../../PipeWork/tools/vhdl-archiver.rb \
            --library dummy_plug \
            --print \
            ../../../Dummy_Plug/src/main/vhdl/ \
            --library msgpack \
            --archive msgpack.vhd \
            ../../../src/main/vhdl/msgpack \
            --library work \
            --print \
            --top test_bench \
            ../../../src/test/vhdl/msgpack_object_code_compare/test_bench.vhd
