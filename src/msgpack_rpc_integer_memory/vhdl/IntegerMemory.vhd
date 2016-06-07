library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IntegerMemory is
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;
    data_address : in  unsigned(32-1 downto 0);
    data_we      : in  std_logic;
    data_oe      : in  std_logic;
    data_din     : in  signed(32-1 downto 0);
    data_dout    : out signed(32-1 downto 0);
    data_length  : out signed(32-1 downto 0)
  );
end IntegerMemory;

architecture RTL of IntegerMemory is
    constant WIDTH         : integer := 32;
    constant DEPTH         : integer := 12;
    constant WORDS         : integer := 2**DEPTH;
    type     MEM_TYPE      is array ( WORDS-1 downto 0 ) of std_logic_vector(WIDTH-1 downto 0);
    shared variable mem    : MEM_TYPE := (others => (others => '0'));

    attribute ram_style    : string;
    attribute ram_style    of mem : variable is "block";

begin
  data_length <= to_signed(WORDS, data_length'length);
 
  process(clk)
  begin
    if clk'event and clk = '1' then
      if data_we = '1' then
        mem(to_integer(unsigned(data_address(DEPTH-1 downto 0)))) := std_logic_vector(data_din);
      end if;
      data_dout <= signed(mem(to_integer(unsigned(data_address(DEPTH-1 downto 0)))));
    end if;
  end process;
  
end RTL;
