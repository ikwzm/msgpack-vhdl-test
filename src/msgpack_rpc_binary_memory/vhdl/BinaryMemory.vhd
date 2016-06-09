library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BinaryMemory is
    generic (
        WIDTH   :     integer := 0;
        DEPTH   :     integer := 12
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        address : in  std_logic_vector(     DEPTH  -1 downto 0);
        we      : in  std_logic;
        wbe     : in  std_logic_vector(  (2**WIDTH)-1 downto 0);
        wdata   : in  std_logic_vector(8*(2**WIDTH)-1 downto 0);
        rdata   : out std_logic_vector(8*(2**WIDTH)-1 downto 0)
    );
end BinaryMemory;

architecture RTL of BinaryMemory is
    constant WORDS         : integer := 2**(DEPTH-WIDTH);
    type     MEM_TYPE      is array ( WORDS-1 downto 0 ) of std_logic_vector(8*(2**WIDTH)-1 downto 0);
    signal   mem           : MEM_TYPE;
begin
 
    process(clk)
        variable addr : integer;
    begin
        if clk'event and clk = '1' then
            addr := to_integer(unsigned(address(DEPTH-1 downto WIDTH)));
            if we = '1' then
                for i in wbe'range loop
                    if (wbe(i) = '1') then
                        mem(addr)(8*(i+1)-1 downto 8*i) <= wdata(8*(i+1)-1 downto 8*i);
                    end if;
                end loop;
            end if;
            rdata <= mem(addr);
        end if;
    end process;
end RTL;
