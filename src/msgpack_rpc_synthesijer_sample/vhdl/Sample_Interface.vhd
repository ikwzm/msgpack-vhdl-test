library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
entity  Sample_Interface is
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
        m0_req               : out std_logic;
        m0_busy              : in  std_logic;
        m1_req               : out std_logic;
        m1_busy              : in  std_logic;
        m1_p                 : out std_logic;
        m1_return            : in  std_logic;
        m2_req               : out std_logic;
        m2_busy              : in  std_logic;
        m2_b                 : out signed(8-1 downto 0);
        m2_i                 : out signed(32-1 downto 0);
        m2_return            : in  signed(8-1 downto 0);
        m3_req               : out std_logic;
        m3_busy              : in  std_logic;
        m3_s                 : out signed(16-1 downto 0);
        m3_i                 : out signed(32-1 downto 0);
        m3_return            : in  signed(16-1 downto 0);
        m4_req               : out std_logic;
        m4_busy              : in  std_logic;
        m4_a3                : out signed(8-1 downto 0);
        m4_a2                : out signed(16-1 downto 0);
        m4_a1                : out signed(32-1 downto 0);
        m4_a0                : out signed(64-1 downto 0);
        m4_return            : in  signed(64-1 downto 0);
        ivar_in              : out signed(32-1 downto 0);
        ivar_we              : out std_logic;
        ivar_out             : in  signed(32-1 downto 0);
        bvar_in              : out signed(8-1 downto 0);
        bvar_we              : out std_logic;
        bvar_out             : in  signed(8-1 downto 0);
        svar_in              : out signed(16-1 downto 0);
        svar_we              : out std_logic;
        svar_out             : in  signed(16-1 downto 0);
        lvar_in              : out signed(64-1 downto 0);
        lvar_we              : out std_logic;
        lvar_out             : in  signed(64-1 downto 0);
        tvar_in              : out std_logic;
        tvar_we              : out std_logic;
        tvar_out             : in  std_logic;
        imem_address         : out signed(32-1 downto 0);
        imem_din             : out signed(32-1 downto 0);
        imem_we              : out std_logic;
        imem_dout            : in  signed(32-1 downto 0);
        imem_oe              : out std_logic;
        imem_length          : in  signed(32-1 downto 0);
        bmem_address         : out signed(32-1 downto 0);
        bmem_din             : out signed(8-1 downto 0);
        bmem_we              : out std_logic;
        bmem_dout            : in  signed(8-1 downto 0);
        bmem_oe              : out std_logic;
        bmem_length          : in  signed(32-1 downto 0);
        smem_address         : out signed(32-1 downto 0);
        smem_din             : out signed(16-1 downto 0);
        smem_we              : out std_logic;
        smem_dout            : in  signed(16-1 downto 0);
        smem_oe              : out std_logic;
        smem_length          : in  signed(32-1 downto 0);
        lmem_address         : out signed(32-1 downto 0);
        lmem_din             : out signed(64-1 downto 0);
        lmem_we              : out std_logic;
        lmem_dout            : in  signed(64-1 downto 0);
        lmem_oe              : out std_logic;
        lmem_length          : in  signed(32-1 downto 0);
        tmem_address         : out signed(32-1 downto 0);
        tmem_din             : out signed(1-1 downto 0);
        tmem_we              : out std_logic;
        tmem_dout            : in  signed(1-1 downto 0);
        tmem_oe              : out std_logic;
        tmem_length          : in  signed(32-1 downto 0)
    );
end     Sample_Interface;
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Main_no_Param;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Return_Nil;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Main_with_Param;
use     MsgPack.MsgPack_Object_Components.MsgPack_Object_Store_Boolean_Register;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Return_Integer;
use     MsgPack.MsgPack_Object_Components.MsgPack_Object_Store_Integer_Register;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Get_Value;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Server_KVMap_Set_Value;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Query_Integer_Register;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Store_Integer_Register;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Query_Boolean_Register;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Store_Boolean_Register;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Query_Integer_Array;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Store_Integer_Array;
architecture RTL of Sample_Interface is
    constant  PROC_NUM          :  integer := 7;
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
    signal    proc_imem_waddr   :  signed(32-1 downto 0);
    signal    proc_imem_wvalid  :  std_logic;
    signal    proc_imem_wready  :  std_logic;
    signal    proc_imem_wstart  :  std_logic;
    signal    proc_imem_wbusy   :  std_logic;
    signal    proc_imem_raddr   :  signed(32-1 downto 0);
    signal    proc_imem_rvalid  :  std_logic;
    signal    proc_imem_rready  :  std_logic;
    signal    proc_imem_rstart  :  std_logic;
    signal    proc_imem_rbusy   :  std_logic;
    signal    proc_bmem_waddr   :  signed(32-1 downto 0);
    signal    proc_bmem_wvalid  :  std_logic;
    signal    proc_bmem_wready  :  std_logic;
    signal    proc_bmem_wstart  :  std_logic;
    signal    proc_bmem_wbusy   :  std_logic;
    signal    proc_bmem_raddr   :  signed(32-1 downto 0);
    signal    proc_bmem_rvalid  :  std_logic;
    signal    proc_bmem_rready  :  std_logic;
    signal    proc_bmem_rstart  :  std_logic;
    signal    proc_bmem_rbusy   :  std_logic;
    signal    proc_smem_waddr   :  signed(32-1 downto 0);
    signal    proc_smem_wvalid  :  std_logic;
    signal    proc_smem_wready  :  std_logic;
    signal    proc_smem_wstart  :  std_logic;
    signal    proc_smem_wbusy   :  std_logic;
    signal    proc_smem_raddr   :  signed(32-1 downto 0);
    signal    proc_smem_rvalid  :  std_logic;
    signal    proc_smem_rready  :  std_logic;
    signal    proc_smem_rstart  :  std_logic;
    signal    proc_smem_rbusy   :  std_logic;
    signal    proc_lmem_waddr   :  signed(32-1 downto 0);
    signal    proc_lmem_wvalid  :  std_logic;
    signal    proc_lmem_wready  :  std_logic;
    signal    proc_lmem_wstart  :  std_logic;
    signal    proc_lmem_wbusy   :  std_logic;
    signal    proc_lmem_raddr   :  signed(32-1 downto 0);
    signal    proc_lmem_rvalid  :  std_logic;
    signal    proc_lmem_rready  :  std_logic;
    signal    proc_lmem_rstart  :  std_logic;
    signal    proc_lmem_rbusy   :  std_logic;
    signal    proc_tmem_waddr   :  signed(32-1 downto 0);
    signal    proc_tmem_wvalid  :  std_logic;
    signal    proc_tmem_wready  :  std_logic;
    signal    proc_tmem_wstart  :  std_logic;
    signal    proc_tmem_wbusy   :  std_logic;
    signal    proc_tmem_raddr   :  signed(32-1 downto 0);
    signal    proc_tmem_rvalid  :  std_logic;
    signal    proc_tmem_rready  :  std_logic;
    signal    proc_tmem_rstart  :  std_logic;
    signal    proc_tmem_rbusy   :  std_logic;
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
    PROC_M0: block
        signal    proc_return_start     :  std_logic;
        signal    proc_return_done      :  std_logic;
        signal    proc_return_error     :  std_logic;
        signal    proc_return_busy      :  std_logic;
        signal    proc_start            :  std_logic;
    begin
        PROC_MAIN: MsgPack_RPC_Method_Main_No_Param         -- 
            generic map (                                                 -- 
                NAME                    => STRING'("m0")                , --
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
                RUN_REQ                 => m0_req                       , -- Out :
                RUN_ACK                 => m0_busy                      , -- In  :
                RUN_BUSY                => m0_busy                      , -- In  :
                RUN_DONE                => '0'                          , -- In  :
                RUNNING                 => open                         , -- Out :
                RET_ID                  => proc_res_id     (0)          , -- Out :
                RET_START               => proc_return_start            , -- Out :
                RET_ERROR               => proc_return_error            , -- Out :
                RET_DONE                => proc_return_done             , -- Out :
                RET_BUSY                => proc_return_busy               -- In  :
            );                                                            -- 
        PROC_RETURN : MsgPack_RPC_Method_Return_Nil              -- 
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
                RES_READY               => proc_res_ready  (0)            -- In  :
            );                                                            -- 
    end block;
    PROC_M1: block
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
                NAME                    => STRING'("m1")                , --
                PARAM_NUM               => PROC_PARAM_NUM               , --
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
                PROC_START              => proc_start                   , -- Out :
                PARAM_CODE              => proc_param_code (1)          , -- In  :
                PARAM_VALID             => proc_param_valid(1)          , -- In  :
                PARAM_LAST              => proc_param_last (1)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(1)          , -- Out :
                SET_PARAM_CODE          => proc_set_param_code          , -- Out :
                SET_PARAM_LAST          => proc_set_param_last          , -- Out :
                SET_PARAM_VALID         => proc_set_param_valid         , -- Out :
                SET_PARAM_ERROR         => proc_set_param_error         , -- In  :
                SET_PARAM_DONE          => proc_set_param_done          , -- In  :
                SET_PARAM_SHIFT         => proc_set_param_shift         , -- In  :
                RUN_REQ                 => m1_req                       , -- Out :
                RUN_ACK                 => m1_busy                      , -- In  :
                RUN_BUSY                => m1_busy                      , -- In  :
                RUN_DONE                => '0'                          , -- In  :
                RUNNING                 => open                         , -- Out :
                RET_ID                  => proc_res_id     (1)          , -- Out :
                RET_START               => proc_return_start            , -- Out :
                RET_DONE                => proc_return_done             , -- Out :
                RET_ERROR               => proc_return_error            , -- Out :
                RET_BUSY                => proc_return_busy               -- In  :
            );                                                            -- 
        PROC_0_P: block
            signal    proc_0_value :  std_logic_vector(1-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m1_p <= '0';
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m1_p <= '0';
                    elsif (proc_0_valid = '1') then
                         m1_p <= proc_0_value(0);
                    end if;
                end if;
            end process;
            PROC_STORE_P : MsgPack_Object_Store_Boolean_Register                      -- 
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
                    RES_CODE                => proc_res_code   (1)          , -- Out :
                    RES_VALID               => proc_res_valid  (1)          , -- Out :
                    RES_LAST                => proc_res_last   (1)          , -- Out :
                    RES_READY               => proc_res_ready  (1)          , -- In  :
                    VALUE                   => proc_return_value              -- In  :
                );
            proc_return_value(0) <= m1_return;
        end block;
    end block;
    PROC_M2: block
        constant  PROC_PARAM_NUM        :  integer := 2;
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
                NAME                    => STRING'("m2")                , --
                PARAM_NUM               => PROC_PARAM_NUM               , --
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
                PROC_START              => proc_start                   , -- Out :
                PARAM_CODE              => proc_param_code (2)          , -- In  :
                PARAM_VALID             => proc_param_valid(2)          , -- In  :
                PARAM_LAST              => proc_param_last (2)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(2)          , -- Out :
                SET_PARAM_CODE          => proc_set_param_code          , -- Out :
                SET_PARAM_LAST          => proc_set_param_last          , -- Out :
                SET_PARAM_VALID         => proc_set_param_valid         , -- Out :
                SET_PARAM_ERROR         => proc_set_param_error         , -- In  :
                SET_PARAM_DONE          => proc_set_param_done          , -- In  :
                SET_PARAM_SHIFT         => proc_set_param_shift         , -- In  :
                RUN_REQ                 => m2_req                       , -- Out :
                RUN_ACK                 => m2_busy                      , -- In  :
                RUN_BUSY                => m2_busy                      , -- In  :
                RUN_DONE                => '0'                          , -- In  :
                RUNNING                 => open                         , -- Out :
                RET_ID                  => proc_res_id     (2)          , -- Out :
                RET_START               => proc_return_start            , -- Out :
                RET_DONE                => proc_return_done             , -- Out :
                RET_ERROR               => proc_return_error            , -- Out :
                RET_BUSY                => proc_return_busy               -- In  :
            );                                                            -- 
        PROC_0_B: block
            signal    proc_0_value :  std_logic_vector(8-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m2_b <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m2_b <= (others => '0');
                    elsif (proc_0_valid = '1') then
                         m2_b <= signed(proc_0_value);
                    end if;
                end if;
            end process;
            PROC_STORE_B : MsgPack_Object_Store_Integer_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 8                            , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
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
                    VALUE               => proc_0_value                 , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_0_I: block
            signal    proc_0_value :  std_logic_vector(32-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m2_i <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m2_i <= (others => '0');
                    elsif (proc_0_valid = '1') then
                         m2_i <= signed(proc_0_value);
                    end if;
                end if;
            end process;
            PROC_STORE_I : MsgPack_Object_Store_Integer_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 32                           , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    I_CODE              => proc_set_param_code          , -- In  :
                    I_LAST              => proc_set_param_last          , -- In  :
                    I_VALID             => proc_set_param_valid(1)      , -- In  :
                    I_ERROR             => proc_set_param_error(1)      , -- Out :
                    I_DONE              => proc_set_param_done (1)      , -- Out :
                    I_SHIFT             => proc_set_param_shift(1)      , -- Out :
                    VALUE               => proc_0_value                 , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_RETURN : block
            signal proc_return_value : std_logic_vector(8-1 downto 0);
        begin
            RET: MsgPack_RPC_Method_Return_Integer  -- 
                generic map (                                                 -- 
                    VALUE_WIDTH             => 8                            , --
                    RETURN_UINT             => FALSE                        , --
                    RETURN_INT              => TRUE                         , --
                    RETURN_FLOAT            => FALSE                        , --
                    RETURN_BOOLEAN          => FALSE                          --
                )                                                             -- 
                port map (                                                    -- 
                    CLK                     => CLK                          , -- In  :
                    RST                     => RST                          , -- in  :
                    CLR                     => CLR                          , -- in  :
                    RET_ERROR               => proc_return_error            , -- In  :
                    RET_START               => proc_return_start            , -- In  :
                    RET_DONE                => proc_return_done             , -- In  :
                    RET_BUSY                => proc_return_busy             , -- Out :
                    RES_CODE                => proc_res_code   (2)          , -- Out :
                    RES_VALID               => proc_res_valid  (2)          , -- Out :
                    RES_LAST                => proc_res_last   (2)          , -- Out :
                    RES_READY               => proc_res_ready  (2)          , -- In  :
                    VALUE                   => proc_return_value              -- In  :
                );
            proc_return_value <= std_logic_vector(m2_return);
        end block;
    end block;
    PROC_M3: block
        constant  PROC_PARAM_NUM        :  integer := 2;
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
                NAME                    => STRING'("m3")                , --
                PARAM_NUM               => PROC_PARAM_NUM               , --
                MATCH_PHASE             => 8                              --
            )                                                             -- 
            port map (                                                    -- 
                CLK                     => CLK                          , -- In  :
                RST                     => RST                          , -- in  :
                CLR                     => CLR                          , -- in  :
                MATCH_REQ               => proc_match_req               , -- In  :
                MATCH_CODE              => proc_match_code              , -- In  :
                MATCH_OK                => proc_match_ok   (3)          , -- Out :
                MATCH_NOT               => proc_match_not  (3)          , -- Out :
                MATCH_SHIFT             => proc_match_shift(3)          , -- Out :
                PROC_REQ_ID             => proc_req_id                  , -- In  :
                PROC_REQ                => proc_req        (3)          , -- In  :
                PROC_BUSY               => proc_busy       (3)          , -- Out :
                PROC_START              => proc_start                   , -- Out :
                PARAM_CODE              => proc_param_code (3)          , -- In  :
                PARAM_VALID             => proc_param_valid(3)          , -- In  :
                PARAM_LAST              => proc_param_last (3)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(3)          , -- Out :
                SET_PARAM_CODE          => proc_set_param_code          , -- Out :
                SET_PARAM_LAST          => proc_set_param_last          , -- Out :
                SET_PARAM_VALID         => proc_set_param_valid         , -- Out :
                SET_PARAM_ERROR         => proc_set_param_error         , -- In  :
                SET_PARAM_DONE          => proc_set_param_done          , -- In  :
                SET_PARAM_SHIFT         => proc_set_param_shift         , -- In  :
                RUN_REQ                 => m3_req                       , -- Out :
                RUN_ACK                 => m3_busy                      , -- In  :
                RUN_BUSY                => m3_busy                      , -- In  :
                RUN_DONE                => '0'                          , -- In  :
                RUNNING                 => open                         , -- Out :
                RET_ID                  => proc_res_id     (3)          , -- Out :
                RET_START               => proc_return_start            , -- Out :
                RET_DONE                => proc_return_done             , -- Out :
                RET_ERROR               => proc_return_error            , -- Out :
                RET_BUSY                => proc_return_busy               -- In  :
            );                                                            -- 
        PROC_0_S: block
            signal    proc_0_value :  std_logic_vector(16-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m3_s <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m3_s <= (others => '0');
                    elsif (proc_0_valid = '1') then
                         m3_s <= signed(proc_0_value);
                    end if;
                end if;
            end process;
            PROC_STORE_S : MsgPack_Object_Store_Integer_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 16                           , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
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
                    VALUE               => proc_0_value                 , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_0_I: block
            signal    proc_0_value :  std_logic_vector(32-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m3_i <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m3_i <= (others => '0');
                    elsif (proc_0_valid = '1') then
                         m3_i <= signed(proc_0_value);
                    end if;
                end if;
            end process;
            PROC_STORE_I : MsgPack_Object_Store_Integer_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 32                           , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    I_CODE              => proc_set_param_code          , -- In  :
                    I_LAST              => proc_set_param_last          , -- In  :
                    I_VALID             => proc_set_param_valid(1)      , -- In  :
                    I_ERROR             => proc_set_param_error(1)      , -- Out :
                    I_DONE              => proc_set_param_done (1)      , -- Out :
                    I_SHIFT             => proc_set_param_shift(1)      , -- Out :
                    VALUE               => proc_0_value                 , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_RETURN : block
            signal proc_return_value : std_logic_vector(16-1 downto 0);
        begin
            RET: MsgPack_RPC_Method_Return_Integer  -- 
                generic map (                                                 -- 
                    VALUE_WIDTH             => 16                           , --
                    RETURN_UINT             => FALSE                        , --
                    RETURN_INT              => TRUE                         , --
                    RETURN_FLOAT            => FALSE                        , --
                    RETURN_BOOLEAN          => FALSE                          --
                )                                                             -- 
                port map (                                                    -- 
                    CLK                     => CLK                          , -- In  :
                    RST                     => RST                          , -- in  :
                    CLR                     => CLR                          , -- in  :
                    RET_ERROR               => proc_return_error            , -- In  :
                    RET_START               => proc_return_start            , -- In  :
                    RET_DONE                => proc_return_done             , -- In  :
                    RET_BUSY                => proc_return_busy             , -- Out :
                    RES_CODE                => proc_res_code   (3)          , -- Out :
                    RES_VALID               => proc_res_valid  (3)          , -- Out :
                    RES_LAST                => proc_res_last   (3)          , -- Out :
                    RES_READY               => proc_res_ready  (3)          , -- In  :
                    VALUE                   => proc_return_value              -- In  :
                );
            proc_return_value <= std_logic_vector(m3_return);
        end block;
    end block;
    PROC_M4: block
        constant  PROC_PARAM_NUM        :  integer := 4;
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
                NAME                    => STRING'("m4")                , --
                PARAM_NUM               => PROC_PARAM_NUM               , --
                MATCH_PHASE             => 8                              --
            )                                                             -- 
            port map (                                                    -- 
                CLK                     => CLK                          , -- In  :
                RST                     => RST                          , -- in  :
                CLR                     => CLR                          , -- in  :
                MATCH_REQ               => proc_match_req               , -- In  :
                MATCH_CODE              => proc_match_code              , -- In  :
                MATCH_OK                => proc_match_ok   (4)          , -- Out :
                MATCH_NOT               => proc_match_not  (4)          , -- Out :
                MATCH_SHIFT             => proc_match_shift(4)          , -- Out :
                PROC_REQ_ID             => proc_req_id                  , -- In  :
                PROC_REQ                => proc_req        (4)          , -- In  :
                PROC_BUSY               => proc_busy       (4)          , -- Out :
                PROC_START              => proc_start                   , -- Out :
                PARAM_CODE              => proc_param_code (4)          , -- In  :
                PARAM_VALID             => proc_param_valid(4)          , -- In  :
                PARAM_LAST              => proc_param_last (4)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(4)          , -- Out :
                SET_PARAM_CODE          => proc_set_param_code          , -- Out :
                SET_PARAM_LAST          => proc_set_param_last          , -- Out :
                SET_PARAM_VALID         => proc_set_param_valid         , -- Out :
                SET_PARAM_ERROR         => proc_set_param_error         , -- In  :
                SET_PARAM_DONE          => proc_set_param_done          , -- In  :
                SET_PARAM_SHIFT         => proc_set_param_shift         , -- In  :
                RUN_REQ                 => m4_req                       , -- Out :
                RUN_ACK                 => m4_busy                      , -- In  :
                RUN_BUSY                => m4_busy                      , -- In  :
                RUN_DONE                => '0'                          , -- In  :
                RUNNING                 => open                         , -- Out :
                RET_ID                  => proc_res_id     (4)          , -- Out :
                RET_START               => proc_return_start            , -- Out :
                RET_DONE                => proc_return_done             , -- Out :
                RET_ERROR               => proc_return_error            , -- Out :
                RET_BUSY                => proc_return_busy               -- In  :
            );                                                            -- 
        PROC_0_A3: block
            signal    proc_0_value :  std_logic_vector(8-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m4_a3 <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m4_a3 <= (others => '0');
                    elsif (proc_0_valid = '1') then
                         m4_a3 <= signed(proc_0_value);
                    end if;
                end if;
            end process;
            PROC_STORE_A3 : MsgPack_Object_Store_Integer_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 8                            , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
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
                    VALUE               => proc_0_value                 , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_0_A2: block
            signal    proc_0_value :  std_logic_vector(16-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m4_a2 <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m4_a2 <= (others => '0');
                    elsif (proc_0_valid = '1') then
                         m4_a2 <= signed(proc_0_value);
                    end if;
                end if;
            end process;
            PROC_STORE_A2 : MsgPack_Object_Store_Integer_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 16                           , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    I_CODE              => proc_set_param_code          , -- In  :
                    I_LAST              => proc_set_param_last          , -- In  :
                    I_VALID             => proc_set_param_valid(1)      , -- In  :
                    I_ERROR             => proc_set_param_error(1)      , -- Out :
                    I_DONE              => proc_set_param_done (1)      , -- Out :
                    I_SHIFT             => proc_set_param_shift(1)      , -- Out :
                    VALUE               => proc_0_value                 , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_0_A1: block
            signal    proc_0_value :  std_logic_vector(32-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m4_a1 <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m4_a1 <= (others => '0');
                    elsif (proc_0_valid = '1') then
                         m4_a1 <= signed(proc_0_value);
                    end if;
                end if;
            end process;
            PROC_STORE_A1 : MsgPack_Object_Store_Integer_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 32                           , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    I_CODE              => proc_set_param_code          , -- In  :
                    I_LAST              => proc_set_param_last          , -- In  :
                    I_VALID             => proc_set_param_valid(2)      , -- In  :
                    I_ERROR             => proc_set_param_error(2)      , -- Out :
                    I_DONE              => proc_set_param_done (2)      , -- Out :
                    I_SHIFT             => proc_set_param_shift(2)      , -- Out :
                    VALUE               => proc_0_value                 , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_0_A0: block
            signal    proc_0_value :  std_logic_vector(64-1 downto 0);
            signal    proc_0_valid :  std_logic;
        begin
            process(CLK, RST) begin
                if (RST = '1') then
                         m4_a0 <= (others => '0');
                elsif (CLK'event and CLK = '1') then
                    if    (CLR = '1') then
                         m4_a0 <= (others => '0');
                    elsif (proc_0_valid = '1') then
                         m4_a0 <= signed(proc_0_value);
                    end if;
                end if;
            end process;
            PROC_STORE_A0 : MsgPack_Object_Store_Integer_Register                      -- 
                generic map (                                             -- 
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 64                           , --
                    VALUE_SIGN          => true                         , --
                    CHECK_RANGE         => TRUE                         , --
                    ENABLE64            => TRUE                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    I_CODE              => proc_set_param_code          , -- In  :
                    I_LAST              => proc_set_param_last          , -- In  :
                    I_VALID             => proc_set_param_valid(3)      , -- In  :
                    I_ERROR             => proc_set_param_error(3)      , -- Out :
                    I_DONE              => proc_set_param_done (3)      , -- Out :
                    I_SHIFT             => proc_set_param_shift(3)      , -- Out :
                    VALUE               => proc_0_value                 , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_0_valid                 , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
        end block;
        PROC_RETURN : block
            signal proc_return_value : std_logic_vector(64-1 downto 0);
        begin
            RET: MsgPack_RPC_Method_Return_Integer  -- 
                generic map (                                                 -- 
                    VALUE_WIDTH             => 64                           , --
                    RETURN_UINT             => FALSE                        , --
                    RETURN_INT              => TRUE                         , --
                    RETURN_FLOAT            => FALSE                        , --
                    RETURN_BOOLEAN          => FALSE                          --
                )                                                             -- 
                port map (                                                    -- 
                    CLK                     => CLK                          , -- In  :
                    RST                     => RST                          , -- in  :
                    CLR                     => CLR                          , -- in  :
                    RET_ERROR               => proc_return_error            , -- In  :
                    RET_START               => proc_return_start            , -- In  :
                    RET_DONE                => proc_return_done             , -- In  :
                    RET_BUSY                => proc_return_busy             , -- Out :
                    RES_CODE                => proc_res_code   (4)          , -- Out :
                    RES_VALID               => proc_res_valid  (4)          , -- Out :
                    RES_LAST                => proc_res_last   (4)          , -- Out :
                    RES_READY               => proc_res_ready  (4)          , -- In  :
                    VALUE                   => proc_return_value              -- In  :
                );
            proc_return_value <= std_logic_vector(m4_return);
        end block;
    end block;
    PROC_QUERY_VARIABLES: block
        constant  PROC_MAP_QUERY_SIZE   :  integer := 10;
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
                MATCH_OK                => proc_match_ok   (5)          , -- Out :
                MATCH_NOT               => proc_match_not  (5)          , -- Out :
                MATCH_SHIFT             => proc_match_shift(5)          , -- Out :
                PROC_REQ_ID             => proc_req_id                  , -- In  :
                PROC_REQ                => proc_req        (5)          , -- In  :
                PROC_BUSY               => proc_busy       (5)          , -- Out :
                PARAM_CODE              => proc_param_code (5)          , -- In  :
                PARAM_VALID             => proc_param_valid(5)          , -- In  :
                PARAM_LAST              => proc_param_last (5)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(5)          , -- Out :
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
                RES_ID                  => proc_res_id     (5)          , -- Out :
                RES_CODE                => proc_res_code   (5)          , -- Out :
                RES_VALID               => proc_res_valid  (5)          , -- Out :
                RES_LAST                => proc_res_last   (5)          , -- Out :
                RES_READY               => proc_res_ready  (5)            -- In  :
            );                                                            -- 
        PROC_QUERY_IVAR: block
            signal    proc_1_data          :  std_logic_vector(31 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("ivar")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
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
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => '1'                          , -- In  :
                    READY               => open                           -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(ivar_out);
        end block;
        PROC_QUERY_BVAR: block
            signal    proc_1_data          :  std_logic_vector(7 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("bvar")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    VALUE_BITS          => 8                            , --
                    VALUE_SIGN          => true                           --
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
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => '1'                          , -- In  :
                    READY               => open                           -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(bvar_out);
        end block;
        PROC_QUERY_SVAR: block
            signal    proc_1_data          :  std_logic_vector(15 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("svar")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    VALUE_BITS          => 16                           , --
                    VALUE_SIGN          => true                           --
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
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => '1'                          , -- In  :
                    READY               => open                           -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(svar_out);
        end block;
        PROC_QUERY_LVAR: block
            signal    proc_1_data          :  std_logic_vector(63 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("lvar")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    VALUE_BITS          => 64                           , --
                    VALUE_SIGN          => true                           --
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
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => '1'                          , -- In  :
                    READY               => open                           -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(lvar_out);
        end block;
        PROC_QUERY_TVAR: block
            signal    proc_1_data          :  std_logic_vector(0 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Boolean_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("tvar")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                              --
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
                    VALUE               => proc_1_data(0)               , -- In  :
                    VALID               => '1'                          , -- In  :
                    READY               => open                           -- Out :
                );                                                        -- 
            proc_1_data(0) <= tvar_out;
        end block;
        PROC_QUERY_IMEM: block
            signal    proc_1_data          :  std_logic_vector(31 downto 0);
            signal    proc_1_addr          :  std_logic_vector(31 downto 0);
            signal    proc_1_default_size  :  std_logic_vector(31 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("imem")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    ADDR_BITS           => 32                           , --
                    SIZE_BITS           => 32                           , --
                    VALUE_BITS          => 32                           , --
                    VALUE_SIGN          => true                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    DEFAULT_SIZE        => proc_1_default_size          , -- In  :
                    I_CODE              => proc_map_param_code          , -- In  :
                    I_LAST              => proc_map_param_last          , -- In  :
                    I_VALID             => proc_map_param_valid(5)      , -- In  :
                    I_ERROR             => proc_map_param_error(5)      , -- Out :
                    I_DONE              => proc_map_param_done (5)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(5)      , -- Out :
                    O_CODE              => proc_map_value_code (5)      , -- Out :
                    O_LAST              => proc_map_value_last (5)      , -- Out :
                    O_VALID             => proc_map_value_valid(5)      , -- Out :
                    O_ERROR             => proc_map_value_error(5)      , -- Out :
                    O_READY             => proc_map_value_ready(5)      , -- In  :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (5)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (5)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(5)      , -- Out :
                    START               => proc_imem_rstart             , -- Out :
                    BUSY                => proc_imem_rbusy              , -- Out :
                    ADDR                => proc_1_addr                  , -- Out :
                    SIZE                => open                         , -- Out :
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => proc_imem_rvalid             , -- In  :
                    READY               => proc_imem_rready               -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(imem_dout);
            proc_imem_raddr <= signed(proc_1_addr);
            proc_1_default_size <= std_logic_vector(imem_length);
        end block;
        PROC_QUERY_BMEM: block
            signal    proc_1_data          :  std_logic_vector(7 downto 0);
            signal    proc_1_addr          :  std_logic_vector(31 downto 0);
            signal    proc_1_default_size  :  std_logic_vector(31 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("bmem")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    ADDR_BITS           => 32                           , --
                    SIZE_BITS           => 32                           , --
                    VALUE_BITS          => 8                            , --
                    VALUE_SIGN          => true                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    DEFAULT_SIZE        => proc_1_default_size          , -- In  :
                    I_CODE              => proc_map_param_code          , -- In  :
                    I_LAST              => proc_map_param_last          , -- In  :
                    I_VALID             => proc_map_param_valid(6)      , -- In  :
                    I_ERROR             => proc_map_param_error(6)      , -- Out :
                    I_DONE              => proc_map_param_done (6)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(6)      , -- Out :
                    O_CODE              => proc_map_value_code (6)      , -- Out :
                    O_LAST              => proc_map_value_last (6)      , -- Out :
                    O_VALID             => proc_map_value_valid(6)      , -- Out :
                    O_ERROR             => proc_map_value_error(6)      , -- Out :
                    O_READY             => proc_map_value_ready(6)      , -- In  :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (6)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (6)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(6)      , -- Out :
                    START               => proc_bmem_rstart             , -- Out :
                    BUSY                => proc_bmem_rbusy              , -- Out :
                    ADDR                => proc_1_addr                  , -- Out :
                    SIZE                => open                         , -- Out :
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => proc_bmem_rvalid             , -- In  :
                    READY               => proc_bmem_rready               -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(bmem_dout);
            proc_bmem_raddr <= signed(proc_1_addr);
            proc_1_default_size <= std_logic_vector(bmem_length);
        end block;
        PROC_QUERY_SMEM: block
            signal    proc_1_data          :  std_logic_vector(15 downto 0);
            signal    proc_1_addr          :  std_logic_vector(31 downto 0);
            signal    proc_1_default_size  :  std_logic_vector(31 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("smem")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    ADDR_BITS           => 32                           , --
                    SIZE_BITS           => 32                           , --
                    VALUE_BITS          => 16                           , --
                    VALUE_SIGN          => true                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    DEFAULT_SIZE        => proc_1_default_size          , -- In  :
                    I_CODE              => proc_map_param_code          , -- In  :
                    I_LAST              => proc_map_param_last          , -- In  :
                    I_VALID             => proc_map_param_valid(7)      , -- In  :
                    I_ERROR             => proc_map_param_error(7)      , -- Out :
                    I_DONE              => proc_map_param_done (7)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(7)      , -- Out :
                    O_CODE              => proc_map_value_code (7)      , -- Out :
                    O_LAST              => proc_map_value_last (7)      , -- Out :
                    O_VALID             => proc_map_value_valid(7)      , -- Out :
                    O_ERROR             => proc_map_value_error(7)      , -- Out :
                    O_READY             => proc_map_value_ready(7)      , -- In  :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (7)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (7)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(7)      , -- Out :
                    START               => proc_smem_rstart             , -- Out :
                    BUSY                => proc_smem_rbusy              , -- Out :
                    ADDR                => proc_1_addr                  , -- Out :
                    SIZE                => open                         , -- Out :
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => proc_smem_rvalid             , -- In  :
                    READY               => proc_smem_rready               -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(smem_dout);
            proc_smem_raddr <= signed(proc_1_addr);
            proc_1_default_size <= std_logic_vector(smem_length);
        end block;
        PROC_QUERY_LMEM: block
            signal    proc_1_data          :  std_logic_vector(63 downto 0);
            signal    proc_1_addr          :  std_logic_vector(31 downto 0);
            signal    proc_1_default_size  :  std_logic_vector(31 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("lmem")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    ADDR_BITS           => 32                           , --
                    SIZE_BITS           => 32                           , --
                    VALUE_BITS          => 64                           , --
                    VALUE_SIGN          => true                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    DEFAULT_SIZE        => proc_1_default_size          , -- In  :
                    I_CODE              => proc_map_param_code          , -- In  :
                    I_LAST              => proc_map_param_last          , -- In  :
                    I_VALID             => proc_map_param_valid(8)      , -- In  :
                    I_ERROR             => proc_map_param_error(8)      , -- Out :
                    I_DONE              => proc_map_param_done (8)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(8)      , -- Out :
                    O_CODE              => proc_map_value_code (8)      , -- Out :
                    O_LAST              => proc_map_value_last (8)      , -- Out :
                    O_VALID             => proc_map_value_valid(8)      , -- Out :
                    O_ERROR             => proc_map_value_error(8)      , -- Out :
                    O_READY             => proc_map_value_ready(8)      , -- In  :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (8)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (8)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(8)      , -- Out :
                    START               => proc_lmem_rstart             , -- Out :
                    BUSY                => proc_lmem_rbusy              , -- Out :
                    ADDR                => proc_1_addr                  , -- Out :
                    SIZE                => open                         , -- Out :
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => proc_lmem_rvalid             , -- In  :
                    READY               => proc_lmem_rready               -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(lmem_dout);
            proc_lmem_raddr <= signed(proc_1_addr);
            proc_1_default_size <= std_logic_vector(lmem_length);
        end block;
        PROC_QUERY_TMEM: block
            signal    proc_1_data          :  std_logic_vector(0 downto 0);
            signal    proc_1_addr          :  std_logic_vector(31 downto 0);
            signal    proc_1_default_size  :  std_logic_vector(31 downto 0);
        begin
            PROC_1 : MsgPack_KVMap_Query_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("tmem")              , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    MATCH_PHASE         => 8                            , --
                    ADDR_BITS           => 32                           , --
                    SIZE_BITS           => 32                           , --
                    VALUE_BITS          => 1                            , --
                    VALUE_SIGN          => true                           --
                )                                                         -- 
                port map (                                                -- 
                    CLK                 => CLK                          , -- In  :
                    RST                 => RST                          , -- in  :
                    CLR                 => CLR                          , -- in  :
                    DEFAULT_SIZE        => proc_1_default_size          , -- In  :
                    I_CODE              => proc_map_param_code          , -- In  :
                    I_LAST              => proc_map_param_last          , -- In  :
                    I_VALID             => proc_map_param_valid(9)      , -- In  :
                    I_ERROR             => proc_map_param_error(9)      , -- Out :
                    I_DONE              => proc_map_param_done (9)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(9)      , -- Out :
                    O_CODE              => proc_map_value_code (9)      , -- Out :
                    O_LAST              => proc_map_value_last (9)      , -- Out :
                    O_VALID             => proc_map_value_valid(9)      , -- Out :
                    O_ERROR             => proc_map_value_error(9)      , -- Out :
                    O_READY             => proc_map_value_ready(9)      , -- In  :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (9)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (9)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(9)      , -- Out :
                    START               => proc_tmem_rstart             , -- Out :
                    BUSY                => proc_tmem_rbusy              , -- Out :
                    ADDR                => proc_1_addr                  , -- Out :
                    SIZE                => open                         , -- Out :
                    VALUE               => proc_1_data                  , -- In  :
                    VALID               => proc_tmem_rvalid             , -- In  :
                    READY               => proc_tmem_rready               -- Out :
                );                                                        -- 
            proc_1_data <= std_logic_vector(tmem_dout);
            proc_tmem_raddr <= signed(proc_1_addr);
            proc_1_default_size <= std_logic_vector(tmem_length);
        end block;
    end block;
    PROC_STORE_VARIABLES: block
        constant  PROC_MAP_STORE_SIZE   :  integer := 10;
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
                MATCH_OK                => proc_match_ok   (6)          , -- Out :
                MATCH_NOT               => proc_match_not  (6)          , -- Out :
                MATCH_SHIFT             => proc_match_shift(6)          , -- Out :
                PROC_REQ_ID             => proc_req_id                  , -- In  :
                PROC_REQ                => proc_req        (6)          , -- In  :
                PROC_BUSY               => proc_busy       (6)          , -- Out :
                PARAM_CODE              => proc_param_code (6)          , -- In  :
                PARAM_VALID             => proc_param_valid(6)          , -- In  :
                PARAM_LAST              => proc_param_last (6)          , -- In  :
                PARAM_SHIFT             => proc_param_shift(6)          , -- Out :
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
                RES_ID                  => proc_res_id     (6)          , -- Out :
                RES_CODE                => proc_res_code   (6)          , -- Out :
                RES_VALID               => proc_res_valid  (6)          , -- Out :
                RES_LAST                => proc_res_last   (6)          , -- Out :
                RES_READY               => proc_res_ready  (6)            -- In  :
            );                                                            -- 
        PROC_STORE_IVAR: block
            signal    proc_0_data      :  std_logic_vector(31 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("ivar")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
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
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => ivar_we                      , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
            ivar_in <= signed(proc_0_data);
        end block;
        PROC_STORE_BVAR: block
            signal    proc_0_data      :  std_logic_vector(7 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("bvar")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 8                            , --
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
                    I_VALID             => proc_map_param_valid(1)      , -- In  :
                    I_ERROR             => proc_map_param_error(1)      , -- Out :
                    I_DONE              => proc_map_param_done (1)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(1)      , -- Out :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (1)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (1)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(1)      , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => bvar_we                      , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
            bvar_in <= signed(proc_0_data);
        end block;
        PROC_STORE_SVAR: block
            signal    proc_0_data      :  std_logic_vector(15 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("svar")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 16                           , --
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
                    I_VALID             => proc_map_param_valid(2)      , -- In  :
                    I_ERROR             => proc_map_param_error(2)      , -- Out :
                    I_DONE              => proc_map_param_done (2)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(2)      , -- Out :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (2)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (2)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(2)      , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => svar_we                      , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
            svar_in <= signed(proc_0_data);
        end block;
        PROC_STORE_LVAR: block
            signal    proc_0_data      :  std_logic_vector(63 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("lvar")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    VALUE_BITS          => 64                           , --
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
                    I_VALID             => proc_map_param_valid(3)      , -- In  :
                    I_ERROR             => proc_map_param_error(3)      , -- Out :
                    I_DONE              => proc_map_param_done (3)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(3)      , -- Out :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (3)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (3)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(3)      , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => lvar_we                      , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
            lvar_in <= signed(proc_0_data);
        end block;
        PROC_STORE_TVAR: block
            signal    proc_0_data      :  std_logic_vector(0 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Boolean_Register   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("tvar")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length        --
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
                    VALUE               => proc_0_data(0)               , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => tvar_we                      , -- Out :
                    READY               => '1'                            -- In  :
                );                                                        -- 
            tvar_in <= proc_0_data(0);
        end block;
        PROC_STORE_IMEM: block
            signal    proc_0_data      :  std_logic_vector(31 downto 0);
            signal    proc_0_addr      :  std_logic_vector(31 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("imem")              , --
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
                    I_VALID             => proc_map_param_valid(5)      , -- In  :
                    I_ERROR             => proc_map_param_error(5)      , -- Out :
                    I_DONE              => proc_map_param_done (5)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(5)      , -- Out :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (5)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (5)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(5)      , -- Out :
                    START               => proc_imem_wstart             , -- Out :
                    BUSY                => proc_imem_wbusy              , -- Out :
                    ADDR                => proc_0_addr                  , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_imem_wvalid             , -- Out :
                    READY               => proc_imem_wready               -- In  :
                );                                                        -- 
            imem_din <= signed(proc_0_data);
            proc_imem_waddr <= signed(proc_0_addr);
        end block;
        PROC_STORE_BMEM: block
            signal    proc_0_data      :  std_logic_vector(7 downto 0);
            signal    proc_0_addr      :  std_logic_vector(31 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("bmem")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    ADDR_BITS           => 32                           , --
                    VALUE_BITS          => 8                            , --
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
                    I_VALID             => proc_map_param_valid(6)      , -- In  :
                    I_ERROR             => proc_map_param_error(6)      , -- Out :
                    I_DONE              => proc_map_param_done (6)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(6)      , -- Out :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (6)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (6)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(6)      , -- Out :
                    START               => proc_bmem_wstart             , -- Out :
                    BUSY                => proc_bmem_wbusy              , -- Out :
                    ADDR                => proc_0_addr                  , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_bmem_wvalid             , -- Out :
                    READY               => proc_bmem_wready               -- In  :
                );                                                        -- 
            bmem_din <= signed(proc_0_data);
            proc_bmem_waddr <= signed(proc_0_addr);
        end block;
        PROC_STORE_SMEM: block
            signal    proc_0_data      :  std_logic_vector(15 downto 0);
            signal    proc_0_addr      :  std_logic_vector(31 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("smem")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    ADDR_BITS           => 32                           , --
                    VALUE_BITS          => 16                           , --
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
                    I_VALID             => proc_map_param_valid(7)      , -- In  :
                    I_ERROR             => proc_map_param_error(7)      , -- Out :
                    I_DONE              => proc_map_param_done (7)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(7)      , -- Out :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (7)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (7)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(7)      , -- Out :
                    START               => proc_smem_wstart             , -- Out :
                    BUSY                => proc_smem_wbusy              , -- Out :
                    ADDR                => proc_0_addr                  , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_smem_wvalid             , -- Out :
                    READY               => proc_smem_wready               -- In  :
                );                                                        -- 
            smem_din <= signed(proc_0_data);
            proc_smem_waddr <= signed(proc_0_addr);
        end block;
        PROC_STORE_LMEM: block
            signal    proc_0_data      :  std_logic_vector(63 downto 0);
            signal    proc_0_addr      :  std_logic_vector(31 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("lmem")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    ADDR_BITS           => 32                           , --
                    VALUE_BITS          => 64                           , --
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
                    I_VALID             => proc_map_param_valid(8)      , -- In  :
                    I_ERROR             => proc_map_param_error(8)      , -- Out :
                    I_DONE              => proc_map_param_done (8)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(8)      , -- Out :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (8)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (8)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(8)      , -- Out :
                    START               => proc_lmem_wstart             , -- Out :
                    BUSY                => proc_lmem_wbusy              , -- Out :
                    ADDR                => proc_0_addr                  , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_lmem_wvalid             , -- Out :
                    READY               => proc_lmem_wready               -- In  :
                );                                                        -- 
            lmem_din <= signed(proc_0_data);
            proc_lmem_waddr <= signed(proc_0_addr);
        end block;
        PROC_STORE_TMEM: block
            signal    proc_0_data      :  std_logic_vector(0 downto 0);
            signal    proc_0_addr      :  std_logic_vector(31 downto 0);
        begin
            PROC_0 : MsgPack_KVMap_Store_Integer_Array   -- 
                generic map (                                             -- 
                    KEY                 => STRING'("tmem")              , --
                    MATCH_PHASE         => 8                            , --
                    CODE_WIDTH          => MsgPack_RPC.Code_Length      , --
                    ADDR_BITS           => 32                           , --
                    VALUE_BITS          => 1                            , --
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
                    I_VALID             => proc_map_param_valid(9)      , -- In  :
                    I_ERROR             => proc_map_param_error(9)      , -- Out :
                    I_DONE              => proc_map_param_done (9)      , -- Out :
                    I_SHIFT             => proc_map_param_shift(9)      , -- Out :
                    MATCH_REQ           => proc_map_match_req           , -- In  :
                    MATCH_CODE          => proc_map_match_code          , -- In  :
                    MATCH_OK            => proc_map_match_ok   (9)      , -- Out :
                    MATCH_NOT           => proc_map_match_not  (9)      , -- Out :
                    MATCH_SHIFT         => proc_map_match_shift(9)      , -- Out :
                    START               => proc_tmem_wstart             , -- Out :
                    BUSY                => proc_tmem_wbusy              , -- Out :
                    ADDR                => proc_0_addr                  , -- Out :
                    VALUE               => proc_0_data                  , -- Out :
                    SIGN                => open                         , -- Out :
                    LAST                => open                         , -- Out :
                    VALID               => proc_tmem_wvalid             , -- Out :
                    READY               => proc_tmem_wready               -- In  :
                );                                                        -- 
            tmem_din <= signed(proc_0_data);
            proc_tmem_waddr <= signed(proc_0_addr);
        end block;
    end block;
    PROC_ARB_IMEM : block
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
                            if    (proc_imem_wstart = '1') then
                                proc_arb_state <= "01";
                            elsif (proc_imem_rstart = '1') then
                                proc_arb_state <= "10";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "01" =>
                            if    (proc_imem_wbusy = '1') then
                                proc_arb_state <= "01";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "10" =>
                            if    (proc_imem_rbusy = '1') then
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
        proc_imem_wready <= proc_arb_state(0);
        proc_imem_rvalid <= proc_arb_state(1);
        imem_oe <= '1' when (proc_arb_state(0) = '0') else '0';
        imem_we <= proc_imem_wvalid when (proc_arb_state(0) = '1') else '0';
        imem_address <= proc_imem_waddr when (proc_arb_state(0) = '1') else proc_imem_raddr;
    end block;
    PROC_ARB_BMEM : block
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
                            if    (proc_bmem_wstart = '1') then
                                proc_arb_state <= "01";
                            elsif (proc_bmem_rstart = '1') then
                                proc_arb_state <= "10";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "01" =>
                            if    (proc_bmem_wbusy = '1') then
                                proc_arb_state <= "01";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "10" =>
                            if    (proc_bmem_rbusy = '1') then
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
        proc_bmem_wready <= proc_arb_state(0);
        proc_bmem_rvalid <= proc_arb_state(1);
        bmem_oe <= '1' when (proc_arb_state(0) = '0') else '0';
        bmem_we <= proc_bmem_wvalid when (proc_arb_state(0) = '1') else '0';
        bmem_address <= proc_bmem_waddr when (proc_arb_state(0) = '1') else proc_bmem_raddr;
    end block;
    PROC_ARB_SMEM : block
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
                            if    (proc_smem_wstart = '1') then
                                proc_arb_state <= "01";
                            elsif (proc_smem_rstart = '1') then
                                proc_arb_state <= "10";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "01" =>
                            if    (proc_smem_wbusy = '1') then
                                proc_arb_state <= "01";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "10" =>
                            if    (proc_smem_rbusy = '1') then
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
        proc_smem_wready <= proc_arb_state(0);
        proc_smem_rvalid <= proc_arb_state(1);
        smem_oe <= '1' when (proc_arb_state(0) = '0') else '0';
        smem_we <= proc_smem_wvalid when (proc_arb_state(0) = '1') else '0';
        smem_address <= proc_smem_waddr when (proc_arb_state(0) = '1') else proc_smem_raddr;
    end block;
    PROC_ARB_LMEM : block
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
                            if    (proc_lmem_wstart = '1') then
                                proc_arb_state <= "01";
                            elsif (proc_lmem_rstart = '1') then
                                proc_arb_state <= "10";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "01" =>
                            if    (proc_lmem_wbusy = '1') then
                                proc_arb_state <= "01";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "10" =>
                            if    (proc_lmem_rbusy = '1') then
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
        proc_lmem_wready <= proc_arb_state(0);
        proc_lmem_rvalid <= proc_arb_state(1);
        lmem_oe <= '1' when (proc_arb_state(0) = '0') else '0';
        lmem_we <= proc_lmem_wvalid when (proc_arb_state(0) = '1') else '0';
        lmem_address <= proc_lmem_waddr when (proc_arb_state(0) = '1') else proc_lmem_raddr;
    end block;
    PROC_ARB_TMEM : block
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
                            if    (proc_tmem_wstart = '1') then
                                proc_arb_state <= "01";
                            elsif (proc_tmem_rstart = '1') then
                                proc_arb_state <= "10";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "01" =>
                            if    (proc_tmem_wbusy = '1') then
                                proc_arb_state <= "01";
                            else
                                proc_arb_state <= "00";
                            end if;
                        when "10" =>
                            if    (proc_tmem_rbusy = '1') then
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
        proc_tmem_wready <= proc_arb_state(0);
        proc_tmem_rvalid <= proc_arb_state(1);
        tmem_oe <= '1' when (proc_arb_state(0) = '0') else '0';
        tmem_we <= proc_tmem_wvalid when (proc_arb_state(0) = '1') else '0';
        tmem_address <= proc_tmem_waddr when (proc_arb_state(0) = '1') else proc_tmem_raddr;
    end block;
end RTL;
