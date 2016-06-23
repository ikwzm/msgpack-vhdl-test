
RPC_IF_GEN = ../../../msgpack-vhdl/tools/msgpack-rpc-ifgen
YAML_FILE           = BooleanTest.yml
INTERFACE_VHDL_FILE = BooleanTest_Interface.vhd

all: $(INTERFACE_VHDL_FILE)

$(INTERFACE_VHDL_FILE) : $(YAML_FILE)
	$(RPC_IF_GEN) -v $(YAML_FILE)

clean:
	rm $(INTERFACE_VHDL_FILE) $(SERVER_VHDL_FILE)
