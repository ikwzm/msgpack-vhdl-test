-----------------------------------------------------------------------------------
--!     @file    Accumulator_Server.vhd
--!     @brief   Sample Module for MsgPack_RPC_Server
--!     @version 0.2.0
--!     @date    2016/6/4
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2016 Ichiro Kawazome
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
entity  Accumulator_Server is
    -------------------------------------------------------------------------------
    -- Generic Parameters
    -------------------------------------------------------------------------------
    generic (
        I_BYTES         : positive := 4;
        O_BYTES         : positive := 4
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock and Reset Signals
    -------------------------------------------------------------------------------
        CLK             : in  std_logic; 
        ARESETn         : in  std_logic;
    -------------------------------------------------------------------------------
    -- MessagePack-RPC Byte Data Input Interface
    -------------------------------------------------------------------------------
        I_TDATA         : in  std_logic_vector(8*I_BYTES-1 downto 0);
        I_TKEEP         : in  std_logic_vector(  I_BYTES-1 downto 0);
        I_TLAST         : in  std_logic := '0';
        I_TVALID        : in  std_logic;
        I_TREADY        : out std_logic;
    -------------------------------------------------------------------------------
    -- MessagePack-RPC Byte Data Output Interface
    -------------------------------------------------------------------------------
        O_TDATA         : out std_logic_vector(8*O_BYTES-1 downto 0);
        O_TKEEP         : out std_logic_vector(  O_BYTES-1 downto 0);
        O_TLAST         : out std_logic;
        O_TVALID        : out std_logic;
        O_TREADY        : in  std_logic
    );
end  Accumulator_Server;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server;
architecture RTL of Accumulator_Server is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   reset          :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   reg_out        :  signed(31 downto 0);
    signal   reg_in         :  signed(31 downto 0);
    signal   reg_we         :  std_logic;
    signal   add_x          :  signed(31 downto 0);
    signal   add_return     :  signed(31 downto 0);
    signal   add_req        :  std_logic;
    signal   add_busy       :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Accumulator_Interface is
        generic(
            I_BYTES         : integer := 1;
            O_BYTES         : integer := 1
        );
        port(
            CLK             : in  std_logic;
            RST             : in  std_logic;
            CLR             : in  std_logic;
            I_DATA          : in  std_logic_vector(8*I_BYTES-1 downto 0);
            I_STRB          : in  std_logic_vector(  I_BYTES-1 downto 0);
            I_LAST          : in  std_logic;
            I_VALID         : in  std_logic;
            I_READY         : out std_logic;
            O_DATA          : out std_logic_vector(8*O_BYTES-1 downto 0);
            O_STRB          : out std_logic_vector(  O_BYTES-1 downto 0);
            O_LAST          : out std_logic;
            O_VALID         : out std_logic;
            O_READY         : in  std_logic;
            add_req         : out std_logic;
            add_busy        : in  std_logic;
            add_x           : out signed(32-1 downto 0);
            add_return      : in  signed(32-1 downto 0);
            reg_in          : out signed(32-1 downto 0);
            reg_we          : out std_logic;
            reg_out         : in  signed(32-1 downto 0)
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component Accumulator is
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            reg_in     : in  signed(32-1 downto 0);
            reg_we     : in  std_logic;
            reg_out    : out signed(32-1 downto 0);
            add_x      : in  signed(32-1 downto 0);
            add_return : out signed(32-1 downto 0);
            add_busy   : out std_logic;
            add_req    : in  std_logic
        );
    end component;
begin
    reset <= '1' when (ARESETn = '0') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    ACC_IF: Accumulator_Interface                -- 
        generic map (                            -- 
            I_BYTES         => I_BYTES,          -- 
            O_BYTES         => O_BYTES           -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => reset           , -- In  :
            CLR             => '0'             , -- In  :
            I_DATA          => I_TDATA         , -- In  :
            I_STRB          => I_TKEEP         , -- In  :
            I_LAST          => I_TLAST         , -- In  :
            I_VALID         => I_TVALID        , -- In  :
            I_READY         => I_TREADY        , -- Out :
            O_DATA          => O_TDATA         , -- Out :
            O_STRB          => O_TKEEP         , -- Out :
            O_LAST          => O_TLAST         , -- Out :
            O_VALID         => O_TVALID        , -- Out :
            O_READY         => O_TREADY        , -- In  :
            add_req         => add_req         , -- Out :
            add_busy        => add_busy        , -- In  :
            add_x           => add_x           , -- Out :
            add_return      => add_return      , -- In  :
            reg_in          => reg_in          , -- Out :
            reg_we          => reg_we          , -- Out :
            reg_out         => reg_out           -- In  :
        );                                       -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    ACC: Accumulator                             -- 
        port map (                               -- 
            clk             => CLK             , -- In  :
            reset           => reset           , -- In  :
            reg_in          => reg_in          , -- In  :
            reg_we          => reg_we          , -- In  :
            reg_out         => reg_out         , -- Out :
            add_x           => add_x           , -- In  :
            add_return      => add_return      , -- Out :
            add_busy        => add_busy        , -- Out :
            add_req         => add_req           -- In  :
        );
end RTL;
