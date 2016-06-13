-----------------------------------------------------------------------------------
--!     @file    IntegerStream_Server.vhd
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
entity  IntegerStream_Server is
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
end  IntegerStream_Server;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of IntegerStream_Server is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   reset          :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   num_i_data     :  signed(32-1 downto 0);
    signal   num_i_last     :  std_logic;
    signal   num_i_valid    :  std_logic;
    signal   num_i_ready    :  std_logic;
    signal   num_o_data     :  signed(32-1 downto 0);
    signal   num_o_last     :  std_logic;
    signal   num_o_valid    :  std_logic;
    signal   num_o_ready    :  std_logic;
    signal   num_o_size     :  std_logic_vector(13-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component  IntegerStream_Interface is
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
            num_i_data           : out signed(32-1 downto 0);
            num_i_last           : out std_logic;
            num_i_valid          : out std_logic;
            num_i_ready          : in  std_logic;
            num_o_size           : in  std_logic_vector(13-1 downto 0);
            num_o_data           : in  signed(32-1 downto 0);
            num_o_last           : in  std_logic;
            num_o_valid          : in  std_logic;
            num_o_ready          : out std_logic
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component  IntegerStream_Fifo is
        generic (
            DEPTH               : positive := 4096;
            DATA_BITS           : positive := 32;
            SIZE_BITS           : positive := 32
        );
        port (
            CLK                 : in  std_logic; 
            RST                 : in  std_logic; 
            CLR                 : in  std_logic; 
            I_DATA              : in  signed(          DATA_BITS-1 downto 0);
            I_LAST              : in  std_logic := '0';
            I_VALID             : in  std_logic;
            I_READY             : out std_logic;
            O_SIZE              : out std_logic_vector(SIZE_BITS-1 downto 0);
            O_DATA              : out signed(          DATA_BITS-1 downto 0);
            O_LAST              : out std_logic;
            O_VALID             : out std_logic;
            O_READY             : in  std_logic
        );
    end component;
begin
    reset <= '1' when (ARESETn = '0') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    ISTRM_IF: IntegerStream_Interface            -- 
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
            num_i_data      => num_i_data      , -- Out :
            num_i_last      => num_i_last      , -- Out :
            num_i_valid     => num_i_valid     , -- Out :
            num_i_ready     => num_i_ready     , -- In  :
            num_o_size      => num_o_size      , -- In  :
            num_o_data      => num_o_data      , -- In  :
            num_o_last      => num_o_last      , -- In  :
            num_o_valid     => num_o_valid     , -- In  :
            num_o_ready     => num_o_ready       -- Out :
        );                                       --
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    NUM: IntegerStream_Fifo                      -- 
        generic map (                            -- 
            DEPTH           => 4096            , -- 
            DATA_BITS       => 32              , -- 
            SIZE_BITS       => 13                -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => reset           , -- In  :
            CLR             => '0'             , -- In  :
            I_DATA          => num_i_data      , -- In  :
            I_LAST          => num_i_last      , -- In  :
            I_VALID         => num_i_valid     , -- In  :
            I_READY         => num_i_ready     , -- Out :
            O_SIZE          => num_o_size      , -- Out :
            O_DATA          => num_o_data      , -- Out :
            O_LAST          => num_o_last      , -- Out :
            O_VALID         => num_o_valid     , -- Out :
            O_READY         => num_o_ready       -- In  :
        );                                       -- 
end RTL;
