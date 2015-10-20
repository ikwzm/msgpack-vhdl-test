-----------------------------------------------------------------------------------
--!     @file    test_bench.vhd
--!     @brief   TEST BENCH for MsgPack_KVS_Key_Compare
--!     @version 0.1.0
--!     @date    2015/10/2
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
library MsgPack;
use     MsgPack.MsgPack_Object;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
entity  TEST_BENCH is
    generic (
        NAME            : STRING  := "TEST";
        I_WIDTH         : integer :=  2
    );
end     TEST_BENCH;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
architecture MODEL of TEST_BENCH is
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant  CLOCK_PERIOD   :  time    := 10 ns;
    constant  DELAY          :  time    :=  1 ns;
    constant  I_MAX_PHASE    :  integer :=  4;
    constant  DUT_NUM        :  integer :=  4;
    constant  HEX            :  STRING(1 to 16) := "0123456789ABCDEF";
    signal    SCENARIO       :  STRING(1 to 5)  := "NONE.";
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    RESET          :  std_logic;
    signal    CLOCK          :  std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    I_CODE         :  MsgPack_Object.Code_Vector(I_WIDTH-1 downto 0);
    signal    I_REQ_PHASE    :  std_logic_vector(I_MAX_PHASE-1 downto 0);
    signal    match          :  std_logic_vector(DUT_NUM-1 downto 0);
    signal    mismatch       :  std_logic_vector(DUT_NUM-1 downto 0);
    signal    shift          :  std_logic_vector(I_WIDTH-1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    function INT_TO_STRING(arg:integer;len:integer;space:character) return STRING is
        variable str   : STRING(1 to len);
        variable value : integer;
    begin
        value  := arg;
        for i in str'right downto str'left loop
            if (value > 0) then
                case (value mod 10) is
                    when 0      => str(i) := '0';
                    when 1      => str(i) := '1';
                    when 2      => str(i) := '2';
                    when 3      => str(i) := '3';
                    when 4      => str(i) := '4';
                    when 5      => str(i) := '5';
                    when 6      => str(i) := '6';
                    when 7      => str(i) := '7';
                    when 8      => str(i) := '8';
                    when 9      => str(i) := '9';
                    when others => str(i) := 'X';
                end case;
            else
                if (i = str'right) then
                    str(i) := '0';
                else
                    str(i) := space;
                end if;
            end if;
            value := value / 10;
        end loop;
        return str;
    end INT_TO_STRING;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component TEST_SAMPLE 
        generic (
            I_WIDTH         : integer range 1 to 64;
            I_MAX_PHASE     : integer range 1 to  7
        );
        port (
            CLK             : in  std_logic; 
            RST             : in  std_logic;
            CLR             : in  std_logic;
            I_CODE          : in  MsgPack_Object.Code_Vector(I_WIDTH-1 downto 0);
            I_REQ_PHASE     : in  std_logic_vector(I_MAX_PHASE-1 downto 0);
            MATCH           : out std_logic_vector(4-1 downto 0);
            MISMATCH        : out std_logic_vector(4-1 downto 0);
            SHIFT           : out std_logic_vector(I_WIDTH-1 downto 0)
        );
    end component;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    DUT: TEST_SAMPLE
        generic map (
            I_WIDTH         => I_WIDTH         , -- 
            I_MAX_PHASE     => I_MAX_PHASE       -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLOCK           , -- 
            RST             => RESET           , -- 
            CLR             => '0'             , -- 
            I_CODE          => I_CODE          , -- 
            I_REQ_PHASE     => I_REQ_PHASE     , -- 
            MATCH           => match           , -- 
            MISMATCH        => mismatch        , -- 
            SHIFT           => shift             -- 
        );
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process 
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        procedure WAIT_CLOCK(CNT:integer) is
        begin
            if (CNT > 0) then
                for i in 1 to CNT loop 
                    wait until (CLOCK'event and CLOCK = '1'); 
                end loop;
            end if;
            wait for DELAY;
        end WAIT_CLOCK;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        
    begin
        ---------------------------------------------------------------------------
        -- シミュレーションの開始、まずはリセットから。
        ---------------------------------------------------------------------------
        assert(false) report "Starting Run..." severity NOTE;
                       SCENARIO    <= "START";
                       RESET       <= '1';
                       I_CODE      <= (others => MsgPack_Object.CODE_NULL);
                       I_REQ_PHASE <= (others => '0');
        WAIT_CLOCK( 4);
        
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        SCENARIO <= "1.0.0";wait for 0 ns;
        I_CODE      <= (0 => MsgPack_Object.New_Code_StringSize(4),
                        1 => MsgPack_Object.New_Code(
                                 CLASS    => MsgPack_Object.CLASS_STRING_DATA,
                                 DATA     => std_logic_vector(to_unsigned(16#44434241#, 32)),
                                 STRB     => "1111",
                                 COMPLETE => '1'
                             )
                       );
        I_REQ_PHASE <= (0 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0001" and mismatch = "1110" and shift = "11") report "Mismatch " & SCENARIO severity error;
        I_REQ_PHASE <= (1 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "1111" and shift = "00") report "Mismatch " & SCENARIO severity error;
        I_REQ_PHASE <= (2 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "1111" and shift = "00") report "Mismatch " & SCENARIO severity error;
        I_REQ_PHASE <= (others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "0000" and shift = "00") report "Mismatch " & SCENARIO severity error;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        SCENARIO <= "1.0.1";wait for 0 ns;
        I_CODE      <= (0 => MsgPack_Object.New_Code_StringSize(4),
                        1 => MsgPack_Object.CODE_NULL
                   );
        I_REQ_PHASE <= (0 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "1110" and shift = "00") report "Mismatch " & SCENARIO severity error;
        I_CODE      <= (0 => MsgPack_Object.New_Code_StringSize(4),
                        1 => MsgPack_Object.New_Code(
                                 CLASS    => MsgPack_Object.CLASS_STRING_DATA,
                                 DATA     => std_logic_vector(to_unsigned(16#44434241#, 32)),
                                 STRB     => "1111",
                                 COMPLETE => '1'
                             )
                       );
        I_REQ_PHASE <= (0 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0001" and mismatch = "1110" and shift = "11") report "Mismatch " & SCENARIO severity error;
        I_REQ_PHASE <= (1 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "1111" and shift = "00") report "Mismatch " & SCENARIO severity error;
        I_REQ_PHASE <= (others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "0000" and shift = "00") report "Mismatch " & SCENARIO severity error;
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        SCENARIO <= "1.2.1";wait for 0 ns;
        I_CODE      <= (0 => MsgPack_Object.New_Code_StringSize(7),
                        1 => MsgPack_Object.New_Code(
                                 CLASS    => MsgPack_Object.CLASS_STRING_DATA,
                                 DATA     => std_logic_vector(to_unsigned(16#44434241#, 32)),
                                 STRB     => "1111",
                                 COMPLETE => '0'
                             )
                       );
        I_REQ_PHASE <= (0 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "1001" and shift = "00") report "Mismatch " & SCENARIO severity error;
        I_CODE      <= (0 => MsgPack_Object.New_Code(
                                 CLASS    => MsgPack_Object.CLASS_STRING_DATA,
                                 DATA     => std_logic_vector(to_unsigned(16#474645#, 24)),
                                 STRB     => "0111",
                                 COMPLETE => '1'
                             ),
                        1 => MsgPack_Object.CODE_NULL
                       );
        I_REQ_PHASE <= (1 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0010" and mismatch = "1101" and shift = "01") report "Mismatch " & SCENARIO severity error;
        I_REQ_PHASE <= (2 => '1', others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "1111" and shift = "00") report "Mismatch " & SCENARIO severity error;
        I_REQ_PHASE <= (others => '0');
        WAIT_CLOCK( 1);
        assert (match = "0000" and mismatch = "0000" and shift = "00") report "Mismatch " & SCENARIO severity error;
        ---------------------------------------------------------------------------
        -- シミュレーション終了
        ---------------------------------------------------------------------------
        WAIT_CLOCK(10); 
        SCENARIO <= "DONE.";
        WAIT_CLOCK(10); 
        assert(false) report NAME & " Run complete..." severity FAILURE;
        wait;
    end process;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process begin
        CLOCK <= '0';
        wait for CLOCK_PERIOD / 2;
        CLOCK <= '1';
        wait for CLOCK_PERIOD / 2;
    end process;
end MODEL;
