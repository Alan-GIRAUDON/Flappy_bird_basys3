----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2023 15:10:53
-- Design Name: 
-- Module Name: vgaManager - Behavioral
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

entity vgaManager is
    Port ( clk_in : in STD_LOGIC;
            hsync: out STD_LOGIC;
            vsync: out STD_LOGIC;
            posH: out integer;
            posV: out integer;
            videoOn:out STD_LOGIC
    );
end vgaManager;

architecture Behavioral of vgaManager is
    constant displayH : integer:=639;
    constant displayV : integer:=479;
    constant PulseH : integer:=96;
    constant PulseV : integer:=2;
    constant frontH : integer:=16;
    constant frontV : integer:=10;
    constant backH : integer:=48;
    constant backV : integer:=29;
    
    signal sposH: integer:=0;
    signal sposV: integer:=0;  
    signal etatH:STD_LOGIC:='0';
    signal etatV:STD_LOGIC:='0';

begin
process(clk_in)
begin
    if rising_edge(clk_in) then
        if(sposV=displayV+frontV+pulseV+backV) then
            sposV<=0;
        end if;
        if(sposH>displayH+frontH and sposH<=displayH+frontH+pulseH) then
            etatH<='0';
        else
            etatH<='1';
        end if;
        if(sposV>displayV+frontV and sposV<=displayV+frontV+pulseV) then
            etatV<='0';
        else
            etatV<='1';
        end if;
        if(sposH<=displayH and sposV<=displayV) then
            videoOn<='1';
        else
            videoOn<='0';
        end if;
        hsync<=etatH;
        vsync<=etatV;
        posH<=sposH;
        posV<=sposV;
        if(sposH=displayH+frontH+pulseH+backH) then
            sposH<=0; 
            sposV<=sposV+1;     
        else
            sposH<=sposH+1;
        end if; 
    end if;

end process;


end Behavioral;
