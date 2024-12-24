----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.03.2023 09:59:29
-- Design Name: 
-- Module Name: collisionManager - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity collisionManager is
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
end collisionManager;

architecture Behavioral of collisionManager is
signal sGameOver:STD_LOGIC:='0';
begin
process(clk_in,rst,videoOn,posFlappyH,posFlappyV,flappySizeH,flappySizeV,posTuyauH,posTuyauV,tuyauSizeH,tuyauSizeV)
begin
    if(rst='1') then
        levelUp<='0';
        collision<='0';
        sGameOver<='0';
    elsif rising_edge(clk_in) then
        if(videoOn='1') then
            if(((posFlappyH+flappySizeH<=posTuyauH or posFlappyH>=posTuyauH+tuyauSizeH)or (posFlappyV>=posTuyauV+tuyauSizeV  and posFlappyV+flappySizeV <=posTuyauV+tuyauSizeV+150))
            ) then
                sGameOver<='0';
            else
                sGameOver<='1';
            end if;
            if(posFlappyH>=posTuyauH) then                                                                                                                                                       
                levelUp<='1';
            else
                levelUp<='0';
            end if;
        end if;
        collision<=sGameOver;
    end if;
end process;

end Behavioral;
