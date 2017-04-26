library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Dflipflop is 
	port (Clock, Reset	: in std_logic;
			Din				: in std_logic;
			Q, Qn				: out std_logic);
end entity;
			
architecture dflipflop_arch of dflipflop is

begin
	Dff : process (Clock, Reset)
		begin
			if (Reset = '0') then
			   Q <= '0'; Qn <= '1';
			elsif(rising_edge(Clock)) then
				Q <= Din; Qn <= not Din;
			end if;
		end process;
end architecture;
			