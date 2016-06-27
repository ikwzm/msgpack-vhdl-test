library ieee;
use     ieee.std_logic_1164.all;
entity  BooleanStream_Fifo is
    -------------------------------------------------------------------------------
    -- Generic Parameters
    -------------------------------------------------------------------------------
    generic (
        WIDTH           : positive := 4;
        DEPTH           : positive := 4096;
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
        I_DATA          : in  std_logic_vector(WIDTH  -1 downto 0);
        I_STRB          : in  std_logic_vector(WIDTH  -1 downto 0) := (others => '1');
        I_LAST          : in  std_logic := '0';
        I_VALID         : in  std_logic;
        I_READY         : out std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
        O_SIZE          : out std_logic_vector(SIZE_BITS-1 downto 0);
        O_DATA          : out std_logic_vector(WIDTH  -1 downto 0);
        O_STRB          : out std_logic_vector(WIDTH  -1 downto 0);
        O_LAST          : out std_logic;
        O_VALID         : out std_logic;
        O_READY         : in  std_logic
    );
end  BooleanStream_Fifo;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of BooleanStream_Fifo is
    constant WORDS         :  integer := DEPTH/WIDTH;
    type     MEM_TYPE      is array ( WORDS-1 downto 0 ) of std_logic_vector(WIDTH+WIDTH downto 0);
    signal   mem           :  MEM_TYPE;
    signal   ii_valid      :  std_logic;
    signal   ii_ready      :  std_logic;
    signal   ii_addr       :  integer range 0 to WORDS-1;
    signal   ii_strb       :  std_logic_vector(  WIDTH  -1 downto 0);
    signal   oo_valid      :  std_logic;
    signal   oo_ready      :  std_logic;
    signal   oo_addr       :  integer range 0 to WORDS-1;
    signal   oo_strb       :  std_logic_vector(  WIDTH  -1 downto 0);
    signal   curr_words    :  integer range 0 to WORDS;
    signal   curr_bits     :  integer range 0 to DEPTH;
begin
    process(CLK, RST) begin
        if (RST = '1') then
                mem <= (others => (others => '0'));
        elsif CLK'event and CLK = '1' then
            if (CLR = '1') then
                mem <= (others => (others => '0'));
            else
                if (ii_valid = '1' and ii_ready = '1') then
                    mem(ii_addr)(WIDTH      -1 downto 0    ) <= I_DATA;
                    mem(ii_addr)(WIDTH+WIDTH-1 downto WIDTH) <= I_STRB;
                    mem(ii_addr)(WIDTH+WIDTH               ) <= I_LAST;
                end if;
            end if;
        end if;
    end process;

    O_DATA  <= mem(oo_addr)(WIDTH      -1 downto 0    );
    O_STRB  <= mem(oo_addr)(WIDTH+WIDTH-1 downto WIDTH);
    O_LAST  <= mem(oo_addr)(WIDTH+WIDTH               );
    oo_strb <= mem(oo_addr)(WIDTH+WIDTH-1 downto WIDTH);

    process(CLK, RST)
        variable next_words : integer;
        variable next_bits  : integer;
        function WORD_WIDTH(STRB: std_logic_vector) return integer is
            variable width: integer;
        begin
            width := 0;
            for i in STRB'range loop
                if (STRB(i) = '1') then
                    width := width + 1;
                end if;
            end loop;
            return width;
        end function;
    begin
        if (RST = '1') then
                ii_addr    <= 0;
                oo_addr    <= 0;
                curr_words <= 0;
                curr_bits <= 0;
        elsif CLK'event and CLK = '1' then
            if (CLR = '1') then
                ii_addr    <= 0;
                oo_addr    <= 0;
                curr_words <= 0;
                curr_bits <= 0;
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
                next_bits  := curr_bits;
                if (ii_valid = '1' and ii_ready = '1') then
                    next_words := next_words + 1;
                    next_bits  := next_bits  + WORD_WIDTH(ii_strb);
                end if;
                if (oo_valid = '1' and oo_ready = '1') then
                    next_words := next_words - 1;
                    next_bits  := next_bits  - WORD_WIDTH(oo_strb);
                end if;
                curr_words <= next_words;
                curr_bits  <= next_bits;
            end if;
        end if;
    end process;

    ii_valid <= I_VALID;
    ii_ready <= '1' when (curr_words < WORDS) else '0';
    ii_strb  <= I_STRB;
    I_READY  <= ii_ready;

    oo_valid <= '1' when (curr_words > 0    ) else '0';
    oo_ready <= O_READY;
    O_VALID  <= oo_valid;
    O_SIZE   <= std_logic_vector(to_unsigned(curr_bits, SIZE_BITS));
    
end RTL;
