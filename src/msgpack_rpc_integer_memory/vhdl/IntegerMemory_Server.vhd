library ieee;
use     ieee.std_logic_1164.all;
entity  IntegerMemory_Server is
    generic(
        I_BYTES              : integer := 1;
        O_BYTES              : integer := 1
    );
    port(
        CLK                  : in  std_logic;
        ARESETn              : in  std_logic;
        I_TDATA              : in  std_logic_vector(8*I_BYTES-1 downto 0);
        I_TKEEP              : in  std_logic_vector(  I_BYTES-1 downto 0);
        I_TLAST              : in  std_logic;
        I_TVALID             : in  std_logic;
        I_TREADY             : out std_logic;
        O_TDATA              : out std_logic_vector(8*O_BYTES-1 downto 0);
        O_TKEEP              : out std_logic_vector(  O_BYTES-1 downto 0);
        O_TLAST              : out std_logic;
        O_TVALID             : out std_logic;
        O_TREADY             : in  std_logic
    );
end     IntegerMemory_Server;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of IntegerMemory_Server is
    signal    reset            :  std_logic;
    signal    reset_n          :  std_logic;
    signal    data_address     :  signed(32-1 downto 0);
    signal    data_din         :  signed(32-1 downto 0);
    signal    data_we          :  std_logic;
    signal    data_dout        :  signed(32-1 downto 0);
    component IntegerMemory_Interface is
        generic(
            I_BYTES              : integer := 1;
            O_BYTES              : integer := 1
        );
        port(
            CLK                  : in  std_logic;
            RST                  : in  std_logic;
            CLR                  : in  std_logic;
            I_DATA               : in  std_logic_vector(8*I_BYTES-1 downto 0);
            I_STRB               : in  std_logic_vector(  I_BYTES-1 downto 0);
            I_LAST               : in  std_logic;
            I_VALID              : in  std_logic;
            I_READY              : out std_logic;
            O_DATA               : out std_logic_vector(8*O_BYTES-1 downto 0);
            O_STRB               : out std_logic_vector(  O_BYTES-1 downto 0);
            O_LAST               : out std_logic;
            O_VALID              : out std_logic;
            O_READY              : in  std_logic;
            data_address         : out signed(32-1 downto 0);
            data_din             : out signed(32-1 downto 0);
            data_we              : out std_logic;
            data_dout            : in  signed(32-1 downto 0)
        );
    end component;
    component IntegerMemory is
        port(
            clk                  : in  std_logic;
            reset                : in  std_logic;
            data_address         : in  signed(32-1 downto 0);
            data_din             : in  signed(32-1 downto 0);
            data_we              : in  std_logic;
            data_dout            : out signed(32-1 downto 0)
        );
    end component;
begin
    reset      <= not ARESETn;
    reset_n    <=     ARESETn;
    U : IntegerMemory_Interface
        generic map(
            I_BYTES              => I_BYTES             ,
            O_BYTES              => O_BYTES             
        )
        port map(
            CLK                  => CLK                 ,
            RST                  => reset               ,
            CLR                  => '0'                 ,
            I_DATA               => I_TDATA             ,
            I_STRB               => I_TKEEP             ,
            I_LAST               => I_TLAST             ,
            I_VALID              => I_TVALID            ,
            I_READY              => I_TREADY            ,
            O_DATA               => O_TDATA             ,
            O_STRB               => O_TKEEP             ,
            O_LAST               => O_TLAST             ,
            O_VALID              => O_TVALID            ,
            O_READY              => O_TREADY            ,
            data_address         => data_address        ,
            data_din             => data_din            ,
            data_we              => data_we             ,
            data_dout            => data_dout           
        );
    T : IntegerMemory
        port map(
            clk                  => CLK                 ,
            reset                => reset               ,
            data_address         => data_address        ,
            data_din             => data_din            ,
            data_we              => data_we             ,
            data_dout            => data_dout           
        );
end RTL;
