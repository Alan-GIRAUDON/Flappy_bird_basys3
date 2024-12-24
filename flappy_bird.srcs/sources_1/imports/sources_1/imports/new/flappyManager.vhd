----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2023 15:10:53
-- Design Name: 
-- Module Name: colorManager - Behavioral
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

entity flappyManager is
    Port ( clk_in : in STD_LOGIC;
           btnL:in STD_LOGIC;
           rst: in STD_LOGIC;
           gameOver:in STD_LOGIC;
           posH: in integer;
           posV: in integer;
           videoOn: in STD_LOGIC;
           ramIn: in myarray_t(48 downto 0)(11 downto 0);
           red_in : in STD_LOGIC_VECTOR (3 downto 0);
           green_in : in STD_LOGIC_VECTOR (3 downto 0);
           blue_in : in STD_LOGIC_VECTOR (3 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0);
           ramEna  : out std_logic_vector;
           ramAddr : out myarray_t(48 downto 0)(69 downto 0);
           posFlappyH : out integer;
           posFlappyV : out integer;
           flappySizeH:out integer;
           flappySizeV:out integer);
end flappyManager;

architecture Behavioral of flappyManager is

constant sizeImgH:integer:=70;
constant sizeImgV:integer:=49;

signal posImgH:integer:=170;
signal posImgV:integer:=100;

signal indexImgH:integer range 0 to 100:=sizeImgH-1;
signal indexImgV:integer range 0 to 70:=sizeImgV-1;

signal btnPrevState:STD_LOGIC:='0';
signal jump:STD_LOGIC:='0';
signal imgTmp:STD_LOGIC_VECTOR(11 downto 0):="000000000000";
signal sStart:STD_LOGIC:='0';

begin
process(clk_in,rst,videoOn,posH,posV,btnL,ramIn,red_in,green_in,blue_in)
begin 

if(rst='1')then
    posImgV<=100;
    indexImgH<=sizeImgH-1;
	indexImgV<=sizeImgV-1;
elsif rising_edge(clk_in) then
    if(btnL='1') then
        sStart<='1';
    end if;
    ramAddr<=(others=>(others=>'0'));
    ramAddr(indexImgV)<=STD_LOGIC_VECTOR(to_unsigned(indexImgH,ramAddr(indexImgV)'length));
    ramEna<=(others=>'0');
    ramEna(indexImgV)<='1';
    
        if(posH=640 and posV=480) then
            indexImgH<=sizeImgH-1;
            indexImgV<=sizeImgV-1;
            if(sStart='1') then
                if(jump='0' and posImgV+sizeImgV<470 and gameOver='0') then
                  posImgV<=posImgV+2;
                end if;
                if(btnL='1' and btnPrevState='0') then
                    jump<='1';
                    btnPrevState<='1';
                elsif(btnL='0') then
                    btnPrevState<='0';     
                end if;
            end if;
        if(posH>posImgH+sizeImgH) then
            indexImgH<=sizeImgH-1;
        end if;
    end if;
    if(videoOn='1') then
        if(indexImgH=0) then
            if(jump='1' and gameOver='0')then
                if(posImgV>61) then
                    posImgV<=posImgV-60;
                end if; 
                jump<='0';      
        end if;
       end if;
        if(posH>=posImgH and posH<posImgH+sizeImgH and posV>=posImgV and posV<posImgV+sizeImgV) then
            imgTmp<=ramIn(indexImgV);
            if(imgTmp="000000001111") then
                red<=red_in;
                green<=green_in;
                blue<=blue_in;
            else  
                if(posH>=posImgH+3 and posV<=posImgV+sizeImgV-2) then  
                    red<=imgTmp(11 downto 8);
                    green<=imgTmp(7 downto 4);
                    blue<=imgTmp(3 downto 0);
                else
                    red<=red_in;
                    green<=green_in;
                    blue<=blue_in;       
                end if;
            end if;
            if(indexImgV=0) then
                indexImgV<=sizeImgV-1;
                indexImgH<=sizeImgH-1;
            end if;       
             if(indexImgH=0) then
                indexImgH<=sizeImgH-1;
                indexImgV<=indexImgV-1;
            else
                indexImgH<=indexImgH-1;
            end if;
               
        else
            red<=red_in;
            green<=green_in;
            blue<=blue_in;
        end if;
    else
        red<=(others =>'0');
        green<=(others =>'0');
        blue<=(others =>'0');
    end if;
    ramAddr<=(others=>(others=>'0'));
    ramAddr(indexImgV)<=STD_LOGIC_VECTOR(to_unsigned(indexImgH,ramAddr(indexImgV)'length));
    ramEna<=(others=>'0');
    ramEna(indexImgV)<='1';
    posFlappyH<=posImgH;
    posFlappyV<=posImgV;
    flappySizeH<=sizeImgH;
    flappySizeV<=sizeImgV;
end if;

end process;

end Behavioral;
