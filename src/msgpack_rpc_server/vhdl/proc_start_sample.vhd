library ieee;
use     ieee.std_logic_1164.all;
library MsgPack;
use     MsgPack.MsgPack_RPC;
entity  PROC_START_SAMPLE is
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
end  PROC_START_SAMPLE;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library MsgPack;
use     MsgPack.MsgPack_Object;
use     MsgPack.MsgPack_RPC;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Main_No_Param;
use     MsgPack.MsgPack_RPC_Components.MsgPack_RPC_Method_Return_Nil;
architecture RTL of PROC_START_SAMPLE is
    signal    return_id         :  MsgPack_RPC.MsgID_Type;
    signal    return_error      :  std_logic;
    signal    return_start      :  std_logic;
    signal    return_done       :  std_logic;
    signal    return_busy       :  std_logic;
    signal    start_req         :  std_logic;
    signal    start_busy        :  std_logic;
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    CORE: MsgPack_RPC_Method_Main_No_Param           -- 
        generic map (                                -- 
            NAME            => NAME                , --
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
            RUN_REQ         => start_req           , -- Out :
            RUN_ACK         => start_busy          , -- In  :
            RUN_BUSY        => start_busy          , -- In  :
            RUN_DONE        => '0'                 , -- In  :
            RUNNING         => open                , -- Out :
            RET_ID          => PROC_RES_ID         , -- Out :
            RET_ERROR       => return_error        , -- Out :
            RET_START       => return_start        , -- Out :
            RET_DONE        => return_done         , -- Out :
            RET_BUSY        => return_busy           -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    RET : MsgPack_RPC_Method_Return_Nil              -- 
        port map (                                   -- 
            CLK             => CLK                 , -- In  :
            RST             => RST                 , -- In  :
            CLR             => CLR                 , -- In  :
            RET_ERROR       => return_error        , -- In  :
            RET_START       => return_start        , -- In  :
            RET_DONE        => return_done         , -- In  :
            RET_BUSY        => return_busy         , -- Out :
            RES_CODE        => PROC_RES_CODE       , -- Out :
            RES_VALID       => PROC_RES_VALID      , -- Out :
            RES_LAST        => PROC_RES_LAST       , -- Out :
            RES_READY       => PROC_RES_READY        -- In  :
        );                                           -- 
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if (RST = '1') then
                start_busy <= '0';
        elsif (CLK'event and CLK = '1') then
            if (CLR = '1') then
                start_busy <= '0';
            else
                start_busy <= start_req;
            end if;
        end if;
    end process;
end RTL;
