-----------------------------------------------------------------------------------
--!     @file    BooleanTest_Server.vhd
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
entity  BooleanTest_Server is
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
end  BooleanTest_Server;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server;
architecture RTL of BooleanTest_Server is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   reset          :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal   control_req    :  std_logic;
    signal   control_busy   :  std_logic;
    signal   control_done   :  std_logic;
    signal   control_status :  boolean;
    signal   control_return :  boolean;
    signal   status_wdata   :  boolean;
    signal   status_we      :  std_logic;
    signal   status_rdata   :  boolean;
    signal   stream1_wdata  :  std_logic_vector(1-1 downto 0);
    signal   stream1_wstrb  :  std_logic_vector(1-1 downto 0);
    signal   stream1_wlast  :  std_logic;
    signal   stream1_wvalid :  std_logic;
    signal   stream1_wready :  std_logic;
    signal   stream1_rdata  :  std_logic_vector(1-1 downto 0);
    signal   stream1_rstrb  :  std_logic_vector(1-1 downto 0);
    signal   stream1_rlast  :  std_logic;
    signal   stream1_rvalid :  std_logic;
    signal   stream1_rready :  std_logic;
    signal   stream4_wdata  :  std_logic_vector(4-1 downto 0);
    signal   stream4_wstrb  :  std_logic_vector(4-1 downto 0);
    signal   stream4_wlast  :  std_logic;
    signal   stream4_wvalid :  std_logic;
    signal   stream4_wready :  std_logic;
    signal   stream4_rdata  :  std_logic_vector(4-1 downto 0);
    signal   stream4_rstrb  :  std_logic_vector(4-1 downto 0);
    signal   stream4_rlast  :  std_logic;
    signal   stream4_rvalid :  std_logic;
    signal   stream4_rready :  std_logic;
    signal   memory1_waddr  :  std_logic_vector(12-1 downto 0);
    signal   memory1_wdata  :  std_logic_vector(1-1 downto 0);
    signal   memory1_strb   :  std_logic_vector(1-1 downto 0);
    signal   memory1_we     :  std_logic;
    signal   memory1_raddr  :  std_logic_vector(12-1 downto 0);
    signal   memory1_rdata  :  std_logic_vector(1-1 downto 0);
    signal   memory4_waddr  :  std_logic_vector(12-1 downto 0);
    signal   memory4_wdata  :  std_logic_vector(4-1 downto 0);
    signal   memory4_strb   :  std_logic_vector(4-1 downto 0);
    signal   memory4_we     :  std_logic;
    signal   memory4_raddr  :  std_logic_vector(12-1 downto 0);
    signal   memory4_rdata  :  std_logic_vector(4-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component BooleanTest_Interface is
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
            control_REQ     : out std_logic;
            control_BUSY    : in  std_logic;
            control_DONE    : in  std_logic;
            control_status  : out boolean;
            control_return  : in  boolean;
            status_wdata    : out boolean;
            status_we       : out std_logic;
            status_rdata    : in  boolean;
            stream1_wdata   : out std_logic_vector(1-1 downto 0);
            stream1_wstrb   : out std_logic_vector(1-1 downto 0);
            stream1_wlast   : out std_logic;
            stream1_wvalid  : out std_logic;
            stream1_wready  : in  std_logic;
            stream1_rdata   : in  std_logic_vector(1-1 downto 0);
            stream1_rstrb   : in  std_logic_vector(1-1 downto 0);
            stream1_rlast   : in  std_logic;
            stream1_rvalid  : in  std_logic;
            stream1_rready  : out std_logic;
            stream4_wdata   : out std_logic_vector(4-1 downto 0);
            stream4_wstrb   : out std_logic_vector(4-1 downto 0);
            stream4_wlast   : out std_logic;
            stream4_wvalid  : out std_logic;
            stream4_wready  : in  std_logic;
            stream4_rdata   : in  std_logic_vector(4-1 downto 0);
            stream4_rstrb   : in  std_logic_vector(4-1 downto 0);
            stream4_rlast   : in  std_logic;
            stream4_rvalid  : in  std_logic;
            stream4_rready  : out std_logic;
            memory1_waddr   : out std_logic_vector(12-1 downto 0);
            memory1_wdata   : out std_logic_vector(1-1 downto 0);
            memory1_strb    : out std_logic_vector(1-1 downto 0);
            memory1_we      : out std_logic;
            memory1_raddr   : out std_logic_vector(12-1 downto 0);
            memory1_rdata   : in  std_logic_vector(1-1 downto 0);
            memory4_waddr   : out std_logic_vector(12-1 downto 0);
            memory4_wdata   : out std_logic_vector(4-1 downto 0);
            memory4_strb    : out std_logic_vector(4-1 downto 0);
            memory4_we      : out std_logic;
            memory4_raddr   : out std_logic_vector(12-1 downto 0);
            memory4_rdata   : in  std_logic_vector(4-1 downto 0)
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component BooleanStream_Fifo is
        generic (
            WIDTH           : positive := 4;
            DEPTH           : positive := 4096;
            SIZE_BITS       : positive := 32
        );
        port (
            CLK             : in  std_logic; 
            RST             : in  std_logic; 
            CLR             : in  std_logic; 
            I_DATA          : in  std_logic_vector(WIDTH  -1 downto 0);
            I_STRB          : in  std_logic_vector(WIDTH  -1 downto 0) := (others => '1');
            I_LAST          : in  std_logic := '0';
            I_VALID         : in  std_logic;
            I_READY         : out std_logic;
            O_SIZE          : out std_logic_vector(SIZE_BITS-1 downto 0);
            O_DATA          : out std_logic_vector(WIDTH  -1 downto 0);
            O_STRB          : out std_logic_vector(WIDTH  -1 downto 0);
            O_LAST          : out std_logic;
            O_VALID         : out std_logic;
            O_READY         : in  std_logic
        );
    end component;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component BooleanMemory is
        generic (
            WIDTH   :     integer := 0;
            DEPTH   :     integer := 12
        );
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            waddr   : in  std_logic_vector(   DEPTH  -1 downto 0);
            we      : in  std_logic;
            wbe     : in  std_logic_vector((2**WIDTH)-1 downto 0);
            wdata   : in  std_logic_vector((2**WIDTH)-1 downto 0);
            raddr   : in  std_logic_vector(   DEPTH  -1 downto 0);
            rdata   : out std_logic_vector((2**WIDTH)-1 downto 0)
        );
    end component;
begin
    reset <= '1' when (ARESETn = '0') else '0';
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    BOOL_IF: BooleanTest_Interface               -- 
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
            control_req     => control_req     , -- Out :
            control_busy    => control_busy    , -- In  :
            control_done    => control_done    , -- In  :
            control_status  => control_status  , -- Out :
            control_return  => control_return  , -- In  :
            status_wdata    => status_wdata    , -- Out :
            status_we       => status_we       , -- Out :
            status_rdata    => status_rdata    , -- In  :
            stream1_wdata   => stream1_wdata   , -- Out :
            stream1_wstrb   => stream1_wstrb   , -- Out :
            stream1_wlast   => stream1_wlast   , -- Out :
            stream1_wvalid  => stream1_wvalid  , -- Out :
            stream1_wready  => stream1_wready  , -- In  :
            stream1_rdata   => stream1_rdata   , -- In  :
            stream1_rstrb   => stream1_rstrb   , -- In  :
            stream1_rlast   => stream1_rlast   , -- In  :
            stream1_rvalid  => stream1_rvalid  , -- In  :
            stream1_rready  => stream1_rready  , -- Out :
            stream4_wdata   => stream4_wdata   , -- Out :
            stream4_wstrb   => stream4_wstrb   , -- Out :
            stream4_wlast   => stream4_wlast   , -- Out :
            stream4_wvalid  => stream4_wvalid  , -- Out :
            stream4_wready  => stream4_wready  , -- In  :
            stream4_rdata   => stream4_rdata   , -- In  :
            stream4_rstrb   => stream4_rstrb   , -- In  :
            stream4_rlast   => stream4_rlast   , -- In  :
            stream4_rvalid  => stream4_rvalid  , -- In  :
            stream4_rready  => stream4_rready  , -- Out :
            memory1_waddr   => memory1_waddr   , -- Out :
            memory1_wdata   => memory1_wdata   , -- Out :
            memory1_strb    => memory1_strb    , -- Out :
            memory1_we      => memory1_we      , -- Out :
            memory1_raddr   => memory1_raddr   , -- Out :
            memory1_rdata   => memory1_rdata   , -- In  :
            memory4_waddr   => memory4_waddr   , -- Out :
            memory4_wdata   => memory4_wdata   , -- Out :
            memory4_strb    => memory4_strb    , -- Out :
            memory4_we      => memory4_we      , -- Out :
            memory4_raddr   => memory4_raddr   , -- Out :
            memory4_rdata   => memory4_rdata     -- In  :
        );                                       -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (CLK, reset) begin
        if (reset = '1') then
                control_busy   <= '0';
                control_return <= FALSE;
                status_rdata   <= FALSE;
        elsif (CLK'event and CLK = '1') then
            if (control_req = '1' and control_busy = '0') then
                control_busy   <= '1';
                control_return <= control_status;
            else
                control_busy   <= '0';
            end if;
            if (status_we = '1') then
                status_rdata   <= status_wdata;
            end if;
        end if;
    end process;
    control_done <= control_busy;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STREAM1: BooleanStream_Fifo                  -- 
        generic map (                            -- 
            WIDTH           => 1               , -- 
            DEPTH           => 4096            , -- 
            SIZE_BITS       => 13                -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => reset           , -- In  :
            CLR             => '0'             , -- In  :
            I_DATA          => stream1_wdata   , -- In  :
            I_STRB          => stream1_wstrb   , -- In  :
            I_LAST          => stream1_wlast   , -- In  :
            I_VALID         => stream1_wvalid  , -- In  :
            I_READY         => stream1_wready  , -- Out :
            O_SIZE          => open            , -- Out :
            O_DATA          => stream1_rdata   , -- Out :
            O_STRB          => stream1_rstrb   , -- Out :
            O_LAST          => stream1_rlast   , -- Out :
            O_VALID         => stream1_rvalid  , -- Out :
            O_READY         => stream1_rready    -- In  :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    STREAM4: BooleanStream_Fifo                  -- 
        generic map (                            -- 
            WIDTH           => 4               , -- 
            DEPTH           => 4096            , -- 
            SIZE_BITS       => 13                -- 
        )                                        -- 
        port map (                               -- 
            CLK             => CLK             , -- In  :
            RST             => reset           , -- In  :
            CLR             => '0'             , -- In  :
            I_DATA          => stream4_wdata   , -- In  :
            I_STRB          => stream4_wstrb   , -- In  :
            I_LAST          => stream4_wlast   , -- In  :
            I_VALID         => stream4_wvalid  , -- In  :
            I_READY         => stream4_wready  , -- Out :
            O_SIZE          => open            , -- Out :
            O_DATA          => stream4_rdata   , -- Out :
            O_STRB          => stream4_rstrb   , -- Out :
            O_LAST          => stream4_rlast   , -- Out :
            O_VALID         => stream4_rvalid  , -- Out :
            O_READY         => stream4_rready    -- In  :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MEMORY1: BooleanMemory                       -- 
        generic map (                            -- 
            WIDTH          => 0                , -- 
            DEPTH          => 12                 -- 
        )                                        -- 
        port map (                               -- 
            clk            => CLK              , -- 
            reset          => reset            , -- 
            waddr          => memory1_waddr    , -- 
            we             => memory1_we       , -- 
            wbe            => memory1_strb     , -- 
            wdata          => memory1_wdata    , -- 
            raddr          => memory1_raddr    , -- 
            rdata          => memory1_rdata      -- 
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MEMORY4: BooleanMemory                       -- 
        generic map (                            -- 
            WIDTH          => 2                , -- 
            DEPTH          => 12                 -- 
        )                                        -- 
        port map (                               -- 
            clk            => CLK              , -- 
            reset          => reset            , -- 
            waddr          => memory4_waddr    , -- 
            we             => memory4_we       , -- 
            wbe            => memory4_strb     , -- 
            wdata          => memory4_wdata    , -- 
            raddr          => memory4_raddr    , -- 
            rdata          => memory4_rdata      -- 
        );
end RTL;
