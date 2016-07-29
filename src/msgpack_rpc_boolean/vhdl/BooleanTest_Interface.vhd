library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
entity  BooleanTest_Interface is
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
        control_REQ          : out std_logic;
        control_BUSY         : in  std_logic;
        control_DONE         : in  std_logic;
        control_status       : out boolean;
        control_return       : in  boolean;
        status_wdata         : out boolean;
        status_we            : out std_logic;
        status_rdata         : in  boolean;
        stream1_wdata        : out std_logic_vector(1-1 downto 0);
        stream1_wstrb        : out std_logic_vector(1-1 downto 0);
        stream1_wlast        : out std_logic;
        stream1_wvalid       : out std_logic;
        stream1_wready       : in  std_logic;
        stream1_rdata        : in  std_logic_vector(1-1 downto 0);
        stream1_rstrb        : in  std_logic_vector(1-1 downto 0);
        stream1_rlast        : in  std_logic;
        stream1_rvalid       : in  std_logic;
        stream1_rready       : out std_logic;
        stream4_wdata        : out std_logic_vector(4-1 downto 0);
        stream4_wstrb        : out std_logic_vector(4-1 downto 0);
        stream4_wlast        : out std_logic;
        stream4_wvalid       : out std_logic;
        stream4_wready       : in  std_logic;
        stream4_rdata        : in  std_logic_vector(4-1 downto 0);
        stream4_rstrb        : in  std_logic_vector(4-1 downto 0);
        stream4_rlast        : in  std_logic;
        stream4_rvalid       : in  std_logic;
        stream4_rready       : out std_logic;
        memory1_waddr        : out std_logic_vector(12-1 downto 0);
        memory1_wdata        : out std_logic_vector(1-1 downto 0);
        memory1_strb         : out std_logic_vector(1-1 downto 0);
        memory1_we           : out std_logic;
        memory1_raddr        : out std_logic_vector(12-1 downto 0);
        memory1_rdata        : in  std_logic_vector(1-1 downto 0);
        memory4_waddr        : out std_logic_vector(12-1 downto 0);
        memory4_wdata        : out std_logic_vector(4-1 downto 0);
        memory4_strb         : out std_logic_vector(4-1 downto 0);
        memory4_we           : out std_logic;
        memory4_raddr        : out std_logic_vector(12-1 downto 0);
        memory4_rdata        : in  std_logic_vector(4-1 downto 0)
    );
end     BooleanTest_Interface;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Main_with_Param;
use     MsgPack.MsgPack_Object_Components.MsgPack_Object_Store_Boolean_Register;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Return_Integer;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Get_Value;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Set_Value;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Query_Boolean_Register;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Store_Boolean_Register;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Query_Boolean_Stream;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Store_Boolean_Stream;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Query_Boolean_Array;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Store_Boolean_Array;
architecture RTL of BooleanTest_Interface is
    constant  PROC_NUM          :  integer := 3;
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
    PROC_CONTROL: block
        constant  PROC_PARAM_NUM        :  integer := 1;
        signal    proc_set_param_code   :  MsgPack_RPC.Code_Type;
        signal    proc_set_param_last   :  std_logic;
        signal    proc_set_param_valid  :  std_logic_vector        (PROC_PARAM_NUM-1 downto 0);
        signal    proc_set_param_error  :  std_logic_vector        (PROC_PARAM_NUM-1 downto 0);
        signal    proc_set_param_done   :  std_logic_vector        (PROC_PARAM_NUM-1 downto 0);
        signal    proc_set_param_shift  :  MsgPack_RPC.Shift_Vector(PROC_PARAM_NUM-1 downto 0);
        signal    proc_return_start     :  std_logic;
        signal    proc_return_error     :  std_logic;
        signal    proc_return_done      :  std_logic;
        signal    proc_return_busy      :  std_logic;
        signal    proc_start            :  std_logic;
    begin
        PROC_MAIN: MsgPack_RPC_Method_Main_with_Param         -- 
            generic map (                                                 -- 
                NAME                    => STRING'("control")           , --
                PARAM_NUM               => PROC_PARAM_NUM               , --
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
                PROC_START              => proc_start                   , -- Out :
                PARAM_CODE              => proc_param_code (0)          , -- In  :
                PARAM_VALID             => proc_param_valid(0)          , -- In  :
                PARAM_LAST              => proc_param_last (0)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(0)          , -- Out :
                SET_PARAM_CODE          => proc_set_param_code          , -- Out :
                SET_PARAM_LAST          => proc_set_param_last          , -- Out :
                SET_PARAM_VALID         => proc_set_param_valid         , -- Out :
                SET_PARAM_ERROR         => proc_set_param_error         , -- In  :
                SET_PARAM_DONE          => proc_set_param_done          , -- In  :
                SET_PARAM_SHIFT         => proc_set_param_shift         , -- In  :
                RUN_REQ                 => control_REQ                  , -- Out :
                RUN_ACK                 => control_BUSY                 , -- In  :
                RUN_BUSY                => control_BUSY                 , -- In  :
                RUN_DONE                => control_DONE                 , -- In  :
                RUNNING                 => open                         , -- Out :
                RET_ID                  => proc_res_id     (0)          , -- Out :
                RET_START               => proc_return_start            , -- Out :
                RET_DONE                => proc_return_done             , -- Out :
                RET_ERROR               => proc_return_error            , -- Out :
                RET_BUSY                => proc_return_busy               -- In  :
            );                                                            -- 
        PROC_0_STATUS: block
            signal    proc_0_value :  std_logic_vector(1-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         control_status <= FALSE;
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         control_status <= FALSE;
                    elsif (proc_0_valid = '1') then
                         control_status <= (proc_0_value(0) = '1');
                    end if;
                end if;
            end process;
            PROC_STORE_STATUS : MsgPack_Object_Store_Boolean_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length        --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    I_CODE              => proc_set_param_code          , -- In  :
                    I_LAST              => proc_set_param_last          , -- In  :
                    I_VALID             => proc_set_param_valid(0)      , -- In  :
                    I_ERROR             => proc_set_param_error(0)      , -- Out :
                    I_DONE              => proc_set_param_done (0)      , -- Out :
                    I_SHIFT             => proc_set_param_shift(0)      , -- Out :
                    VALUE               => proc_0_value(0)              , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_RETURN : block
            signal proc_return_value : std_logic_vector(0 downto 0);
        begin
            RET: MsgPack_RPC_Method_Return_Integer  -- 
                generic map (                                                 -- 
                    VALUE_WIDTH             => 1                            , --
                    RETURN_UINT             => FALSE                        , --
                    RETURN_INT              => FALSE                        , --
                    RETURN_FLOAT            => FALSE                        , --
                    RETURN_BOOLEAN          => TRUE                           --
                )                                                             -- 
                port map (                                                    -- 
                    CLK                     => CLK                          , -- In  :
                    RST                     => RST                          , -- in  :
                    CLR                     => CLR                          , -- in  :
                    RET_ERROR               => proc_return_error            , -- In  :
                    RET_START               => proc_return_start            , -- In  :
                    RET_DONE                => proc_return_done             , -- In  :
                    RET_BUSY                => proc_return_busy             , -- Out :
                    RES_CODE                => proc_res_code   (0)          , -- Out :
                    RES_VALID               => proc_res_valid  (0)          , -- Out :
                    RES_LAST                => proc_res_last   (0)          , -- Out :
                    RES_READY               => proc_res_ready  (0)          , -- In  :
                    VALUE                   => proc_return_value              -- In  :
                );
            proc_return_value <= (others => '1') when control_return else (others => '0');
        end block;
    end block;
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
                RES_ID                  => proc_res_id     (1)          , -- Out :
                RES_CODE                => proc_res_code   (1)          , -- Out :
                RES_VALID               => proc_res_valid  (1)          , -- Out :
                RES_LAST                => proc_res_last   (1)          , -- Out :
                RES_READY               => proc_res_ready  (1)            -- In  :
            );                                                            -- 
        PROC_QUERY_STATUS: block
            signal    proc_1_data          :  std_logic_vector(0 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Boolean_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("status")            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                              --
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
                    VALUE               => proc_1_data(0)               , -- In  :
                    VALID               => '1'                          , -- In  :
                    READY               => open                           -- Out :
                );                                                        -- 
            proc_1_data <= (others => '1') when status_rdata else (others => '0');
        end block;
        PROC_QUERY_STREAM1 : MsgPack_KVMap_Query_Boolean_Stream   -- 
            generic map (                                             -- 
                KEY                 => STRING'("stream1")           , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                DATA_BITS           => 1                            , --
                SIZE_BITS           => 13                             --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                DEFAULT_SIZE        => "1000000000000"              , -- In  :
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
                START               => open                         , -- Out :
                BUSY                => open                         , -- Out :
                SIZE                => open                         , -- In  :
                DATA                => stream1_rdata                , -- In  :
                STRB                => stream1_rstrb                , -- In  :
                LAST                => stream1_rlast                , -- In  :
                VALID               => stream1_rvalid               , -- In  :
                READY               => stream1_rready                 -- Out :
            );                                                        -- 
        PROC_QUERY_STREAM4 : MsgPack_KVMap_Query_Boolean_Stream   -- 
            generic map (                                             -- 
                KEY                 => STRING'("stream4")           , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                DATA_BITS           => 4                            , --
                SIZE_BITS           => 13                             --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                DEFAULT_SIZE        => "1000000000000"              , -- In  :
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
                START               => open                         , -- Out :
                BUSY                => open                         , -- Out :
                SIZE                => open                         , -- In  :
                DATA                => stream4_rdata                , -- In  :
                STRB                => stream4_rstrb                , -- In  :
                LAST                => stream4_rlast                , -- In  :
                VALID               => stream4_rvalid               , -- In  :
                READY               => stream4_rready                 -- Out :
            );                                                        -- 
        PROC_QUERY_MEMORY1 : MsgPack_KVMap_Query_Boolean_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("memory1")           , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                MATCH_PHASE         => 8                            , --
                DATA_BITS           => 1                            , --
                ADDR_BITS           => 12                           , --
                SIZE_BITS           => 13                             --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                DEFAULT_SIZE        => "1000000000000"              , -- In  :
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
                START               => open                         , -- Out :
                BUSY                => open                         , -- Out :
                ADDR                => memory1_raddr                , -- Out :
                SIZE                => open                         , -- Out :
                DATA                => memory1_rdata                , -- In  :
                VALID               => '1'                          , -- In  :
                READY               => open                           -- Out :
            );                                                        -- 
        PROC_QUERY_MEMORY4 : MsgPack_KVMap_Query_Boolean_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("memory4")           , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                MATCH_PHASE         => 8                            , --
                DATA_BITS           => 4                            , --
                ADDR_BITS           => 12                           , --
                SIZE_BITS           => 13                             --
            )                                                         -- 
            port map (                                                -- 
                CLK                 => CLK                          , -- In  :
                RST                 => RST                          , -- in  :
                CLR                 => CLR                          , -- in  :
                DEFAULT_SIZE        => "1000000000000"              , -- In  :
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
                START               => open                         , -- Out :
                BUSY                => open                         , -- Out :
                ADDR                => memory4_raddr                , -- Out :
                SIZE                => open                         , -- Out :
                DATA                => memory4_rdata                , -- In  :
                VALID               => '1'                          , -- In  :
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
                MATCH_OK                => proc_match_ok   (2)          , -- Out :
                MATCH_NOT               => proc_match_not  (2)          , -- Out :
                MATCH_SHIFT             => proc_match_shift(2)          , -- Out :
                PROC_REQ_ID             => proc_req_id                  , -- In  :
                PROC_REQ                => proc_req        (2)          , -- In  :
                PROC_BUSY               => proc_busy       (2)          , -- Out :
                PARAM_CODE              => proc_param_code (2)          , -- In  :
                PARAM_VALID             => proc_param_valid(2)          , -- In  :
                PARAM_LAST              => proc_param_last (2)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(2)          , -- Out :
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
                RES_ID                  => proc_res_id     (2)          , -- Out :
                RES_CODE                => proc_res_code   (2)          , -- Out :
                RES_VALID               => proc_res_valid  (2)          , -- Out :
                RES_LAST                => proc_res_last   (2)          , -- Out :
                RES_READY               => proc_res_ready  (2)            -- In  :
            );                                                            -- 
        PROC_STORE_STATUS: block
            signal    proc_0_data      :  std_logic_vector(0 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Boolean_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("status")            , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length        --
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
                    VALUE               => proc_0_data(0)               , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => status_we                    , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
            status_wdata <= (proc_0_data(0) = '1');
        end block;
        PROC_STORE_STREAM1 : MsgPack_KVMap_Store_Boolean_Stream   -- 
            generic map (                                             -- 
                KEY                 => STRING'("stream1")           , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                DATA_BITS           => 1                            , --
                SIZE_BITS           => 13                             --
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
                START               => open                         , -- Out :
                BUSY                => open                         , -- Out :
                SIZE                => open                         , -- Out :
                DATA                => stream1_wdata                , -- Out :
                STRB                => stream1_wstrb                , -- Out :
                LAST                => stream1_wlast                , -- Out :
                VALID               => stream1_wvalid               , -- Out :
                READY               => stream1_wready                 -- In  :
            );                                                        -- 
        PROC_STORE_STREAM4 : MsgPack_KVMap_Store_Boolean_Stream   -- 
            generic map (                                             -- 
                KEY                 => STRING'("stream4")           , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                DATA_BITS           => 4                            , --
                SIZE_BITS           => 13                             --
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
                START               => open                         , -- Out :
                BUSY                => open                         , -- Out :
                SIZE                => open                         , -- Out :
                DATA                => stream4_wdata                , -- Out :
                STRB                => stream4_wstrb                , -- Out :
                LAST                => stream4_wlast                , -- Out :
                VALID               => stream4_wvalid               , -- Out :
                READY               => stream4_wready                 -- In  :
            );                                                        -- 
        PROC_STORE_MEMORY1 : MsgPack_KVMap_Store_Boolean_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("memory1")           , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                DATA_BITS           => 1                            , --
                ADDR_BITS           => 12                           , --
                SIZE_BITS           => 13                             --
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
                START               => open                         , -- Out :
                BUSY                => open                         , -- Out :
                SIZE                => open                         , -- Out :
                ADDR                => memory1_waddr                , -- Out :
                DATA                => memory1_wdata                , -- Out :
                STRB                => memory1_strb                 , -- Out :
                LAST                => open                         , -- Out :
                VALID               => memory1_we                   , -- Out :
                READY               => '1'                            -- In  :
            );                                                        -- 
        PROC_STORE_MEMORY4 : MsgPack_KVMap_Store_Boolean_Array   -- 
            generic map (                                             -- 
                KEY                 => STRING'("memory4")           , --
                MATCH_PHASE         => 8                            , --
                CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                DATA_BITS           => 4                            , --
                ADDR_BITS           => 12                           , --
                SIZE_BITS           => 13                             --
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
                START               => open                         , -- Out :
                BUSY                => open                         , -- Out :
                SIZE                => open                         , -- Out :
                ADDR                => memory4_waddr                , -- Out :
                DATA                => memory4_wdata                , -- Out :
                STRB                => memory4_strb                 , -- Out :
                LAST                => open                         , -- Out :
                VALID               => memory4_we                   , -- Out :
                READY               => '1'                            -- In  :
            );                                                        -- 
    end block;
end RTL;
