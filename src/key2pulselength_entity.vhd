LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY key2pulselength IS
  GENERIC (max_length : integer := 20000);
  PORT (key    : IN std_logic_vector(7 DOWNTO 0);
        pulse_length : OUT INTEGER RANGE 0 TO max_length
       );
END key2pulselength;

Architecture bhd of key2pulselength is
CONSTANT key_Tab : std_logic_vector := X"0D";
CONSTANT key_1 : std_logic_vector := X"16"; 
CONSTANT key_Q : std_logic_vector := X"15"; 
CONSTANT key_W : std_logic_vector := X"1D";
CONSTANT key_3 : std_logic_vector := X"26"; 
CONSTANT key_E : std_logic_vector := X"24"; 
CONSTANT key_4 : std_logic_vector := X"25";
CONSTANT key_R : std_logic_vector := X"2D"; 
CONSTANT key_T : std_logic_vector := X"2C";
CONSTANT key_6 : std_logic_vector := X"36"; 
CONSTANT key_Y : std_logic_vector := X"35";
CONSTANT key_7 : std_logic_vector := X"3D"; 
CONSTANT key_U : std_logic_vector := X"3C";
CONSTANT key_8 : std_logic_vector := X"3E";
CONSTANT key_I : std_logic_vector := X"43";
CONSTANT key_O : std_logic_vector := X"44";
CONSTANT key_0 : std_logic_vector := X"45";
CONSTANT key_P : std_logic_vector := X"4D";
CONSTANT key_DASH : std_logic_vector := X"4E";
CONSTANT key_LEFT_SQB : std_logic_vector := X"54";
CONSTANT key_RIGHT_SQB : std_logic_vector := X"5B";
CONSTANT key_l : std_logic_vector := X"5D";

begin 

process(key)
begin 


IF key = key_Tab	 	  THEN pulse_length <= 1776; 
ELSIF key= key_1		 	  THEN pulse_length<= 1676; 
ELSIF key=key_Q 	 	  THEN pulse_length<= 1582; 
ELSIF key=key_W 	     THEN pulse_length<= 1493; 
ELSIF key=key_3 	 	  THEN pulse_length<= 1409; 
ELSIF key=key_E		     THEN pulse_length<= 1330; 
ELSIF key=key_4 	     THEN pulse_length<= 1256; 
ELSIF key=key_R 	     THEN pulse_length<= 1185; 
ELSIF key=key_T  	     THEN pulse_length<= 1119; 
ELSIF key=key_6 	     THEN pulse_length<= 1056; 
ELSIF key=key_Y  	     THEN pulse_length<=  997; 
ELSIF key=key_7	        THEN pulse_length<=  941; 
ELSIF key=key_U 	     THEN pulse_length<=  888; 
ELSIF key=key_8  	     THEN pulse_length<=  838; 
ELSIF key=key_I         THEN pulse_length<=  791;
ELSIF key=key_O         THEN pulse_length<=  747; 
ELSIF key=key_0         THEN pulse_length<=  705; 
ELSIF key=key_P         THEN pulse_length<=  665; 
ELSIF key=key_DASH      THEN pulse_length<=  628; 
ELSIF key=key_LEFT_SQB  THEN pulse_length<=  593; 
ELSIF key=key_RIGHT_SQB THEN pulse_length<=  559; 
ELSIF key=key_l 		  THEN pulse_length<=  528; 
ELSE pulse_length<=  0; 
END IF;


end process;
end bhd; 



