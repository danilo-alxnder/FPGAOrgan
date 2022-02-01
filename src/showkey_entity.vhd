-- In this version scancode is read on the (negative)falling-edge of kbclock (autogenerated 20kHz).
-- It counts the number of negative edges. IF 11 edges are detected the byte is read and byte_read is '1'.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY showkey IS
  PORT (
    reset     : in std_logic;
    kbclock   : IN STD_LOGIC; -- low freq. clk (~ 20 kHz) from keyboard
    kbdata    : IN STD_LOGIC; -- serial data from the keyboard
    dig0, dig1: OUT std_logic_vector(6 DOWNTO 0); -- show key pressed on display in Hex dig1 (upper 4 bits) dig0 (lower 4 bits)
    scancode  : OUT std_logic_vector(7 DOWNTO 0);
    byte_read : OUT std_logic
    );
END showkey;

ARCHITECTURE behavior OF showkey IS 
	SIGNAL LONG: std_logic_vector (7 DOWNTO 0):= (others => '0');
	
	
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
	PROCESS (reset, kbclock)
	VARIABLE count, i: integer := 0;
	
	BEGIN	
		IF reset='0' THEN									-- if reset button is pressed
		   scancode <= "00000000";
			byte_read <= '0';
			count:= 0;
			i := 0;
			Long <= "00000000";
			dig0 <= "0000000";
			dig1 <= "0000000";
			

		ELSIF falling_edge(kbclock) THEN	
		
				count:= count + 1;   						-- counter for 11 bit code, count becomes 1 after 1st falling edge  
				
			  IF (count>1 and count<10) THEN 		-- condition to read only relevent 8-bits into scancode
			  
				  scancode(i) <= kbdata;		    		-- reads each bit into scancode			  
				  LONG(i) <= kbdata;
				 				  
				  i := i + 1;   
			  END IF;	  	  
		 		  
			  IF count = 11 THEN
				   byte_read <= '1';					-- byte is read 
					
					dig0 <= hex2display(LONG(3 DOWNTO 0));
					dig1 <= hex2display(LONG(7 DOWNTO 4));
					
			  END IF;
			  
			 IF count = 12 THEN						-- case: when key is kept pressed or another key is pressed
					byte_read <= '0';						-- byte read is reset
					count:= 1;
					i:= 0 ;
			  END IF;
			  
		END IF; 
		
	END PROCESS;
	
	
END behavior;


