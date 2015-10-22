library ieee;
use     ieee.std_logic_1164.all;
library MsgPack;
use     MsgPack.MsgPack_RPC;
entity  PROC_KVMAP_GET_VALUE_SAMPLE is
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
        PARAM_A_VALUE   : in  std_logic_vector(31 downto 0);
        PARAM_B_VALUE   : in  std_logic_vector(63 downto 0);
        PARAM_C_VALUE   : in  std_logic_vector(31 downto 0);
        PARAM_C_ADDR    : out std_logic_vector( 3 downto 0)
    );
end  PROC_KVMAP_GET_VALUE_SAMPLE;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Get_Value;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Get_Integer;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Get_Integer_Array;
architecture RTL of PROC_KVMAP_GET_VALUE_SAMPLE is
    constant  STORE_SIZE        :  integer := 3;
    signal    key_match_req     :  std_logic_vector       (MATCH_PHASE-1 downto 0);
    signal    key_match_code    :  MsgPack_RPC.Code_Type;
    signal    key_match_ok      :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    key_match_not     :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    key_match_shift   :  MsgPack_RPC.Shift_Vector(STORE_SIZE-1 downto 0);
    signal    value_code        :  MsgPack_RPC.Code_Vector (STORE_SIZE-1 downto 0);
    signal    value_start       :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    value_valid       :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    value_last        :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    value_error       :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    value_done        :  std_logic_vector        (STORE_SIZE-1 downto 0);
    signal    value_ready       :  std_logic_vector        (STORE_SIZE-1 downto 0);
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MAIN: MsgPack_RPC_Server_KVMap_Get_Value         -- 
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
            VALUE_START     => value_start         , -- Out :
            VALUE_VALID     => value_valid         , -- In  :
            VALUE_CODE      => value_code          , -- In  :
            VALUE_LAST      => value_last          , -- In  :
            VALUE_ERROR     => value_error         , -- In  :
            VALUE_READY     => value_ready         , -- Out :
            RES_ID          => PROC_RES_ID         , -- Out :
            RES_CODE        => PROC_RES_CODE       , -- Out :
            RES_VALID       => PROC_RES_VALID      , -- Out :
            RES_LAST        => PROC_RES_LAST       , -- Out :
            RES_READY       => PROC_RES_READY        -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PARAM_A:  MsgPack_KVMap_Get_Integer              -- 
        generic map (                                -- 
            KEY             => STRING'("PARAM_A")  , --
            CODE_WIDTH      => MsgPack_RPC.Code_Length  , --
            MATCH_PHASE     => MATCH_PHASE         , --
            VALUE_BITS      => PARAM_A_VALUE'length, --
            VALUE_SIGN      => TRUE                  --
        )                                            -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- in  :
            CLR             => CLR                 , -- In  :
            START           => value_start    (0)  , -- In  :
            BUSY            => open                , -- Out :
            O_CODE          => value_code     (0)  , -- Out :
            O_LAST          => value_last     (0)  , -- Out :
            O_VALID         => value_valid    (0)  , -- Out :
            O_ERROR         => value_error    (0)  , -- Out :
            O_READY         => value_ready    (0)  , -- In  :
            MATCH_REQ       => key_match_req       , -- In  :
            MATCH_CODE      => key_match_code      , -- In  :
            MATCH_OK        => key_match_ok   (0)  , -- Out :
            MATCH_NOT       => key_match_not  (0)  , -- Out :
            MATCH_SHIFT     => key_match_shift(0)  , -- Out :
            I_VALUE         => PARAM_A_VALUE       , -- In  :
            I_VALID         => '1'                 , -- In  :
            I_READY         => open                  -- Out :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PARAM_B:  MsgPack_KVMap_Get_Integer              -- 
        generic map (                                -- 
            KEY             => STRING'("PARAM_B")  , --
            CODE_WIDTH      => MsgPack_RPC.Code_Length  , --
            MATCH_PHASE     => MATCH_PHASE         , --
            VALUE_BITS      => PARAM_B_VALUE'length, --
            VALUE_SIGN      => TRUE                  --
        )                                            -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- in  :
            CLR             => CLR                 , -- In  :
            START           => value_start    (1)  , -- In  :
            BUSY            => open                , -- Out :
            O_CODE          => value_code     (1)  , -- Out :
            O_LAST          => value_last     (1)  , -- Out :
            O_VALID         => value_valid    (1)  , -- Out :
            O_ERROR         => value_error    (1)  , -- Out :
            O_READY         => value_ready    (1)  , -- In  :
            MATCH_REQ       => key_match_req       , -- In  :
            MATCH_CODE      => key_match_code      , -- In  :
            MATCH_OK        => key_match_ok   (1)  , -- Out :
            MATCH_NOT       => key_match_not  (1)  , -- Out :
            MATCH_SHIFT     => key_match_shift(1)  , -- Out :
            I_VALUE         => PARAM_B_VALUE       , -- In  :
            I_VALID         => '1'                 , -- In  :
            I_READY         => open                  -- Out :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PARAM_C:  MsgPack_KVMap_Get_Integer_Array        -- 
        generic map (                                -- 
            KEY             => STRING'("PARAM_C")  , --
            CODE_WIDTH      => MsgPack_RPC.Code_Length  , --
            MATCH_PHASE     => MATCH_PHASE         , --
            ADDR_BITS       => PARAM_C_ADDR'length , --
            VALUE_BITS      => PARAM_C_VALUE'length, --
            VALUE_SIGN      => TRUE                  --
        )                                            -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- in  :
            CLR             => CLR                 , -- In  :
            START           => value_start    (2)  , -- In  :
            SIZE            => std_logic_vector(to_unsigned(2**PARAM_C_ADDR'length, 32)), 
            BUSY            => open                , -- Out :
            O_CODE          => value_code     (2)  , -- Out :
            O_LAST          => value_last     (2)  , -- Out :
            O_VALID         => value_valid    (2)  , -- Out :
            O_ERROR         => value_error    (2)  , -- Out :
            O_READY         => value_ready    (2)  , -- In  :
            MATCH_REQ       => key_match_req       , -- In  :
            MATCH_CODE      => key_match_code      , -- In  :
            MATCH_OK        => key_match_ok   (2)  , -- Out :
            MATCH_NOT       => key_match_not  (2)  , -- Out :
            MATCH_SHIFT     => key_match_shift(2)  , -- Out :
            I_VALUE         => PARAM_C_VALUE       , -- In  :
            I_ADDR          => PARAM_C_ADDR        , -- Out :
            I_VALID         => '1'                 , -- In  :
            I_READY         => open                  -- Out :
        );
end RTL;
