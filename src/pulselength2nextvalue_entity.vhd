LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY pulselength2nextvalue IS
 GENERIC (max_length : integer := 20000);
 PORT (clk : IN std_logic;
 reset : IN std_logic;
 sine_complete : IN std_logic;
 pulse_length: IN INTEGER RANGE 0 TO max_length;
 next_value : OUT std_logic
 );
END pulselength2nextvalue;

architecture bhv of pulselength2nextvalue is
shared variable i : integer :=0;
shared variable k : std_logic :='0';
shared variable j :INTEGER RANGE 0 TO max_length;
begin
process(clk,reset,sine_complete)
begin
if reset ='0' then
	next_value<='0';
  i := 0;
  j := 0;
elsif rising_edge(clk) then
	i:=i+1;
	if sine_complete='1' then
		j:= pulse_length;
		i:=0;
	elsif k='0' AND pulse_length /= 0  then
		j:= pulse_length ;
		k:='1';
		i:=0;
	end if;
		if i=j then
			next_value<='1';
			i:=0;
    elsif j=0 THEN
      i:=0;
		else
			next_value<='0';
		end if;
end if;
end process;
end bhv;