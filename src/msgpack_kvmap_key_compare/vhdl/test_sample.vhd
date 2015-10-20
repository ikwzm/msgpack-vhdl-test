-----------------------------------------------------------------------------------
--!     @file    test_sample.vhd
--!     @brief   TEST SAMPLE for msgpack_keyword_match
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
library MsgPack;
use     MsgPack.MsgPack_Object;
entity  TEST_SAMPLE is
    generic (
        I_WIDTH         : integer range 1 to 64 := 1;
        I_MAX_PHASE     : integer range 1 to  7 := 4
    );
    port (
    -------------------------------------------------------------------------------
    -- クロック&リセット信号
    -------------------------------------------------------------------------------
        CLK             : in  std_logic; 
        RST             : in  std_logic;
        CLR             : in  std_logic;
    -------------------------------------------------------------------------------
    -- 比較被対象入力インターフェース
    -------------------------------------------------------------------------------
        I_CODE          : in  MsgPack_Object.Code_Vector(I_WIDTH-1 downto 0);
        I_REQ_PHASE     : in  std_logic_vector(I_MAX_PHASE-1 downto 0);
    -------------------------------------------------------------------------------
    -- 比較結果出力
    -------------------------------------------------------------------------------
        MATCH           : out std_logic_vector(4-1 downto 0);
        MISMATCH        : out std_logic_vector(4-1 downto 0);
        SHIFT           : out std_logic_vector(I_WIDTH-1 downto 0)
    );
end TEST_SAMPLE;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Key_Compare;
architecture RTL of TEST_SAMPLE is
    subtype   SHIFT_TYPE    is std_logic_vector(I_WIDTH-1 downto 0);
    type      SHIFT_VECTOR  is array(integer range <>) of SHIFT_TYPE;
    signal    o_shift       :  SHIFT_VECTOR(3 downto 0);
begin
    DUT_0: MsgPack_KVMap_Key_Compare                 -- 
            generic map (                            -- 
                CODE_WIDTH      => I_WIDTH         , -- 
                I_MAX_PHASE     => I_MAX_PHASE     , --
                KEYWORD         => string'("ABCD")   --
            )                                        -- 
            port map (                               -- 
                CLK             => CLK             , -- 
                RST             => RST             , -- 
                CLR             => CLR             , -- 
                I_CODE          => I_CODE          , -- 
                I_REQ_PHASE     => I_REQ_PHASE     , -- 
                MATCH           => MATCH(0)        , -- 
                MISMATCH        => MISMATCH(0)     , -- 
                SHIFT           => o_shift(0)        -- 
            );
    DUT_1: MsgPack_KVMap_Key_Compare                 -- 
            generic map (                            -- 
                CODE_WIDTH      => I_WIDTH         , -- 
                I_MAX_PHASE     => I_MAX_PHASE     , --
                KEYWORD         => string'("ABCDEFG")   --
            )                                        -- 
            port map (                               -- 
                CLK             => CLK             , -- 
                RST             => RST             , -- 
                CLR             => CLR             , -- 
                I_CODE          => I_CODE          , -- 
                I_REQ_PHASE     => I_REQ_PHASE     , -- 
                MATCH           => MATCH(1)        , -- 
                MISMATCH        => MISMATCH(1)     , -- 
                SHIFT           => o_shift(1)        -- 
            );
    DUT_2: MsgPack_KVMap_Key_Compare                 -- 
            generic map (                            -- 
                CODE_WIDTH      => I_WIDTH         , -- 
                I_MAX_PHASE     => I_MAX_PHASE     , --
                KEYWORD         => string'("ABCDZXY")   --
            )                                        -- 
            port map (                               -- 
                CLK             => CLK             , -- 
                RST             => RST             , -- 
                CLR             => CLR             , -- 
                I_CODE          => I_CODE          , -- 
                I_REQ_PHASE     => I_REQ_PHASE     , -- 
                MATCH           => MATCH(2)        , -- 
                MISMATCH        => MISMATCH(2)     , -- 
                SHIFT           => o_shift(2)        -- 
            );
    DUT_4: MsgPack_KVMap_Key_Compare                 -- 
            generic map (                            -- 
                CODE_WIDTH      => I_WIDTH         , -- 
                I_MAX_PHASE     => I_MAX_PHASE     , --
                KEYWORD         => string'("ABCDEFGH")   --
            )                                        -- 
            port map (                               -- 
                CLK             => CLK             , -- 
                RST             => RST             , -- 
                CLR             => CLR             , -- 
                I_CODE          => I_CODE          , -- 
                I_REQ_PHASE     => I_REQ_PHASE     , -- 
                MATCH           => MATCH(3)        , -- 
                MISMATCH        => MISMATCH(3)     , -- 
                SHIFT           => o_shift(3)        -- 
            );
    SHIFT <= o_shift(0) or o_shift(1) or o_shift(2) or o_shift(3);
end RTL;
