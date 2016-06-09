library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
entity  BinaryMemory_Interface is
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
        bin1_addr            : out std_logic_vector(12-1 downto 0);
        bin1_wdata           : out std_logic_vector(8-1 downto 0);
        bin1_wbe             : out std_logic_vector(1-1 downto 0);
        bin1_we              : out std_logic;
        bin1_rdata           : in  std_logic_vector(8-1 downto 0);
        bin2_addr            : out std_logic_vector(12-1 downto 0);
        bin2_wdata           : out std_logic_vector(16-1 downto 0);
        bin2_wbe             : out std_logic_vector(2-1 downto 0);
        bin2_we              : out std_logic;
        bin2_rdata           : in  std_logic_vector(16-1 downto 0);
        bin4_addr            : out std_logic_vector(12-1 downto 0);
        bin4_wdata           : out std_logic_vector(32-1 downto 0);
        bin4_wbe             : out std_logic_vector(4-1 downto 0);
        bin4_we              : out std_logic;
        bin4_rdata           : in  std_logic_vector(32-1 downto 0);
        bin8_addr            : out std_logic_vector(12-1 downto 0);
        bin8_wdata           : out std_logic_vector(64-1 downto 0);
        bin8_wbe             : out std_logic_vector(8-1 downto 0);
        bin8_we              : out std_logic;
        bin8_rdata           : in  std_logic_vector(64-1 downto 0);
        str4_addr            : out std_logic_vector(12-1 downto 0);
        str4_wdata           : out std_logic_vector(32-1 downto 0);
        str4_wbe             : out std_logic_vector(4-1 downto 0);
        str4_we              : out std_logic;
        str4_rdata           : in  std_logic_vector(32-1 downto 0)
    );
end     BinaryMemory_Interface;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Get_Value;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Set_Value;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Query_Binary_Array;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Store_Binary_Array;
architecture RTL of BinaryMemory_Interface is
    constant  PROC_NUM          :  integer := 2;
    signal    proc_match_req    :  std_logic_vector        (8-1 downto 0);
    signal    proc_match_code   :  MsgPack_RPC.Code_Type;
    signal    proc_match_ok     :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_match_not    :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_match_shift  :  MsgPack_RPC.Shift_Vector(PROC_NUM-1 downto 0);
    signal    proc_req_id       :  MsgPack_RPC.MsgID_Type;
    signal    proc_req          :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_busy         :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_param_code   :  MsgPack_RPC.Code_Vector (PROC_NUM-1 downto 0);
    signal    proc_param_valid  :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_param_last   :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_param_shift  :  MsgPack_RPC.Shift_Vector(PROC_NUM-1 downto 0);
    signal    proc_res_id       :  MsgPack_RPC.MsgID_Vector(PROC_NUM-1 downto 0);
    signal    proc_res_code     :  MsgPack_RPC.Code_Vector (PROC_NUM-1 downto 0);
    signal    proc_res_valid    :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_res_last     :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_res_ready    :  std_logic_vector        (PROC_NUM-1 downto 0);
    signal    proc_bin1_waddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_bin1_wready  :  std_logic;
    signal    proc_bin1_wstart  :  std_logic;
    signal    proc_bin1_wbusy   :  std_logic;
    signal    proc_bin1_raddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_bin1_rvalid  :  std_logic;
    signal    proc_bin1_rstart  :  std_logic;
    signal    proc_bin1_rbusy   :  std_logic;
    signal    proc_bin2_waddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_bin2_wready  :  std_logic;
    signal    proc_bin2_wstart  :  std_logic;
    signal    proc_bin2_wbusy   :  std_logic;
    signal    proc_bin2_raddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_bin2_rvalid  :  std_logic;
    signal    proc_bin2_rstart  :  std_logic;
    signal    proc_bin2_rbusy   :  std_logic;
    signal    proc_bin4_waddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_bin4_wready  :  std_logic;
    signal    proc_bin4_wstart  :  std_logic;
    signal    proc_bin4_wbusy   :  std_logic;
    signal    proc_bin4_raddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_bin4_rvalid  :  std_logic;
    signal    proc_bin4_rstart  :  std_logic;
    signal    proc_bin4_rbusy   :  std_logic;
    signal    proc_bin8_waddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_bin8_wready  :  std_logic;
    signal    proc_bin8_wstart  :  std_logic;
    signal    proc_bin8_wbusy   :  std_logic;
    signal    proc_bin8_raddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_bin8_rvalid  :  std_logic;
    signal    proc_bin8_rstart  :  std_logic;
    signal    proc_bin8_rbusy   :  std_logic;
    signal    proc_str4_waddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_str4_wready  :  std_logic;
    signal    proc_str4_wstart  :  std_logic;
    signal    proc_str4_wbusy   :  std_logic;
    signal    proc_str4_raddr   :  std_logic_vector(12-1 downto 0);
    signal    proc_str4_rvalid  :  std_logic;
    signal    proc_str4_rstart  :  std_logic;
    signal    proc_str4_rbusy   :  std_logic;
begin
    PROC_SERVER: MsgPack_RPC_Server                   -- 
        generic map (                                             -- 
            I_BYTES             => I_BYTES                      , --
            O_BYTES             => O_BYTES                      , --
            PROC_NUM            => PROC_NUM                     , --
            MATCH_PHASE         => 8                              --
        )                                                         -- 
        port map (                                                -- 
            CLK                 => CLK                          , -- In  :
            RST                 => RST                          , -- in  :
            CLR                 => CLR                          , -- in  :
            I_DATA              => I_DATA                       , -- In  :
            I_STRB              => I_STRB                       , -- In  :
            I_LAST              => I_LAST                       , -- In  :
            I_VALID             => I_VALID                      , -- In  :
            I_READY             => I_READY                      , -- Out :
            O_DATA              => O_DATA                       , -- Out :
            O_STRB              => O_STRB                       , -- Out :
            O_LAST              => O_LAST                       , -- Out :
            O_VALID             => O_VALID                      , -- Out :
            O_READY             => O_READY                      , -- In  :
            MATCH_REQ           => proc_match_req               , -- Out :
            MATCH_CODE          => proc_match_code              , -- Out :
            MATCH_OK            => proc_match_ok                , -- In  :
            MATCH_NOT           => proc_match_not               , -- In  :
            MATCH_SHIFT         => proc_match_shift             , -- In  :
            PROC_REQ_ID         => proc_req_id                  , -- Out :
            PROC_REQ            => proc_req                     , -- Out :
            PROC_BUSY           => proc_busy                    , -- In  :
            PARAM_VALID         => proc_param_valid             , -- Out :
            PARAM_CODE          => proc_param_code              , -- Out :
            PARAM_LAST          => proc_param_last              , -- Out :
            PARAM_SHIFT         => proc_param_shift             , -- In  :
            PROC_RES_ID         => proc_res_id                  , -- In  :
            PROC_RES_CODE       => proc_res_code                , -- In  :
            PROC_RES_VALID      => proc_res_valid               , -- In  :
            PROC_RES_LAST       => proc_res_last                , -- In  :
            PROC_RES_READY      => proc_res_ready                 -- Out :
        );                                                        -- 
    PROC_QUERY_VARIABLES: block
        constant  PROC_MAP_QUERY_SIZE   :  integer := 5;
        signal    proc_map_match_req    :  std_logic_vector        (8-1 downto 0);
        signal    proc_map_match_code   :  MsgPack_RPC.Code_Type;
        signal    proc_map_match_ok     :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_match_not    :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_match_shift  :  MsgPack_RPC.Shift_Vector(PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_param_code   :  MsgPack_RPC.Code_Type;
        signal    proc_map_param_last   :  std_logic;
        signal    proc_map_param_start  :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_param_valid  :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_param_error  :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_param_done   :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_param_shift  :  MsgPack_RPC.Shift_Vector(PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_value_code   :  MsgPack_RPC.Code_Vector (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_value_valid  :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_value_last   :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_value_error  :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
        signal    proc_map_value_ready  :  std_logic_vector        (PROC_MAP_QUERY_SIZE-1 downto 0);
    begin
        PROC_MAIN: MsgPack_RPC_Server_KVMap_Get_Value         -- 
            generic map (                                                 -- 
                NAME                    => STRING'("$GET")              , --
                STORE_SIZE              => PROC_MAP_QUERY_SIZE          , --
                MATCH_PHASE             => 8                              --
            )                                                             -- 
            port map (                                                    -- 
                CLK                     => CLK                          , -- In  :
                RST                     => RST                          , -- in  :
                CLR                     => CLR                          , -- in  :
                MATCH_REQ               => proc_match_req               , -- In  :
                MATCH_CODE              => proc_match_code              , -- In  :
                MATCH_OK                => proc_match_ok   (0)          , -- Out :
                MATCH_NOT               => proc_match_not  (0)          , -- Out :
                MATCH_SHIFT             => proc_match_shift(0)          , -- Out :
                PROC_REQ_ID             => proc_req_id                  , -- In  :
                PROC_REQ                => proc_req        (0)          , -- In  :
                PROC_BUSY               => proc_busy       (0)          , -- Out :
                PARAM_CODE              => proc_param_code (0)          , -- In  :
                PARAM_VALID             => proc_param_valid(0)          , -- In  :
                PARAM_LAST              => proc_param_last (0)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(0)          , -- Out :
                MAP_MATCH_REQ           => proc_map_match_req           , -- Out :
                MAP_MATCH_CODE          => proc_map_match_code          , -- Out :
                MAP_MATCH_OK            => proc_map_match_ok            , -- In  :
                MAP_MATCH_NOT           => proc_map_match_not           , -- In  :
                MAP_MATCH_SHIFT         => proc_map_match_shift         , -- In  :
                MAP_PARAM_START         => proc_map_param_start         , -- Out :
                MAP_PARAM_VALID         => proc_map_param_valid         , -- Out :
                MAP_PARAM_CODE          => proc_map_param_code          , -- Out :
                MAP_PARAM_LAST          => proc_map_param_last          , -- Out :
                MAP_PARAM_ERROR         => proc_map_param_error         , -- In  :
                MAP_PARAM_DONE          => proc_map_param_done          , -- In  :
                MAP_PARAM_SHIFT         => proc_map_param_shift         , -- In  :
                MAP_VALUE_VALID         => proc_map_value_valid         , -- In  :
                MAP_VALUE_CODE          => proc_map_value_code          , -- In  :
                MAP_VALUE_LAST          => proc_map_value_last          , -- In  :
                MAP_VALUE_ERROR         => proc_map_value_error         , -- In  :
                MAP_VALUE_READY         => proc_map_value_ready         , -- Out :
                RES_ID                  => proc_res_id     (0)          , -- Out :
                RES_CODE                => proc_res_code   (0)          , -- Out :
                RES_VALID               => proc_res_valid  (0)          , -- Out :
                RES_LAST                => proc_res_last   (0)          , -- Out :
                RES_READY               => proc_res_ready  (0)            -- In  :
            );                                                            -- 
        PROC_QUERY_BIN1 : MsgPack_KVMap_Query_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("bin1")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 8                            , --
                SIZE_BITS           => 32                           , --
                SIZE_MAX            => 4096                         , --
                ENCODE_BINARY       => TRUE                         , --
                ENCODE_STRING       => FALSE                          --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(0)      , -- In  :
                I_ERROR             => proc_map_param_error(0)      , -- Out :
                I_DONE              => proc_map_param_done (0)      , -- Out :
                I_SHIFT             => proc_map_param_shift(0)      , -- Out :
                O_CODE              => proc_map_value_code (0)      , -- Out :
                O_LAST              => proc_map_value_last (0)      , -- Out :
                O_VALID             => proc_map_value_valid(0)      , -- Out :
                O_ERROR             => proc_map_value_error(0)      , -- Out :
                O_READY             => proc_map_value_ready(0)      , -- In  :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (0)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (0)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(0)      , -- Out :
                START               => proc_bin1_rstart             , -- Out :
                BUSY                => proc_bin1_rbusy              , -- Out :
                ADDR                => proc_bin1_raddr              , -- Out :
                DATA                => bin1_rdata                   , -- In  :
                VALID               => proc_bin1_rvalid             , -- In  :
                READY               => open                           -- Out :
            );                                                        -- 
        PROC_QUERY_BIN2 : MsgPack_KVMap_Query_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("bin2")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 16                           , --
                SIZE_BITS           => 32                           , --
                SIZE_MAX            => 4096                         , --
                ENCODE_BINARY       => TRUE                         , --
                ENCODE_STRING       => FALSE                          --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(1)      , -- In  :
                I_ERROR             => proc_map_param_error(1)      , -- Out :
                I_DONE              => proc_map_param_done (1)      , -- Out :
                I_SHIFT             => proc_map_param_shift(1)      , -- Out :
                O_CODE              => proc_map_value_code (1)      , -- Out :
                O_LAST              => proc_map_value_last (1)      , -- Out :
                O_VALID             => proc_map_value_valid(1)      , -- Out :
                O_ERROR             => proc_map_value_error(1)      , -- Out :
                O_READY             => proc_map_value_ready(1)      , -- In  :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (1)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (1)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(1)      , -- Out :
                START               => proc_bin2_rstart             , -- Out :
                BUSY                => proc_bin2_rbusy              , -- Out :
                ADDR                => proc_bin2_raddr              , -- Out :
                DATA                => bin2_rdata                   , -- In  :
                VALID               => proc_bin2_rvalid             , -- In  :
                READY               => open                           -- Out :
            );                                                        -- 
        PROC_QUERY_BIN4 : MsgPack_KVMap_Query_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("bin4")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 32                           , --
                SIZE_BITS           => 32                           , --
                SIZE_MAX            => 4096                         , --
                ENCODE_BINARY       => TRUE                         , --
                ENCODE_STRING       => FALSE                          --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(2)      , -- In  :
                I_ERROR             => proc_map_param_error(2)      , -- Out :
                I_DONE              => proc_map_param_done (2)      , -- Out :
                I_SHIFT             => proc_map_param_shift(2)      , -- Out :
                O_CODE              => proc_map_value_code (2)      , -- Out :
                O_LAST              => proc_map_value_last (2)      , -- Out :
                O_VALID             => proc_map_value_valid(2)      , -- Out :
                O_ERROR             => proc_map_value_error(2)      , -- Out :
                O_READY             => proc_map_value_ready(2)      , -- In  :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (2)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (2)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(2)      , -- Out :
                START               => proc_bin4_rstart             , -- Out :
                BUSY                => proc_bin4_rbusy              , -- Out :
                ADDR                => proc_bin4_raddr              , -- Out :
                DATA                => bin4_rdata                   , -- In  :
                VALID               => proc_bin4_rvalid             , -- In  :
                READY               => open                           -- Out :
            );                                                        -- 
        PROC_QUERY_BIN8 : MsgPack_KVMap_Query_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("bin8")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 64                           , --
                SIZE_BITS           => 32                           , --
                SIZE_MAX            => 4096                         , --
                ENCODE_BINARY       => TRUE                         , --
                ENCODE_STRING       => FALSE                          --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(3)      , -- In  :
                I_ERROR             => proc_map_param_error(3)      , -- Out :
                I_DONE              => proc_map_param_done (3)      , -- Out :
                I_SHIFT             => proc_map_param_shift(3)      , -- Out :
                O_CODE              => proc_map_value_code (3)      , -- Out :
                O_LAST              => proc_map_value_last (3)      , -- Out :
                O_VALID             => proc_map_value_valid(3)      , -- Out :
                O_ERROR             => proc_map_value_error(3)      , -- Out :
                O_READY             => proc_map_value_ready(3)      , -- In  :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (3)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (3)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(3)      , -- Out :
                START               => proc_bin8_rstart             , -- Out :
                BUSY                => proc_bin8_rbusy              , -- Out :
                ADDR                => proc_bin8_raddr              , -- Out :
                DATA                => bin8_rdata                   , -- In  :
                VALID               => proc_bin8_rvalid             , -- In  :
                READY               => open                           -- Out :
            );                                                        -- 
        PROC_QUERY_STR4 : MsgPack_KVMap_Query_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("str4")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 32                           , --
                SIZE_BITS           => 32                           , --
                SIZE_MAX            => 4096                         , --
                ENCODE_BINARY       => FALSE                        , --
                ENCODE_STRING       => TRUE                           --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(4)      , -- In  :
                I_ERROR             => proc_map_param_error(4)      , -- Out :
                I_DONE              => proc_map_param_done (4)      , -- Out :
                I_SHIFT             => proc_map_param_shift(4)      , -- Out :
                O_CODE              => proc_map_value_code (4)      , -- Out :
                O_LAST              => proc_map_value_last (4)      , -- Out :
                O_VALID             => proc_map_value_valid(4)      , -- Out :
                O_ERROR             => proc_map_value_error(4)      , -- Out :
                O_READY             => proc_map_value_ready(4)      , -- In  :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (4)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (4)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(4)      , -- Out :
                START               => proc_str4_rstart             , -- Out :
                BUSY                => proc_str4_rbusy              , -- Out :
                ADDR                => proc_str4_raddr              , -- Out :
                DATA                => str4_rdata                   , -- In  :
                VALID               => proc_str4_rvalid             , -- In  :
                READY               => open                           -- Out :
            );                                                        -- 
    end block;
    PROC_STORE_VARIABLES: block
        constant  PROC_MAP_STORE_SIZE   :  integer := 5;
        signal    proc_map_match_req    :  std_logic_vector        (8-1 downto 0);
        signal    proc_map_match_code   :  MsgPack_RPC.Code_Type;
        signal    proc_map_match_ok     :  std_logic_vector        (PROC_MAP_STORE_SIZE-1 downto 0);
        signal    proc_map_match_not    :  std_logic_vector        (PROC_MAP_STORE_SIZE-1 downto 0);
        signal    proc_map_match_shift  :  MsgPack_RPC.Shift_Vector(PROC_MAP_STORE_SIZE-1 downto 0);
        signal    proc_map_param_code   :  MsgPack_RPC.Code_Type;
        signal    proc_map_param_valid  :  std_logic_vector        (PROC_MAP_STORE_SIZE-1 downto 0);
        signal    proc_map_param_last   :  std_logic;
        signal    proc_map_param_error  :  std_logic_vector        (PROC_MAP_STORE_SIZE-1 downto 0);
        signal    proc_map_param_done   :  std_logic_vector        (PROC_MAP_STORE_SIZE-1 downto 0);
        signal    proc_map_param_shift  :  MsgPack_RPC.Shift_Vector(PROC_MAP_STORE_SIZE-1 downto 0);
    begin
        PROC_MAIN: MsgPack_RPC_Server_KVMap_Set_Value         -- 
            generic map (                                                 -- 
                NAME                    => STRING'("$SET")              , --
                STORE_SIZE              => PROC_MAP_STORE_SIZE          , --
                MATCH_PHASE             => 8                              --
            )                                                             -- 
            port map (                                                    -- 
                CLK                     => CLK                          , -- In  :
                RST                     => RST                          , -- in  :
                CLR                     => CLR                          , -- in  :
                MATCH_REQ               => proc_match_req               , -- In  :
                MATCH_CODE              => proc_match_code              , -- In  :
                MATCH_OK                => proc_match_ok   (1)          , -- Out :
                MATCH_NOT               => proc_match_not  (1)          , -- Out :
                MATCH_SHIFT             => proc_match_shift(1)          , -- Out :
                PROC_REQ_ID             => proc_req_id                  , -- In  :
                PROC_REQ                => proc_req        (1)          , -- In  :
                PROC_BUSY               => proc_busy       (1)          , -- Out :
                PARAM_CODE              => proc_param_code (1)          , -- In  :
                PARAM_VALID             => proc_param_valid(1)          , -- In  :
                PARAM_LAST              => proc_param_last (1)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(1)          , -- Out :
                MAP_MATCH_REQ           => proc_map_match_req           , -- Out :
                MAP_MATCH_CODE          => proc_map_match_code          , -- Out :
                MAP_MATCH_OK            => proc_map_match_ok            , -- In  :
                MAP_MATCH_NOT           => proc_map_match_not           , -- In  :
                MAP_MATCH_SHIFT         => proc_map_match_shift         , -- In  :
                MAP_VALUE_VALID         => proc_map_param_valid         , -- Out :
                MAP_VALUE_CODE          => proc_map_param_code          , -- Out :
                MAP_VALUE_LAST          => proc_map_param_last          , -- Out :
                MAP_VALUE_ERROR         => proc_map_param_error         , -- In  :
                MAP_VALUE_DONE          => proc_map_param_done          , -- In  :
                MAP_VALUE_SHIFT         => proc_map_param_shift         , -- In  :
                RES_ID                  => proc_res_id     (1)          , -- Out :
                RES_CODE                => proc_res_code   (1)          , -- Out :
                RES_VALID               => proc_res_valid  (1)          , -- Out :
                RES_LAST                => proc_res_last   (1)          , -- Out :
                RES_READY               => proc_res_ready  (1)            -- In  :
            );                                                            -- 
        PROC_STORE_BIN1 : MsgPack_KVMap_Store_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("bin1")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 8                            , --
                DECODE_BINARY       => TRUE                         , --
                DECODE_STRING       => FALSE                          --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(0)      , -- In  :
                I_ERROR             => proc_map_param_error(0)      , -- Out :
                I_DONE              => proc_map_param_done (0)      , -- Out :
                I_SHIFT             => proc_map_param_shift(0)      , -- Out :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (0)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (0)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(0)      , -- Out :
                START               => proc_bin1_wstart             , -- Out :
                BUSY                => proc_bin1_wbusy              , -- Out :
                ADDR                => proc_bin1_waddr              , -- Out :
                DATA                => bin1_wdata                   , -- Out :
                STRB                => bin1_wbe                     , -- Out :
                LAST                => open                         , -- Out :
                VALID               => bin1_we                      , -- Out :
                READY               => proc_bin1_wready               -- In  :
            );                                                        -- 
        PROC_STORE_BIN2 : MsgPack_KVMap_Store_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("bin2")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 16                           , --
                DECODE_BINARY       => TRUE                         , --
                DECODE_STRING       => FALSE                          --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(1)      , -- In  :
                I_ERROR             => proc_map_param_error(1)      , -- Out :
                I_DONE              => proc_map_param_done (1)      , -- Out :
                I_SHIFT             => proc_map_param_shift(1)      , -- Out :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (1)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (1)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(1)      , -- Out :
                START               => proc_bin2_wstart             , -- Out :
                BUSY                => proc_bin2_wbusy              , -- Out :
                ADDR                => proc_bin2_waddr              , -- Out :
                DATA                => bin2_wdata                   , -- Out :
                STRB                => bin2_wbe                     , -- Out :
                LAST                => open                         , -- Out :
                VALID               => bin2_we                      , -- Out :
                READY               => proc_bin2_wready               -- In  :
            );                                                        -- 
        PROC_STORE_BIN4 : MsgPack_KVMap_Store_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("bin4")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 32                           , --
                DECODE_BINARY       => TRUE                         , --
                DECODE_STRING       => FALSE                          --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(2)      , -- In  :
                I_ERROR             => proc_map_param_error(2)      , -- Out :
                I_DONE              => proc_map_param_done (2)      , -- Out :
                I_SHIFT             => proc_map_param_shift(2)      , -- Out :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (2)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (2)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(2)      , -- Out :
                START               => proc_bin4_wstart             , -- Out :
                BUSY                => proc_bin4_wbusy              , -- Out :
                ADDR                => proc_bin4_waddr              , -- Out :
                DATA                => bin4_wdata                   , -- Out :
                STRB                => bin4_wbe                     , -- Out :
                LAST                => open                         , -- Out :
                VALID               => bin4_we                      , -- Out :
                READY               => proc_bin4_wready               -- In  :
            );                                                        -- 
        PROC_STORE_BIN8 : MsgPack_KVMap_Store_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("bin8")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 64                           , --
                DECODE_BINARY       => TRUE                         , --
                DECODE_STRING       => FALSE                          --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(3)      , -- In  :
                I_ERROR             => proc_map_param_error(3)      , -- Out :
                I_DONE              => proc_map_param_done (3)      , -- Out :
                I_SHIFT             => proc_map_param_shift(3)      , -- Out :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (3)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (3)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(3)      , -- Out :
                START               => proc_bin8_wstart             , -- Out :
                BUSY                => proc_bin8_wbusy              , -- Out :
                ADDR                => proc_bin8_waddr              , -- Out :
                DATA                => bin8_wdata                   , -- Out :
                STRB                => bin8_wbe                     , -- Out :
                LAST                => open                         , -- Out :
                VALID               => bin8_we                      , -- Out :
                READY               => proc_bin8_wready               -- In  :
            );                                                        -- 
        PROC_STORE_STR4 : MsgPack_KVMap_Store_Binary_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("str4")              , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                ADDR_BITS           => 12                           , --
                DATA_BITS           => 32                           , --
                DECODE_BINARY       => FALSE                        , --
                DECODE_STRING       => TRUE                           --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                I_CODE              => proc_map_param_code          , -- In  :
                I_LAST              => proc_map_param_last          , -- In  :
                I_VALID             => proc_map_param_valid(4)      , -- In  :
                I_ERROR             => proc_map_param_error(4)      , -- Out :
                I_DONE              => proc_map_param_done (4)      , -- Out :
                I_SHIFT             => proc_map_param_shift(4)      , -- Out :
                MATCH_REQ           => proc_map_match_req           , -- In  :
                MATCH_CODE          => proc_map_match_code          , -- In  :
                MATCH_OK            => proc_map_match_ok   (4)      , -- Out :
                MATCH_NOT           => proc_map_match_not  (4)      , -- Out :
                MATCH_SHIFT         => proc_map_match_shift(4)      , -- Out :
                START               => proc_str4_wstart             , -- Out :
                BUSY                => proc_str4_wbusy              , -- Out :
                ADDR                => proc_str4_waddr              , -- Out :
                DATA                => str4_wdata                   , -- Out :
                STRB                => str4_wbe                     , -- Out :
                LAST                => open                         , -- Out :
                VALID               => str4_we                      , -- Out :
                READY               => proc_str4_wready               -- In  :
            );                                                        -- 
    end block;
    PROC_ARB_BIN1 : block
        signal   proc_arb_state :  std_logic_vector(1 downto 0);
    begin
         process(CLK, RST) begin
             if (RST = '1') then
                     proc_arb_state <= (others => '0');
             elsif (CLK'event and CLK = '1') then
                 if    (CLR = '1') then
                     proc_arb_state <= (others => '0');
                 else
                     case proc_arb_state is
                         when "00" => 
                             if    (proc_bin1_wstart = '1') then
                                 proc_arb_state <= "01";
                             elsif (proc_bin1_rstart = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "01" =>
                             if    (proc_bin1_wbusy = '1') then
                                 proc_arb_state <= "01";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "10" =>
                             if    (proc_bin1_rbusy = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when others => 
                                 proc_arb_state <= "00";
                     end case;
                 end if;
             end if;
         end process;
         proc_bin1_wready <= proc_arb_state(0);
         proc_bin1_rvalid <= proc_arb_state(1);
         bin1_addr <= proc_bin1_waddr when (proc_arb_state(0) = '1') else proc_bin1_raddr;
    end block;
    PROC_ARB_BIN2 : block
        signal   proc_arb_state :  std_logic_vector(1 downto 0);
    begin
         process(CLK, RST) begin
             if (RST = '1') then
                     proc_arb_state <= (others => '0');
             elsif (CLK'event and CLK = '1') then
                 if    (CLR = '1') then
                     proc_arb_state <= (others => '0');
                 else
                     case proc_arb_state is
                         when "00" => 
                             if    (proc_bin2_wstart = '1') then
                                 proc_arb_state <= "01";
                             elsif (proc_bin2_rstart = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "01" =>
                             if    (proc_bin2_wbusy = '1') then
                                 proc_arb_state <= "01";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "10" =>
                             if    (proc_bin2_rbusy = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when others => 
                                 proc_arb_state <= "00";
                     end case;
                 end if;
             end if;
         end process;
         proc_bin2_wready <= proc_arb_state(0);
         proc_bin2_rvalid <= proc_arb_state(1);
         bin2_addr <= proc_bin2_waddr when (proc_arb_state(0) = '1') else proc_bin2_raddr;
    end block;
    PROC_ARB_BIN4 : block
        signal   proc_arb_state :  std_logic_vector(1 downto 0);
    begin
         process(CLK, RST) begin
             if (RST = '1') then
                     proc_arb_state <= (others => '0');
             elsif (CLK'event and CLK = '1') then
                 if    (CLR = '1') then
                     proc_arb_state <= (others => '0');
                 else
                     case proc_arb_state is
                         when "00" => 
                             if    (proc_bin4_wstart = '1') then
                                 proc_arb_state <= "01";
                             elsif (proc_bin4_rstart = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "01" =>
                             if    (proc_bin4_wbusy = '1') then
                                 proc_arb_state <= "01";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "10" =>
                             if    (proc_bin4_rbusy = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when others => 
                                 proc_arb_state <= "00";
                     end case;
                 end if;
             end if;
         end process;
         proc_bin4_wready <= proc_arb_state(0);
         proc_bin4_rvalid <= proc_arb_state(1);
         bin4_addr <= proc_bin4_waddr when (proc_arb_state(0) = '1') else proc_bin4_raddr;
    end block;
    PROC_ARB_BIN8 : block
        signal   proc_arb_state :  std_logic_vector(1 downto 0);
    begin
         process(CLK, RST) begin
             if (RST = '1') then
                     proc_arb_state <= (others => '0');
             elsif (CLK'event and CLK = '1') then
                 if    (CLR = '1') then
                     proc_arb_state <= (others => '0');
                 else
                     case proc_arb_state is
                         when "00" => 
                             if    (proc_bin8_wstart = '1') then
                                 proc_arb_state <= "01";
                             elsif (proc_bin8_rstart = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "01" =>
                             if    (proc_bin8_wbusy = '1') then
                                 proc_arb_state <= "01";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "10" =>
                             if    (proc_bin8_rbusy = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when others => 
                                 proc_arb_state <= "00";
                     end case;
                 end if;
             end if;
         end process;
         proc_bin8_wready <= proc_arb_state(0);
         proc_bin8_rvalid <= proc_arb_state(1);
         bin8_addr <= proc_bin8_waddr when (proc_arb_state(0) = '1') else proc_bin8_raddr;
    end block;
    PROC_ARB_STR4 : block
        signal   proc_arb_state :  std_logic_vector(1 downto 0);
    begin
         process(CLK, RST) begin
             if (RST = '1') then
                     proc_arb_state <= (others => '0');
             elsif (CLK'event and CLK = '1') then
                 if    (CLR = '1') then
                     proc_arb_state <= (others => '0');
                 else
                     case proc_arb_state is
                         when "00" => 
                             if    (proc_str4_wstart = '1') then
                                 proc_arb_state <= "01";
                             elsif (proc_str4_rstart = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "01" =>
                             if    (proc_str4_wbusy = '1') then
                                 proc_arb_state <= "01";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "10" =>
                             if    (proc_str4_rbusy = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when others => 
                                 proc_arb_state <= "00";
                     end case;
                 end if;
             end if;
         end process;
         proc_str4_wready <= proc_arb_state(0);
         proc_str4_rvalid <= proc_arb_state(1);
         str4_addr <= proc_str4_waddr when (proc_arb_state(0) = '1') else proc_str4_raddr;
    end block;
end RTL;
