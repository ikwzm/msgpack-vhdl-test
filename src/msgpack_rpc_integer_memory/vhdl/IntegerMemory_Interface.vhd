library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
entity  IntegerMemory_Interface is
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
        data_address         : out unsigned(32-1 downto 0);
        data_din             : out signed(32-1 downto 0);
        data_we              : out std_logic;
        data_dout            : in  signed(32-1 downto 0)
    );
end     IntegerMemory_Interface;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Get_Value;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Set_Value;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Query_Integer_Array;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Store_Integer_Array;
architecture RTL of IntegerMemory_Interface is
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
    signal    proc_data_waddr   :  unsigned(32-1 downto 0);
    signal    proc_data_wready  :  std_logic;
    signal    proc_data_wstart  :  std_logic;
    signal    proc_data_wbusy   :  std_logic;
    signal    proc_data_raddr   :  unsigned(32-1 downto 0);
    signal    proc_data_rvalid  :  std_logic;
    signal    proc_data_rstart  :  std_logic;
    signal    proc_data_rbusy   :  std_logic;
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
        constant  PROC_MAP_QUERY_SIZE   :  integer := 1;
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
        PROC_QUERY_DATA: block
            signal    proc_1_data      :  std_logic_vector(31 downto 0);
            signal    proc_1_addr      :  std_logic_vector(31 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("data")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    ADDR_BITS           => 32                           , --
                    VALUE_BITS          => 32                           , --
                    VALUE_SIGN          => true                           --
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
                    START               => proc_data_rstart             , -- Out :
                    BUSY                => proc_data_rbusy              , -- Out :
                    ADDR                => proc_1_addr                  , -- Out :
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => proc_data_rvalid             , -- In  :
                    READY               => open                           -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(data_dout);
            proc_data_raddr <= unsigned(proc_1_addr);
        end block;
    end block;
    PROC_STORE_VARIABLES: block
        constant  PROC_MAP_STORE_SIZE   :  integer := 1;
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
        PROC_STORE_DATA: block
            signal    proc_0_data      :  std_logic_vector(31 downto 0);
            signal    proc_0_addr      :  std_logic_vector(31 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("data")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    ADDR_BITS           => 32                           , --
                    VALUE_BITS          => 32                           , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
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
                    START               => proc_data_wstart             , -- Out :
                    BUSY                => proc_data_wbusy              , -- Out :
                    ADDR                => proc_0_addr                  , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => data_we                      , -- Out :
                    READY               => proc_data_wready               -- In  :
                );                                                        -- 
            data_din <= signed(proc_0_data);
            proc_data_waddr <= unsigned(proc_0_addr);
        end block;
    end block;
    PROC_ARB_DATA : block
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
                             if    (proc_data_wstart = '1') then
                                 proc_arb_state <= "01";
                             elsif (proc_data_rstart = '1') then
                                 proc_arb_state <= "10";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "01" =>
                             if    (proc_data_wbusy = '1') then
                                 proc_arb_state <= "01";
                             else
                                 proc_arb_state <= "00";
                             end if;
                         when "10" =>
                             if    (proc_data_rbusy = '1') then
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
         proc_data_wready <= proc_arb_state(0);
         proc_data_rvalid <= proc_arb_state(1);
         data_address <= proc_data_waddr when (proc_arb_state(0) = '1') else proc_data_raddr;
    end block;
end RTL;
