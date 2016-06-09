-----------------------------------------------------------------------------------
--!     @file    BinaryMemory_Server.vhd
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
entity  BinaryMemory_Server is
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
end  BinaryMemory_Server;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of BinaryMemory_Server is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   reset          :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   bin1_addr      :  std_logic_vector(12-1 downto 0);
    signal   bin1_wdata     :  std_logic_vector( 8-1 downto 0);
    signal   bin1_wbe       :  std_logic_vector( 1-1 downto 0);
    signal   bin1_we        :  std_logic;
    signal   bin1_rdata     :  std_logic_vector( 8-1 downto 0);
    signal   bin2_addr      :  std_logic_vector(12-1 downto 0);
    signal   bin2_wdata     :  std_logic_vector(16-1 downto 0);
    signal   bin2_wbe       :  std_logic_vector( 2-1 downto 0);
    signal   bin2_we        :  std_logic;
    signal   bin2_rdata     :  std_logic_vector(16-1 downto 0);
    signal   bin4_addr      :  std_logic_vector(12-1 downto 0);
    signal   bin4_wdata     :  std_logic_vector(32-1 downto 0);
    signal   bin4_wbe       :  std_logic_vector( 4-1 downto 0);
    signal   bin4_we        :  std_logic;
    signal   bin4_rdata     :  std_logic_vector(32-1 downto 0);
    signal   bin8_addr      :  std_logic_vector(12-1 downto 0);
    signal   bin8_wdata     :  std_logic_vector(64-1 downto 0);
    signal   bin8_wbe       :  std_logic_vector( 8-1 downto 0);
    signal   bin8_we        :  std_logic;
    signal   bin8_rdata     :  std_logic_vector(64-1 downto 0);
    signal   str4_addr      :  std_logic_vector(12-1 downto 0);
    signal   str4_wdata     :  std_logic_vector(32-1 downto 0);
    signal   str4_wbe       :  std_logic_vector( 4-1 downto 0);
    signal   str4_we        :  std_logic;
    signal   str4_rdata     :  std_logic_vector(32-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component  BinaryMemory_Interface is
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
            bin1_addr       : out std_logic_vector(12-1 downto 0);
            bin1_wdata      : out std_logic_vector( 8-1 downto 0);
            bin1_wbe        : out std_logic_vector( 1-1 downto 0);
            bin1_we         : out std_logic;
            bin1_rdata      : in  std_logic_vector( 8-1 downto 0);
            bin2_addr       : out std_logic_vector(12-1 downto 0);
            bin2_wdata      : out std_logic_vector(16-1 downto 0);
            bin2_wbe        : out std_logic_vector( 2-1 downto 0);
            bin2_we         : out std_logic;
            bin2_rdata      : in  std_logic_vector(16-1 downto 0);
            bin4_addr       : out std_logic_vector(12-1 downto 0);
            bin4_wdata      : out std_logic_vector(32-1 downto 0);
            bin4_wbe        : out std_logic_vector( 4-1 downto 0);
            bin4_we         : out std_logic;
            bin4_rdata      : in  std_logic_vector(32-1 downto 0);
            bin8_addr       : out std_logic_vector(12-1 downto 0);
            bin8_wdata      : out std_logic_vector(64-1 downto 0);
            bin8_wbe        : out std_logic_vector( 8-1 downto 0);
            bin8_we         : out std_logic;
            bin8_rdata      : in  std_logic_vector(64-1 downto 0);
            str4_addr       : out std_logic_vector(12-1 downto 0);
            str4_wdata      : out std_logic_vector(32-1 downto 0);
            str4_wbe        : out std_logic_vector( 4-1 downto 0);
            str4_we         : out std_logic;
            str4_rdata      : in  std_logic_vector(32-1 downto 0)
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component BinaryMemory is
        generic (
            WIDTH   :     integer := 0;
            DEPTH   :     integer := 12
        );
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            address : in  std_logic_vector(     DEPTH  -1 downto 0);
            we      : in  std_logic;
            wbe     : in  std_logic_vector(  (2**WIDTH)-1 downto 0);
            wdata   : in  std_logic_vector(8*(2**WIDTH)-1 downto 0);
            rdata   : out std_logic_vector(8*(2**WIDTH)-1 downto 0)
        );
    end component;
begin
    reset <= '1' when (ARESETn = '0') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    BMEM_IF: BinaryMemory_Interface              -- 
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
            bin1_addr       => bin1_addr       , -- Out :
            bin1_wdata      => bin1_wdata      , -- Out :
            bin1_wbe        => bin1_wbe        , -- Out :
            bin1_we         => bin1_we         , -- Out :
            bin1_rdata      => bin1_rdata      , -- In  :
            bin2_addr       => bin2_addr       , -- Out :
            bin2_wdata      => bin2_wdata      , -- Out :
            bin2_wbe        => bin2_wbe        , -- Out :
            bin2_we         => bin2_we         , -- Out :
            bin2_rdata      => bin2_rdata      , -- In  :
            bin4_addr       => bin4_addr       , -- Out :
            bin4_wdata      => bin4_wdata      , -- Out :
            bin4_wbe        => bin4_wbe        , -- Out :
            bin4_we         => bin4_we         , -- Out :
            bin4_rdata      => bin4_rdata      , -- In  :
            bin8_addr       => bin8_addr       , -- Out :
            bin8_wdata      => bin8_wdata      , -- Out :
            bin8_wbe        => bin8_wbe        , -- Out :
            bin8_we         => bin8_we         , -- Out :
            bin8_rdata      => bin8_rdata      , -- In  :
            str4_addr       => str4_addr       , -- Out :
            str4_wdata      => str4_wdata      , -- Out :
            str4_wbe        => str4_wbe        , -- Out :
            str4_we         => str4_we         , -- Out :
            str4_rdata      => str4_rdata        -- In  :
        );                                       -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    BIN1: BinaryMemory
        generic map (
            WIDTH           => 0               ,
            DEPTH           => 12
        )
        port map (
            clk             => CLK             , -- In  :
            reset           => reset           , -- In  :
            address         => bin1_addr       , -- In  :
            we              => bin1_we         , -- In  :
            wbe             => bin1_wbe        , -- In  :
            wdata           => bin1_wdata      , -- In  :
            rdata           => bin1_rdata        -- Out :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    BIN2: BinaryMemory
        generic map (
            WIDTH           => 1               ,
            DEPTH           => 12
        )
        port map (
            clk             => CLK             , -- In  :
            reset           => reset           , -- In  :
            address         => bin2_addr       , -- In  :
            we              => bin2_we         , -- In  :
            wbe             => bin2_wbe        , -- In  :
            wdata           => bin2_wdata      , -- In  :
            rdata           => bin2_rdata        -- Out :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    BIN4: BinaryMemory
        generic map (
            WIDTH           => 2               ,
            DEPTH           => 12
        )
        port map (
            clk             => CLK             , -- In  :
            reset           => reset           , -- In  :
            address         => bin4_addr       , -- In  :
            we              => bin4_we         , -- In  :
            wbe             => bin4_wbe        , -- In  :
            wdata           => bin4_wdata      , -- In  :
            rdata           => bin4_rdata        -- Out :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    BIN8: BinaryMemory
        generic map (
            WIDTH           => 3               ,
            DEPTH           => 12
        )
        port map (
            clk             => CLK             , -- In  :
            reset           => reset           , -- In  :
            address         => bin8_addr       , -- In  :
            we              => bin8_we         , -- In  :
            wbe             => bin8_wbe        , -- In  :
            wdata           => bin8_wdata      , -- In  :
            rdata           => bin8_rdata        -- Out :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STR4: BinaryMemory
        generic map (
            WIDTH           => 2               ,
            DEPTH           => 12
        )
        port map (
            clk             => CLK             , -- In  :
            reset           => reset           , -- In  :
            address         => str4_addr       , -- In  :
            we              => str4_we         , -- In  :
            wbe             => str4_wbe        , -- In  :
            wdata           => str4_wdata      , -- In  :
            rdata           => str4_rdata        -- Out :
        );
end RTL;
