-----------------------------------------------------------------------------------
--!     @file    test_bench.vhd
--!     @brief   Test Bench for MsgPack_Object_Packer
--!     @version 0.1.0
--!     @date    2015/10/18
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2015 Ichiro Kawazome
--      All rights reserved.
--
--      Redistribution and use in source and binary forms, with or without
--      modification, are permitted provided that the following conditions
--      are met:
--
--        1. Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--        2. Redistributions in binary form must reproduce the above copyright
--           notice, this list of conditions and the following disclaimer in
--           the documentation and/or other materials provided with the
--           distribution.
--
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     std.textio.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.AXI4_TYPES.all;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_STREAM_MASTER_PLAYER;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_STREAM_SLAVE_PLAYER;
use     DUMMY_PLUG.SYNC.all;
use     DUMMY_PLUG.CORE.MARCHAL;
use     DUMMY_PLUG.CORE.REPORT_STATUS_TYPE;
use     DUMMY_PLUG.CORE.REPORT_STATUS_VECTOR;
use     DUMMY_PLUG.CORE.MARGE_REPORT_STATUS;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_Object_Components.MsgPack_Object_Packer;
use     MsgPack.MsgPack_Object_Components.MsgPack_Object_Code_Reducer;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
entity  TEST_BENCH is
    generic (
        NAME            : STRING := "TEST";
        SCENARIO_FILE   : STRING := "test.snr"
    );
end     TEST_BENCH;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
architecture MODEL of TEST_BENCH is
    -------------------------------------------------------------------------------
    -- 各種定数
    -------------------------------------------------------------------------------
    constant CLOCK_PERIOD    : time    := 10 ns;
    constant DELAY           : time    :=  1 ns;
    constant O_BYTES         : integer :=  4;
    constant O_WIDTH         : AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                 ID    => 4,
                                 USER  => 4,
                                 DEST  => 4,
                                 DATA  => 8*O_BYTES);
    constant I_WORDS         : integer :=  2;
    constant I_BYTES         : integer :=  4*I_WORDS;
    constant I_WIDTH         : AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                 ID    => 4,
                                 USER  => 8*I_WORDS,
                                 DEST  => 4,
                                 DATA  => 8*I_BYTES);
    constant T_WORDS         : integer := I_WORDS;
    constant SYNC_WIDTH      : integer :=  2;
    constant GPO_WIDTH       : integer :=  8;
    constant GPI_WIDTH       : integer :=  GPO_WIDTH;
    -------------------------------------------------------------------------------
    -- グローバルシグナル.
    -------------------------------------------------------------------------------
    signal   ARESETn         : std_logic;
    signal   RESET           : std_logic;
    signal   CLOCK           : std_logic;
    -------------------------------------------------------------------------------
    -- シンクロ用信号
    -------------------------------------------------------------------------------
    signal   SYNC            : SYNC_SIG_VECTOR (SYNC_WIDTH     -1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal   O_TDATA         : std_logic_vector(O_WIDTH.DATA   -1 downto 0);
    signal   O_TSTRB         : std_logic_vector(O_WIDTH.DATA/8 -1 downto 0);
    signal   O_TLAST         : std_logic;
    signal   O_TVALID        : std_logic;
    signal   O_TREADY        : std_logic;
    constant O_TKEEP         : std_logic_vector(O_WIDTH.DATA/8 -1 downto 0) := (others => '1');
    constant O_TUSER         : std_logic_vector(O_WIDTH.USER   -1 downto 0) := (others => '0');
    constant O_TDEST         : std_logic_vector(O_WIDTH.DEST   -1 downto 0) := (others => '0');
    constant O_TID           : std_logic_vector(O_WIDTH.ID     -1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   t_code          : MsgPack_Object.Code_Vector(T_WORDS-1 downto 0);
    signal   t_shift         : std_logic_vector          (T_WORDS-1 downto 0);
    constant t_offset        : std_logic_vector          (T_WORDS-1 downto 0) := (others => '0');
    signal   t_last          : std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal   I_TDATA         : std_logic_vector(I_WIDTH.DATA   -1 downto 0);
    signal   I_TSTRB         : std_logic_vector(I_WIDTH.DATA/8 -1 downto 0);
    signal   I_TUSER         : std_logic_vector(I_WIDTH.USER   -1 downto 0) := (others => '0');
    constant I_TDEST         : std_logic_vector(I_WIDTH.DEST   -1 downto 0) := (others => '0');
    constant I_TID           : std_logic_vector(I_WIDTH.ID     -1 downto 0) := (others => '0');
    signal   I_TLAST         : std_logic;
    signal   I_TVALID        : std_logic;
    signal   I_TREADY        : std_logic;
    signal   I_CODE          : MsgPack_Object.Code_Vector(I_WORDS-1 downto 0);
    -------------------------------------------------------------------------------
    -- GPIO(General Purpose Input/Output)
    -------------------------------------------------------------------------------
    signal   I_GPI           : std_logic_vector(GPI_WIDTH      -1 downto 0);
    signal   I_GPO           : std_logic_vector(GPO_WIDTH      -1 downto 0);
    signal   O_GPI           : std_logic_vector(GPI_WIDTH      -1 downto 0);
    signal   O_GPO           : std_logic_vector(GPO_WIDTH      -1 downto 0);
    -------------------------------------------------------------------------------
    -- 各種状態出力.
    -------------------------------------------------------------------------------
    signal   N_REPORT        : REPORT_STATUS_TYPE;
    signal   I_REPORT        : REPORT_STATUS_TYPE;
    signal   O_REPORT        : REPORT_STATUS_TYPE;
    signal   N_FINISH        : std_logic;
    signal   I_FINISH        : std_logic;
    signal   O_FINISH        : std_logic;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    N: MARCHAL
        generic map(
            SCENARIO_FILE   => SCENARIO_FILE,
            NAME            => "MARCHAL",
            SYNC_PLUG_NUM   => 1,
            SYNC_WIDTH      => SYNC_WIDTH,
            FINISH_ABORT    => FALSE
        )
        port map(
            CLK             => CLOCK           , -- In  :
            RESET           => RESET           , -- In  :
            SYNC(0)         => SYNC(0)         , -- I/O :
            SYNC(1)         => SYNC(1)         , -- I/O :
            REPORT_STATUS   => N_REPORT        , -- Out :
            FINISH          => N_FINISH          -- Out :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O: AXI4_STREAM_SLAVE_PLAYER                  -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "O"             , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 2               , --
            WIDTH           => O_WIDTH         , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map(                                -- 
            ACLK            => CLOCK           , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => O_TDATA         , -- In  :
            TSTRB           => O_TSTRB         , -- In  :
            TKEEP           => O_TKEEP         , -- In  :
            TUSER           => O_TUSER         , -- In  :
            TDEST           => O_TDEST         , -- In  :
            TID             => O_TID           , -- In  :
            TLAST           => O_TLAST         , -- In  :
            TVALID          => O_TVALID        , -- In  :
            TREADY          => O_TREADY        , -- Out :
            SYNC            => SYNC            , -- Inou:
            GPI             => O_GPI           , -- In  :
            GPO             => O_GPO           , -- Out :
            REPORT_STATUS   => O_REPORT        , -- Out :
            FINISH          => O_FINISH          -- Out :
        );                                       -- 
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    T: MsgPack_Object_Code_Reducer               -- 
        generic map (                            -- 
            I_WIDTH         => I_WORDS         , -- 
            O_WIDTH         => T_WORDS         , --
            O_VALID_SIZE    => 1               , -- 
            QUEUE_SIZE      => 0                 -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLOCK           , -- In  :
            RST             => RESET           , -- In  :
            CLR             => '0'             , -- In  :
            DONE            => '0'             , -- In  :
            BUSY            => open            , -- Out :
            I_ENABLE        => '1'             , -- In  :
            I_CODE          => I_CODE          , -- In  :
            I_DONE          => I_TLAST         , -- In  :
            I_VALID         => I_TVALID        , -- In  :
            I_READY         => I_TREADY        , -- Out :
            O_ENABLE        => '1'             , -- In  :
            O_CODE          => t_code          , -- Out :
            O_DONE          => t_last          , -- Out :
            O_VALID         => open            , -- Out :
            O_READY         => '1'             , -- In  :
            O_SHIFT         => t_shift           -- In  :
        );                                       --
    process (I_TDATA, I_TSTRB, I_TUSER) begin
        for i in 0 to I_WORDS-1 loop
            if (I_TUSER(8*i+5) = '1') then
                I_CODE(i).data     <= I_TDATA(32*i+31 downto 32*i);
                I_CODE(i).strb     <= I_TSTRB( 4*i+ 3 downto  4*i);
                I_CODE(i).class    <= I_TUSER( 8*i+ 3 downto  8*i);
                I_CODE(i).complete <= I_TUSER( 8*i+ 4);
                I_CODE(i).valid    <= I_TUSER( 8*i+ 5);
            else
                I_CODE(i) <= MsgPack_Object.CODE_NULL;
            end if;
        end loop;
    end process;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    I: AXI4_STREAM_MASTER_PLAYER                 -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "I"             , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 3               , --
            WIDTH           => I_WIDTH         , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map (                               -- 
            ACLK            => CLOCK           , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => I_TDATA         , -- Out :
            TSTRB           => I_TSTRB         , -- Out :
            TKEEP           => open            , -- Out :
            TUSER           => I_TUSER         , -- Out :
            TDEST           => open            , -- Out :
            TID             => open            , -- Out :
            TLAST           => I_TLAST         , -- Out :
            TVALID          => I_TVALID        , -- Out :
            TREADY          => I_TREADY        , -- In  :
            SYNC            => SYNC            , -- I/O :
            GPI             => I_GPI           , -- In  :
            GPO             => I_GPO           , -- Out :
            REPORT_STATUS   => I_REPORT        , -- Out :
            FINISH          => I_FINISH          -- Out :
        );                                       -- 
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    DUT: MsgPack_Object_Packer                   -- 
        generic map (                            -- 
            CODE_WIDTH      => T_WORDS         , --
            O_BYTES         => O_BYTES           --
        )                                        -- 
        port map (                               -- 
            CLK             => CLOCK           , -- : In  :
            RST             => RESET           , -- : In  :
            CLR             => '0'             , -- : In  :
            I_CODE          => t_code          , -- : In  :
            I_LAST          => t_last          , -- : In  :
            I_SHIFT         => t_shift         , -- : Out :
            O_DATA          => O_TDATA         , -- : Out :
            O_STRB          => O_TSTRB         , -- : Out :
            O_LAST          => O_TLAST         , -- : Out :
            O_VALID         => O_TVALID        , -- : Out :
            O_READY         => O_TREADY          -- : In  :
        );                                       -- 
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process begin
        CLOCK <= '0';
        wait for CLOCK_PERIOD / 2;
        CLOCK <= '1';
        wait for CLOCK_PERIOD / 2;
    end process;

    ARESETn <= '1' when (RESET = '0') else '0';
    process
        variable L   : LINE;
        constant T   : STRING(1 to 7) := "  ***  ";
    begin
        wait until (O_FINISH'event and O_FINISH = '1');
        wait for DELAY;
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "ERROR REPORT " & NAME);                          WRITELINE(OUTPUT,L);
        WRITE(L,T & "[ I ]");                                         WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,I_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,I_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,I_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T & "[ O ]");                                         WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,O_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,O_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,O_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        assert FALSE report "Simulation complete." severity FAILURE;
        wait;
    end process;
    
 -- SYNC_PRINT_0: SYNC_PRINT generic map(string'("AXI4_TEST_1:SYNC(0)")) port map (SYNC(0));
 -- SYNC_PRINT_1: SYNC_PRINT generic map(string'("AXI4_TEST_1:SYNC(1)")) port map (SYNC(1));
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
