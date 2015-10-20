-----------------------------------------------------------------------------------
--!     @file    server_sample.vhd
--!     @brief   Sample Module for MsgPack_RPC_Server
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
entity  Server_Sample is
    -------------------------------------------------------------------------------
    -- ジェネリック変数.
    -------------------------------------------------------------------------------
    generic (
        I_BYTES         : --! @brief INPUT BYTE SIZE :
                          --! 入力側のデータのバイト数を指定する.
                          positive := 4;
        O_BYTES         : --! @brief OUTPUT CODE SIZE :
                          --! 出力側のデータのバイト数を指定する.
                          positive := 4
    );
    port (
    -------------------------------------------------------------------------------
    -- クロック&リセット信号
    -------------------------------------------------------------------------------
        CLK             : --! @brief CLOCK :
                          --! クロック信号
                          in  std_logic; 
        RST             : --! @brief ASYNCRONOUSE RESET :
                          --! 非同期リセット信号.アクティブハイ.
                          in  std_logic;
    -------------------------------------------------------------------------------
    -- MessagePack-RPC Byte Data 入力 I/F 
    -------------------------------------------------------------------------------
        I_DATA          : --! @brief INPUT BYTE DATA :
                          --! データ入力.
                          in  std_logic_vector(8*I_BYTES-1 downto 0);
        I_STRB          : --! @brief INPUT BYTE ENABLE :
                          --! ワードストローブ信号入力.
                          in  std_logic_vector(  I_BYTES-1 downto 0);
        I_LAST          : --! @brief INPUT LAST :
                          --! 最終ワード信号入力.
                          --! * 最後のデータ入力であることを示すフラグ.
                          in  std_logic := '0';
        I_VALID         : --! @brief INPUT VALID :
                          --! 入力データ有効信号.
                          --! * I_DATA/I_STRB/I_LASTが有効であることを示す.
                          --! * I_VALID='1'and I_READY='1'でワードデータがキューに
                          --!   取り込まれる.
                          in  std_logic;
        I_READY         : --! @brief INPUT READY :
                          --! 入力レディ信号.
                          --! * キューが次のデータを入力出来ることを示す.
                          --! * I_VALID='1'and I_READY='1'でワードデータがキューに
                          --!   取り込まれる.
                          out std_logic;
    -------------------------------------------------------------------------------
    -- MessagePack-RPC Byte Data I/F 
    -------------------------------------------------------------------------------
        O_DATA          : --! @brief OUTLET BYTE DATA :
                          --! バイト出力.
                          out std_logic_vector(8*O_BYTES-1 downto 0);
        O_STRB          : --! @brief OUTLET BYTE ENABLE :
                          --! バイトイネーブル信号出力.
                          out std_logic_vector(  O_BYTES-1 downto 0);
        O_LAST          : --! @brief OUTLET LAST :
                          --! 最終ワード信号出力.
                          --! * 最後のデータ出力であることを示すフラグ.
                          out std_logic;
        O_VALID         : --! @brief OUTLET VALID :
                          --! 出力データ有効信号.
                          --! * O_DATA/O_STRB/O_LASTが有効であることを示す.
                          out std_logic;
        O_READY         : --! @brief OUTLET READY :
                          --! 出力レディ信号.
                          in  std_logic
    );
end  Server_Sample;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server;
architecture RTL of Server_Sample is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant PROC_NUM       :  integer :=  5;
    constant MATCH_PHASE    :  integer :=  8;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   match_req      :  std_logic_vector        (MATCH_PHASE-1 downto 0);
    signal   match_code     :  MsgPack_RPC.Code_Type;
    signal   match_ok       :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal   match_not      :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal   match_shift    :  MsgPack_RPC.Shift_Vector(PROC_NUM-1 downto 0);
    signal   proc_req_id    :  MsgPack_RPC.MsgID_Type;
    signal   proc_req       :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal   proc_busy      :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal   param_code     :  MsgPack_RPC.Code_Vector (PROC_NUM-1 downto 0);
    signal   param_valid    :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal   param_last     :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal   param_shift    :  MsgPack_RPC.Shift_Vector(PROC_NUM-1 downto 0);
    signal   proc_res_id    :  MsgPack_RPC.MsgID_Vector(PROC_NUM-1 downto 0);
    signal   proc_res_code  :  MsgPack_RPC.Code_Vector (PROC_NUM-1 downto 0);
    signal   proc_res_valid :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal   proc_res_last  :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal   proc_res_ready :  std_logic_vector        (PROC_NUM-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   param_a_value  :  std_logic_vector(31 downto 0);
    signal   param_a_din    :  std_logic_vector(31 downto 0);
    signal   param_a_we     :  std_logic;
    signal   param_b_value  :  std_logic_vector(63 downto 0);
    signal   param_b_din    :  std_logic_vector(63 downto 0);
    signal   param_b_we     :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component PROC_LOOP_SAMPLE
        generic (
            NAME            : string;
            MATCH_PHASE     : integer
        );
        port (
            CLK             : in  std_logic; 
            RST             : in  std_logic;
            CLR             : in  std_logic;
            MATCH_REQ       : in  std_logic_vector(MATCH_PHASE-1 downto 0);
            MATCH_CODE      : in  MsgPack_RPC.Code_Type;
            MATCH_OK        : out std_logic;
            MATCH_NOT       : out std_logic;
            MATCH_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_REQ_ID     : in  MsgPack_RPC.MsgID_Type;
            PROC_REQ        : in  std_logic;
            PROC_BUSY       : out std_logic;
            PARAM_CODE      : in  MsgPack_RPC.Code_Type;
            PARAM_VALID     : in  std_logic;
            PARAM_LAST      : in  std_logic;
            PARAM_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_RES_ID     : out MsgPack_RPC.MsgID_Type;
            PROC_RES_CODE   : out MsgPack_RPC.Code_Type;
            PROC_RES_VALID  : out std_logic;
            PROC_RES_LAST   : out std_logic;
            PROC_RES_READY  : in  std_logic
        );
    end  component;
    component PROC_ADD_SAMPLE
        generic (
            NAME            : string;
            MATCH_PHASE     : integer
        );
        port (
            CLK             : in  std_logic; 
            RST             : in  std_logic;
            CLR             : in  std_logic;
            MATCH_REQ       : in  std_logic_vector(MATCH_PHASE-1 downto 0);
            MATCH_CODE      : in  MsgPack_RPC.Code_Type;
            MATCH_OK        : out std_logic;
            MATCH_NOT       : out std_logic;
            MATCH_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_REQ_ID     : in  MsgPack_RPC.MsgID_Type;
            PROC_REQ        : in  std_logic;
            PROC_BUSY       : out std_logic;
            PARAM_CODE      : in  MsgPack_RPC.Code_Type;
            PARAM_VALID     : in  std_logic;
            PARAM_LAST      : in  std_logic;
            PARAM_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_RES_ID     : out MsgPack_RPC.MsgID_Type;
            PROC_RES_CODE   : out MsgPack_RPC.Code_Type;
            PROC_RES_VALID  : out std_logic;
            PROC_RES_LAST   : out std_logic;
            PROC_RES_READY  : in  std_logic
        );
    end  component;
    component PROC_START_SAMPLE
        generic (
            NAME            : string;
            MATCH_PHASE     : integer
        );
        port (
            CLK             : in  std_logic; 
            RST             : in  std_logic;
            CLR             : in  std_logic;
            MATCH_REQ       : in  std_logic_vector(MATCH_PHASE-1 downto 0);
            MATCH_CODE      : in  MsgPack_RPC.Code_Type;
            MATCH_OK        : out std_logic;
            MATCH_NOT       : out std_logic;
            MATCH_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_REQ_ID     : in  MsgPack_RPC.MsgID_Type;
            PROC_REQ        : in  std_logic;
            PROC_BUSY       : out std_logic;
            PARAM_CODE      : in  MsgPack_RPC.Code_Type;
            PARAM_VALID     : in  std_logic;
            PARAM_LAST      : in  std_logic;
            PARAM_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_RES_ID     : out MsgPack_RPC.MsgID_Type;
            PROC_RES_CODE   : out MsgPack_RPC.Code_Type;
            PROC_RES_VALID  : out std_logic;
            PROC_RES_LAST   : out std_logic;
            PROC_RES_READY  : in  std_logic
        );
    end  component;
    component PROC_KVMAP_SET_VALUE_SAMPLE
        generic (
            NAME            : string;
            MATCH_PHASE     : integer
        );
        port (
            CLK             : in  std_logic; 
            RST             : in  std_logic;
            CLR             : in  std_logic;
            MATCH_REQ       : in  std_logic_vector(MATCH_PHASE-1 downto 0);
            MATCH_CODE      : in  MsgPack_RPC.Code_Type;
            MATCH_OK        : out std_logic;
            MATCH_NOT       : out std_logic;
            MATCH_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_REQ_ID     : in  MsgPack_RPC.MsgID_Type;
            PROC_REQ        : in  std_logic;
            PROC_BUSY       : out std_logic;
            PARAM_CODE      : in  MsgPack_RPC.Code_Type;
            PARAM_VALID     : in  std_logic;
            PARAM_LAST      : in  std_logic;
            PARAM_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_RES_ID     : out MsgPack_RPC.MsgID_Type;
            PROC_RES_CODE   : out MsgPack_RPC.Code_Type;
            PROC_RES_VALID  : out std_logic;
            PROC_RES_LAST   : out std_logic;
            PROC_RES_READY  : in  std_logic;
            PARAM_A_VALUE   : out std_logic_vector(31 downto 0);
            PARAM_A_WE      : out std_logic;
            PARAM_B_VALUE   : out std_logic_vector(63 downto 0);
            PARAM_B_WE      : out std_logic
        );
    end  component;
    component PROC_KVMAP_GET_VALUE_SAMPLE
        generic (
            NAME            : string;
            MATCH_PHASE     : integer
        );
        port (
            CLK             : in  std_logic; 
            RST             : in  std_logic;
            CLR             : in  std_logic;
            MATCH_REQ       : in  std_logic_vector(MATCH_PHASE-1 downto 0);
            MATCH_CODE      : in  MsgPack_RPC.Code_Type;
            MATCH_OK        : out std_logic;
            MATCH_NOT       : out std_logic;
            MATCH_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_REQ_ID     : in  MsgPack_RPC.MsgID_Type;
            PROC_REQ        : in  std_logic;
            PROC_BUSY       : out std_logic;
            PARAM_CODE      : in  MsgPack_RPC.Code_Type;
            PARAM_VALID     : in  std_logic;
            PARAM_LAST      : in  std_logic;
            PARAM_SHIFT     : out MsgPack_RPC.Shift_Type;
            PROC_RES_ID     : out MsgPack_RPC.MsgID_Type;
            PROC_RES_CODE   : out MsgPack_RPC.Code_Type;
            PROC_RES_VALID  : out std_logic;
            PROC_RES_LAST   : out std_logic;
            PROC_RES_READY  : in  std_logic;
            PARAM_A_VALUE   : in  std_logic_vector(31 downto 0);
            PARAM_B_VALUE   : in  std_logic_vector(63 downto 0)
        );
    end  component;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    Server: MsgPack_RPC_Server                   -- 
        generic map (                            -- 
            I_BYTES         => I_BYTES         , --
            O_BYTES         => O_BYTES         , --
            PROC_NUM        => PROC_NUM        , -- 
            MATCH_PHASE     => MATCH_PHASE       --
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => RST             , -- In  :
            CLR             => '0'             , -- In  :
            I_DATA          => I_DATA          , -- In  :
            I_STRB          => I_STRB          , -- In  :
            I_LAST          => I_LAST          , -- In  :
            I_VALID         => I_VALID         , -- In  :
            I_READY         => I_READY         , -- Out :
            O_DATA          => O_DATA          , -- Out :
            O_STRB          => O_STRB          , -- Out :
            O_LAST          => O_LAST          , -- Out :
            O_VALID         => O_VALID         , -- Out :
            O_READY         => O_READY         , -- In  :
            MATCH_REQ       => match_req       , -- Out :
            MATCH_CODE      => match_code      , -- Out :
            MATCH_OK        => match_ok        , -- In  :
            MATCH_NOT       => match_not       , -- In  :
            MATCH_SHIFT     => match_shift     , -- In  :
            PROC_REQ_ID     => proc_req_id     , -- Out :
            PROC_REQ        => proc_req        , -- Out :
            PROC_BUSY       => proc_busy       , -- In  :
            PARAM_VALID     => param_valid     , -- Out :
            PARAM_CODE      => param_code      , -- Out :
            PARAM_LAST      => param_last      , -- Out :
            PARAM_SHIFT     => param_shift     , -- In  :
            PROC_RES_ID     => proc_res_id     , -- In  :
            PROC_RES_CODE   => proc_res_code   , -- In  :
            PROC_RES_VALID  => proc_res_valid  , -- In  :
            PROC_RES_LAST   => proc_res_last   , -- In  :
            PROC_RES_READY  => proc_res_ready    -- Out :
            );                                   -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PROC_0: PROC_LOOP_SAMPLE
        generic map (
            NAME            => string'("LOOP"),
            MATCH_PHASE     => MATCH_PHASE
        )
        port map (
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => '0'                 , -- In  :
            MATCH_REQ       => match_req           , -- In  :
            MATCH_CODE      => match_code          , -- In  :
            MATCH_OK        => match_ok      (0)   , -- Out :
            MATCH_NOT       => match_not     (0)   , -- Out :
            MATCH_SHIFT     => match_shift   (0)   , -- Out :
            PROC_REQ_ID     => proc_req_id         , -- In  :
            PROC_REQ        => proc_req      (0)   , -- In  :
            PROC_BUSY       => proc_busy     (0)   , -- Out :
            PARAM_VALID     => param_valid   (0)   , -- In  :
            PARAM_CODE      => param_code    (0)   , -- In  :
            PARAM_LAST      => param_last    (0)   , -- In  :
            PARAM_SHIFT     => param_shift   (0)   , -- Out :
            PROC_RES_ID     => proc_res_id   (0)   , -- Out :
            PROC_RES_CODE   => proc_res_code (0)   , -- Out :
            PROC_RES_VALID  => proc_res_valid(0)   , -- Out :
            PROC_RES_LAST   => proc_res_last (0)   , -- Out :
            PROC_RES_READY  => proc_res_ready(0)     -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PROC_1: PROC_ADD_SAMPLE
        generic map (
            NAME            => string'("ADD"),
            MATCH_PHASE     => MATCH_PHASE
        )
        port map (
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => '0'                 , -- In  :
            MATCH_REQ       => match_req           , -- In  :
            MATCH_CODE      => match_code          , -- In  :
            MATCH_OK        => match_ok      (1)   , -- Out :
            MATCH_NOT       => match_not     (1)   , -- Out :
            MATCH_SHIFT     => match_shift   (1)   , -- Out :
            PROC_REQ_ID     => proc_req_id         , -- In  :
            PROC_REQ        => proc_req      (1)   , -- In  :
            PROC_BUSY       => proc_busy     (1)   , -- Out :
            PARAM_VALID     => param_valid   (1)   , -- In  :
            PARAM_CODE      => param_code    (1)   , -- In  :
            PARAM_LAST      => param_last    (1)   , -- In  :
            PARAM_SHIFT     => param_shift   (1)   , -- Out :
            PROC_RES_ID     => proc_res_id   (1)   , -- Out :
            PROC_RES_CODE   => proc_res_code (1)   , -- Out :
            PROC_RES_VALID  => proc_res_valid(1)   , -- Out :
            PROC_RES_LAST   => proc_res_last (1)   , -- Out :
            PROC_RES_READY  => proc_res_ready(1)     -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PROC_2: PROC_START_SAMPLE
        generic map (
            NAME            => string'("START"),
            MATCH_PHASE     => MATCH_PHASE
        )
        port map (
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => '0'                 , -- In  :
            MATCH_REQ       => match_req           , -- In  :
            MATCH_CODE      => match_code          , -- In  :
            MATCH_OK        => match_ok      (2)   , -- Out :
            MATCH_NOT       => match_not     (2)   , -- Out :
            MATCH_SHIFT     => match_shift   (2)   , -- Out :
            PROC_REQ_ID     => proc_req_id         , -- In  :
            PROC_REQ        => proc_req      (2)   , -- In  :
            PROC_BUSY       => proc_busy     (2)   , -- Out :
            PARAM_VALID     => param_valid   (2)   , -- In  :
            PARAM_CODE      => param_code    (2)   , -- In  :
            PARAM_LAST      => param_last    (2)   , -- In  :
            PARAM_SHIFT     => param_shift   (2)   , -- Out :
            PROC_RES_ID     => proc_res_id   (2)   , -- Out :
            PROC_RES_CODE   => proc_res_code (2)   , -- Out :
            PROC_RES_VALID  => proc_res_valid(2)   , -- Out :
            PROC_RES_LAST   => proc_res_last (2)   , -- Out :
            PROC_RES_READY  => proc_res_ready(2)     -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PROC_3: PROC_KVMAP_SET_VALUE_SAMPLE
        generic map (
            NAME            => string'("$SET"),
            MATCH_PHASE     => MATCH_PHASE
        )
        port map (
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => '0'                 , -- In  :
            MATCH_REQ       => match_req           , -- In  :
            MATCH_CODE      => match_code          , -- In  :
            MATCH_OK        => match_ok      (3)   , -- Out :
            MATCH_NOT       => match_not     (3)   , -- Out :
            MATCH_SHIFT     => match_shift   (3)   , -- Out :
            PROC_REQ_ID     => proc_req_id         , -- In  :
            PROC_REQ        => proc_req      (3)   , -- In  :
            PROC_BUSY       => proc_busy     (3)   , -- Out :
            PARAM_VALID     => param_valid   (3)   , -- In  :
            PARAM_CODE      => param_code    (3)   , -- In  :
            PARAM_LAST      => param_last    (3)   , -- In  :
            PARAM_SHIFT     => param_shift   (3)   , -- Out :
            PROC_RES_ID     => proc_res_id   (3)   , -- Out :
            PROC_RES_CODE   => proc_res_code (3)   , -- Out :
            PROC_RES_VALID  => proc_res_valid(3)   , -- Out :
            PROC_RES_LAST   => proc_res_last (3)   , -- Out :
            PROC_RES_READY  => proc_res_ready(3)   , -- In  :
            PARAM_A_VALUE   => param_a_din         , -- Out :
            PARAM_A_WE      => param_a_we          , -- Out :
            PARAM_B_VALUE   => param_b_din         , -- Out :
            PARAM_B_WE      => param_b_we            -- Out :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PROC_4: PROC_KVMAP_GET_VALUE_SAMPLE
        generic map (
            NAME            => string'("$GET"),
            MATCH_PHASE     => MATCH_PHASE
        )
        port map (
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => '0'                 , -- In  :
            MATCH_REQ       => match_req           , -- In  :
            MATCH_CODE      => match_code          , -- In  :
            MATCH_OK        => match_ok      (4)   , -- Out :
            MATCH_NOT       => match_not     (4)   , -- Out :
            MATCH_SHIFT     => match_shift   (4)   , -- Out :
            PROC_REQ_ID     => proc_req_id         , -- In  :
            PROC_REQ        => proc_req      (4)   , -- In  :
            PROC_BUSY       => proc_busy     (4)   , -- Out :
            PARAM_VALID     => param_valid   (4)   , -- In  :
            PARAM_CODE      => param_code    (4)   , -- In  :
            PARAM_LAST      => param_last    (4)   , -- In  :
            PARAM_SHIFT     => param_shift   (4)   , -- Out :
            PROC_RES_ID     => proc_res_id   (4)   , -- Out :
            PROC_RES_CODE   => proc_res_code (4)   , -- Out :
            PROC_RES_VALID  => proc_res_valid(4)   , -- Out :
            PROC_RES_LAST   => proc_res_last (4)   , -- Out :
            PROC_RES_READY  => proc_res_ready(4)   , -- In  :
            PARAM_A_VALUE   => param_a_value       , -- Out :
            PARAM_B_VALUE   => param_b_value         -- Out :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if (RST = '1') then
                param_a_value <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if (param_a_we = '1') then
                param_a_value <= param_a_din;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if (RST = '1') then
                param_b_value <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if (param_b_we = '1') then
                param_b_value <= param_b_din;
            end if;
        end if;
    end process;
end RTL;
