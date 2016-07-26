SYNTHESIJER ?= ../synthesijer/bin
RPC_IF_GEN  = ../../../msgpack-vhdl/tools/msgpack-rpc-synthesijer-ifgen

SOURCES_JAVA_FILE   = Fib.java
SOURCES_VHDL_FILE   = Fib.vhd
INTERFACE_VHDL_FILE = Fib_Interface.vhd
SERVER_VHDL_FILE    = Fib_Server.vhd

all: $(INTERFACE_VHDL_FILE)

# $(SOURCES_VHDL_FILE)   : $(SOURCES_JAVA_FILE)
# 	java -cp $(SYNTHESIJER):. synthesijer.Main --vhdl $(SOURCES_JAVA_FILE)

$(INTERFACE_VHDL_FILE) : $(SOURCES_VHDL_FILE)
	$(RPC_IF_GEN) -v --server $(SOURCES_VHDL_FILE)

clean:
	rm $(INTERFACE_VHDL_FILE) $(SERVER_VHDL_FILE)

test:	
	-rm $(INTERFACE_VHDL_FILE) $(SERVER_VHDL_FILE) test.log
	$(RPC_IF_GEN) -v --server Fib.vhd
	touch test.log
	git diff $(INTERFACE_VHDL_FILE) >> test.log
	git diff $(SERVER_VHDL_FILE)    >> test.log
	cat test.log
