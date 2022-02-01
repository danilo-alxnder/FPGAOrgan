LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
ENTITY sinegen IS
  PORT(
    next_value    : in std_logic;
    clk           : in std_logic;
    reset         : in std_logic;
    sine_complete : OUT std_logic;
    DATA          : OUT std_logic_vector(15 downto 0)
  );
END sinegen;

ARCHITECTURE bhv of sinegen IS
    type LUT_TYPE is array (15 DOWNTO 0) of integer range 0 to 8000; 
    signal LUT : LUT_TYPE  := (7961, 7846, 7655, 7391, 7055, 6652, 6184, 5657, 5075, 4445, 3771, 3061, 2322, 1561, 784, 0);
    signal state : natural range 0 to 3;
    signal count : natural range 0 to 15;
    signal sine_out : integer range -8000 to 8000 := 0;
    signal sine_complete_set : std_logic := '1'; 

BEGIN
    sine_complete <= sine_complete_set;
    DATA <= std_logic_vector(to_signed(sine_out, 16));
    PROCESS(reset, clk)
    BEGIN
        IF reset = '0' THEN
            state <= 0;
            count <= 0;
            sine_out <= 0;
            sine_complete_set <= '1';
        ELSIF rising_edge(clk) THEN
            IF next_value = '1' THEN
                IF state = 0 THEN
                    sine_complete_set <= '0';
                    IF count = 15 THEN
                        state <= 1;
                        sine_out <= 8000;
                    ELSE
                        count <= count + 1;
                        sine_out <= LUT(count + 1);
                    END IF;
                ELSIF state = 1 THEN
                    IF count = 0 THEN
                        state <= 2;
                        sine_out <= 0;
                    ELSE
                        count <= count - 1;
                        sine_out <= LUT(count); 
                    END IF;
                ELSIF state = 2 THEN
                    IF count = 15 THEN
                        state <= 3;
                        sine_out <= -8000;
                    ELSE
                        count <= count + 1;
                        sine_out <= - LUT(count + 1);
                    END IF;
                ELSIF state = 3 THEN
                    IF count = 0 THEN
                        sine_complete_set <= '1';
                        state <= 0;
                        sine_out <= 0;
                    ELSE
                        count <= count -1;
                        sine_out <= - LUT(count);
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END;