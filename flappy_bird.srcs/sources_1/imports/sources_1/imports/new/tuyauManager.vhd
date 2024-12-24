----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2023 09:59:29
-- Design Name: 
-- Module Name: tuyauManager - Behavioral
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

entity tuyauManager is
    Port ( clk_in : in STD_LOGIC;
           rst: in STD_LOGIC;
           start: in STD_LOGIC;
           gameOver:in STD_LOGIC;
           posH : in integer;
           posV : in integer;
           videoOn : in STD_LOGIC;
           ramIn: in myarray_t(40 downto 0)(11 downto 0);
           red_in : in STD_LOGIC_VECTOR (3 downto 0);
           green_in : in STD_LOGIC_VECTOR (3 downto 0);
           blue_in : in STD_LOGIC_VECTOR (3 downto 0);
           red_out : out STD_LOGIC_VECTOR (3 downto 0);
           green_out : out STD_LOGIC_VECTOR (3 downto 0);
           blue_out : out STD_LOGIC_VECTOR (3 downto 0);
           ramEna  : out std_logic_vector;
           ramAddr : out myarray_t(40 downto 0)(65 downto 0);
           posTuyauH : out integer;
           posTuyauV : out integer;
           tuyauSizeH:out integer;
           tuyauSizeV:out integer
           );
end tuyauManager;

architecture Behavioral of tuyauManager is
signal aleatoire: integer:=0;

signal sizeImgH1:integer:=66;
signal sizeImgV1:integer:=150;

signal sizeImgH2:integer:=66;
signal sizeImgV2:integer:=180;

signal posImgH1:integer:=550;
signal posImgV1:integer:=0;

signal posImgH2:integer:=550;
signal posImgV2:integer:=300;

signal indexImgH1:integer:=sizeImgH1-1;
signal indexImgV1:integer:=0;

signal indexImgH2:integer:=sizeImgH2-1;
signal indexImgV2:integer:=40;

signal imgTmp:STD_LOGIC_VECTOR(11 downto 0):="000000000000";
signal resizeTuyau1:STD_LOGIC:='1';
signal resizeTuyau2:STD_LOGIC:='0';
signal sStart:STD_LOGIC:='0';

begin
process(clk_in,rst,videoOn,posH,posV,ramIn,red_in,green_in,blue_in,sizeImgV1,sizeImgV2,sizeImgH1,sizeImgH2,aleatoire,start)
begin
if(rst='1') then
    posImgH1<=550;
    posImgV1<=0;
    sizeImgV1<=aleatoire + 50;
    
    posImgH2<=550;
    sizeImgV2<=480-(aleatoire + 50 + 150);
    posImgV2<=aleatoire + 50 + 150; 
    
    indexImgH1<=sizeImgH1-1;
    indexImgV1<=0;
    
    indexImgH2<=sizeImgH2-1;
    indexImgV2<=40;
elsif (rising_edge(clk_in)) then
    if(aleatoire>=190) then
        aleatoire<=0;
    else
        aleatoire<=aleatoire+1;
    end if;
    if(start='1') then
        sStart<='1';
    end if; 
    ramAddr<=(others=>(others=>'0'));
    ramEna<=(others=>'0');
    
    ramAddr(indexImgV1)<=STD_LOGIC_VECTOR(to_unsigned(indexImgH1,ramAddr(indexImgV1)'length));       
    ramEna(indexImgV1)<='1';
    
    ramAddr(indexImgV2)<=STD_LOGIC_VECTOR(to_unsigned(indexImgH2,ramAddr(indexImgV2)'length));       
    ramEna(indexImgV2)<='1';  
    
   if(posH=640 and posV=480) then
        indexImgH1<=sizeImgH1-1;
        indexImgV1<=0;
        indexImgH2<=sizeImgH2-1;
        indexImgV2<=40;
        resizeTuyau1<='1';
        resizeTuyau2<='0';
      if(sStart='1') then  
            if(posImgH1>0 and gameOver='0') then
                posImgH1<=posImgH1-2;
            elsif(gameOver='0')then
                posImgH1<=639-sizeImgH1-1;
            end if;
            if(posImgH2>0 and gameOver='0') then
                posImgH2<=posImgH2-2;    
            elsif(gameOver='0')then
                sizeImgV1<=aleatoire + 50;
                sizeImgV2<=480-(aleatoire + 50 + 150);
                posImgV2<=aleatoire + 50 + 150;
                posImgH2<=639-sizeImgH2-1;         
            end if;
        end if;
    end if;
    if(videoOn='1') then
        if(posH>=posImgH1 and posH<posImgH1+sizeImgH1 and posV>posImgV1 and posV<=posImgV1+sizeImgV1) then
            imgTmp<=ramIn(indexImgV1);
            if(imgTmp="111111111111") then
                red_out<=red_in;
                green_out<=green_in;
                blue_out<=blue_in;
            else
                if(posH>=posImgH1+2) then	
                    red_out<=imgTmp(11 downto 8);
                    green_out<=imgTmp(7 downto 4);
                    blue_out<=imgTmp(3 downto 0);
                else
                    red_out<=red_in;
                    green_out<=green_in;
                    blue_out<=blue_in;
                end if;
            end if;        
            if(indexImgH1=0) then
                indexImgH1<=sizeImgH1-1;
                indexImgV1<=indexImgV1+1;
            else
                indexImgH1<=indexImgH1-1;
            end if;
            if(resizeTuyau1='1') then
                 indexImgV1<=4;
                 if(posV>posImgV1+sizeImgV1-36) then
                     resizeTuyau1<='0';
                 end if;
            end if;
        elsif(posH>=posImgH2 and posH<posImgH2+sizeImgH2 and posV>=posImgV2 and posV<posImgV2+sizeImgV2) then
            imgTmp<=ramIn(indexImgV2);
            if(imgTmp="111111111111") then
                red_out<=red_in;
                green_out<=green_in;
                blue_out<=blue_in;
            else
                if(posH>=posImgH2+2) then
                    red_out<=imgTmp(11 downto 8);
                    green_out<=imgTmp(7 downto 4);
                    blue_out<=imgTmp(3 downto 0);
                else
                    red_out<=red_in;
                    green_out<=green_in;
                    blue_out<=blue_in;
                end if;
            end if;
            if(indexImgH2=0) then
                indexImgH2<=sizeImgH2-1;
                indexImgV2<=indexImgV2-1;
            else
              indexImgH2<=indexImgH2-1;
            end if;
            if(indexImgV2=0) then
                indexImgV2<=40;
                resizeTuyau2<='1';
            end if;
            if(resizeTuyau2='1') then
                 indexImgV2<=3;
            end if;
        else
            red_out<=red_in;
            green_out<=green_in;
            blue_out<=blue_in;
        end if;
    else
        red_out<=(others =>'0');
        green_out<=(others =>'0');
        blue_out<=(others =>'0');
    end if;
    posTuyauH<=posImgH1;
    posTuyauV<=posImgV1;
    tuyauSizeH<=sizeImgH1;
    tuyauSizeV<=sizeImgV1;
end if;

end process;

end Behavioral;
