----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2023 15:42:23
-- Design Name: 
-- Module Name: top_vga - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.mypack.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_vga is
    Port ( clk : in STD_LOGIC;
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC;
           btnL: in STD_LOGIC;
           rst: in STD_LOGIC
           );
end top_vga;

architecture Behavioral of top_vga is
    component clkManager is 
    port(
        clk_in: in std_logic;
        clk_out:out std_logic);
    end component;
    component vgaManager is
    Port ( clk_in : in STD_LOGIC;
            hsync: out STD_LOGIC;
            vsync: out STD_LOGIC;
            posH: out integer;
            posV: out integer;
            videoOn: out STD_LOGIC
    );
    end component;
    component fontManager is
        Port ( clk_in : in STD_LOGIC;      
           posH: in integer;
           posV: in integer;
           videoOn: in STD_LOGIC;
           score: in integer;
           red_out : out STD_LOGIC_VECTOR (3 downto 0);
           green_out : out STD_LOGIC_VECTOR (3 downto 0);
           blue_out : out STD_LOGIC_VECTOR (3 downto 0)
           );
    end component;
    component tuyauManager is
        Port ( clk_in : in STD_LOGIC;
           rst: in STD_LOGIC;
           start: in STD_LOGIC;
           gameOver:in STD_LOGIC;
           posH : in integer;
           posV : in integer;
           videoOn : in STD_LOGIC;
           ramIn: in myarray_t;
           red_in : in STD_LOGIC_VECTOR (3 downto 0);
           green_in : in STD_LOGIC_VECTOR (3 downto 0);
           blue_in : in STD_LOGIC_VECTOR (3 downto 0);
           red_out : out STD_LOGIC_VECTOR (3 downto 0);
           green_out : out STD_LOGIC_VECTOR (3 downto 0);
           blue_out : out STD_LOGIC_VECTOR (3 downto 0);
           ramEna  : out std_logic_vector;
           ramAddr : out myarray_t;
           posTuyauH : out integer;
           posTuyauV : out integer;
           tuyauSizeH:out integer;
           tuyauSizeV:out integer
           );
    end component;
    component flappyManager is
        Port ( clk_in : in STD_LOGIC;
           btnL: in STD_LOGIC;
           rst: in STD_LOGIC;
           gameOver:in STD_LOGIC;
           posH: in integer;
           posV: in integer;
           videoOn: in STD_LOGIC;
           ramIn: in myarray_t;
           red_in : in STD_LOGIC_VECTOR (3 downto 0);
           green_in : in STD_LOGIC_VECTOR (3 downto 0);
           blue_in : in STD_LOGIC_VECTOR (3 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0);
           ramEna  : out std_logic_vector;
           ramAddr : out myarray_t;
           posFlappyH : out integer;
           posFlappyV : out integer;
           flappySizeH:out integer;
           flappySizeV:out integer);
    end component;
    component collisionManager is
        Port ( clk_in : in STD_LOGIC;
           rst: in STD_LOGIC;
           videoOn : in STD_LOGIC;
           posFlappyH : in integer;
           posFlappyV : in integer;
           flappySizeH: in integer;
           flappySizeV: in integer;
           posTuyauH : in integer;
           posTuyauV : in integer;
           tuyauSizeH:in integer;
           tuyauSizeV:in integer;
           collision : out STD_LOGIC;
           levelUp : out STD_LOGIC
           );
    end component;
    component gameOverManager is
        Port ( clk_in : in STD_LOGIC;
           rst: in STD_LOGIC;
           posH: in integer;
           posV: in integer;
           videoOn: in STD_LOGIC;
           ramIn: in myarray_t(24 downto 0)(11 downto 0);
           gameOver: in STD_LOGIC;
           red_in : in STD_LOGIC_VECTOR (3 downto 0);
           green_in : in STD_LOGIC_VECTOR (3 downto 0);
           blue_in : in STD_LOGIC_VECTOR (3 downto 0);
           red : inout STD_LOGIC_VECTOR (3 downto 0);
           green : inout STD_LOGIC_VECTOR (3 downto 0);
           blue : inout STD_LOGIC_VECTOR (3 downto 0);
           ramEna  : out std_logic_vector;
           ramAddr : out myarray_t(24 downto 0)(49 downto 0)
           );
    end component;
    component scoreManager is
        Port ( clk_in : in STD_LOGIC;
           rst: in STD_LOGIC;
           posH : in integer range 0 to 800;
           posV : in integer range 0 to 521;
           videoOn : in STD_LOGIC;
           levelUp: in STD_LOGIC;
		   red_in : in STD_LOGIC_VECTOR (3 downto 0);
           green_in : in STD_LOGIC_VECTOR (3 downto 0);
           blue_in : in STD_LOGIC_VECTOR (3 downto 0);
           red_out : out STD_LOGIC_VECTOR (3 downto 0);
           green_out : out STD_LOGIC_VECTOR (3 downto 0);
           blue_out : out STD_LOGIC_VECTOR (3 downto 0);
           score : out integer
           );
    end component;
    component ram_flappy is
        generic(
        NUM_RAMS : integer;
        A_WID    : integer;
        D_WID    : integer
        );
        port  (
            clk    : in std_logic;
            we     : in std_logic_vector(NUM_RAMS-1 downto 0);
            ena    : in std_logic_vector(NUM_RAMS-1 downto 0);
            addr   : in myarray_t(NUM_RAMS-1 downto 0)(A_WID-1 downto 0);
            din    : in myarray_t(NUM_RAMS-1 downto 0)(D_WID-1 downto 0);
            dout   : out myarray_t(NUM_RAMS-1 downto 0)(D_WID-1 downto 0)
            );
    end component;
    component ram_tuyau is
        generic(
        NUM_RAMS : integer;
        A_WID    : integer;
        D_WID    : integer
        );
        port  (
            clk    : in std_logic;
            we     : in std_logic_vector(NUM_RAMS-1 downto 0);
            ena    : in std_logic_vector(NUM_RAMS-1 downto 0);
            addr   : in myarray_t(NUM_RAMS-1 downto 0)(A_WID-1 downto 0);
            din    : in myarray_t(NUM_RAMS-1 downto 0)(D_WID-1 downto 0);
            dout   : out myarray_t(NUM_RAMS-1 downto 0)(D_WID-1 downto 0)
            );
    end component;
    component ram_game_over is
        generic(
        NUM_RAMS : integer;
        A_WID    : integer;
        D_WID    : integer
        );
        port  (
            clk    : in std_logic;
            we     : in std_logic_vector(NUM_RAMS-1 downto 0);
            ena    : in std_logic_vector(NUM_RAMS-1 downto 0);
            addr   : in myarray_t(NUM_RAMS-1 downto 0)(A_WID-1 downto 0);
            din    : in myarray_t(NUM_RAMS-1 downto 0)(D_WID-1 downto 0);
            dout   : out myarray_t(NUM_RAMS-1 downto 0)(D_WID-1 downto 0)
            );
    end component;
    signal clk_pixel:STD_LOGIC;
    signal sposH:integer;
    signal sposV:integer;
    signal svideoOn:STD_LOGIC;
    
    signal redFontTuyau:STD_LOGIC_VECTOR (3 downto 0);
    signal greenFontTuyau:STD_LOGIC_VECTOR (3 downto 0);
    signal blueFontTuyau:STD_LOGIC_VECTOR (3 downto 0);
    
    signal redTuyauFlappy:STD_LOGIC_VECTOR (3 downto 0);
    signal greenTuyauFlappy:STD_LOGIC_VECTOR (3 downto 0);
    signal blueTuyauFlappy:STD_LOGIC_VECTOR (3 downto 0);
    
    signal redFlappyGameOver:STD_LOGIC_VECTOR (3 downto 0);
    signal greenFlappyGameOver:STD_LOGIC_VECTOR (3 downto 0);
    signal blueFlappyGameOver:STD_LOGIC_VECTOR (3 downto 0);
    
    signal redGameOverScore:STD_LOGIC_VECTOR (3 downto 0);
    signal greenGameOverScore:STD_LOGIC_VECTOR (3 downto 0);
    signal blueGameOverScore:STD_LOGIC_VECTOR (3 downto 0);
    
    signal myCollision:STD_LOGIC;
    signal sLevelUp:STD_LOGIC;
    
    
    signal sizeTuyauH:integer;
    signal sizeTuyauV:integer;
    signal posTuyauH:integer;
    signal posTuyauV:integer;
    
    signal sizeFlappyH:integer;
    signal sizeFlappyV:integer;
    signal posFlappyH:integer;
    signal posFlappyV:integer;
    
    signal ram_flappy_We:std_logic_vector(48 downto 0):=(others=>'0');
    signal ram_flappy_In:myarray_t(48 downto 0)(11 downto 0):=(others=>(others=>'0'));
    
    signal ram_tuyau_We:std_logic_vector(40 downto 0):=(others=>'0');
    signal ram_tuyau_In:myarray_t(40 downto 0)(11 downto 0):=(others=>(others=>'0'));
    
    signal ram_game_over_We:std_logic_vector(24 downto 0):=(others=>'0');
    signal ram_game_over_In:myarray_t(24 downto 0)(11 downto 0):=(others=>(others=>'0'));
    
    signal ram_flappy_Ena:std_logic_vector(48 downto 0):=(others=>'0');   
    signal ram_flappy_Addr: myarray_t(48 downto 0)(69 downto 0):=(others=>(others=>'0'));  
    signal ram_flappy_Out:myarray_t(48 downto 0)(11 downto 0):=(others=>(others=>'0'));
    
    signal ram_tuyau_Ena:std_logic_vector(40 downto 0):=(others=>'0');   
    signal ram_tuyau_Addr: myarray_t(40 downto 0)(65 downto 0):=(others=>(others=>'0'));  
    signal ram_tuyau_Out:myarray_t(40 downto 0)(11 downto 0):=(others=>(others=>'0'));
    
    signal ram_game_over_Ena:std_logic_vector(24 downto 0):=(others=>'0');   
    signal ram_game_over_Addr: myarray_t(24 downto 0)(49 downto 0):=(others=>(others=>'0'));  
    signal ram_game_over_Out:myarray_t(24 downto 0)(11 downto 0):=(others=>(others=>'0'));
    
    signal sScore:integer;
begin
    dut_clk: clkManager port map(
    clk_in=>clk,
    clk_out=>clk_pixel
    );
    dut_font: fontManager port map(
    clk_in=>clk_pixel,
    posH=>sposH,
    posV=>sposV,
    videoOn=>svideoOn,
    score=>sScore,
    red_out=>redFontTuyau,
    green_out=>greenFontTuyau,
    blue_out=>blueFontTuyau
    );
    dut_tuyau: tuyauManager port map(
    clk_in=>clk_pixel,
    rst=>rst,
    start=>btnL,
    gameOver=>myCollision,
    posH=>sposH,
    posV=>sposV,
    videoOn=>svideoOn,
    ramIn=>ram_tuyau_Out,
    red_in=>redFontTuyau,
    green_in=>greenFontTuyau,
    blue_in=>blueFontTuyau,
    red_out=>redTuyauFlappy,
    green_out=>greenTuyauFlappy,
    blue_out=>blueTuyauFlappy,
    posTuyauH=>posTuyauH,
    posTuyauV=>posTuyauV,
    tuyauSizeH=>sizeTuyauH,
    tuyauSizeV=>sizeTuyauV,
    ramEna=>ram_tuyau_Ena,
    ramAddr=>ram_tuyau_Addr
    );
    dut_flappy: flappyManager port map(
    clk_in=>clk_pixel,
    btnL=>btnL,
    rst=>rst,
    gameOver=>myCollision,
    posH=>sposH,
    posV=>sposV,
    videoOn=>svideoOn,
    ramIn=>ram_flappy_Out,
    red_in=>redTuyauFlappy,
    green_in=>greenTuyauFlappy,
    blue_in=>blueTuyauFlappy,
    red=>redFlappyGameOver,
    green=>greenFlappyGameOver,
    blue=>blueFlappyGameOver,
    ramEna=>ram_flappy_Ena,
    ramAddr=>ram_flappy_Addr,
    posFlappyH =>posFlappyH,
    posFlappyV=>posFlappyV,
    flappySizeH=>sizeFlappyH,
    flappySizeV=>sizeFlappyV
    );
    dut_collision: collisionManager port map(
           clk_in=>clk_pixel,
           rst=>rst,
           videoOn=>sVideoOn,
           posFlappyH=>posFlappyH,
           posFlappyV=>posFlappyV,
           flappySizeH=>sizeFlappyH,
           flappySizeV=>sizeFlappyV,
           posTuyauH=>posTuyauH,
           posTuyauV=>posTuyauV,
           tuyauSizeH=>sizeTuyauH,
           tuyauSizeV=>sizeTuyauV,
           collision=>myCollision,
           levelUp=>sLevelUp
    );
    dut_game_over: gameOverManager port map(
    clk_in=>clk_pixel,
    rst=>rst,
    posH=>sposH,
    posV=>sposV,
    videoOn=>svideoOn,
    ramIn=>ram_game_over_Out,
    gameOver=>myCollision,
    red_in=>redFlappyGameOver,
    green_in=>greenFlappyGameOver,
    blue_in=>blueFlappyGameOver,
    red=>redGameOverScore,
    green=>greenGameOverScore,
    blue=>blueGameOverScore,
    ramEna=>ram_game_over_Ena,
    ramAddr=>ram_game_over_Addr
    );
    dut_score: scoreManager port map(
    clk_in=>clk_pixel,
    rst=>rst,
    posH=>sposH,
    posV=>sposV,
    videoOn=>svideoOn,
    levelUp=>sLevelUp,
    red_in=>redGameOverScore,
    green_in=>greenGameOverScore,
    blue_in=>blueGameOverScore,
    red_out=>vgaRed,
    green_out=>vgaGreen,
    blue_out=>vgaBlue,
    score=>sScore
    );
    dut_vga_manager: vgaManager port map(
    clk_in=>clk_pixel,
    hsync=>Hsync,
    vsync=>Vsync,
    posH=>sposH,
    posV=>sposV,
    videoOn=>svideoOn
    );
    dut_ram_flappy: ram_flappy 
    generic map(
        NUM_RAMS=>49,
        A_WID=>70,
        D_WID=>12
    )
    port map(
            clk=>clk,
            we=>ram_flappy_We,
            ena=>ram_flappy_Ena,
            addr=>ram_flappy_Addr,
            din=>ram_flappy_In,
            dout=>ram_flappy_Out
    );
    dut_ram_tuyau: ram_tuyau 
    generic map(
        NUM_RAMS=>41,
        A_WID=>66,
        D_WID=>12
    )
    port map(
            clk=>clk,
            we=>ram_tuyau_We,
            ena=>ram_tuyau_Ena,
            addr=>ram_tuyau_Addr,
            din=>ram_tuyau_In,
            dout=>ram_tuyau_Out
    );
    dut_ram_game_over: ram_game_over 
    generic map(
        NUM_RAMS=>25,
        A_WID=>50,
        D_WID=>12
    )
    port map(
            clk=>clk,
            we=>ram_game_over_We,
            ena=>ram_game_over_Ena,
            addr=>ram_game_over_Addr,
            din=>ram_game_over_In,
            dout=>ram_game_over_Out
    );
end Behavioral;
