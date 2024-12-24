----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2023 15:10:53
-- Design Name: 
-- Module Name: clkManager - Behavioral
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

entity clkManager is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clkManager;

architecture Behavioral of clkManager is
    signal sclk :STD_LOGIC:='0';
begin
process(clk_in,sclk)
    variable count: std_logic :='0';
begin
    if rising_edge(clk_in) then
        if(count='1') then
            count:='0';
            sclk <= not sclk;
        else
            count := not count;
       end if;
       end if;
       clk_out<=sclk;
end process;
end Behavioral;
