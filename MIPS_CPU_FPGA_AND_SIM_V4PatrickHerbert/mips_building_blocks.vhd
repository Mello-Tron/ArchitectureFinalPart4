library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity regfile is -- three-port register file
  port(clk:           in  STD_LOGIC;
       we3:           in  STD_LOGIC;
       ra1, ra2, wa3: in  STD_LOGIC_VECTOR(4 downto 0);
       wd3:           in  STD_LOGIC_VECTOR(31 downto 0);
       rd1, rd2:      out STD_LOGIC_VECTOR(31 downto 0));
end;

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
entity adder is -- adder
  port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
       y:    out STD_LOGIC_VECTOR(31 downto 0));
end;

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
entity sl2 is -- shift left by 2
  port(a: in  STD_LOGIC_VECTOR(31 downto 0);
       y: out STD_LOGIC_VECTOR(31 downto 0));
end;

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
entity signext is -- sign extender
  port(a: in  STD_LOGIC_VECTOR(15 downto 0);
       y: out STD_LOGIC_VECTOR(31 downto 0));
end;

library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.NUMERIC_STD.all;
entity flopr is -- flip-flop with synchronous reset
  generic(width: integer);
  port(clk, reset: in  STD_LOGIC;
       d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
       q:          out STD_LOGIC_VECTOR(width-1 downto 0));
end;

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
entity mux2 is -- two-input multiplexer
  generic(width: integer);
  port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
       s:      in  STD_LOGIC;
       y:      out STD_LOGIC_VECTOR(width-1 downto 0));
end;

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
entity mux2cont is -- two-input multiplexer
  port(d0, d1: in  STD_LOGIC;
       s:      in  STD_LOGIC;
       y:      out STD_LOGIC);
end;

------------------------------------------------
-- Module Name: ShiftLeft - Behavioral Pat
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity ShiftLeft is
Port ( a : in STD_LOGIC_VECTOR(31 downto 0);
shamt : in STD_LOGIC_VECTOR(4 downto 0);
c : out STD_LOGIC_VECTOR(31 downto 0) );
end ShiftLeft;

------------------------------------------------
-- Module Name: ShiftRight - Behavioral Pat
------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity ShiftRight is
Port ( a : in STD_LOGIC_VECTOR(31 downto 0);
shamt : in STD_LOGIC_VECTOR(4 downto 0);
c : out STD_LOGIC_VECTOR(31 downto 0) );
end ShiftRight;

architecture behave of regfile is
  type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  signal mem: ramtype;
begin
  -- three-ported register file
  -- read two ports combinationally
  -- write third port on rising edge of clock
  process(clk) begin
    if clk'event and clk = '1' then
       if we3 = '1' then mem(to_integer( unsigned(wa3) )) <= wd3;
       end if;
    end if;
  end process;
  process(ra1, ra2, mem) begin
    if ( to_integer(unsigned(ra1)) = 0) then rd1 <= X"00000000"; -- register 0 holds 0
    else rd1 <= mem(to_integer(unsigned(ra1)));
    end if;
    if ( to_integer(unsigned(ra2)) = 0) then rd2 <= X"00000000"; 
    else rd2 <= mem(to_integer( unsigned(ra2)));
    end if;
  end process;
end;

architecture behave of adder is
begin
  y <= a + b;
end;

architecture behave of sl2 is
begin
  y <= a(29 downto 0) & "00";
end;

architecture behave of signext is
begin
  y <= X"0000" & a when a(15) = '0' else X"ffff" & a; 
end;

architecture asynchronous of flopr is
begin
  process(clk, reset) begin
    if reset = '1' then  q <= std_logic_vector(to_unsigned(0,32));
    elsif clk'event and clk = '1' then
      q <= d;
    end if;
  end process;
end;

architecture behave of mux2 is
begin
  y <= d0 when s = '0' else d1;
end;

architecture behave of mux2cont is
begin
  y <= d0 when s = '0' else d1;
end;

-- Pat
architecture Behavioral of ShiftLeft is
begin
 process(a,shamt)
 begin
			case(shamt) is
			when "00000" => c <= std_logic_vector(unsigned(a) sll 0);
			when "00001" => c <= std_logic_vector(unsigned(a) sll 1);
			when "00010" => c <= std_logic_vector(unsigned(a) sll 2);
			when "00011" => c <= std_logic_vector(unsigned(a) sll 3);
			when "00100" => c <= std_logic_vector(unsigned(a) sll 4);
			when "00101" => c <= std_logic_vector(unsigned(a) sll 5);
			when "00110" => c <= std_logic_vector(unsigned(a) sll 6);
			when "00111" => c <= std_logic_vector(unsigned(a) sll 7);
			when "01000" => c <= std_logic_vector(unsigned(a) sll 8);
			when "01001" => c <= std_logic_vector(unsigned(a) sll 9);
			when "01010" => c <= std_logic_vector(unsigned(a) sll 10);
			when "01011" => c <= std_logic_vector(unsigned(a) sll 11);
			when "01100" => c <= std_logic_vector(unsigned(a) sll 12);
			when "01101" => c <= std_logic_vector(unsigned(a) sll 13);
			when "01110" => c <= std_logic_vector(unsigned(a) sll 14);
			when "01111" => c <= std_logic_vector(unsigned(a) sll 15);
			when "10000" => c <= std_logic_vector(unsigned(a) sll 16);
			when "10001" => c <= std_logic_vector(unsigned(a) sll 17);
			when "10010" => c <= std_logic_vector(unsigned(a) sll 18);
			when "10011" => c <= std_logic_vector(unsigned(a) sll 19);
			when "10100" => c <= std_logic_vector(unsigned(a) sll 20);
			when "10101" => c <= std_logic_vector(unsigned(a) sll 21);
			when "10110" => c <= std_logic_vector(unsigned(a) sll 22);
			when "10111" => c <= std_logic_vector(unsigned(a) sll 23);
			when "11000" => c <= std_logic_vector(unsigned(a) sll 24);
			when "11001" => c <= std_logic_vector(unsigned(a) sll 25);
			when "11010" => c <= std_logic_vector(unsigned(a) sll 26);
			when "11011" => c <= std_logic_vector(unsigned(a) sll 27);
			when "11100" => c <= std_logic_vector(unsigned(a) sll 28);
			when "11101" => c <= std_logic_vector(unsigned(a) sll 29);
			when "11110" => c <= std_logic_vector(unsigned(a) sll 30);
			when "11111" => c <= std_logic_vector(unsigned(a) sll 31);
			when others => c <= "--------------------------------"; -- illegal
 end case;
end process;

end Behavioral;

-- Pat
architecture Behavioral of ShiftRight is
begin
 process(a,shamt)
 begin
			case(shamt) is
			when "00000" => c <= std_logic_vector(unsigned(a) srl 0);
			when "00001" => c <= std_logic_vector(unsigned(a) srl 1);
			when "00010" => c <= std_logic_vector(unsigned(a) srl 2);
			when "00011" => c <= std_logic_vector(unsigned(a) srl 3);
			when "00100" => c <= std_logic_vector(unsigned(a) srl 4);
			when "00101" => c <= std_logic_vector(unsigned(a) srl 5);
			when "00110" => c <= std_logic_vector(unsigned(a) srl 6);
			when "00111" => c <= std_logic_vector(unsigned(a) srl 7);
			when "01000" => c <= std_logic_vector(unsigned(a) srl 8);
			when "01001" => c <= std_logic_vector(unsigned(a) srl 9);
			when "01010" => c <= std_logic_vector(unsigned(a) srl 10);
			when "01011" => c <= std_logic_vector(unsigned(a) srl 11);
			when "01100" => c <= std_logic_vector(unsigned(a) srl 12);
			when "01101" => c <= std_logic_vector(unsigned(a) srl 13);
			when "01110" => c <= std_logic_vector(unsigned(a) srl 14);
			when "01111" => c <= std_logic_vector(unsigned(a) srl 15);
			when "10000" => c <= std_logic_vector(unsigned(a) srl 16);
			when "10001" => c <= std_logic_vector(unsigned(a) srl 17);
			when "10010" => c <= std_logic_vector(unsigned(a) srl 18);
			when "10011" => c <= std_logic_vector(unsigned(a) srl 19);
			when "10100" => c <= std_logic_vector(unsigned(a) srl 20);
			when "10101" => c <= std_logic_vector(unsigned(a) srl 21);
			when "10110" => c <= std_logic_vector(unsigned(a) srl 22);
			when "10111" => c <= std_logic_vector(unsigned(a) srl 23);
			when "11000" => c <= std_logic_vector(unsigned(a) srl 24);
			when "11001" => c <= std_logic_vector(unsigned(a) srl 25);
			when "11010" => c <= std_logic_vector(unsigned(a) srl 26);
			when "11011" => c <= std_logic_vector(unsigned(a) srl 27);
			when "11100" => c <= std_logic_vector(unsigned(a) srl 28);
			when "11101" => c <= std_logic_vector(unsigned(a) srl 29);
			when "11110" => c <= std_logic_vector(unsigned(a) srl 30);
			when "11111" => c <= std_logic_vector(unsigned(a) srl 31);
			when others => c <= "--------------------------------"; -- illegal
 end case;
end process;

end Behavioral;