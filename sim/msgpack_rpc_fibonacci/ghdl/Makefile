
DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SRC_PATH             = ../../../src/msgpack_rpc_fibonacci

COPY       = cp
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH)

test   : test_1

test_1 : test_bench.o dut test_1.snr 
	$(COPY) test_1.snr test.snr
	-$(GHDL) -e $(GHDLFLAGS) --work=msgpack TEST_BENCH
	-$(GHDL) -r $(GHDLFLAGS) --work=msgpack TEST_BENCH

clean  : 
	$(REMOVE) *.o *.cf *.snr sources.mk

dut    : Fibonacci_Server.o

sources.mk   : sources.yml
	make -C $(SRC_PATH)/vhdl/
	../../../PipeWork/tools/vhdl-archiver.rb -v --config sources.yml > sources.mk

test_1.snr   : $(SRC_PATH)/scenarios/test_1.rb
	ruby $<

include sources.mk

