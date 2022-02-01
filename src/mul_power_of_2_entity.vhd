LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY mul_power_of_2 IS
  GENERIC (max_length : integer := 20000);
  PORT ( clk                     : IN std_logic;
         reset                   : IN std_logic;
         key                     : IN std_logic_vector(7 DOWNTO 0);
	       pulse_length            : IN integer RANGE 0 TO max_length;
	       pulse_length_multiplied : OUT integer RANGE 0 TO max_length*32
	      ); 
END mul_power_of_2;

ARCHITECTURE bhv OF mul_power_of_2 IS
    signal state : natural range 0 to 5 := 2;
    signal prev_key : std_logic_vector (7 DOWNTO 0) := X"00";
    constant a : std_logic_vector (7 DOWNTO 0) := X"1C";
    constant z : std_logic_vector (7 DOWNTO 0) := X"1A";
    signal pulse_length_temp : integer range 0  to max_length*32;

    FUNCTION shiftLeft (obj : INTEGER range 0 to 20000) RETURN INTEGER IS
    VARIABLE shifted : INTEGER range 0 to 20000*32;
    variable vec0, vec1 : std_logic_vector (19 DOWNTO 0); 
    BEGIN
        vec0 := std_logic_vector(to_unsigned(obj, 20));
        vec1(0) := '0';
        vec1(1) := vec0(0);
        vec1(2) := vec0(1);
        vec1(3) := vec0(2);
        vec1(4) := vec0(3);
        vec1(5) := vec0(4);
        vec1(6) := vec0(5);
        vec1(7) := vec0(6);
        vec1(8) := vec0(7);
        vec1(9) := vec0(8);
        vec1(10) := vec0(9);
        vec1(11) := vec0(10);
        vec1(12) := vec0(11);
        vec1(13) := vec0(12);
        vec1(14) := vec0(13);
        vec1(15) := vec0(14);
        vec1(16) := vec0(15);
        vec1(17) := vec0(16);
        vec1(18) := vec0(17);
        vec1(19) := vec0(18);
        shifted := to_integer(unsigned(vec1));
        RETURN shifted;
    END;

    FUNCTION shiftRight (obj : INTEGER range 0 to 20000) RETURN INTEGER IS
    VARIABLE shifted : INTEGER range 0 to 20000*32;
    variable vec0, vec1 : std_logic_vector (19 DOWNTO 0); 
    BEGIN
        vec0 := std_logic_vector(to_unsigned(obj, 20));
        vec1(0) := vec0(1);
        vec1(1) := vec0(2);
        vec1(2) := vec0(3);
        vec1(3) := vec0(4);
        vec1(4) := vec0(5);
        vec1(5) := vec0(6);
        vec1(6) := vec0(7);
        vec1(7) := vec0(8);
        vec1(8) := vec0(9);
        vec1(9) := vec0(10);
        vec1(10) := vec0(11);
        vec1(11) := vec0(12);
        vec1(12) := vec0(13);
        vec1(13) := vec0(14);
        vec1(14) := vec0(15);
        vec1(15) := vec0(16);
        vec1(16) := vec0(17);
        vec1(17) := vec0(18);
        vec1(18) := vec0(19);
        vec1(19) := '0';
        shifted := to_integer(unsigned(vec1));
        RETURN shifted;
    END;

BEGIN
    pulse_length_multiplied <= pulse_length_temp;
    PROCESS(reset, clk)
    BEGIN
        IF reset = '0' THEN
            state <= 2;
            pulse_length_temp <= 0;
            prev_key <= "00000000";
        ELSIF rising_edge(clk) THEN

            IF state = 0 THEN
                pulse_length_temp <= shiftLeft(shiftLeft(pulse_length));
            ELSIF state = 1 THEN
                pulse_length_temp <= shiftLeft(pulse_length);
            ELSIF state = 2 THEN
                pulse_length_temp <= pulse_length;
            ELSIF state = 3 THEN
                pulse_length_temp <= shiftRight(pulse_length);
            ELSIF state = 4 THEN
                pulse_length_temp <= shiftRight(shiftRight(pulse_length));
            ELSIF state = 5 THEN
                pulse_length_temp <= shiftRight(shiftRight(shiftRight(pulse_length)));
            END IF;

            prev_key <= key;
            IF key = a and key /= prev_key THEN
                IF state /= 5 THEN
                    state <= state + 1;
                ELSIF state = 5 THEN
                    state <= 5;
                END IF;
            ELSIF key = z and key /= prev_key THEN
                IF state /= 0 THEN
                    state <= state - 1;
                ELSE
                    state <= 0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END;