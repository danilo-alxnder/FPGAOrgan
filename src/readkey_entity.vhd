LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY readkey IS
  PORT (
    clk        : IN std_logic; -- high freq. clock (~ 50 MHz)
    reset      : IN std_logic;
    kbdata     : IN STD_LOGIC; -- low freq. clk (~ 20 kHz) serial data from the keyboard
    kbclock    : IN STD_LOGIC; -- clock from the keyboard
	  key        : OUT std_logic_vector(7 DOWNTO 0);
	  -- I/O check via 7-segment displays    
    dig0, dig1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- show key pressed on display
    dig2, dig3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- show key pressed on display; after processed by constant key
   );
END readkey;

ARchitecture bhv OF readkey IS
SIGNAL byte_read : std_logic;
SIGNAL scancode: std_logic_vector(7 downto 0);

COMPONENT showkey IS 
port(  reset     : in std_logic;
    kbclock   : IN STD_LOGIC; -- low freq. clk (~ 20 kHz) from keyboard
    kbdata    : IN STD_LOGIC; -- serial data from the keyboard
    dig0, dig1: OUT std_logic_vector(6 DOWNTO 0); -- show key pressed on display in Hex dig1 (upper 4 bits) dig0 (lower 4 bits)
    scancode  : OUT std_logic_vector(7 DOWNTO 0);
    byte_read : OUT std_logic
	 );
	 
END COMPONENT;

COMPONENT constantkey IS
PORT (
    reset      : IN std_logic;
    clk        : IN std_logic; -- 50MHz clokc
    scancode   : IN std_logic_vector(7 DOWNTO 0);
    byte_read  : IN std_logic;
    dig2, dig3 : OUT std_logic_vector(6 DOWNTO 0); 
    key        : OUT std_logic_vector(7 DOWNTO 0)    
    );
END COMPONENT;

BEGIN 


SK: showkey port map (kbclock   => kbclock,
							 reset     => reset,
							 kbdata    => kbdata,
							 dig0      => dig0,
							 dig1      => dig1,
							 scancode  => scancode,
							 byte_read => byte_read);

CK: constantkey port map ( reset   => reset,
									clk     => clk,
									scancode   => scancode,
									byte_read   => byte_read,
									dig2   => dig2,
									dig3   => dig3,
									key   => key);

END bhv;
