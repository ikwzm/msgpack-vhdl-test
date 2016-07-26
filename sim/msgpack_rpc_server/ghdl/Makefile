
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SRC_PATH             = ../../../src

COPY       = cp
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH)

test   : test_1 test_2 test 3

test_1 : test_bench.o dut $(SRC_PATH)/msgpack_rpc_server/scenarios/test_1.snr 
	$(COPY) $(SRC_PATH)/msgpack_rpc_server/scenarios/test_1.snr test.snr
	$(GHDL) -e $(GHDLFLAGS) --work=msgpack TEST_BENCH
	$(GHDL) -r $(GHDLFLAGS) --work=msgpack TEST_BENCH

test_2 : test_bench.o dut $(SRC_PATH)/msgpack_rpc_server/scenarios/test_2.snr 
	$(COPY) $(SRC_PATH)/msgpack_rpc_server/scenarios/test_2.snr test.snr
	$(GHDL) -e $(GHDLFLAGS) --work=msgpack TEST_BENCH
	$(GHDL) -r $(GHDLFLAGS) --work=msgpack TEST_BENCH

test_3 : test_bench.o dut $(SRC_PATH)/msgpack_rpc_server/scenarios/test_3.snr 
	$(COPY) $(SRC_PATH)/msgpack_rpc_server/scenarios/test_3.snr test.snr
	$(GHDL) -e $(GHDLFLAGS) --work=msgpack TEST_BENCH
	$(GHDL) -r $(GHDLFLAGS) --work=msgpack TEST_BENCH

clean  : 
	$(REMOVE) *.o *.cf *.snr sources.mk

dut    : msgpack_rpc_server.o

sources.mk   : sources.yml
	../../../PipeWork/tools/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk

