library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Sample is
  port (
    clk : in std_logic;
    reset : in std_logic;
    ivar_in : in signed(32-1 downto 0);
    ivar_we : in std_logic;
    ivar_out : out signed(32-1 downto 0);
    imem_address : in signed(32-1 downto 0);
    imem_we : in std_logic;
    imem_oe : in std_logic;
    imem_din : in signed(32-1 downto 0);
    imem_dout : out signed(32-1 downto 0);
    imem_length : out signed(32-1 downto 0);
    bvar_in : in signed(8-1 downto 0);
    bvar_we : in std_logic;
    bvar_out : out signed(8-1 downto 0);
    bmem_address : in signed(32-1 downto 0);
    bmem_we : in std_logic;
    bmem_oe : in std_logic;
    bmem_din : in signed(8-1 downto 0);
    bmem_dout : out signed(8-1 downto 0);
    bmem_length : out signed(32-1 downto 0);
    svar_in : in signed(16-1 downto 0);
    svar_we : in std_logic;
    svar_out : out signed(16-1 downto 0);
    smem_address : in signed(32-1 downto 0);
    smem_we : in std_logic;
    smem_oe : in std_logic;
    smem_din : in signed(16-1 downto 0);
    smem_dout : out signed(16-1 downto 0);
    smem_length : out signed(32-1 downto 0);
    lvar_in : in signed(64-1 downto 0);
    lvar_we : in std_logic;
    lvar_out : out signed(64-1 downto 0);
    lmem_address : in signed(32-1 downto 0);
    lmem_we : in std_logic;
    lmem_oe : in std_logic;
    lmem_din : in signed(64-1 downto 0);
    lmem_dout : out signed(64-1 downto 0);
    lmem_length : out signed(32-1 downto 0);
    tvar_in : in std_logic;
    tvar_we : in std_logic;
    tvar_out : out std_logic;
    tmem_address : in signed(32-1 downto 0);
    tmem_we : in std_logic;
    tmem_oe : in std_logic;
    tmem_din : in signed(1-1 downto 0);
    tmem_dout : out signed(1-1 downto 0);
    tmem_length : out signed(32-1 downto 0);
    m1_p : in std_logic;
    m2_b : in signed(8-1 downto 0);
    m2_i : in signed(32-1 downto 0);
    m3_s : in signed(16-1 downto 0);
    m3_i : in signed(32-1 downto 0);
    m4_a3 : in signed(8-1 downto 0);
    m4_a2 : in signed(16-1 downto 0);
    m4_a1 : in signed(32-1 downto 0);
    m4_a0 : in signed(64-1 downto 0);
    m0_busy : out std_logic;
    m0_req : in std_logic;
    m1_return : out std_logic;
    m1_busy : out std_logic;
    m1_req : in std_logic;
    m2_return : out signed(8-1 downto 0);
    m2_busy : out std_logic;
    m2_req : in std_logic;
    m3_return : out signed(16-1 downto 0);
    m3_busy : out std_logic;
    m3_req : in std_logic;
    m4_return : out signed(64-1 downto 0);
    m4_busy : out std_logic;
    m4_req : in std_logic
  );
end Sample;

architecture RTL of Sample is

  attribute mark_debug : string;
  attribute keep : string;
  attribute S : string;

  component dualportram
    generic (
      WIDTH : integer := 32;
      DEPTH : integer := 10;
      WORDS : integer := 1024
    );
    port (
      clk : in std_logic;
      reset : in std_logic;
      length : out signed(31 downto 0);
      address : in signed(31 downto 0);
      din : in signed(WIDTH-1 downto 0);
      dout : out signed(WIDTH-1 downto 0);
      we : in std_logic;
      oe : in std_logic;
      address_b : in signed(31 downto 0);
      din_b : in signed(WIDTH-1 downto 0);
      dout_b : out signed(WIDTH-1 downto 0);
      we_b : in std_logic;
      oe_b : in std_logic
    );
  end component dualportram;

  signal clk_sig : std_logic := '0';
  signal reset_sig : std_logic := '0';
  signal ivar_in_sig : signed(32-1 downto 0) := (others => '0');
  signal ivar_we_sig : std_logic := '0';
  signal ivar_out_sig : signed(32-1 downto 0) := (others => '0');
  signal imem_address_sig : signed(32-1 downto 0) := (others => '0');
  signal imem_we_sig : std_logic := '0';
  signal imem_oe_sig : std_logic := '0';
  signal imem_din_sig : signed(32-1 downto 0) := (others => '0');
  signal imem_dout_sig : signed(32-1 downto 0) := (others => '0');
  signal imem_length_sig : signed(32-1 downto 0) := (others => '0');
  signal bvar_in_sig : signed(8-1 downto 0) := (others => '0');
  signal bvar_we_sig : std_logic := '0';
  signal bvar_out_sig : signed(8-1 downto 0) := (others => '0');
  signal bmem_address_sig : signed(32-1 downto 0) := (others => '0');
  signal bmem_we_sig : std_logic := '0';
  signal bmem_oe_sig : std_logic := '0';
  signal bmem_din_sig : signed(8-1 downto 0) := (others => '0');
  signal bmem_dout_sig : signed(8-1 downto 0) := (others => '0');
  signal bmem_length_sig : signed(32-1 downto 0) := (others => '0');
  signal svar_in_sig : signed(16-1 downto 0) := (others => '0');
  signal svar_we_sig : std_logic := '0';
  signal svar_out_sig : signed(16-1 downto 0) := (others => '0');
  signal smem_address_sig : signed(32-1 downto 0) := (others => '0');
  signal smem_we_sig : std_logic := '0';
  signal smem_oe_sig : std_logic := '0';
  signal smem_din_sig : signed(16-1 downto 0) := (others => '0');
  signal smem_dout_sig : signed(16-1 downto 0) := (others => '0');
  signal smem_length_sig : signed(32-1 downto 0) := (others => '0');
  signal lvar_in_sig : signed(64-1 downto 0) := (others => '0');
  signal lvar_we_sig : std_logic := '0';
  signal lvar_out_sig : signed(64-1 downto 0) := (others => '0');
  signal lmem_address_sig : signed(32-1 downto 0) := (others => '0');
  signal lmem_we_sig : std_logic := '0';
  signal lmem_oe_sig : std_logic := '0';
  signal lmem_din_sig : signed(64-1 downto 0) := (others => '0');
  signal lmem_dout_sig : signed(64-1 downto 0) := (others => '0');
  signal lmem_length_sig : signed(32-1 downto 0) := (others => '0');
  signal tvar_in_sig : std_logic := '0';
  signal tvar_we_sig : std_logic := '0';
  signal tvar_out_sig : std_logic := '0';
  signal tmem_address_sig : signed(32-1 downto 0) := (others => '0');
  signal tmem_we_sig : std_logic := '0';
  signal tmem_oe_sig : std_logic := '0';
  signal tmem_din_sig : signed(1-1 downto 0) := (others => '0');
  signal tmem_dout_sig : signed(1-1 downto 0) := (others => '0');
  signal tmem_length_sig : signed(32-1 downto 0) := (others => '0');
  signal m1_p_sig : std_logic := '0';
  signal m2_b_sig : signed(8-1 downto 0) := (others => '0');
  signal m2_i_sig : signed(32-1 downto 0) := (others => '0');
  signal m3_s_sig : signed(16-1 downto 0) := (others => '0');
  signal m3_i_sig : signed(32-1 downto 0) := (others => '0');
  signal m4_a3_sig : signed(8-1 downto 0) := (others => '0');
  signal m4_a2_sig : signed(16-1 downto 0) := (others => '0');
  signal m4_a1_sig : signed(32-1 downto 0) := (others => '0');
  signal m4_a0_sig : signed(64-1 downto 0) := (others => '0');
  signal m0_busy_sig : std_logic := '1';
  signal m0_req_sig : std_logic := '0';
  signal m1_return_sig : std_logic := '0';
  signal m1_busy_sig : std_logic := '1';
  signal m1_req_sig : std_logic := '0';
  signal m2_return_sig : signed(8-1 downto 0) := (others => '0');
  signal m2_busy_sig : std_logic := '1';
  signal m2_req_sig : std_logic := '0';
  signal m3_return_sig : signed(16-1 downto 0) := (others => '0');
  signal m3_busy_sig : std_logic := '1';
  signal m3_req_sig : std_logic := '0';
  signal m4_return_sig : signed(64-1 downto 0) := (others => '0');
  signal m4_busy_sig : std_logic := '1';
  signal m4_req_sig : std_logic := '0';

  signal class_ivar_0000 : signed(32-1 downto 0) := (others => '0');
  signal class_ivar_0000_mux : signed(32-1 downto 0) := (others => '0');
  signal tmp_0001 : signed(32-1 downto 0) := (others => '0');
  signal class_imem_0001_clk : std_logic := '0';
  signal class_imem_0001_reset : std_logic := '0';
  signal class_imem_0001_length : signed(32-1 downto 0) := (others => '0');
  signal class_imem_0001_address : signed(32-1 downto 0) := (others => '0');
  signal class_imem_0001_din : signed(32-1 downto 0) := (others => '0');
  signal class_imem_0001_dout : signed(32-1 downto 0) := (others => '0');
  signal class_imem_0001_we : std_logic := '0';
  signal class_imem_0001_oe : std_logic := '0';
  signal class_imem_0001_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_imem_0001_din_b : signed(32-1 downto 0) := (others => '0');
  signal class_imem_0001_dout_b : signed(32-1 downto 0) := (others => '0');
  signal class_imem_0001_we_b : std_logic := '0';
  signal class_imem_0001_oe_b : std_logic := '0';
  signal class_bvar_0004 : signed(8-1 downto 0) := (others => '0');
  signal class_bvar_0004_mux : signed(8-1 downto 0) := (others => '0');
  signal tmp_0002 : signed(8-1 downto 0) := (others => '0');
  signal class_bmem_0005_clk : std_logic := '0';
  signal class_bmem_0005_reset : std_logic := '0';
  signal class_bmem_0005_length : signed(32-1 downto 0) := (others => '0');
  signal class_bmem_0005_address : signed(32-1 downto 0) := (others => '0');
  signal class_bmem_0005_din : signed(8-1 downto 0) := (others => '0');
  signal class_bmem_0005_dout : signed(8-1 downto 0) := (others => '0');
  signal class_bmem_0005_we : std_logic := '0';
  signal class_bmem_0005_oe : std_logic := '0';
  signal class_bmem_0005_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_bmem_0005_din_b : signed(8-1 downto 0) := (others => '0');
  signal class_bmem_0005_dout_b : signed(8-1 downto 0) := (others => '0');
  signal class_bmem_0005_we_b : std_logic := '0';
  signal class_bmem_0005_oe_b : std_logic := '0';
  signal class_svar_0008 : signed(16-1 downto 0) := (others => '0');
  signal class_svar_0008_mux : signed(16-1 downto 0) := (others => '0');
  signal tmp_0003 : signed(16-1 downto 0) := (others => '0');
  signal class_smem_0009_clk : std_logic := '0';
  signal class_smem_0009_reset : std_logic := '0';
  signal class_smem_0009_length : signed(32-1 downto 0) := (others => '0');
  signal class_smem_0009_address : signed(32-1 downto 0) := (others => '0');
  signal class_smem_0009_din : signed(16-1 downto 0) := (others => '0');
  signal class_smem_0009_dout : signed(16-1 downto 0) := (others => '0');
  signal class_smem_0009_we : std_logic := '0';
  signal class_smem_0009_oe : std_logic := '0';
  signal class_smem_0009_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_smem_0009_din_b : signed(16-1 downto 0) := (others => '0');
  signal class_smem_0009_dout_b : signed(16-1 downto 0) := (others => '0');
  signal class_smem_0009_we_b : std_logic := '0';
  signal class_smem_0009_oe_b : std_logic := '0';
  signal class_lvar_0012 : signed(64-1 downto 0) := (others => '0');
  signal class_lvar_0012_mux : signed(64-1 downto 0) := (others => '0');
  signal tmp_0004 : signed(64-1 downto 0) := (others => '0');
  signal class_lmem_0013_clk : std_logic := '0';
  signal class_lmem_0013_reset : std_logic := '0';
  signal class_lmem_0013_length : signed(32-1 downto 0) := (others => '0');
  signal class_lmem_0013_address : signed(32-1 downto 0) := (others => '0');
  signal class_lmem_0013_din : signed(64-1 downto 0) := (others => '0');
  signal class_lmem_0013_dout : signed(64-1 downto 0) := (others => '0');
  signal class_lmem_0013_we : std_logic := '0';
  signal class_lmem_0013_oe : std_logic := '0';
  signal class_lmem_0013_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_lmem_0013_din_b : signed(64-1 downto 0) := (others => '0');
  signal class_lmem_0013_dout_b : signed(64-1 downto 0) := (others => '0');
  signal class_lmem_0013_we_b : std_logic := '0';
  signal class_lmem_0013_oe_b : std_logic := '0';
  signal class_tvar_0016 : std_logic := '0';
  signal class_tvar_0016_mux : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal class_tmem_0017_clk : std_logic := '0';
  signal class_tmem_0017_reset : std_logic := '0';
  signal class_tmem_0017_length : signed(32-1 downto 0) := (others => '0');
  signal class_tmem_0017_address : signed(32-1 downto 0) := (others => '0');
  signal class_tmem_0017_din : signed(1-1 downto 0) := (others => '0');
  signal class_tmem_0017_dout : signed(1-1 downto 0) := (others => '0');
  signal class_tmem_0017_we : std_logic := '0';
  signal class_tmem_0017_oe : std_logic := '0';
  signal class_tmem_0017_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_tmem_0017_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_tmem_0017_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_tmem_0017_we_b : std_logic := '0';
  signal class_tmem_0017_oe_b : std_logic := '0';
  signal m1_p_0020 : std_logic := '0';
  signal m1_p_local : std_logic := '0';
  signal binary_expr_00021 : std_logic := '0';
  signal m2_b_0022 : signed(8-1 downto 0) := (others => '0');
  signal m2_b_local : signed(8-1 downto 0) := (others => '0');
  signal m2_i_0023 : signed(32-1 downto 0) := (others => '0');
  signal m2_i_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00024 : signed(8-1 downto 0) := (others => '0');
  signal array_access_00025 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00026 : signed(8-1 downto 0) := (others => '0');
  signal cast_expr_00027 : signed(8-1 downto 0) := (others => '0');
  signal m3_s_0028 : signed(16-1 downto 0) := (others => '0');
  signal m3_s_local : signed(16-1 downto 0) := (others => '0');
  signal m3_i_0029 : signed(32-1 downto 0) := (others => '0');
  signal m3_i_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00030 : signed(16-1 downto 0) := (others => '0');
  signal array_access_00031 : signed(16-1 downto 0) := (others => '0');
  signal binary_expr_00032 : signed(16-1 downto 0) := (others => '0');
  signal cast_expr_00033 : signed(16-1 downto 0) := (others => '0');
  signal m4_a3_0034 : signed(8-1 downto 0) := (others => '0');
  signal m4_a3_local : signed(8-1 downto 0) := (others => '0');
  signal m4_a2_0035 : signed(16-1 downto 0) := (others => '0');
  signal m4_a2_local : signed(16-1 downto 0) := (others => '0');
  signal m4_a1_0036 : signed(32-1 downto 0) := (others => '0');
  signal m4_a1_local : signed(32-1 downto 0) := (others => '0');
  signal m4_a0_0037 : signed(64-1 downto 0) := (others => '0');
  signal m4_a0_local : signed(64-1 downto 0) := (others => '0');
  signal cast_expr_00038 : signed(16-1 downto 0) := (others => '0');
  signal binary_expr_00039 : signed(16-1 downto 0) := (others => '0');
  signal cast_expr_00040 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00041 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00042 : signed(64-1 downto 0) := (others => '0');
  signal binary_expr_00043 : signed(64-1 downto 0) := (others => '0');
  signal cast_expr_00044 : signed(64-1 downto 0) := (others => '0');
  signal m0_req_flag : std_logic := '0';
  signal m0_req_local : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal m1_req_flag : std_logic := '0';
  signal m1_req_local : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal m2_req_flag : std_logic := '0';
  signal m2_req_local : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal m3_req_flag : std_logic := '0';
  signal m3_req_local : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal m4_req_flag : std_logic := '0';
  signal m4_req_local : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  type Type_m0_method is (
    m0_method_IDLE,
    m0_method_S_0000,
    m0_method_S_0001,
    m0_method_S_0002  
  );
  signal m0_method : Type_m0_method := m0_method_IDLE;
  signal m0_method_delay : signed(32-1 downto 0) := (others => '0');
  signal m0_req_flag_d : std_logic := '0';
  signal m0_req_flag_edge : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal tmp_0012 : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : std_logic := '0';
  type Type_m1_method is (
    m1_method_IDLE,
    m1_method_S_0000,
    m1_method_S_0001,
    m1_method_S_0002,
    m1_method_S_0003,
    m1_method_S_0004  
  );
  signal m1_method : Type_m1_method := m1_method_IDLE;
  signal m1_method_delay : signed(32-1 downto 0) := (others => '0');
  signal m1_req_flag_d : std_logic := '0';
  signal m1_req_flag_edge : std_logic := '0';
  signal tmp_0019 : std_logic := '0';
  signal tmp_0020 : std_logic := '0';
  signal tmp_0021 : std_logic := '0';
  signal tmp_0022 : std_logic := '0';
  signal tmp_0023 : std_logic := '0';
  signal tmp_0024 : std_logic := '0';
  signal tmp_0025 : std_logic := '0';
  signal tmp_0026 : std_logic := '0';
  signal tmp_0027 : std_logic := '0';
  signal tmp_0028 : std_logic := '0';
  type Type_m2_method is (
    m2_method_IDLE,
    m2_method_S_0000,
    m2_method_S_0001,
    m2_method_S_0002,
    m2_method_S_0003,
    m2_method_S_0004,
    m2_method_S_0005,
    m2_method_S_0006,
    m2_method_S_0007  
  );
  signal m2_method : Type_m2_method := m2_method_IDLE;
  signal m2_method_delay : signed(32-1 downto 0) := (others => '0');
  signal m2_req_flag_d : std_logic := '0';
  signal m2_req_flag_edge : std_logic := '0';
  signal tmp_0029 : std_logic := '0';
  signal tmp_0030 : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : signed(8-1 downto 0) := (others => '0');
  signal tmp_0038 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0039 : signed(8-1 downto 0) := (others => '0');
  signal tmp_0040 : signed(8-1 downto 0) := (others => '0');
  type Type_m3_method is (
    m3_method_IDLE,
    m3_method_S_0000,
    m3_method_S_0001,
    m3_method_S_0002,
    m3_method_S_0003,
    m3_method_S_0004,
    m3_method_S_0005,
    m3_method_S_0006,
    m3_method_S_0007  
  );
  signal m3_method : Type_m3_method := m3_method_IDLE;
  signal m3_method_delay : signed(32-1 downto 0) := (others => '0');
  signal m3_req_flag_d : std_logic := '0';
  signal m3_req_flag_edge : std_logic := '0';
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : std_logic := '0';
  signal tmp_0045 : std_logic := '0';
  signal tmp_0046 : std_logic := '0';
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : signed(16-1 downto 0) := (others => '0');
  signal tmp_0050 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0051 : signed(16-1 downto 0) := (others => '0');
  signal tmp_0052 : signed(16-1 downto 0) := (others => '0');
  type Type_m4_method is (
    m4_method_IDLE,
    m4_method_S_0000,
    m4_method_S_0001,
    m4_method_S_0002,
    m4_method_S_0003,
    m4_method_S_0004,
    m4_method_S_0005,
    m4_method_S_0006,
    m4_method_S_0007,
    m4_method_S_0008,
    m4_method_S_0009,
    m4_method_S_0010  
  );
  signal m4_method : Type_m4_method := m4_method_IDLE;
  signal m4_method_delay : signed(32-1 downto 0) := (others => '0');
  signal m4_req_flag_d : std_logic := '0';
  signal m4_req_flag_edge : std_logic := '0';
  signal tmp_0053 : std_logic := '0';
  signal tmp_0054 : std_logic := '0';
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal tmp_0061 : signed(8-1 downto 0) := (others => '0');
  signal tmp_0062 : signed(16-1 downto 0) := (others => '0');
  signal tmp_0063 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0064 : signed(64-1 downto 0) := (others => '0');
  signal tmp_0065 : signed(16-1 downto 0) := (others => '0');
  signal tmp_0066 : signed(16-1 downto 0) := (others => '0');
  signal tmp_0067 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0068 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0069 : signed(64-1 downto 0) := (others => '0');
  signal tmp_0070 : signed(64-1 downto 0) := (others => '0');

begin

  clk_sig <= clk;
  reset_sig <= reset;
  ivar_in_sig <= ivar_in;
  ivar_we_sig <= ivar_we;
  ivar_out <= ivar_out_sig;
  ivar_out_sig <= class_ivar_0000;

  imem_address_sig <= imem_address;
  imem_we_sig <= imem_we;
  imem_oe_sig <= imem_oe;
  imem_din_sig <= imem_din;
  imem_dout <= imem_dout_sig;
  imem_dout_sig <= class_imem_0001_dout;

  imem_length <= imem_length_sig;
  imem_length_sig <= class_imem_0001_length;

  bvar_in_sig <= bvar_in;
  bvar_we_sig <= bvar_we;
  bvar_out <= bvar_out_sig;
  bvar_out_sig <= class_bvar_0004;

  bmem_address_sig <= bmem_address;
  bmem_we_sig <= bmem_we;
  bmem_oe_sig <= bmem_oe;
  bmem_din_sig <= bmem_din;
  bmem_dout <= bmem_dout_sig;
  bmem_dout_sig <= class_bmem_0005_dout;

  bmem_length <= bmem_length_sig;
  bmem_length_sig <= class_bmem_0005_length;

  svar_in_sig <= svar_in;
  svar_we_sig <= svar_we;
  svar_out <= svar_out_sig;
  svar_out_sig <= class_svar_0008;

  smem_address_sig <= smem_address;
  smem_we_sig <= smem_we;
  smem_oe_sig <= smem_oe;
  smem_din_sig <= smem_din;
  smem_dout <= smem_dout_sig;
  smem_dout_sig <= class_smem_0009_dout;

  smem_length <= smem_length_sig;
  smem_length_sig <= class_smem_0009_length;

  lvar_in_sig <= lvar_in;
  lvar_we_sig <= lvar_we;
  lvar_out <= lvar_out_sig;
  lvar_out_sig <= class_lvar_0012;

  lmem_address_sig <= lmem_address;
  lmem_we_sig <= lmem_we;
  lmem_oe_sig <= lmem_oe;
  lmem_din_sig <= lmem_din;
  lmem_dout <= lmem_dout_sig;
  lmem_dout_sig <= class_lmem_0013_dout;

  lmem_length <= lmem_length_sig;
  lmem_length_sig <= class_lmem_0013_length;

  tvar_in_sig <= tvar_in;
  tvar_we_sig <= tvar_we;
  tvar_out <= tvar_out_sig;
  tvar_out_sig <= class_tvar_0016;

  tmem_address_sig <= tmem_address;
  tmem_we_sig <= tmem_we;
  tmem_oe_sig <= tmem_oe;
  tmem_din_sig <= tmem_din;
  tmem_dout <= tmem_dout_sig;
  tmem_dout_sig <= class_tmem_0017_dout;

  tmem_length <= tmem_length_sig;
  tmem_length_sig <= class_tmem_0017_length;

  m1_p_sig <= m1_p;
  m2_b_sig <= m2_b;
  m2_i_sig <= m2_i;
  m3_s_sig <= m3_s;
  m3_i_sig <= m3_i;
  m4_a3_sig <= m4_a3;
  m4_a2_sig <= m4_a2;
  m4_a1_sig <= m4_a1;
  m4_a0_sig <= m4_a0;
  m0_busy <= m0_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m0_busy_sig <= '1';
      else
        if m0_method = m0_method_S_0000 then
          m0_busy_sig <= '0';
        elsif m0_method = m0_method_S_0001 then
          m0_busy_sig <= tmp_0014;
        end if;
      end if;
    end if;
  end process;

  m0_req_sig <= m0_req;
  m1_return <= m1_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m1_return_sig <= '0';
      else
        if m1_method = m1_method_S_0003 then
          m1_return_sig <= binary_expr_00021;
        end if;
      end if;
    end if;
  end process;

  m1_busy <= m1_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m1_busy_sig <= '1';
      else
        if m1_method = m1_method_S_0000 then
          m1_busy_sig <= '0';
        elsif m1_method = m1_method_S_0001 then
          m1_busy_sig <= tmp_0022;
        end if;
      end if;
    end if;
  end process;

  m1_req_sig <= m1_req;
  m2_return <= m2_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m2_return_sig <= (others => '0');
      else
        if m2_method = m2_method_S_0006 then
          m2_return_sig <= cast_expr_00027;
        end if;
      end if;
    end if;
  end process;

  m2_busy <= m2_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m2_busy_sig <= '1';
      else
        if m2_method = m2_method_S_0000 then
          m2_busy_sig <= '0';
        elsif m2_method = m2_method_S_0001 then
          m2_busy_sig <= tmp_0032;
        end if;
      end if;
    end if;
  end process;

  m2_req_sig <= m2_req;
  m3_return <= m3_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m3_return_sig <= (others => '0');
      else
        if m3_method = m3_method_S_0006 then
          m3_return_sig <= cast_expr_00033;
        end if;
      end if;
    end if;
  end process;

  m3_busy <= m3_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m3_busy_sig <= '1';
      else
        if m3_method = m3_method_S_0000 then
          m3_busy_sig <= '0';
        elsif m3_method = m3_method_S_0001 then
          m3_busy_sig <= tmp_0044;
        end if;
      end if;
    end if;
  end process;

  m3_req_sig <= m3_req;
  m4_return <= m4_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m4_return_sig <= (others => '0');
      else
        if m4_method = m4_method_S_0009 then
          m4_return_sig <= cast_expr_00044;
        end if;
      end if;
    end if;
  end process;

  m4_busy <= m4_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m4_busy_sig <= '1';
      else
        if m4_method = m4_method_S_0000 then
          m4_busy_sig <= '0';
        elsif m4_method = m4_method_S_0001 then
          m4_busy_sig <= tmp_0056;
        end if;
      end if;
    end if;
  end process;

  m4_req_sig <= m4_req;

  -- expressions
  tmp_0001 <= ivar_in_sig when ivar_we_sig = '1' else class_ivar_0000;
  tmp_0002 <= bvar_in_sig when bvar_we_sig = '1' else class_bvar_0004;
  tmp_0003 <= svar_in_sig when svar_we_sig = '1' else class_svar_0008;
  tmp_0004 <= lvar_in_sig when lvar_we_sig = '1' else class_lvar_0012;
  tmp_0005 <= tvar_in_sig when tvar_we_sig = '1' else class_tvar_0016;
  tmp_0006 <= m0_req_local or m0_req_sig;
  tmp_0007 <= m1_req_local or m1_req_sig;
  tmp_0008 <= m2_req_local or m2_req_sig;
  tmp_0009 <= m3_req_local or m3_req_sig;
  tmp_0010 <= m4_req_local or m4_req_sig;
  tmp_0011 <= not m0_req_flag_d;
  tmp_0012 <= m0_req_flag and tmp_0011;
  tmp_0013 <= m0_req_flag or m0_req_flag_d;
  tmp_0014 <= m0_req_flag or m0_req_flag_d;
  tmp_0015 <= '1' when m0_method /= m0_method_S_0000 else '0';
  tmp_0016 <= '1' when m0_method /= m0_method_S_0001 else '0';
  tmp_0017 <= tmp_0016 and m0_req_flag_edge;
  tmp_0018 <= tmp_0015 and tmp_0017;
  tmp_0019 <= not m1_req_flag_d;
  tmp_0020 <= m1_req_flag and tmp_0019;
  tmp_0021 <= m1_req_flag or m1_req_flag_d;
  tmp_0022 <= m1_req_flag or m1_req_flag_d;
  tmp_0023 <= '1' when m1_method /= m1_method_S_0000 else '0';
  tmp_0024 <= '1' when m1_method /= m1_method_S_0001 else '0';
  tmp_0025 <= tmp_0024 and m1_req_flag_edge;
  tmp_0026 <= tmp_0023 and tmp_0025;
  tmp_0027 <= m1_p_sig when m1_req_sig = '1' else m1_p_local;
  tmp_0028 <= m1_p_0020 and class_tvar_0016;
  tmp_0029 <= not m2_req_flag_d;
  tmp_0030 <= m2_req_flag and tmp_0029;
  tmp_0031 <= m2_req_flag or m2_req_flag_d;
  tmp_0032 <= m2_req_flag or m2_req_flag_d;
  tmp_0033 <= '1' when m2_method /= m2_method_S_0000 else '0';
  tmp_0034 <= '1' when m2_method /= m2_method_S_0001 else '0';
  tmp_0035 <= tmp_0034 and m2_req_flag_edge;
  tmp_0036 <= tmp_0033 and tmp_0035;
  tmp_0037 <= m2_b_sig when m2_req_sig = '1' else m2_b_local;
  tmp_0038 <= m2_i_sig when m2_req_sig = '1' else m2_i_local;
  tmp_0039 <= m2_b_0022 + class_bvar_0004;
  tmp_0040 <= binary_expr_00024 + array_access_00025;
  tmp_0041 <= not m3_req_flag_d;
  tmp_0042 <= m3_req_flag and tmp_0041;
  tmp_0043 <= m3_req_flag or m3_req_flag_d;
  tmp_0044 <= m3_req_flag or m3_req_flag_d;
  tmp_0045 <= '1' when m3_method /= m3_method_S_0000 else '0';
  tmp_0046 <= '1' when m3_method /= m3_method_S_0001 else '0';
  tmp_0047 <= tmp_0046 and m3_req_flag_edge;
  tmp_0048 <= tmp_0045 and tmp_0047;
  tmp_0049 <= m3_s_sig when m3_req_sig = '1' else m3_s_local;
  tmp_0050 <= m3_i_sig when m3_req_sig = '1' else m3_i_local;
  tmp_0051 <= m3_s_0028 + class_svar_0008;
  tmp_0052 <= binary_expr_00030 + array_access_00031;
  tmp_0053 <= not m4_req_flag_d;
  tmp_0054 <= m4_req_flag and tmp_0053;
  tmp_0055 <= m4_req_flag or m4_req_flag_d;
  tmp_0056 <= m4_req_flag or m4_req_flag_d;
  tmp_0057 <= '1' when m4_method /= m4_method_S_0000 else '0';
  tmp_0058 <= '1' when m4_method /= m4_method_S_0001 else '0';
  tmp_0059 <= tmp_0058 and m4_req_flag_edge;
  tmp_0060 <= tmp_0057 and tmp_0059;
  tmp_0061 <= m4_a3_sig when m4_req_sig = '1' else m4_a3_local;
  tmp_0062 <= m4_a2_sig when m4_req_sig = '1' else m4_a2_local;
  tmp_0063 <= m4_a1_sig when m4_req_sig = '1' else m4_a1_local;
  tmp_0064 <= m4_a0_sig when m4_req_sig = '1' else m4_a0_local;
  tmp_0065 <= (16-1 downto 8 => m4_a3_0034(7)) & m4_a3_0034;
  tmp_0066 <= cast_expr_00038 + m4_a2_0035;
  tmp_0067 <= (32-1 downto 16 => binary_expr_00039(15)) & binary_expr_00039;
  tmp_0068 <= cast_expr_00040 + m4_a1_0036;
  tmp_0069 <= (64-1 downto 32 => binary_expr_00041(31)) & binary_expr_00041;
  tmp_0070 <= cast_expr_00042 + m4_a0_0037;

  -- sequencers
  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m0_method <= m0_method_IDLE;
        m0_method_delay <= (others => '0');
      else
        case (m0_method) is
          when m0_method_IDLE => 
            m0_method <= m0_method_S_0000;
          when m0_method_S_0000 => 
            m0_method <= m0_method_S_0001;
          when m0_method_S_0001 => 
            if tmp_0013 = '1' then
              m0_method <= m0_method_S_0002;
            end if;
          when m0_method_S_0002 => 
            m0_method <= m0_method_S_0000;
          when others => null;
        end case;
        m0_req_flag_d <= m0_req_flag;
        if (tmp_0015 and tmp_0017) = '1' then
          m0_method <= m0_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m1_method <= m1_method_IDLE;
        m1_method_delay <= (others => '0');
      else
        case (m1_method) is
          when m1_method_IDLE => 
            m1_method <= m1_method_S_0000;
          when m1_method_S_0000 => 
            m1_method <= m1_method_S_0001;
          when m1_method_S_0001 => 
            if tmp_0021 = '1' then
              m1_method <= m1_method_S_0002;
            end if;
          when m1_method_S_0002 => 
            m1_method <= m1_method_S_0003;
          when m1_method_S_0003 => 
            m1_method <= m1_method_S_0000;
          when m1_method_S_0004 => 
            m1_method <= m1_method_S_0000;
          when others => null;
        end case;
        m1_req_flag_d <= m1_req_flag;
        if (tmp_0023 and tmp_0025) = '1' then
          m1_method <= m1_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m2_method <= m2_method_IDLE;
        m2_method_delay <= (others => '0');
      else
        case (m2_method) is
          when m2_method_IDLE => 
            m2_method <= m2_method_S_0000;
          when m2_method_S_0000 => 
            m2_method <= m2_method_S_0001;
          when m2_method_S_0001 => 
            if tmp_0031 = '1' then
              m2_method <= m2_method_S_0002;
            end if;
          when m2_method_S_0002 => 
            m2_method <= m2_method_S_0003;
          when m2_method_S_0003 => 
            if m2_method_delay >= 2 then
              m2_method_delay <= (others => '0');
              m2_method <= m2_method_S_0004;
            else
              m2_method_delay <= m2_method_delay + 1;
            end if;
          when m2_method_S_0004 => 
            m2_method <= m2_method_S_0005;
          when m2_method_S_0005 => 
            m2_method <= m2_method_S_0006;
          when m2_method_S_0006 => 
            m2_method <= m2_method_S_0000;
          when m2_method_S_0007 => 
            m2_method <= m2_method_S_0000;
          when others => null;
        end case;
        m2_req_flag_d <= m2_req_flag;
        if (tmp_0033 and tmp_0035) = '1' then
          m2_method <= m2_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m3_method <= m3_method_IDLE;
        m3_method_delay <= (others => '0');
      else
        case (m3_method) is
          when m3_method_IDLE => 
            m3_method <= m3_method_S_0000;
          when m3_method_S_0000 => 
            m3_method <= m3_method_S_0001;
          when m3_method_S_0001 => 
            if tmp_0043 = '1' then
              m3_method <= m3_method_S_0002;
            end if;
          when m3_method_S_0002 => 
            m3_method <= m3_method_S_0003;
          when m3_method_S_0003 => 
            if m3_method_delay >= 2 then
              m3_method_delay <= (others => '0');
              m3_method <= m3_method_S_0004;
            else
              m3_method_delay <= m3_method_delay + 1;
            end if;
          when m3_method_S_0004 => 
            m3_method <= m3_method_S_0005;
          when m3_method_S_0005 => 
            m3_method <= m3_method_S_0006;
          when m3_method_S_0006 => 
            m3_method <= m3_method_S_0000;
          when m3_method_S_0007 => 
            m3_method <= m3_method_S_0000;
          when others => null;
        end case;
        m3_req_flag_d <= m3_req_flag;
        if (tmp_0045 and tmp_0047) = '1' then
          m3_method <= m3_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m4_method <= m4_method_IDLE;
        m4_method_delay <= (others => '0');
      else
        case (m4_method) is
          when m4_method_IDLE => 
            m4_method <= m4_method_S_0000;
          when m4_method_S_0000 => 
            m4_method <= m4_method_S_0001;
          when m4_method_S_0001 => 
            if tmp_0055 = '1' then
              m4_method <= m4_method_S_0002;
            end if;
          when m4_method_S_0002 => 
            m4_method <= m4_method_S_0003;
          when m4_method_S_0003 => 
            m4_method <= m4_method_S_0004;
          when m4_method_S_0004 => 
            m4_method <= m4_method_S_0005;
          when m4_method_S_0005 => 
            m4_method <= m4_method_S_0006;
          when m4_method_S_0006 => 
            m4_method <= m4_method_S_0007;
          when m4_method_S_0007 => 
            m4_method <= m4_method_S_0008;
          when m4_method_S_0008 => 
            m4_method <= m4_method_S_0009;
          when m4_method_S_0009 => 
            m4_method <= m4_method_S_0000;
          when m4_method_S_0010 => 
            m4_method <= m4_method_S_0000;
          when others => null;
        end case;
        m4_req_flag_d <= m4_req_flag;
        if (tmp_0057 and tmp_0059) = '1' then
          m4_method <= m4_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_ivar_0000 <= (others => '0');
      else
        class_ivar_0000 <= class_ivar_0000_mux;
      end if;
    end if;
  end process;

  class_ivar_0000_mux <= tmp_0001;

  class_imem_0001_clk <= clk_sig;

  class_imem_0001_reset <= reset_sig;

  class_imem_0001_address <= imem_address_sig;

  class_imem_0001_din <= imem_din_sig;

  class_imem_0001_we <= imem_we_sig;

  class_imem_0001_oe <= imem_oe_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_bvar_0004 <= (others => '0');
      else
        class_bvar_0004 <= class_bvar_0004_mux;
      end if;
    end if;
  end process;

  class_bvar_0004_mux <= tmp_0002;

  class_bmem_0005_clk <= clk_sig;

  class_bmem_0005_reset <= reset_sig;

  class_bmem_0005_address <= bmem_address_sig;

  class_bmem_0005_din <= bmem_din_sig;

  class_bmem_0005_we <= bmem_we_sig;

  class_bmem_0005_oe <= bmem_oe_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_bmem_0005_address_b <= (others => '0');
      else
        if m2_method = m2_method_S_0003 and m2_method_delay = 0 then
          class_bmem_0005_address_b <= m2_i_0023;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_bmem_0005_oe_b <= '0';
      else
        if m2_method = m2_method_S_0003 and m2_method_delay = 0 then
          class_bmem_0005_oe_b <= '1';
        else
          class_bmem_0005_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_svar_0008 <= (others => '0');
      else
        class_svar_0008 <= class_svar_0008_mux;
      end if;
    end if;
  end process;

  class_svar_0008_mux <= tmp_0003;

  class_smem_0009_clk <= clk_sig;

  class_smem_0009_reset <= reset_sig;

  class_smem_0009_address <= smem_address_sig;

  class_smem_0009_din <= smem_din_sig;

  class_smem_0009_we <= smem_we_sig;

  class_smem_0009_oe <= smem_oe_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_smem_0009_address_b <= (others => '0');
      else
        if m3_method = m3_method_S_0003 and m3_method_delay = 0 then
          class_smem_0009_address_b <= m3_i_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_smem_0009_oe_b <= '0';
      else
        if m3_method = m3_method_S_0003 and m3_method_delay = 0 then
          class_smem_0009_oe_b <= '1';
        else
          class_smem_0009_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_lvar_0012 <= (others => '0');
      else
        class_lvar_0012 <= class_lvar_0012_mux;
      end if;
    end if;
  end process;

  class_lvar_0012_mux <= tmp_0004;

  class_lmem_0013_clk <= clk_sig;

  class_lmem_0013_reset <= reset_sig;

  class_lmem_0013_address <= lmem_address_sig;

  class_lmem_0013_din <= lmem_din_sig;

  class_lmem_0013_we <= lmem_we_sig;

  class_lmem_0013_oe <= lmem_oe_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_tvar_0016 <= '0';
      else
        class_tvar_0016 <= class_tvar_0016_mux;
      end if;
    end if;
  end process;

  class_tvar_0016_mux <= tmp_0005;

  class_tmem_0017_clk <= clk_sig;

  class_tmem_0017_reset <= reset_sig;

  class_tmem_0017_address <= tmem_address_sig;

  class_tmem_0017_din <= tmem_din_sig;

  class_tmem_0017_we <= tmem_we_sig;

  class_tmem_0017_oe <= tmem_oe_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m1_p_0020 <= '0';
      else
        if m1_method = m1_method_S_0001 then
          m1_p_0020 <= tmp_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00021 <= '0';
      else
        if m1_method = m1_method_S_0002 then
          binary_expr_00021 <= tmp_0028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m2_b_0022 <= (others => '0');
      else
        if m2_method = m2_method_S_0001 then
          m2_b_0022 <= tmp_0037;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m2_i_0023 <= (others => '0');
      else
        if m2_method = m2_method_S_0001 then
          m2_i_0023 <= tmp_0038;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00024 <= (others => '0');
      else
        if m2_method = m2_method_S_0002 then
          binary_expr_00024 <= tmp_0039;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00025 <= (others => '0');
      else
        if m2_method = m2_method_S_0003 and m2_method_delay = 2 then
          array_access_00025 <= class_bmem_0005_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00026 <= (others => '0');
      else
        if m2_method = m2_method_S_0004 then
          binary_expr_00026 <= tmp_0040;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00027 <= (others => '0');
      else
        if m2_method = m2_method_S_0005 then
          cast_expr_00027 <= binary_expr_00026;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m3_s_0028 <= (others => '0');
      else
        if m3_method = m3_method_S_0001 then
          m3_s_0028 <= tmp_0049;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m3_i_0029 <= (others => '0');
      else
        if m3_method = m3_method_S_0001 then
          m3_i_0029 <= tmp_0050;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00030 <= (others => '0');
      else
        if m3_method = m3_method_S_0002 then
          binary_expr_00030 <= tmp_0051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00031 <= (others => '0');
      else
        if m3_method = m3_method_S_0003 and m3_method_delay = 2 then
          array_access_00031 <= class_smem_0009_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00032 <= (others => '0');
      else
        if m3_method = m3_method_S_0004 then
          binary_expr_00032 <= tmp_0052;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00033 <= (others => '0');
      else
        if m3_method = m3_method_S_0005 then
          cast_expr_00033 <= binary_expr_00032;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m4_a3_0034 <= (others => '0');
      else
        if m4_method = m4_method_S_0001 then
          m4_a3_0034 <= tmp_0061;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m4_a2_0035 <= (others => '0');
      else
        if m4_method = m4_method_S_0001 then
          m4_a2_0035 <= tmp_0062;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m4_a1_0036 <= (others => '0');
      else
        if m4_method = m4_method_S_0001 then
          m4_a1_0036 <= tmp_0063;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        m4_a0_0037 <= (others => '0');
      else
        if m4_method = m4_method_S_0001 then
          m4_a0_0037 <= tmp_0064;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00038 <= (others => '0');
      else
        if m4_method = m4_method_S_0002 then
          cast_expr_00038 <= tmp_0065;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00039 <= (others => '0');
      else
        if m4_method = m4_method_S_0003 then
          binary_expr_00039 <= tmp_0066;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00040 <= (others => '0');
      else
        if m4_method = m4_method_S_0004 then
          cast_expr_00040 <= tmp_0067;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00041 <= (others => '0');
      else
        if m4_method = m4_method_S_0005 then
          binary_expr_00041 <= tmp_0068;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00042 <= (others => '0');
      else
        if m4_method = m4_method_S_0006 then
          cast_expr_00042 <= tmp_0069;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00043 <= (others => '0');
      else
        if m4_method = m4_method_S_0007 then
          binary_expr_00043 <= tmp_0070;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00044 <= (others => '0');
      else
        if m4_method = m4_method_S_0008 then
          cast_expr_00044 <= binary_expr_00043;
        end if;
      end if;
    end if;
  end process;

  m0_req_flag <= tmp_0006;

  m1_req_flag <= tmp_0007;

  m2_req_flag <= tmp_0008;

  m3_req_flag <= tmp_0009;

  m4_req_flag <= tmp_0010;

  m0_req_flag_edge <= tmp_0012;

  m1_req_flag_edge <= tmp_0020;

  m2_req_flag_edge <= tmp_0030;

  m3_req_flag_edge <= tmp_0042;

  m4_req_flag_edge <= tmp_0054;


  inst_class_imem_0001 : dualportram
  generic map(
    WIDTH => 32,
    DEPTH => 10,
    WORDS => 1024
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_imem_0001_length,
    address => class_imem_0001_address,
    din => class_imem_0001_din,
    dout => class_imem_0001_dout,
    we => class_imem_0001_we,
    oe => class_imem_0001_oe,
    address_b => class_imem_0001_address_b,
    din_b => class_imem_0001_din_b,
    dout_b => class_imem_0001_dout_b,
    we_b => class_imem_0001_we_b,
    oe_b => class_imem_0001_oe_b
  );

  inst_class_bmem_0005 : dualportram
  generic map(
    WIDTH => 8,
    DEPTH => 10,
    WORDS => 1024
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_bmem_0005_length,
    address => class_bmem_0005_address,
    din => class_bmem_0005_din,
    dout => class_bmem_0005_dout,
    we => class_bmem_0005_we,
    oe => class_bmem_0005_oe,
    address_b => class_bmem_0005_address_b,
    din_b => class_bmem_0005_din_b,
    dout_b => class_bmem_0005_dout_b,
    we_b => class_bmem_0005_we_b,
    oe_b => class_bmem_0005_oe_b
  );

  inst_class_smem_0009 : dualportram
  generic map(
    WIDTH => 16,
    DEPTH => 10,
    WORDS => 1024
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_smem_0009_length,
    address => class_smem_0009_address,
    din => class_smem_0009_din,
    dout => class_smem_0009_dout,
    we => class_smem_0009_we,
    oe => class_smem_0009_oe,
    address_b => class_smem_0009_address_b,
    din_b => class_smem_0009_din_b,
    dout_b => class_smem_0009_dout_b,
    we_b => class_smem_0009_we_b,
    oe_b => class_smem_0009_oe_b
  );

  inst_class_lmem_0013 : dualportram
  generic map(
    WIDTH => 64,
    DEPTH => 10,
    WORDS => 1024
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_lmem_0013_length,
    address => class_lmem_0013_address,
    din => class_lmem_0013_din,
    dout => class_lmem_0013_dout,
    we => class_lmem_0013_we,
    oe => class_lmem_0013_oe,
    address_b => class_lmem_0013_address_b,
    din_b => class_lmem_0013_din_b,
    dout_b => class_lmem_0013_dout_b,
    we_b => class_lmem_0013_we_b,
    oe_b => class_lmem_0013_oe_b
  );

  inst_class_tmem_0017 : dualportram
  generic map(
    WIDTH => 1,
    DEPTH => 10,
    WORDS => 1024
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_tmem_0017_length,
    address => class_tmem_0017_address,
    din => class_tmem_0017_din,
    dout => class_tmem_0017_dout,
    we => class_tmem_0017_we,
    oe => class_tmem_0017_oe,
    address_b => class_tmem_0017_address_b,
    din_b => class_tmem_0017_din_b,
    dout_b => class_tmem_0017_dout_b,
    we_b => class_tmem_0017_we_b,
    oe_b => class_tmem_0017_oe_b
  );


end RTL;
