LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY sample_generation IS
  PORT (
    clk   : IN std_logic;
    reset : IN std_logic;
    key   : IN std_logic_vector(7 DOWNTO 0);
    DATA  : OUT std_logic_vector(15 downto 0) 
		  );		
END ENTITY sample_generation;

ARCHITECTURE behaviour OF sample_generation IS

COMPONENT key2pulselength
	GENERIC (max_length : integer := 20000); 
	PORT (	key    : IN std_logic_vector(7 DOWNTO 0);
        	pulse_length : OUT INTEGER RANGE 0 TO max_length
		);
END COMPONENT;

COMPONENT mul_power_of_2
	GENERIC (max_length : integer := 20000);
  	PORT ( clk               : IN std_logic;
         reset                   : IN std_logic;
         key                     : IN std_logic_vector(7 DOWNTO 0);
	 pulse_length            : IN integer RANGE 0 TO max_length;
	 pulse_length_multiplied : OUT integer RANGE 0 TO max_length*32:=0
	      );
END COMPONENT;

COMPONENT pulselength2nextvalue
	GENERIC (max_length : integer := 20000);
	PORT  (clk           : IN std_logic;
         reset         : IN std_logic;
         sine_complete : IN std_logic;
         pulse_length  : IN INTEGER RANGE 0 TO max_length;
         next_value    : OUT std_logic
  		);	

END COMPONENT;

COMPONENT sinegen
	 PORT(
   	 next_value    : in std_logic;
    	clk           : in std_logic;
    	reset         : in std_logic;
    	sine_complete : OUT std_logic;
    	DATA          : OUT std_logic_vector(15 downto 0)
  	);
END COMPONENT;

	signal pulse_length : integer RANGE 0 TO 20000;
	signal pulse_length_multiplied : integer RANGE 0 TO 20000*32:=0;
	signal next_value : std_logic;
	signal sine_complete : std_logic;
	
BEGIN 
	KEY2PULSELENGTH1: key2pulselength 
			--GENERIC MAP(max_length); 
			 PORT MAP(key=>key, pulse_length=>pulse_length);

	MUL_POWER_OF_21: mul_power_of_2 
			--GENERIC MAP(max_length);
			PORT MAP(clk=>clk,
							reset=>reset,
							key=>key,
							pulse_length=>pulse_length,
							pulse_length_multiplied=>pulse_length_multiplied);

	PULSELENGTH2NEXTVALUE1: pulselength2nextvalue 
			--GENERIC MAP(max_length);
			PORT MAP(clk=>clk,
							reset=>reset,
							sine_complete=>sine_complete,
							pulse_length=>pulse_length_multiplied,
							next_value=>next_value);	

	SINEGEN1: sinegen PORT MAP(next_value=>next_value, 
					clk=>clk,
					reset=>reset,
					sine_complete=>sine_complete,
					DATA=>DATA);
END behaviour;