library ieee;
use     ieee.std_logic_1164.all;
library MsgPack;
use     MsgPack.MsgPack_RPC;
entity  PROC_ADD_SAMPLE is
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
        PARAM_VALID     : in  std_logic;
        PARAM_CODE      : in  MsgPack_RPC.Code_Type;
        PARAM_LAST      : in  std_logic;
        PARAM_SHIFT     : out MsgPack_RPC.Shift_Type;
        PROC_RES_ID     : out MsgPack_RPC.MsgID_Type;
        PROC_RES_CODE   : out MsgPack_RPC.Code_Type;
        PROC_RES_VALID  : out std_logic;
        PROC_RES_LAST   : out std_logic;
        PROC_RES_READY  : in  std_logic
    );
end  PROC_ADD_SAMPLE;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Main_with_Param;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Return_Integer;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Set_Param_Integer;
architecture RTL of PROC_ADD_SAMPLE is
    constant  PARAM_NUM         :  integer := 2;
    signal    set_param_code    :  MsgPack_RPC.Code_Type;
    signal    set_param_last    :  std_logic;
    signal    set_param_valid   :  std_logic_vector        (PARAM_NUM-1 downto 0);
    signal    set_param_error   :  std_logic_vector        (PARAM_NUM-1 downto 0);
    signal    set_param_done    :  std_logic_vector        (PARAM_NUM-1 downto 0);
    signal    set_param_shift   :  MsgPack_RPC.Shift_Vector(PARAM_NUM-1 downto 0);
    signal    return_id         :  MsgPack_RPC.MsgID_Type;
    signal    return_error      :  std_logic;
    signal    return_start      :  std_logic;
    signal    return_busy       :  std_logic;
    signal    proc_start        :  std_logic;
    signal    add_req           :  std_logic;
    signal    add_busy          :  std_logic;
    signal    add_a             :  std_logic_vector(31 downto 0);
    signal    add_a_default     :  std_logic_vector(31 downto 0) := (others => '0');
    signal    add_b             :  std_logic_vector(31 downto 0);
    signal    add_b_default     :  std_logic_vector(31 downto 0) := (others => '0');
    signal    add_return        :  signed(31 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    component ADD is
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            add_a      : in signed(32-1 downto 0);
            add_b      : in signed(32-1 downto 0);
            add_return : out signed(32-1 downto 0);
            add_busy   : out std_logic;
            add_req    : in std_logic
        );
    end component;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    CORE: MsgPack_RPC_Method_Main_with_Param         -- 
        generic map (                                -- 
            NAME            => NAME                , --
            PARAM_NUM       => PARAM_NUM           , --
            MATCH_PHASE     => MATCH_PHASE           --
        )                                            -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => CLR                 , -- In  :
            MATCH_REQ       => MATCH_REQ           , -- In  :
            MATCH_CODE      => MATCH_CODE          , -- In  :
            MATCH_OK        => MATCH_OK            , -- Out :
            MATCH_NOT       => MATCH_NOT           , -- Out :
            MATCH_SHIFT     => MATCH_SHIFT         , -- Out :
            PROC_REQ_ID     => PROC_REQ_ID         , -- In  :
            PROC_REQ        => PROC_REQ            , -- In  :
            PROC_BUSY       => PROC_BUSY           , -- Out :
            PROC_START      => proc_start          , -- Out :
            PARAM_CODE      => PARAM_CODE          , -- In  :
            PARAM_VALID     => PARAM_VALID         , -- In  :
            PARAM_LAST      => PARAM_LAST          , -- In  :
            PARAM_SHIFT     => PARAM_SHIFT         , -- Out :
            SET_PARAM_CODE  => set_param_code      , -- Out :
            SET_PARAM_LAST  => set_param_last      , -- Out :
            SET_PARAM_VALID => set_param_valid     , -- Out :
            SET_PARAM_ERROR => set_param_error     , -- In  :
            SET_PARAM_DONE  => set_param_done      , -- In  :
            SET_PARAM_SHIFT => set_param_shift     , -- In  :
            RUN_REQ         => add_req             , -- Out :
            RUN_BUSY        => add_busy            , -- In  :
            RET_ID          => PROC_RES_ID         , -- Out :
            RET_ERROR       => return_error        , -- Out :
            RET_START       => return_start        , -- Out :
            RET_BUSY        => return_busy           -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    ARG0: MsgPack_RPC_Method_Set_Param_Integer       -- 
        generic map (                                -- 
            VALUE_WIDTH     => add_a'length        , --
            VALUE_SIGN      => TRUE                , --
            CHECK_RANGE     => TRUE                , --
            ENABLE64        => TRUE                  --
        )
        port map (
            CLK             => CLK                 , -- : In  :
            RST             => RST                 , -- : In  :
            CLR             => CLR                 , -- : In  :
            SET_PARAM_CODE  => set_param_code      , -- : In  :
            SET_PARAM_LAST  => set_param_last      , -- : In  :
            SET_PARAM_VALID => set_param_valid(0)  , -- : In  :
            SET_PARAM_ERROR => set_param_error(0)  , -- : Out :
            SET_PARAM_DONE  => set_param_done (0)  , -- : Out :
            SET_PARAM_SHIFT => set_param_shift(0)  , -- : Out :
            DEFAULT_WE      => proc_start          , -- : In  :
            DEFAULT_VALUE   => add_a_default       , -- : In  :
            PARAM_VALUE     => add_a               , -- : Out :
            PARAM_WE        => open                  -- : Out :
        );                                           --
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    ARG1: MsgPack_RPC_Method_Set_Param_Integer       -- 
        generic map (                                -- 
            VALUE_WIDTH     => add_b'length        , --
            VALUE_SIGN      => TRUE                , --
            CHECK_RANGE     => TRUE                , --
            ENABLE64        => TRUE                  --
        )
        port map (
            CLK             => CLK                 , -- : In  :
            RST             => RST                 , -- : In  :
            CLR             => CLR                 , -- : In  :
            SET_PARAM_CODE  => set_param_code      , -- : In  :
            SET_PARAM_LAST  => set_param_last      , -- : In  :
            SET_PARAM_VALID => set_param_valid(1)  , -- : In  :
            SET_PARAM_ERROR => set_param_error(1)  , -- : Out :
            SET_PARAM_DONE  => set_param_done (1)  , -- : Out :
            SET_PARAM_SHIFT => set_param_shift(1)  , -- : Out :
            DEFAULT_WE      => proc_start          , -- : In  :
            DEFAULT_VALUE   => add_b_default       , -- : In  :
            PARAM_VALUE     => add_b               , -- : Out :
            PARAM_WE        => open                  -- : Out :
        );                                           --
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    RET : MsgPack_RPC_Method_Return_Integer          -- 
        generic map (                                -- 
            VALUE_WIDTH     => add_return'length   , --
            RETURN_UINT     => FALSE               , --
            RETURN_INT      => TRUE                , --
            RETURN_FLOAT    => FALSE               , --
            RETURN_BOOLEAN  => FALSE                 --
        )                                            -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => CLR                 , -- In  :
            RET_ERROR       => return_error        , -- In  :
            RET_START       => return_start        , -- In  :
            RET_BUSY        => return_busy         , -- Out :
            RES_CODE        => PROC_RES_CODE       , -- Out :
            RES_VALID       => PROC_RES_VALID      , -- Out :
            RES_LAST        => PROC_RES_LAST       , -- Out :
            RES_READY       => PROC_RES_READY      , -- In  :
            VALUE           => std_logic_vector(add_return) -- In  :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    U_ADD: ADD                                       -- 
        port map (                                   -- 
            clk             => CLK                 , -- In  :
            reset           => RST                 , -- In  :
            add_a           => signed(add_a)       , -- In  :
            add_b           => signed(add_b)       , -- In  :
            add_return      => add_return          , -- Out :
            add_busy        => add_busy            , -- Out :
            add_req         => add_req               -- In  :
        );
end RTL;
