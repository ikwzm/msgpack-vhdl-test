msgpack_object.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object.vhd

pipework_components.o : ../../../msgpack-vhdl/src/msgpack/pipework/pipework_components.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/pipework/pipework_components.vhd

queue_register.o : ../../../msgpack-vhdl/src/msgpack/pipework/queue_register.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/pipework/queue_register.vhd

reducer.o : ../../../msgpack-vhdl/src/msgpack/pipework/reducer.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/pipework/reducer.vhd

msgpack_kvmap_components.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_components.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_components.vhd

msgpack_kvmap_key_match_aggregator.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_key_match_aggregator.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_key_match_aggregator.vhd

msgpack_object_code_reducer.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_reducer.vhd msgpack_object.o pipework_components.o reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_reducer.vhd

msgpack_object_components.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_components.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_components.vhd

msgpack_object_decode_array.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_array.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_array.vhd

msgpack_object_decode_integer.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_integer.vhd msgpack_object.o pipework_components.o queue_register.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_integer.vhd

msgpack_object_encode_array.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_array.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_array.vhd

msgpack_kvmap_dispatcher.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_dispatcher.vhd msgpack_object.o msgpack_kvmap_components.o msgpack_kvmap_key_match_aggregator.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_dispatcher.vhd

msgpack_object_decode_integer_stream.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_integer_stream.vhd msgpack_object.o msgpack_object_components.o msgpack_object_decode_array.o msgpack_object_decode_integer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_integer_stream.vhd

msgpack_object_decode_map.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_map.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_map.vhd

msgpack_object_encode_integer_stream.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_integer_stream.vhd msgpack_object.o msgpack_object_components.o msgpack_object_code_reducer.o msgpack_object_encode_array.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_integer_stream.vhd

msgpack_object_encode_map.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_map.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_map.vhd

msgpack_structure_stack.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_structure_stack.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_structure_stack.vhd

chopper.o : ../../../msgpack-vhdl/src/msgpack/pipework/chopper.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/pipework/chopper.vhd

msgpack_kvmap_query_map_value.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_query_map_value.vhd msgpack_object.o msgpack_kvmap_components.o msgpack_kvmap_dispatcher.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_query_map_value.vhd

msgpack_kvmap_store_map_value.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_store_map_value.vhd msgpack_object.o msgpack_kvmap_components.o msgpack_kvmap_dispatcher.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_store_map_value.vhd

msgpack_object_code_compare.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_compare.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_compare.vhd

msgpack_object_code_fifo.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_fifo.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_code_fifo.vhd

msgpack_object_decode_integer_array.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_integer_array.vhd msgpack_object.o msgpack_object_components.o msgpack_object_decode_integer_stream.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_decode_integer_array.vhd

msgpack_object_encode_integer_array.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_integer_array.vhd msgpack_object.o msgpack_object_components.o msgpack_object_encode_integer_stream.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_integer_array.vhd

msgpack_object_encode_string_constant.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_string_constant.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_encode_string_constant.vhd

msgpack_object_match_aggregator.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_match_aggregator.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_match_aggregator.vhd

msgpack_object_packer.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_packer.vhd msgpack_object.o pipework_components.o reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_packer.vhd

msgpack_object_query_array.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_query_array.vhd msgpack_object.o msgpack_object_components.o msgpack_object_decode_map.o msgpack_object_encode_map.o msgpack_object_decode_integer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_query_array.vhd

msgpack_object_query_stream_parameter.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_query_stream_parameter.vhd msgpack_object.o msgpack_object_components.o msgpack_object_decode_integer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_query_stream_parameter.vhd

msgpack_object_store_array.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_store_array.vhd msgpack_object.o msgpack_object_components.o msgpack_object_decode_map.o msgpack_object_decode_integer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_store_array.vhd

msgpack_object_unpacker.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_unpacker.vhd msgpack_object.o pipework_components.o msgpack_object_components.o reducer.o chopper.o msgpack_structure_stack.o msgpack_object_code_reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_unpacker.vhd

queue_arbiter.o : ../../../msgpack-vhdl/src/msgpack/pipework/queue_arbiter.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/pipework/queue_arbiter.vhd

msgpack_rpc.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc.vhd msgpack_object.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc.vhd

msgpack_kvmap_key_compare.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_key_compare.vhd msgpack_object.o msgpack_object_components.o msgpack_object_code_compare.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_key_compare.vhd

msgpack_kvmap_query.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_query.vhd msgpack_object.o msgpack_object_components.o msgpack_kvmap_components.o msgpack_object_decode_map.o msgpack_kvmap_query_map_value.o msgpack_object_encode_map.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_query.vhd

msgpack_kvmap_store.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_store.vhd msgpack_object.o msgpack_object_components.o msgpack_kvmap_components.o msgpack_object_decode_map.o msgpack_kvmap_store_map_value.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_store.vhd

msgpack_object_query_integer_array.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_query_integer_array.vhd msgpack_object.o msgpack_object_components.o msgpack_object_query_array.o msgpack_object_query_stream_parameter.o msgpack_object_encode_integer_array.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_query_integer_array.vhd

msgpack_object_store_integer_array.o : ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_store_integer_array.vhd msgpack_object.o msgpack_object_components.o msgpack_object_store_array.o msgpack_object_decode_integer_array.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/object/msgpack_object_store_integer_array.vhd

msgpack_rpc_components.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_components.vhd msgpack_object.o msgpack_rpc.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_components.vhd

msgpack_rpc_method_return_code.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_method_return_code.vhd msgpack_object.o msgpack_rpc.o msgpack_object_components.o msgpack_object_code_reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_method_return_code.vhd

msgpack_rpc_method_return_nil.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_method_return_nil.vhd msgpack_object.o msgpack_rpc.o msgpack_object_components.o msgpack_object_code_reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_method_return_nil.vhd

msgpack_rpc_server_requester.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server_requester.vhd msgpack_object.o msgpack_rpc.o msgpack_object_components.o msgpack_kvmap_components.o msgpack_object_unpacker.o msgpack_object_code_compare.o msgpack_object_match_aggregator.o msgpack_kvmap_key_match_aggregator.o msgpack_object_code_fifo.o msgpack_object_code_reducer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server_requester.vhd

msgpack_rpc_server_responder.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server_responder.vhd msgpack_object.o msgpack_rpc.o msgpack_object_components.o pipework_components.o queue_arbiter.o msgpack_object_encode_string_constant.o msgpack_object_code_reducer.o msgpack_object_packer.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server_responder.vhd

msgpack_kvmap_query_integer_array.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_query_integer_array.vhd msgpack_object.o msgpack_object_components.o msgpack_kvmap_components.o msgpack_kvmap_key_compare.o msgpack_object_query_integer_array.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_query_integer_array.vhd

msgpack_kvmap_store_integer_array.o : ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_store_integer_array.vhd msgpack_object.o msgpack_object_components.o msgpack_kvmap_components.o msgpack_kvmap_key_compare.o msgpack_object_store_integer_array.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/kvmap/msgpack_kvmap_store_integer_array.vhd

msgpack_rpc_server.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server.vhd msgpack_object.o msgpack_rpc.o msgpack_rpc_components.o msgpack_rpc_server_requester.o msgpack_rpc_server_responder.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server.vhd

msgpack_rpc_server_kvmap_get_value.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server_kvmap_get_value.vhd msgpack_object.o msgpack_rpc.o msgpack_object_components.o msgpack_rpc_components.o msgpack_kvmap_components.o msgpack_kvmap_key_compare.o msgpack_object_code_reducer.o msgpack_object_decode_array.o msgpack_kvmap_query.o msgpack_object_encode_array.o msgpack_rpc_method_return_code.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server_kvmap_get_value.vhd

msgpack_rpc_server_kvmap_set_value.o : ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server_kvmap_set_value.vhd msgpack_object.o msgpack_rpc.o msgpack_object_components.o msgpack_rpc_components.o msgpack_kvmap_components.o msgpack_kvmap_key_compare.o msgpack_object_code_reducer.o msgpack_object_decode_array.o msgpack_kvmap_store.o msgpack_rpc_method_return_nil.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../msgpack-vhdl/src/msgpack/rpc/msgpack_rpc_server_kvmap_set_value.vhd

IntegerMemory.o : ../../../src/msgpack_rpc_integer_memory/vhdl/IntegerMemory.vhd 
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../src/msgpack_rpc_integer_memory/vhdl/IntegerMemory.vhd

IntegerMemory_Interface.o : ../../../src/msgpack_rpc_integer_memory/vhdl/IntegerMemory_Interface.vhd msgpack_object.o msgpack_rpc.o msgpack_rpc_components.o msgpack_kvmap_components.o msgpack_rpc_server.o msgpack_rpc_server_kvmap_get_value.o msgpack_kvmap_query_integer_array.o msgpack_rpc_server_kvmap_set_value.o msgpack_kvmap_store_integer_array.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../src/msgpack_rpc_integer_memory/vhdl/IntegerMemory_Interface.vhd

IntegerMemory_Server.o : ../../../src/msgpack_rpc_integer_memory/vhdl/IntegerMemory_Server.vhd msgpack_object.o IntegerMemory_Interface.o IntegerMemory.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../src/msgpack_rpc_integer_memory/vhdl/IntegerMemory_Server.vhd

test_bench.o : ../../../src/msgpack_rpc_integer_memory/vhdl/test_bench.vhd IntegerMemory_Server.o
	ghdl -a -C $(GHDLFLAGS) --work=MSGPACK ../../../src/msgpack_rpc_integer_memory/vhdl/test_bench.vhd

