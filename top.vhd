library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity top is
	port (CLOCK_50, RESET_N : in std_logic;
			SW		: in std_logic_vector(9 downto 0);
			LEDR	: out std_logic_vector(9 downto 0);
			GPIO_0: out std_logic_vector(7 downto 0);
			HEX0,HEX1,HEX2,HEX3, HEX4, HEX5	: out std_logic_vector(6 downto 0));
end entity;

architecture top_arch of top is
	
	signal CNT 				: std_logic_vector(23 downto 0);
	signal CNT_int       : integer range 0 to 16777215;  
	signal Clock 			: std_logic;
	signal BCD_1 				: std_logic_vector(3 downto 0);
	signal BCD_2 				: std_logic_vector(3 downto 0);
	signal BCD_3 				: std_logic_vector(3 downto 0);
	signal BCD_4 				: std_logic_vector(3 downto 0);
	signal BCD_5 				: std_logic_vector(3 downto 0);
	signal BCD_6 				: std_logic_vector(3 downto 0);
	
	
	component CharDecoder
		port (Count : in std_logic_vector (3 downto 0);
			HEX0 : out std_logic_vector (6 downto 0));
	end component;
	
	component clock_div_prec
		port (CLOCK_50 : in std_logic;
				RESET_N : in std_logic;
				Sel_in : in std_logic_vector (1 downto 0);
				Clock_out : out std_logic);
	end component;
	
	
	begin
		clockprec : clock_div_prec port map (CLOCK_50 => CLOCK_50, RESET_N => RESET_N, Sel_in => SW(1 downto 0), Clock_Out => Clock);
		
		BCD6 : process(Clock, RESET_N)
		begin
			if (RESET_N = '0') then
				BCD_6 <= "0000";
			elsif (rising_edge(Clock)) then	
				if (BCD_5 = "1001") then	
					if(BCD_4 = "1001") then				
						if(BCD_3 = "1001") then			
							if(BCD_2 = "1001") then		
								if (BCD_1 = "1001") then				
									if (BCD_6 = "1001") then
										BCD_6 <= "0000";
									else
										BCD_6 <= BCD_6 + 1;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if; 
		end process;
		
		BCD5 : process(Clock, RESET_N)
		begin
			if (RESET_N = '0') then
				BCD_5 <= "0000";
			elsif (rising_edge(Clock)) then	
				if(BCD_4 = "1001") then				
						if(BCD_3 = "1001") then			
							if(BCD_2 = "1001") then		
								if (BCD_1 = "1001") then	
									if (BCD_5 = "1001") then
										BCD_5 <= "0000";
									else
										BCD_5 <= BCD_5 + 1;
								end if;
							end if;			
						end if;
					end if;
				end if;
			end if; 
		end process;
		
		BCD4 : process(Clock, RESET_N)
		begin
			if (RESET_N = '0') then
				BCD_4 <= "0000";
			elsif (rising_edge(Clock)) then	
				if(BCD_3 = "1001") then			
					if(BCD_2 = "1001") then		
						if (BCD_1 = "1001") then	
							if (BCD_4 = "1001") then
								BCD_4 <= "0000";
							else
								BCD_4 <= BCD_4 + 1;
							end if;
						end if;
					end if;
				end if;
			end if; 
		end process;
		
		BCD3 : process(Clock, RESET_N)
		begin
			if (RESET_N = '0') then
				BCD_3 <= "0000";
			elsif (rising_edge(Clock)) then	
				if(BCD_2 = "1001") then		
					if (BCD_1 = "1001") then		
						if (BCD_3 = "1001") then
							BCD_3 <= "0000";
						else
							BCD_3 <= BCD_3 + 1;
						end if;
					end if;
				end if;
			end if; 
		end process;
		
		BCD2 : process(Clock, RESET_N)
		begin
			if (RESET_N = '0') then
				BCD_2 <= "0000";
			elsif (rising_edge(Clock)) then	
				if (BCD_1 = "1001") then				
					if (BCD_2 = "1001") then
						BCD_2 <= "0000";
					else
						BCD_2 <= BCD_2 + 1;
					end if;
				end if;
			end if; 
		end process;
		

		BCD1 : process(Clock, RESET_N)
		begin
			if (RESET_N = '0') then
				BCD_1 <= "0000";
			elsif (rising_edge(Clock)) then	
				if (BCD_1 = "1001") then
					BCD_1 <= "0000";
				else
					BCD_1 <= BCD_1 + 1;
				end if;
			end if; 
		end process;
		
		C0 : CharDecoder port map (Count => BCD_1(3 downto 0), HEX0 => HEX0);
		C1 : CharDecoder port map (Count => BCD_2(3 downto 0), HEX0 => HEX1);
		C2 : CharDecoder port map (Count => BCD_3(3 downto 0), HEX0 => HEX2);
		C3 : CharDecoder port map (Count => BCD_4(3 downto 0), HEX0 => HEX3);
		C4 : CharDecoder port map (Count => BCD_5(3 downto 0), HEX0 => HEX4);
		C5 : CharDecoder port map (Count => BCD_6(3 downto 0), HEX0 => HEX5);
		
		LEDR <= CNT(9 downto 0);
		GPIO_0 <= CNT(7 downto 0);

end architecture; --5CEBA4F23C7