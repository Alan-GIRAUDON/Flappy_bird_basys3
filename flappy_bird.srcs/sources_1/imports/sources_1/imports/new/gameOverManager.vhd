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

entity gameOverManager is
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
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0);
           ramEna  : out std_logic_vector;
           ramAddr : out myarray_t(24 downto 0)(49 downto 0)
           );
end gameOverManager;

architecture Behavioral of gameOverManager is

constant sizeImgH:integer:=50;
constant sizeImgV:integer:=25;

signal posImgH:integer:=270;
signal posImgV:integer:=215;

signal indexImgH:integer range 0 to 100:=sizeImgH-1;
signal indexImgV:integer range 0 to 70:=sizeImgV-1;

signal imgTmp:STD_LOGIC_VECTOR(11 downto 0):="000000000000";

signal duplicatePixel:STD_LOGIC:='0';
signal duplicateLine:STD_LOGIC:='0';
begin
process(clk_in,rst,videoOn,posH,posV,gameOver,ramIn)
begin
if(rst='1') then
elsif rising_edge(clk_in) then
        ramAddr<=(others=>(others=>'0'));
        ramAddr(indexImgV)<=STD_LOGIC_VECTOR(to_unsigned(indexImgH,ramAddr(indexImgV)'length));
        ramEna<=(others=>'0');
        ramEna(indexImgV)<='1'; 
    if(posH>=640 and posV>=480) then
		indexImgH<=sizeImgH-1;
		indexImgV<=sizeImgV-1;
    end if;
    if(posH>posImgH+(sizeImgH*2)) then
        indexImgH<=sizeImgH-1;
    end if;
    if(videoOn='1') then
        if(posH>=posImgH and posH<posImgH+(sizeImgH*2) and posV>=posImgV and posV<posImgV+(sizeImgV*2) and gameOver='1') then
            imgTmp<=ramIn(indexImgV);
            if(imgTmp="000000001111") then
                red<=red_in;
                green<=green_in;
                blue<=blue_in;
            else    
                red<=imgTmp(11 downto 8);
                green<=imgTmp(7 downto 4);
                blue<=imgTmp(3 downto 0);         
                
            end if;    
             if(indexImgH=0) then
                indexImgH<=sizeImgH-1;
                if(duplicateLine='0') then
                    duplicateLine<='1';
                else
                    duplicateLine<='0';
                    indexImgV<=indexImgV-1;
                end if;     
            else
                if(duplicatePixel='0') then
                    duplicatePixel<='1';
                else
                    duplicatePixel<='0';
                    indexImgH<=indexImgH-1;
                end if;              
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
    if(posH>=640 and posV>=480) then
		indexImgH<=sizeImgH-1;
		indexImgV<=sizeImgV-1;
    end if;
    ramAddr<=(others=>(others=>'0'));
    ramAddr(indexImgV)<=STD_LOGIC_VECTOR(to_unsigned(indexImgH,ramAddr(indexImgV)'length));
    ramEna<=(others=>'0');
    ramEna(indexImgV)<='1';
end if;

end process;

end Behavioral;
