library ieee;
use     ieee.std_logic_1164.all;
library MsgPack;
use     MsgPack.MsgPack_RPC;
entity  PROC_KVMAP_SET_VALUE_SAMPLE is
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
        PROC_RES_READY  : in  std_logic;
        PARAM_A_VALUE   : out std_logic_vector(31 downto 0);
        PARAM_A_WE      : out std_logic;
        PARAM_B_VALUE   : out std_logic_vector(63 downto 0);
        PARAM_B_WE      : out std_logic
    );
end  PROC_KVMAP_SET_VALUE_SAMPLE;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Set_Value;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Set_Integer;
architecture RTL of PROC_KVMAP_SET_VALUE_SAMPLE is
    constant  STORE_SIZE        :  integer := 2;
    signal    key_match_req     :  std_logic_vector       (MATCH_PHASE-1 downto 0);
    signal    key_match_code    :  MsgPack_RPC.Code_Type;
    signal    key_match_ok      :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    key_match_not     :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    key_match_shift   :  MsgPack_RPC.Shift_Vector(STORE_SIZE-1 downto 0);
    signal    value_code        :  MsgPack_RPC.Code_Type;
    signal    value_valid       :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    value_last        :  std_logic;
    signal    value_error       :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    value_done        :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    value_shift       :  MsgPack_RPC.Shift_Vector(STORE_SIZE-1 downto 0);
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MAIN: MsgPack_RPC_Server_KVMap_Set_Value         -- 
        generic map (                                -- 
            NAME            => NAME                , -- 
            STORE_SIZE      => STORE_SIZE          , -- 
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
            PARAM_CODE      => PARAM_CODE          , -- In  :
            PARAM_VALID     => PARAM_VALID         , -- In  :
            PARAM_LAST      => PARAM_LAST          , -- In  :
            PARAM_SHIFT     => PARAM_SHIFT         , -- Out :
            KEY_MATCH_REQ   => key_match_req       , -- Out :
            KEY_MATCH_CODE  => key_match_code      , -- Out :
            KEY_MATCH_OK    => key_match_ok        , -- In  :
            KEY_MATCH_NOT   => key_match_not       , -- In  :
            KEY_MATCH_SHIFT => key_match_shift     , -- In  :
            VALUE_VALID     => value_valid         , -- Out :
            VALUE_CODE      => value_code          , -- Out :
            VALUE_LAST      => value_last          , -- Out :
            VALUE_ERROR     => value_error         , -- In  :
            VALUE_DONE      => value_done          , -- In  :
            VALUE_SHIFT     => value_shift         , -- In  :
            RES_ID          => PROC_RES_ID         , -- Out :
            RES_CODE        => PROC_RES_CODE       , -- Out :
            RES_VALID       => PROC_RES_VALID      , -- Out :
            RES_LAST        => PROC_RES_LAST       , -- Out :
            RES_READY       => PROC_RES_READY        -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PARAM_A:  MsgPack_KVMap_Set_Integer              -- 
        generic map (                                -- 
            KEY             => STRING'("PARAM_A")  , --
            CODE_WIDTH      => MsgPack_RPC.Code_Length  , --
            MATCH_PHASE     => MATCH_PHASE         , --
            VALUE_WIDTH     => PARAM_A_VALUE'length, --
            VALUE_SIGN      => TRUE                , --
            CHECK_RANGE     => TRUE                , --
            ENABLE64        => TRUE                  --
        )                                            -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- in  :
            CLR             => CLR                 , -- In  :
            I_CODE          => value_code          , -- In  :
            I_LAST          => value_last          , -- In  :
            I_VALID         => value_valid    (0)  , -- In  :
            I_ERROR         => value_error    (0)  , -- Out :
            I_DONE          => value_done     (0)  , -- Out :
            I_SHIFT         => value_shift    (0)  , -- Out :
            MATCH_REQ       => key_match_req       , -- In  :
            MATCH_CODE      => key_match_code      , -- In  :
            MATCH_OK        => key_match_ok   (0)  , -- Out :
            MATCH_NOT       => key_match_not  (0)  , -- Out :
            MATCH_SHIFT     => key_match_shift(0)  , -- Out :
            VALUE           => PARAM_A_VALUE       , -- Out :
            SIGN            => open                , -- Out :
            WE              => PARAM_A_WE            -- Out :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PARAM_B:  MsgPack_KVMap_Set_Integer              -- 
        generic map (                                -- 
            KEY             => STRING'("PARAM_B")  , --
            CODE_WIDTH      => MsgPack_RPC.Code_Length  , --
            MATCH_PHASE     => MATCH_PHASE         , --
            VALUE_WIDTH     => PARAM_B_VALUE'length, --
            VALUE_SIGN      => TRUE                , --
            CHECK_RANGE     => TRUE                , --
            ENABLE64        => TRUE                  --
        )                                            -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- in  :
            CLR             => CLR                 , -- In  :
            I_CODE          => value_code          , -- In  :
            I_LAST          => value_last          , -- In  :
            I_VALID         => value_valid    (1)  , -- In  :
            I_ERROR         => value_error    (1)  , -- Out :
            I_DONE          => value_done     (1)  , -- Out :
            I_SHIFT         => value_shift    (1)  , -- Out :
            MATCH_REQ       => key_match_req       , -- In  :
            MATCH_CODE      => key_match_code      , -- In  :
            MATCH_OK        => key_match_ok   (1)  , -- Out :
            MATCH_NOT       => key_match_not  (1)  , -- Out :
            MATCH_SHIFT     => key_match_shift(1)  , -- Out :
            VALUE           => PARAM_B_VALUE       , -- Out :
            SIGN            => open                , -- Out :
            WE              => PARAM_B_WE            -- Out :
        );
end RTL;

    
