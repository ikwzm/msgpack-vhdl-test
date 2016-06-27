
RPC_IF_GEN = ../../../msgpack-vhdl/tools/msgpack-rpc-ifgen
YAML_FILE           = BinaryMemory.yml
INTERFACE_VHDL_FILE = BinaryMemory_Interface.vhd

all: $(INTERFACE_VHDL_FILE)

$(INTERFACE_VHDL_FILE) : $(YAML_FILE)
	$(RPC_IF_GEN) -v $(YAML_FILE)

clean:
	rm $(INTERFACE_VHDL_FILE)

test:	
	-rm $(INTERFACE_VHDL_FILE) test.log
	$(RPC_IF_GEN) -v $(YAML_FILE)
	touch test.log
	git diff $(INTERFACE_VHDL_FILE) >> test.log
	cat test.log
