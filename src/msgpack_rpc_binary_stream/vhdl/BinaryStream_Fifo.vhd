library ieee;
use     ieee.std_logic_1164.all;
entity  BinaryStream_Fifo is
    -------------------------------------------------------------------------------
    -- Generic Parameters
    -------------------------------------------------------------------------------
    generic (
        BYTES           : positive := 4;
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
        I_DATA          : in  std_logic_vector(8*BYTES  -1 downto 0);
        I_STRB          : in  std_logic_vector(  BYTES  -1 downto 0) := (others => '1');
        I_LAST          : in  std_logic := '0';
        I_VALID         : in  std_logic;
        I_READY         : out std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
        O_SIZE          : out std_logic_vector(SIZE_BITS-1 downto 0);
        O_DATA          : out std_logic_vector(8*BYTES  -1 downto 0);
        O_STRB          : out std_logic_vector(  BYTES  -1 downto 0);
        O_LAST          : out std_logic;
        O_VALID         : out std_logic;
        O_READY         : in  std_logic
    );
end  BinaryStream_Fifo;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of BinaryStream_Fifo is
    constant WORDS         :  integer := DEPTH/BYTES;
    type     MEM_TYPE      is array ( WORDS-1 downto 0 ) of std_logic_vector(8*BYTES+BYTES downto 0);
    signal   mem           :  MEM_TYPE;
    signal   ii_valid      :  std_logic;
    signal   ii_ready      :  std_logic;
    signal   ii_addr       :  integer range 0 to WORDS-1;
    signal   ii_strb       :  std_logic_vector(  BYTES  -1 downto 0);
    signal   oo_valid      :  std_logic;
    signal   oo_ready      :  std_logic;
    signal   oo_addr       :  integer range 0 to WORDS-1;
    signal   oo_strb       :  std_logic_vector(  BYTES  -1 downto 0);
    signal   curr_words    :  integer range 0 to WORDS;
    signal   curr_bytes    :  integer range 0 to DEPTH;
begin
    process(CLK, RST) begin
        if (RST = '1') then
                mem <= (others => (others => '0'));
        elsif CLK'event and CLK = '1' then
            if (CLR = '1') then
                mem <= (others => (others => '0'));
            else
                if (ii_valid = '1' and ii_ready = '1') then
                    mem(ii_addr)(8*BYTES      -1 downto 0      ) <= I_DATA;
                    mem(ii_addr)(8*BYTES+BYTES-1 downto 8*BYTES) <= I_STRB;
                    mem(ii_addr)(8*BYTES+BYTES                 ) <= I_LAST;
                end if;
            end if;
        end if;
    end process;

    O_DATA  <= mem(oo_addr)(8*BYTES      -1 downto 0      );
    O_STRB  <= mem(oo_addr)(8*BYTES+BYTES-1 downto 8*BYTES);
    O_LAST  <= mem(oo_addr)(8*BYTES+BYTES                 );
    oo_strb <= mem(oo_addr)(8*BYTES+BYTES-1 downto 8*BYTES);

    process(CLK, RST)
        variable next_words : integer;
        variable next_bytes : integer;
        function WORD_BYTES(STRB: std_logic_vector) return integer is
            variable bytes: integer;
        begin
            bytes := 0;
            for i in STRB'range loop
                if (STRB(i) = '1') then
                    bytes := bytes + 1;
                end if;
            end loop;
            return bytes;
        end function;
    begin
        if (RST = '1') then
                ii_addr    <= 0;
                oo_addr    <= 0;
                curr_words <= 0;
                curr_bytes <= 0;
        elsif CLK'event and CLK = '1' then
            if (CLR = '1') then
                ii_addr    <= 0;
                oo_addr    <= 0;
                curr_words <= 0;
                curr_bytes <= 0;
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
                next_bytes := curr_bytes;
                if (ii_valid = '1' and ii_ready = '1') then
                    next_words := next_words + 1;
                    next_bytes := next_bytes + WORD_BYTES(ii_strb);
                end if;
                if (oo_valid = '1' and oo_ready = '1') then
                    next_words := next_words - 1;
                    next_bytes := next_bytes - WORD_BYTES(oo_strb);
                end if;
                curr_words <= next_words;
                curr_bytes <= next_bytes;
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
    O_SIZE   <= std_logic_vector(to_unsigned(curr_bytes, SIZE_BITS));
    
end RTL;
