library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_div_prec is
	port (CLOCK_50 : in std_logic;
		  RESET_N : in std_logic;
		  Sel_in : in std_logic_vector (1 downto 0);
		  Clock_out : out std_logic);
end entity;
architecture clock_div_prec_arch of clock_div_prec is

	signal Delay_Steps : integer range 0 to 50000000;
	
	signal Count : integer range 0 to 50000000;
	
	signal Clk : std_logic := '0';
	
	begin
	
	
		Delay_Steps_FREQ : process (RESET_N, CLOCK_50)
			begin
				case (Sel_in) is
					when "11" => Delay_Steps <= 25000;     -- 1 kHz
					when "10" => Delay_Steps <= 250000;    -- 100 Hz
					when "01" => Delay_Steps <= 2500000;   -- 10 Hz
					when "00" => Delay_Steps <= 25000000;  -- 1 Hz
					
					when others => Delay_Steps <= 1;
				end case;
				
				if (RESET_N = '0') then
					Count <= 0;
				elsif (CLOCK_50'event and CLOCK_50='1') then
					if (Count = Delay_Steps) then
						Count <= 0;
						Clock_out <= not Clk;
						Clk <= not Clk;
					else
						Count <= Count + 1;
					end if;
				end if;
			end process;
		
end architecture;