-----------------------------------------------------------------------------------
--!     @file    IntegerMemory_Server.vhd
--!     @brief   Sample Module for MsgPack_RPC_Server
--!     @version 0.2.0
--!     @date    2016/6/7
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
entity  IntegerMemory_Server is
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
end  IntegerMemory_Server;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of IntegerMemory_Server is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   reset          :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   data_address   : signed(32-1 downto 0);
    signal   data_dout      : signed(32-1 downto 0);
    signal   data_we        : std_logic;
    signal   data_din       : signed(32-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component IntegerMemory_Interface is
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
            data_address    : out signed(32-1 downto 0);
            data_we         : out std_logic;
            data_din        : out signed(32-1 downto 0);
            data_dout       : in  signed(32-1 downto 0)
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component IntegerMemory is
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            data_address : in  signed(32-1 downto 0);
            data_we      : in  std_logic;
            data_oe      : in  std_logic;
            data_din     : in  signed(32-1 downto 0);
            data_dout    : out signed(32-1 downto 0);
            data_length  : out signed(32-1 downto 0)
        );
    end component;
begin
    reset <= '1' when (ARESETn = '0') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    IMEM_IF: IntegerMemory_Interface             -- 
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
            data_address    => data_address    , -- Out :
            data_we         => data_we         , -- Out :
            data_din        => data_din        , -- Out :
            data_dout       => data_dout         -- In  :
        );                                       -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    IMEM: IntegerMemory                          -- 
        port map (                               -- 
            clk             => CLK             , -- In  :
            reset           => reset           , -- In  :
            data_address    => data_address    , -- In  :
            data_we         => data_we         , -- In  :
            data_oe         => '1'             , -- In  :
            data_din        => data_din        , -- In  :
            data_dout       => data_dout       , -- Out :
            data_length     => open              -- Out :
        );
end RTL;
