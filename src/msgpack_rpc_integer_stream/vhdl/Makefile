
RPC_IF_GEN = ../../../msgpack-vhdl/tools/msgpack-rpc-ifgen
YAML_FILE           = IntegerStream.yml
INTERFACE_VHDL_FILE = IntegerStream_Interface.vhd

all: $(INTERFACE_VHDL_FILE)

$(INTERFACE_VHDL_FILE) : $(YAML_FILE)
	$(RPC_IF_GEN) -v $(YAML_FILE)

clean:
	rm $(INTERFACE_VHDL_FILE)
