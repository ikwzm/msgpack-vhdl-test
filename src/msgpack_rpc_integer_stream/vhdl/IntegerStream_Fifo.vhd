library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
entity  IntegerStream_Fifo is
    -------------------------------------------------------------------------------
    -- Generic Parameters
    -------------------------------------------------------------------------------
    generic (
        DEPTH           : positive := 4096;
        DATA_BITS       : positive := 32;
        SIZE_BITS       : positive := 32
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock and Reset Signals
    -------------------------------------------------------------------------------
        CLK             : in  std_logic; 
        RST             : in  std_logic; 
        CLR             : in  std_logic; 
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
        I_DATA          : in  signed(          DATA_BITS-1 downto 0);
        I_LAST          : in  std_logic := '0';
        I_VALID         : in  std_logic;
        I_READY         : out std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
        O_SIZE          : out std_logic_vector(SIZE_BITS-1 downto 0);
        O_DATA          : out signed(          DATA_BITS-1 downto 0);
        O_LAST          : out std_logic;
        O_VALID         : out std_logic;
        O_READY         : in  std_logic
    );
end  IntegerStream_Fifo;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of IntegerStream_Fifo is
    constant WORDS         :  integer := DEPTH;
    type     MEM_TYPE      is array ( WORDS-1 downto 0 ) of std_logic_vector(DATA_BITS downto 0);
    signal   mem           :  MEM_TYPE;
    signal   ii_valid      :  std_logic;
    signal   ii_ready      :  std_logic;
    signal   ii_addr       :  integer range 0 to WORDS-1;
    signal   oo_valid      :  std_logic;
    signal   oo_ready      :  std_logic;
    signal   oo_addr       :  integer range 0 to WORDS-1;
    signal   curr_words    :  integer range 0 to WORDS;
begin
    process(CLK, RST) begin
        if (RST = '1') then
                mem <= (others => (others => '0'));
        elsif CLK'event and CLK = '1' then
            if (CLR = '1') then
                mem <= (others => (others => '0'));
            else
                if (ii_valid = '1' and ii_ready = '1') then
                    mem(ii_addr)(DATA_BITS-1 downto 0) <= std_logic_vector(I_DATA);
                    mem(ii_addr)(DATA_BITS           ) <= I_LAST;
                end if;
            end if;
        end if;
    end process;

    O_DATA  <= signed(mem(oo_addr)(DATA_BITS-1 downto 0));
    O_LAST  <=        mem(oo_addr)(DATA_BITS           );

    process(CLK, RST)
        variable next_words : integer;
    begin
        if (RST = '1') then
                ii_addr    <= 0;
                oo_addr    <= 0;
                curr_words <= 0;
        elsif CLK'event and CLK = '1' then
            if (CLR = '1') then
                ii_addr    <= 0;
                oo_addr    <= 0;
                curr_words <= 0;
            else
                if (ii_valid = '1' and ii_ready = '1') then
                    if (ii_addr < WORDS-1) then
                        ii_addr <= ii_addr + 1;
                    else
                        ii_addr <= 0;
                    end if;
                    
                end if;
                if (oo_valid = '1' and oo_ready = '1') then
                    if (oo_addr < WORDS-1) then
                        oo_addr <= oo_addr + 1;
                    else
                        oo_addr <= 0;
                    end if;
                end if;
                next_words := curr_words;
                if (ii_valid = '1' and ii_ready = '1') then
                    next_words := next_words + 1;
                end if;
                if (oo_valid = '1' and oo_ready = '1') then
                    next_words := next_words - 1;
                end if;
                curr_words <= next_words;
            end if;
        end if;
    end process;

    ii_valid <= I_VALID;
    ii_ready <= '1' when (curr_words < WORDS) else '0';
    I_READY  <= ii_ready;

    oo_valid <= '1' when (curr_words > 0    ) else '0';
    oo_ready <= O_READY;
    O_VALID  <= oo_valid;
    O_SIZE   <= std_logic_vector(to_unsigned(curr_words, SIZE_BITS));
    
end RTL;
