library ieee;
use     ieee.std_logic_1164.all;
entity  Sample_Server is
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
end     Sample_Server;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of Sample_Server is
    signal    reset            :  std_logic;
    signal    reset_n          :  std_logic;
    signal    m0_req           :  std_logic;
    signal    m0_busy          :  std_logic;
    signal    m1_req           :  std_logic;
    signal    m1_busy          :  std_logic;
    signal    m1_p             :  std_logic;
    signal    m1_return        :  std_logic;
    signal    m2_req           :  std_logic;
    signal    m2_busy          :  std_logic;
    signal    m2_b             :  signed(8-1 downto 0);
    signal    m2_i             :  signed(32-1 downto 0);
    signal    m2_return        :  signed(8-1 downto 0);
    signal    m3_req           :  std_logic;
    signal    m3_busy          :  std_logic;
    signal    m3_s             :  signed(16-1 downto 0);
    signal    m3_i             :  signed(32-1 downto 0);
    signal    m3_return        :  signed(16-1 downto 0);
    signal    m4_req           :  std_logic;
    signal    m4_busy          :  std_logic;
    signal    m4_a3            :  signed(8-1 downto 0);
    signal    m4_a2            :  signed(16-1 downto 0);
    signal    m4_a1            :  signed(32-1 downto 0);
    signal    m4_a0            :  signed(64-1 downto 0);
    signal    m4_return        :  signed(64-1 downto 0);
    signal    ivar_in          :  signed(32-1 downto 0);
    signal    ivar_we          :  std_logic;
    signal    ivar_out         :  signed(32-1 downto 0);
    signal    bvar_in          :  signed(8-1 downto 0);
    signal    bvar_we          :  std_logic;
    signal    bvar_out         :  signed(8-1 downto 0);
    signal    svar_in          :  signed(16-1 downto 0);
    signal    svar_we          :  std_logic;
    signal    svar_out         :  signed(16-1 downto 0);
    signal    lvar_in          :  signed(64-1 downto 0);
    signal    lvar_we          :  std_logic;
    signal    lvar_out         :  signed(64-1 downto 0);
    signal    tvar_in          :  std_logic;
    signal    tvar_we          :  std_logic;
    signal    tvar_out         :  std_logic;
    signal    imem_address     :  signed(32-1 downto 0);
    signal    imem_din         :  signed(32-1 downto 0);
    signal    imem_we          :  std_logic;
    signal    imem_dout        :  signed(32-1 downto 0);
    signal    imem_oe          :  std_logic;
    signal    imem_length      :  signed(32-1 downto 0);
    signal    bmem_address     :  signed(32-1 downto 0);
    signal    bmem_din         :  signed(8-1 downto 0);
    signal    bmem_we          :  std_logic;
    signal    bmem_dout        :  signed(8-1 downto 0);
    signal    bmem_oe          :  std_logic;
    signal    bmem_length      :  signed(32-1 downto 0);
    signal    smem_address     :  signed(32-1 downto 0);
    signal    smem_din         :  signed(16-1 downto 0);
    signal    smem_we          :  std_logic;
    signal    smem_dout        :  signed(16-1 downto 0);
    signal    smem_oe          :  std_logic;
    signal    smem_length      :  signed(32-1 downto 0);
    signal    lmem_address     :  signed(32-1 downto 0);
    signal    lmem_din         :  signed(64-1 downto 0);
    signal    lmem_we          :  std_logic;
    signal    lmem_dout        :  signed(64-1 downto 0);
    signal    lmem_oe          :  std_logic;
    signal    lmem_length      :  signed(32-1 downto 0);
    signal    tmem_address     :  signed(32-1 downto 0);
    signal    tmem_din         :  signed(1-1 downto 0);
    signal    tmem_we          :  std_logic;
    signal    tmem_dout        :  signed(1-1 downto 0);
    signal    tmem_oe          :  std_logic;
    signal    tmem_length      :  signed(32-1 downto 0);
    component Sample_Interface is
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
            m0_req               : out std_logic;
            m0_busy              : in  std_logic;
            m1_req               : out std_logic;
            m1_busy              : in  std_logic;
            m1_p                 : out std_logic;
            m1_return            : in  std_logic;
            m2_req               : out std_logic;
            m2_busy              : in  std_logic;
            m2_b                 : out signed(8-1 downto 0);
            m2_i                 : out signed(32-1 downto 0);
            m2_return            : in  signed(8-1 downto 0);
            m3_req               : out std_logic;
            m3_busy              : in  std_logic;
            m3_s                 : out signed(16-1 downto 0);
            m3_i                 : out signed(32-1 downto 0);
            m3_return            : in  signed(16-1 downto 0);
            m4_req               : out std_logic;
            m4_busy              : in  std_logic;
            m4_a3                : out signed(8-1 downto 0);
            m4_a2                : out signed(16-1 downto 0);
            m4_a1                : out signed(32-1 downto 0);
            m4_a0                : out signed(64-1 downto 0);
            m4_return            : in  signed(64-1 downto 0);
            ivar_in              : out signed(32-1 downto 0);
            ivar_we              : out std_logic;
            ivar_out             : in  signed(32-1 downto 0);
            bvar_in              : out signed(8-1 downto 0);
            bvar_we              : out std_logic;
            bvar_out             : in  signed(8-1 downto 0);
            svar_in              : out signed(16-1 downto 0);
            svar_we              : out std_logic;
            svar_out             : in  signed(16-1 downto 0);
            lvar_in              : out signed(64-1 downto 0);
            lvar_we              : out std_logic;
            lvar_out             : in  signed(64-1 downto 0);
            tvar_in              : out std_logic;
            tvar_we              : out std_logic;
            tvar_out             : in  std_logic;
            imem_address         : out signed(32-1 downto 0);
            imem_din             : out signed(32-1 downto 0);
            imem_we              : out std_logic;
            imem_dout            : in  signed(32-1 downto 0);
            imem_oe              : out std_logic;
            imem_length          : in  signed(32-1 downto 0);
            bmem_address         : out signed(32-1 downto 0);
            bmem_din             : out signed(8-1 downto 0);
            bmem_we              : out std_logic;
            bmem_dout            : in  signed(8-1 downto 0);
            bmem_oe              : out std_logic;
            bmem_length          : in  signed(32-1 downto 0);
            smem_address         : out signed(32-1 downto 0);
            smem_din             : out signed(16-1 downto 0);
            smem_we              : out std_logic;
            smem_dout            : in  signed(16-1 downto 0);
            smem_oe              : out std_logic;
            smem_length          : in  signed(32-1 downto 0);
            lmem_address         : out signed(32-1 downto 0);
            lmem_din             : out signed(64-1 downto 0);
            lmem_we              : out std_logic;
            lmem_dout            : in  signed(64-1 downto 0);
            lmem_oe              : out std_logic;
            lmem_length          : in  signed(32-1 downto 0);
            tmem_address         : out signed(32-1 downto 0);
            tmem_din             : out signed(1-1 downto 0);
            tmem_we              : out std_logic;
            tmem_dout            : in  signed(1-1 downto 0);
            tmem_oe              : out std_logic;
            tmem_length          : in  signed(32-1 downto 0)
        );
    end component;
    component Sample is
        port(
            clk                  : in  std_logic;
            reset                : in  std_logic;
            m0_req               : in  std_logic;
            m0_busy              : out std_logic;
            m1_req               : in  std_logic;
            m1_busy              : out std_logic;
            m1_p                 : in  std_logic;
            m1_return            : out std_logic;
            m2_req               : in  std_logic;
            m2_busy              : out std_logic;
            m2_b                 : in  signed(8-1 downto 0);
            m2_i                 : in  signed(32-1 downto 0);
            m2_return            : out signed(8-1 downto 0);
            m3_req               : in  std_logic;
            m3_busy              : out std_logic;
            m3_s                 : in  signed(16-1 downto 0);
            m3_i                 : in  signed(32-1 downto 0);
            m3_return            : out signed(16-1 downto 0);
            m4_req               : in  std_logic;
            m4_busy              : out std_logic;
            m4_a3                : in  signed(8-1 downto 0);
            m4_a2                : in  signed(16-1 downto 0);
            m4_a1                : in  signed(32-1 downto 0);
            m4_a0                : in  signed(64-1 downto 0);
            m4_return            : out signed(64-1 downto 0);
            ivar_in              : in  signed(32-1 downto 0);
            ivar_we              : in  std_logic;
            ivar_out             : out signed(32-1 downto 0);
            bvar_in              : in  signed(8-1 downto 0);
            bvar_we              : in  std_logic;
            bvar_out             : out signed(8-1 downto 0);
            svar_in              : in  signed(16-1 downto 0);
            svar_we              : in  std_logic;
            svar_out             : out signed(16-1 downto 0);
            lvar_in              : in  signed(64-1 downto 0);
            lvar_we              : in  std_logic;
            lvar_out             : out signed(64-1 downto 0);
            tvar_in              : in  std_logic;
            tvar_we              : in  std_logic;
            tvar_out             : out std_logic;
            imem_address         : in  signed(32-1 downto 0);
            imem_din             : in  signed(32-1 downto 0);
            imem_we              : in  std_logic;
            imem_dout            : out signed(32-1 downto 0);
            imem_oe              : in  std_logic;
            imem_length          : out signed(32-1 downto 0);
            bmem_address         : in  signed(32-1 downto 0);
            bmem_din             : in  signed(8-1 downto 0);
            bmem_we              : in  std_logic;
            bmem_dout            : out signed(8-1 downto 0);
            bmem_oe              : in  std_logic;
            bmem_length          : out signed(32-1 downto 0);
            smem_address         : in  signed(32-1 downto 0);
            smem_din             : in  signed(16-1 downto 0);
            smem_we              : in  std_logic;
            smem_dout            : out signed(16-1 downto 0);
            smem_oe              : in  std_logic;
            smem_length          : out signed(32-1 downto 0);
            lmem_address         : in  signed(32-1 downto 0);
            lmem_din             : in  signed(64-1 downto 0);
            lmem_we              : in  std_logic;
            lmem_dout            : out signed(64-1 downto 0);
            lmem_oe              : in  std_logic;
            lmem_length          : out signed(32-1 downto 0);
            tmem_address         : in  signed(32-1 downto 0);
            tmem_din             : in  signed(1-1 downto 0);
            tmem_we              : in  std_logic;
            tmem_dout            : out signed(1-1 downto 0);
            tmem_oe              : in  std_logic;
            tmem_length          : out signed(32-1 downto 0)
        );
    end component;
begin
    reset      <= not ARESETn;
    reset_n    <=     ARESETn;
    U : Sample_Interface
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
            m0_req               => m0_req              ,
            m0_busy              => m0_busy             ,
            m1_req               => m1_req              ,
            m1_busy              => m1_busy             ,
            m1_p                 => m1_p                ,
            m1_return            => m1_return           ,
            m2_req               => m2_req              ,
            m2_busy              => m2_busy             ,
            m2_b                 => m2_b                ,
            m2_i                 => m2_i                ,
            m2_return            => m2_return           ,
            m3_req               => m3_req              ,
            m3_busy              => m3_busy             ,
            m3_s                 => m3_s                ,
            m3_i                 => m3_i                ,
            m3_return            => m3_return           ,
            m4_req               => m4_req              ,
            m4_busy              => m4_busy             ,
            m4_a3                => m4_a3               ,
            m4_a2                => m4_a2               ,
            m4_a1                => m4_a1               ,
            m4_a0                => m4_a0               ,
            m4_return            => m4_return           ,
            ivar_in              => ivar_in             ,
            ivar_we              => ivar_we             ,
            ivar_out             => ivar_out            ,
            bvar_in              => bvar_in             ,
            bvar_we              => bvar_we             ,
            bvar_out             => bvar_out            ,
            svar_in              => svar_in             ,
            svar_we              => svar_we             ,
            svar_out             => svar_out            ,
            lvar_in              => lvar_in             ,
            lvar_we              => lvar_we             ,
            lvar_out             => lvar_out            ,
            tvar_in              => tvar_in             ,
            tvar_we              => tvar_we             ,
            tvar_out             => tvar_out            ,
            imem_address         => imem_address        ,
            imem_din             => imem_din            ,
            imem_we              => imem_we             ,
            imem_dout            => imem_dout           ,
            imem_oe              => imem_oe             ,
            imem_length          => imem_length         ,
            bmem_address         => bmem_address        ,
            bmem_din             => bmem_din            ,
            bmem_we              => bmem_we             ,
            bmem_dout            => bmem_dout           ,
            bmem_oe              => bmem_oe             ,
            bmem_length          => bmem_length         ,
            smem_address         => smem_address        ,
            smem_din             => smem_din            ,
            smem_we              => smem_we             ,
            smem_dout            => smem_dout           ,
            smem_oe              => smem_oe             ,
            smem_length          => smem_length         ,
            lmem_address         => lmem_address        ,
            lmem_din             => lmem_din            ,
            lmem_we              => lmem_we             ,
            lmem_dout            => lmem_dout           ,
            lmem_oe              => lmem_oe             ,
            lmem_length          => lmem_length         ,
            tmem_address         => tmem_address        ,
            tmem_din             => tmem_din            ,
            tmem_we              => tmem_we             ,
            tmem_dout            => tmem_dout           ,
            tmem_oe              => tmem_oe             ,
            tmem_length          => tmem_length         
        );
    T : Sample
        port map(
            clk                  => CLK                 ,
            reset                => reset               ,
            m0_req               => m0_req              ,
            m0_busy              => m0_busy             ,
            m1_req               => m1_req              ,
            m1_busy              => m1_busy             ,
            m1_p                 => m1_p                ,
            m1_return            => m1_return           ,
            m2_req               => m2_req              ,
            m2_busy              => m2_busy             ,
            m2_b                 => m2_b                ,
            m2_i                 => m2_i                ,
            m2_return            => m2_return           ,
            m3_req               => m3_req              ,
            m3_busy              => m3_busy             ,
            m3_s                 => m3_s                ,
            m3_i                 => m3_i                ,
            m3_return            => m3_return           ,
            m4_req               => m4_req              ,
            m4_busy              => m4_busy             ,
            m4_a3                => m4_a3               ,
            m4_a2                => m4_a2               ,
            m4_a1                => m4_a1               ,
            m4_a0                => m4_a0               ,
            m4_return            => m4_return           ,
            ivar_in              => ivar_in             ,
            ivar_we              => ivar_we             ,
            ivar_out             => ivar_out            ,
            bvar_in              => bvar_in             ,
            bvar_we              => bvar_we             ,
            bvar_out             => bvar_out            ,
            svar_in              => svar_in             ,
            svar_we              => svar_we             ,
            svar_out             => svar_out            ,
            lvar_in              => lvar_in             ,
            lvar_we              => lvar_we             ,
            lvar_out             => lvar_out            ,
            tvar_in              => tvar_in             ,
            tvar_we              => tvar_we             ,
            tvar_out             => tvar_out            ,
            imem_address         => imem_address        ,
            imem_din             => imem_din            ,
            imem_we              => imem_we             ,
            imem_dout            => imem_dout           ,
            imem_oe              => imem_oe             ,
            imem_length          => imem_length         ,
            bmem_address         => bmem_address        ,
            bmem_din             => bmem_din            ,
            bmem_we              => bmem_we             ,
            bmem_dout            => bmem_dout           ,
            bmem_oe              => bmem_oe             ,
            bmem_length          => bmem_length         ,
            smem_address         => smem_address        ,
            smem_din             => smem_din            ,
            smem_we              => smem_we             ,
            smem_dout            => smem_dout           ,
            smem_oe              => smem_oe             ,
            smem_length          => smem_length         ,
            lmem_address         => lmem_address        ,
            lmem_din             => lmem_din            ,
            lmem_we              => lmem_we             ,
            lmem_dout            => lmem_dout           ,
            lmem_oe              => lmem_oe             ,
            lmem_length          => lmem_length         ,
            tmem_address         => tmem_address        ,
            tmem_din             => tmem_din            ,
            tmem_we              => tmem_we             ,
            tmem_dout            => tmem_dout           ,
            tmem_oe              => tmem_oe             ,
            tmem_length          => tmem_length         
        );
end RTL;
