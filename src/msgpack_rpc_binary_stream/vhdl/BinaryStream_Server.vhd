-----------------------------------------------------------------------------------
--!     @file    BinaryStream_Server.vhd
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
entity  BinaryStream_Server is
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
end  BinaryStream_Server;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of BinaryStream_Server is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   reset          :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   bin1_i_data    :  std_logic_vector(8-1 downto 0);
    signal   bin1_i_last    :  std_logic;
    signal   bin1_i_valid   :  std_logic;
    signal   bin1_i_ready   :  std_logic;
    signal   bin1_o_data    :  std_logic_vector(8-1 downto 0);
    signal   bin1_o_last    :  std_logic;
    signal   bin1_o_valid   :  std_logic;
    signal   bin1_o_ready   :  std_logic;
    signal   bin4_i_data    :  std_logic_vector(32-1 downto 0);
    signal   bin4_i_strb    :  std_logic_vector(4-1 downto 0);
    signal   bin4_i_last    :  std_logic;
    signal   bin4_i_valid   :  std_logic;
    signal   bin4_i_ready   :  std_logic;
    signal   bin4_o_size    :  std_logic_vector(20-1 downto 0);
    signal   bin4_o_data    :  std_logic_vector(32-1 downto 0);
    signal   bin4_o_strb    :  std_logic_vector(4-1 downto 0);
    signal   bin4_o_last    :  std_logic;
    signal   bin4_o_valid   :  std_logic;
    signal   bin4_o_ready   :  std_logic;
    signal   str4_wdata     :  std_logic_vector(32-1 downto 0);
    signal   str4_wstrb     :  std_logic_vector(4-1 downto 0);
    signal   str4_wlast     :  std_logic;
    signal   str4_wvalid    :  std_logic;
    signal   str4_wready    :  std_logic;
    signal   str4_rdata     :  std_logic_vector(32-1 downto 0);
    signal   str4_rstrb     :  std_logic_vector(4-1 downto 0);
    signal   str4_rlast     :  std_logic;
    signal   str4_rvalid    :  std_logic;
    signal   str4_rready    :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component  BinaryStream_Interface is
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
            bin1_i_data          : out std_logic_vector(8-1 downto 0);
            bin1_i_last          : out std_logic;
            bin1_i_valid         : out std_logic;
            bin1_i_ready         : in  std_logic;
            bin1_o_data          : in  std_logic_vector(8-1 downto 0);
            bin1_o_last          : in  std_logic;
            bin1_o_valid         : in  std_logic;
            bin1_o_ready         : out std_logic;
            bin4_i_data          : out std_logic_vector(32-1 downto 0);
            bin4_i_strb          : out std_logic_vector(4-1 downto 0);
            bin4_i_last          : out std_logic;
            bin4_i_valid         : out std_logic;
            bin4_i_ready         : in  std_logic;
            bin4_o_size          : in  std_logic_vector(20-1 downto 0);
            bin4_o_data          : in  std_logic_vector(32-1 downto 0);
            bin4_o_strb          : in  std_logic_vector(4-1 downto 0);
            bin4_o_last          : in  std_logic;
            bin4_o_valid         : in  std_logic;
            bin4_o_ready         : out std_logic;
            str4_wdata           : out std_logic_vector(32-1 downto 0);
            str4_wstrb           : out std_logic_vector(4-1 downto 0);
            str4_wlast           : out std_logic;
            str4_wvalid          : out std_logic;
            str4_wready          : in  std_logic;
            str4_rdata           : in  std_logic_vector(32-1 downto 0);
            str4_rstrb           : in  std_logic_vector(4-1 downto 0);
            str4_rlast           : in  std_logic;
            str4_rvalid          : in  std_logic;
            str4_rready          : out std_logic
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component  BinaryStream_Fifo is
        generic (
            BYTES               : positive := 4;
            DEPTH               : positive := 4096;
            SIZE_BITS           : positive := 32
        );
        port (
            CLK                 : in  std_logic; 
            RST                 : in  std_logic; 
            CLR                 : in  std_logic; 
            I_DATA              : in  std_logic_vector(8*BYTES  -1 downto 0);
            I_STRB              : in  std_logic_vector(  BYTES  -1 downto 0) := (others => '1');
            I_LAST              : in  std_logic := '0';
            I_VALID             : in  std_logic;
            I_READY             : out std_logic;
            O_SIZE              : out std_logic_vector(SIZE_BITS-1 downto 0);
            O_DATA              : out std_logic_vector(8*BYTES  -1 downto 0);
            O_STRB              : out std_logic_vector(  BYTES  -1 downto 0);
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
    BMEM_IF: BinaryStream_Interface              -- 
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
            bin1_i_data     => bin1_i_data     , -- Out :
            bin1_i_last     => bin1_i_last     , -- Out :
            bin1_i_valid    => bin1_i_valid    , -- Out :
            bin1_i_ready    => bin1_i_ready    , -- In  :
            bin1_o_data     => bin1_o_data     , -- In  :
            bin1_o_last     => bin1_o_last     , -- In  :
            bin1_o_valid    => bin1_o_valid    , -- In  :
            bin1_o_ready    => bin1_o_ready    , -- Out :
            bin4_i_data     => bin4_i_data     , -- Out :
            bin4_i_strb     => bin4_i_strb     , -- Out :
            bin4_i_last     => bin4_i_last     , -- Out :
            bin4_i_valid    => bin4_i_valid    , -- Out :
            bin4_i_ready    => bin4_i_ready    , -- In  :
            bin4_o_size     => bin4_o_size     , -- In  :
            bin4_o_data     => bin4_o_data     , -- In  :
            bin4_o_strb     => bin4_o_strb     , -- In  :
            bin4_o_last     => bin4_o_last     , -- In  :
            bin4_o_valid    => bin4_o_valid    , -- In  :
            bin4_o_ready    => bin4_o_ready    , -- Out :
            str4_wdata      => str4_wdata      , -- Out :
            str4_wstrb      => str4_wstrb      , -- Out :
            str4_wlast      => str4_wlast      , -- Out :
            str4_wvalid     => str4_wvalid     , -- Out :
            str4_wready     => str4_wready     , -- In  :
            str4_rdata      => str4_rdata      , -- In  :
            str4_rstrb      => str4_rstrb      , -- In  :
            str4_rlast      => str4_rlast      , -- In  :
            str4_rvalid     => str4_rvalid     , -- In  :
            str4_rready     => str4_rready       -- Out :
        );                                       --
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    BIN1: BinaryStream_Fifo                      -- 
        generic map (                            -- 
            BYTES           => 1               , -- 
            DEPTH           => 4096            , -- 
            SIZE_BITS       => 13                -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => reset           , -- In  :
            CLR             => '0'             , -- In  :
            I_DATA          => bin1_i_data     , -- In  :
            I_LAST          => bin1_i_last     , -- In  :
            I_VALID         => bin1_i_valid    , -- In  :
            I_READY         => bin1_i_ready    , -- Out :
            O_DATA          => bin1_o_data     , -- Out :
            O_LAST          => bin1_o_last     , -- Out :
            O_VALID         => bin1_o_valid    , -- Out :
            O_READY         => bin1_o_ready      -- In  :
        );                                       -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    BIN4: BinaryStream_Fifo                      -- 
        generic map (                            -- 
            BYTES           => 4               , -- 
            DEPTH           => 4096            , -- 
            SIZE_BITS       => 20                -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => reset           , -- In  :
            CLR             => '0'             , -- In  :
            I_DATA          => bin4_i_data     , -- In  :
            I_STRB          => bin4_i_strb     , -- In  :
            I_LAST          => bin4_i_last     , -- In  :
            I_VALID         => bin4_i_valid    , -- In  :
            I_READY         => bin4_i_ready    , -- Out :
            O_SIZE          => bin4_o_size     , -- Out :
            O_DATA          => bin4_o_data     , -- Out :
            O_STRB          => bin4_o_strb     , -- Out :
            O_LAST          => bin4_o_last     , -- Out :
            O_VALID         => bin4_o_valid    , -- Out :
            O_READY         => bin4_o_ready      -- In  :
        );                                       -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STR4: BinaryStream_Fifo                      -- 
        generic map (                            -- 
            BYTES           => 4               , -- 
            DEPTH           => 4096            , -- 
            SIZE_BITS       => 13                -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => reset           , -- In  :
            CLR             => '0'             , -- In  :
            I_DATA          => str4_wdata      , -- In  :
            I_STRB          => str4_wstrb      , -- In  :
            I_LAST          => str4_wlast      , -- In  :
            I_VALID         => str4_wvalid     , -- In  :
            I_READY         => str4_wready     , -- Out :
            O_DATA          => str4_rdata      , -- Out :
            O_STRB          => str4_rstrb      , -- Out :
            O_LAST          => str4_rlast      , -- Out :
            O_VALID         => str4_rvalid     , -- Out :
            O_READY         => str4_rready       -- In  :
        );                                       -- 
end RTL;
