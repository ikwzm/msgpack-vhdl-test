library ieee;
use     ieee.std_logic_1164.all;
library MsgPack;
use     MsgPack.MsgPack_RPC;
entity  PROC_LOOP_SAMPLE is
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
end  PROC_LOOP_SAMPLE;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_KVMap_Components.MsgPack_KVMap_Key_Compare;
use     MsgPack.MsgPack_Object_Components.MsgPack_Object_Code_Reducer;
architecture RTL of PROC_LOOP_SAMPLE is
    constant  outlet_shift   :  MsgPack_RPC.Shift_Type := (others => '1');
    signal    outlet_busy    :  std_logic;
    signal    resp_code      :  MsgPack_RPC.Code_Type;
    signal    resp_last      :  std_logic;
    signal    resp_valid     :  std_logic;
    signal    resp_ready     :  std_logic;
    type      STATE_TYPE     is (IDLE_STATE, PARAM_STATE, BUSY_STATE);
    signal    curr_state     :  STATE_TYPE;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    MATCH: MsgPack_KVMap_Key_Compare                     -- 
        generic map (                                    -- 
            CODE_WIDTH      => MsgPack_RPC.Code_Length , -- 
            I_MAX_PHASE     => MATCH_PHASE             , --
            KEYWORD         => NAME                      --
        )                                                -- 
        port map (                                       -- 
            CLK             => CLK                     , -- 
            RST             => RST                     , -- 
            CLR             => CLR                     , -- 
            I_CODE          => MATCH_CODE              , -- 
            I_REQ_PHASE     => MATCH_REQ               , -- 
            MATCH           => MATCH_OK                , -- 
            MISMATCH        => MATCH_NOT               , -- 
            SHIFT           => MATCH_SHIFT               -- 
        );                                               -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    FIFO: MsgPack_Object_Code_Reducer                    -- 
        generic map (                                    -- 
            I_WIDTH         => MsgPack_RPC.Code_Length , -- 
            O_WIDTH         => MsgPack_RPC.Code_Length , -- 
            O_VALID_SIZE    => MsgPack_RPC.Code_Length , -- 
            QUEUE_SIZE      => 0                         -- 
        )                                                -- 
        port map (                                       -- 
            CLK             => CLK                     , -- In  :
            RST             => RST                     , -- In  :
            CLR             => CLR                     , -- In  :
            DONE            => '0'                     , -- In  :
            BUSY            => outlet_busy             , -- Out :
            I_ENABLE        => '1'                     , -- In  :
            I_CODE          => resp_code               , -- In  :
            I_DONE          => resp_last               , -- In  :
            I_VALID         => resp_valid              , -- In  :
            I_READY         => resp_ready              , -- Out :
            O_ENABLE        => '1'                     , -- In  :
            O_CODE          => PROC_RES_CODE           , -- Out :
            O_DONE          => PROC_RES_LAST           , -- Out :
            O_VALID         => PROC_RES_VALID          , -- Out :
            O_READY         => PROC_RES_READY          , -- In  :
            O_SHIFT         => outlet_shift              -- In  :
        );                                               -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if (RST = '1') then
                curr_state  <= IDLE_STATE;
                PROC_RES_ID <= MsgPack_RPC.MsgID_Null;
        elsif (CLK'event and CLK = '1') then
            if (CLR = '1') then
                curr_state  <= IDLE_STATE;
                PROC_RES_ID <= MsgPack_RPC.MsgID_Null;
            else
                case curr_state is
                    when IDLE_STATE =>
                        if (PROC_REQ = '1') then
                            curr_state  <= PARAM_STATE;
                            PROC_RES_ID <= PROC_REQ_ID;
                        else
                            curr_state  <= IDLE_STATE;
                        end if;
                    when PARAM_STATE =>
                        if (resp_valid = '1' and resp_ready = '1' and resp_last = '1') then
                            curr_state  <= BUSY_STATE;
                        else
                            curr_state  <= PARAM_STATE;
                        end if;
                    when BUSY_STATE =>
                        if (outlet_busy = '0') then
                            curr_state  <= IDLE_STATE;
                        else
                            curr_state  <= BUSY_STATE;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process;
    process (curr_state, resp_ready, PROC_REQ, PARAM_VALID, PARAM_LAST, PARAM_CODE)
    begin
        if    (curr_state = IDLE_STATE  and PROC_REQ    = '1') then
            resp_valid <= '1';
            PARAM_SHIFT <= (others => '0');
        elsif (curr_state = PARAM_STATE and PARAM_VALID = '1') and
           ((PARAM_CODE(PARAM_CODE'high).valid = '1') or
            (PARAM_CODE(PARAM_CODE'low ).valid = '1' and PARAM_LAST = '1')) then
            resp_valid <= '1';
            for i in PARAM_SHIFT'range loop
                PARAM_SHIFT(i) <= PARAM_CODE(i).valid and resp_ready;
            end loop;
        else
            resp_valid  <= '0';
            PARAM_SHIFT <= (others => '0');
        end if;
    end process;
    resp_last   <= PARAM_LAST;
    resp_code   <= PARAM_CODE when (curr_state = PARAM_STATE) else
                   MsgPack_Object.New_Code_Vector_Nil(MsgPack_RPC.Code_Length);
    PROC_BUSY   <= '1' when (curr_state = PARAM_STATE or curr_state = BUSY_STATE) else '0';
end RTL;
