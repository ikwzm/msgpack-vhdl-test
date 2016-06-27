library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BooleanMemory is
    generic (
        WIDTH   :     integer := 0;
        DEPTH   :     integer := 12
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        waddr   : in  std_logic_vector(   DEPTH  -1 downto 0);
        we      : in  std_logic;
        wbe     : in  std_logic_vector((2**WIDTH)-1 downto 0);
        wdata   : in  std_logic_vector((2**WIDTH)-1 downto 0);
        raddr   : in  std_logic_vector(   DEPTH  -1 downto 0);
        rdata   : out std_logic_vector((2**WIDTH)-1 downto 0)
    );
end BooleanMemory;

architecture RTL of BooleanMemory is
    constant WORDS         : integer := 2**(DEPTH-WIDTH);
    type     MEM_TYPE      is array ( WORDS-1 downto 0 ) of std_logic_vector((2**WIDTH)-1 downto 0);
    signal   mem           : MEM_TYPE;
begin
 
    process(clk)
        variable addr : integer;
    begin
        if clk'event and clk = '1' then
            addr  := to_integer(unsigned(waddr(DEPTH-1 downto WIDTH)));
            if we = '1' then
                for i in wbe'range loop
                    if (wbe(i) = '1') then
                        mem(addr)((i+1)-1 downto i) <= wdata((i+1)-1 downto i);
                    end if;
                end loop;
            end if;
            addr  := to_integer(unsigned(raddr(DEPTH-1 downto WIDTH)));
            rdata <= mem(addr);
        end if;
    end process;
end RTL;
