LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY constantkey IS
  PORT (
    reset      : IN std_logic;
    clk        : IN std_logic; -- 50MHz clokc
    scancode   : IN std_logic_vector(7 DOWNTO 0);
    byte_read  : IN std_logic;
    dig2, dig3 : OUT std_logic_vector(6 DOWNTO 0); -- show key pressed on display dig2 en dig3 (resp high & low).
    key        : OUT std_logic_vector(7 DOWNTO 0)    
    );
END constantkey;

ARCHITECTURE behavior OF constantkey IS
--Defining variables

	type state_type is (s0 ,s1 ,s2);
	signal current_s,next_s: state_type;
	signal NSD1,NSD2: STD_LOGIC;    								--50 Mhz new_scancode_detected 
	signal scancode_sync: STD_LOGIC_VECTOR(7 DOWNTO 0); 
	
FUNCTION hex2display (n:std_logic_vector(3 DOWNTO 0)) RETURN std_logic_vector IS
    VARIABLE res : std_logic_vector(6 DOWNTO 0);
	BEGIN
    CASE n IS          --        gfedcba; low active
	    WHEN "0000" => RETURN NOT "0111111";
	    WHEN "0001" => RETURN NOT "0000110";
	    WHEN "0010" => RETURN NOT "1011011";
	    WHEN "0011" => RETURN NOT "1001111";
	    WHEN "0100" => RETURN NOT "1100110";
	    WHEN "0101" => RETURN NOT "1101101";
	    WHEN "0110" => RETURN NOT "1111101";
	    WHEN "0111" => RETURN NOT "0000111";
	    WHEN "1000" => RETURN NOT "1111111";
	    WHEN "1001" => RETURN NOT "1101111";
	    WHEN "1010" => RETURN NOT "1110111";
	    WHEN "1011" => RETURN NOT "1111100";
	    WHEN "1100" => RETURN NOT "0111001";
	    WHEN "1101" => RETURN NOT "1011110";
	    WHEN "1110" => RETURN NOT "1111001";
	    WHEN OTHERS => RETURN NOT "1110001";			
    END CASE;
END hex2display;

BEGIN
-- process: synchronise into NSD + reset 
process(clk, reset) is
	begin
	
		if (reset = '0') then
		    NSD1 <= '0';
		    NSD2 <= '0';
		    scancode_sync <= "00000000";
		
		elsif falling_edge(clk) then
		    NSD1 <= 	byte_read;
		    NSD2 <= 	NSD1;
		    if (NSD2='1') then
			scancode_sync <= scancode;
		    end if;
		end if;	
end process;

-- process for chnaging stw to detect a change i
process(clk,reset) is
	begin

		if(reset = '0') then
		current_s <= s0; 					---no new_scancode_detected
		elsif (rising_edge(clk)) then
		current_s <= next_s; 			--- a new_scancode_detected
		end if;

end process;
	
 -- process decide relationship
process(current_s,NSD2, scancode_sync)
	begin
	     case current_s is
	     when s0 =>
			key <= "00000000";	
			dig2 <= "0000000";
			dig3 <= "0000000";
			   

 	        if(NSD2 ='1') then
	           next_s <= s1;
		else  
		next_s<=current_s;
	        end if; 	

	    when s1 =>    
			dig2 <= hex2display(scancode(3 downto 0));
			dig3 <= hex2display(scancode(7 downto 4));
			key<=scancode; --F0    
	   	
		if(scancode_sync = "11110000") then
		   next_s <= s2;
		else
		   next_s <= current_s;
		end if;
	    
	    when s2 =>  
		dig2 <= "0000000";
		dig3 <= "0000000";
		key <= "00000000";     
		
		if(NSD2 = '1' ) then
	  	 next_s <= current_s;
		else
		   next_s <= s0;
		end if;
	
	
	  end case;
end process;
		
END behavior;