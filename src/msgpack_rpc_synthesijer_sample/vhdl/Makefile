
RPC_IF_GEN = ../../../msgpack-vhdl/tools/msgpack-rpc-synthesijer-ifgen
INTERFACE_VHDL_FILE = Sample_Interface.vhd
SERVER_VHDL_FILE    = Sample_Server.vhd
CONFIG_YAML_FILE    = Sample.yaml

all: $(INTERFACE_VHDL_FILE)

$(INTERFACE_VHDL_FILE) : Sample.vhd
	$(RPC_IF_GEN) -v --server Sample.vhd

clean:
	rm $(INTERFACE_VHDL_FILE) $(SERVER_VHDL_FILE)

test:	
	-rm $(INTERFACE_VHDL_FILE) $(SERVER_VHDL_FILE) $(CONFIG_YAML_FILE) test.log
	$(RPC_IF_GEN) -v --server --yaml $(CONFIG_YAML_FILE) Sample.vhd
	touch test.log
	git diff $(INTERFACE_VHDL_FILE) >> test.log
	git diff $(SERVER_VHDL_FILE)    >> test.log
	git diff $(CONFIG_YAML_FILE)    >> test.log
	cat test.log
