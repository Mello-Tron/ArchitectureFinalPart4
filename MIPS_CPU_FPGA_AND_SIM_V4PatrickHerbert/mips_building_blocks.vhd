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
entity mux3 is -- three-input multiplexer
  generic(width: integer);
  port(d0, d1, d2: in  STD_LOGIC_VECTOR(width-1 downto 0);
       s:      in  STD_LOGIC_VECTOR(1 downto 0);
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

architecture Behavioral of mux3 is
begin
 process(s)
 begin
	case(s) is
	when "00" => y <= d0;
	when "01" => y <= d1;
	when others => y <= d2;
	end case;
 end process;
end Behavioral;

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

----------------------------------------------------------------------------------
-- VGA
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vgatest is
port(
	clk50_in : in std_logic;
	scancode  : in std_logic_vector(7 downto 0);   -- scancode from keyboard to VGA
	writedata: in STD_LOGIC_VECTOR(31 downto 0);
	we2      : in STD_LOGIC;
	--readdata2: out STD_LOGIC_VECTOR(31 downto 0);
	red_out : out std_logic_vector(2 downto 0);
	green_out : out std_logic_vector(2 downto 0);
	blue_out : out std_logic_vector(2 downto 0);
	hs_out : out std_logic;
	vs_out : out std_logic
);
end vgatest;

architecture behavioral of vgatest is

signal clk25              : std_logic;
signal hcounter : integer range 0 to 800;
signal vcounter   : integer range 0 to 521;
signal color: std_logic_vector(2 downto 0);
begin

-- generate a 25Mhz clock
process (clk50_in)
begin
  if clk50_in'event and clk50_in='1' then
    clk25 <= not clk25;
  end if;
end process;

-- change color every one second
p1: process (clk25)
	variable cnt: integer;
begin
	if clk25'event and clk25='1' then
		cnt := cnt + 1;
		if cnt = 25000000 then
			color <= color + "001";
			cnt := 0;
		end if;
	end if;
end process;

p2: process (clk25, hcounter, vcounter)
	variable x: integer range 0 to 639;
	variable y: integer range 0 to 479;
	constant z : integer := 5;
begin
	-- hcounter counts from 0 to 799
	-- vcounter counts from 0 to 520
	-- x coordinate: 0 - 639 (x = hcounter - 144, i.e., hcounter -Tpw-Tbp)
	-- y coordinate: 0 - 479 (y = vcounter - 31, i.e., vcounter-Tpw-Tbp)
	x := hcounter - 144;
	y := vcounter - 31;
  	if clk25'event and clk25 = '1' then
 		-- To draw a pixel in (x0, y0), simply test if the ray trace to it
		-- and set its color to any value between 1 to 7. The following example simply sets 
		-- the whole display area to a single-color wash, which is changed every one 
		-- second. 	
		
		--NUMBER 1
	 	if (x > (30+(z*2))) and (x <= (30+(z*3))) and y > 30 and y <= ((30 + (z*5))) then
      	red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 2
		else if ( (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > 30 and y <= (30 + z)) or
			(x > (30 + (z*6)) and x <= (30 + (z*7)) and y > 30 and y <= (30 + (z*3))) or
			(x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*2)) and y <= (30 + (z*3))) or
			(x > (30 + (z*4)) and x <= (30 + (z*5)) and y > (30 + (z*2)) and y <= (30 + (z*5))) or
			(x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*4)) and y <= (30 + (z*5)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 3
		else if ((x > (30 + (z*8)) and x <= (30 + (z*11)) and y > 30 and y <= (30 + z)) or
				  (x > (30 + (z*8)) and x <= (30 + (z*11)) and y > (30 + (z*2)) and y <= (30 + (z*3))) or
				  (x > (30 + (z*8)) and x <= (30 + (z*11)) and y > (30 + (z*4)) and y <= (30 + (z*5))) or
				  (x > (30 + (z*10)) and x <= (30 + (z*11)) and y > 30 and y <= (30 + (z*5)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 4
		else if ( (x > 30 and x <= (30 + z) and y > (30 + (z*6)) and y <= (30 + (z*9))) or
				  (x > (30 + (z*2)) and x <= (30 + (z*3)) and y > (30 + (z*6)) and y <= (30 + (z*11))) or
				  (x > 30 and x <= (30 + (z*3)) and y > (30 + (z*8)) and y <= (30 + (z*9)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 5
		else if ( (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*6)) and y <= (30 + (z*7))) or
				  (x > (30 + (z*4)) and x <= (30 + (z*5)) and y > (30 + (z*6)) and y <= (30 + (z*9))) or
				  (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*8)) and y <= (30 + (z*9))) or
				  (x > (30 + (z*6)) and x <= (30 + (z*7)) and y > (30 + (z*8)) and y <= (30 + (z*11))) or
				  (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*10)) and y <= (30 + (z*11)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 6
		else if ( (x > (30 + (z*8)) and x <= (30 + (z*11)) and y > (30 + (z*6)) and y <= (30 + (z*7))) or
				  (x > (30 + (z*8)) and x <= (30 + (z*9)) and y > (30 + (z*6)) and y <= (30 + (z*11))) or
				  (x > (30 + (z*8)) and x <= (30 + (z*11)) and y > (30 + (z*8)) and y <= (30 + (z*9))) or
				  (x > (30 + (z*10)) and x <= (30 + (z*11)) and y > (30 + (z*8)) and y <= (30 + (z*11))) or
				  (x > (30 + (z*8)) and x <= (30 + (z*11)) and y > (30 + (z*10)) and y <= (30 + (z*11)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 7
		else if ( (x > 30 and x <= (30 + (z*3)) and y > (30 + (z*12)) and y <= (30 + (z*13))) or
				  (x > (30 + (z*2)) and x <= (30 + (z*3)) and y > (30 + (z*12)) and y <= (30 + (z*17)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 8
		else if ( (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*12)) and y <= (30 + (z*13))) or
				  (x > (30 + (z*4)) and x <= (30 + (z*5)) and y > (30 + (z*12)) and y <= (30 + (z*17))) or
				  (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*14)) and y <= (30 + (z*15))) or
				  (x > (30 + (z*6)) and x <= (30 + (z*7)) and y > (30 + (z*12)) and y <= (30 + (z*17))) or
				  (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*16)) and y <= (30 + (z*17)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 9
		else if ( (x > (30 + (z*8)) and x <= (30 + (z*11)) and y > (30 + (z*12)) and y <= (30 + (z*13))) or
				  (x > (30 + (z*8)) and x <= (30 + (z*9)) and y > (30 + (z*12)) and y <= (30 + (z*15))) or
				  (x > (30 + (z*8)) and x <= (30 + (z*11)) and y > (30 + (z*14)) and y <= (30 + (z*15))) or
				  (x > (30 + (z*10)) and x <= (30 + (z*11)) and y > (30 + (z*12)) and y <= (30 + (z*17)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
		--NUMBER 0
		else if ( (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*18)) and y <= (30 + (z*19))) or
				  (x > (30 + (z*4)) and x <= (30 + (z*5)) and y > (30 + (z*18)) and y <= (30 + (z*23))) or
				  (x > (30 + (z*6)) and x <= (30 + (z*7)) and y > (30 + (z*18)) and y <= (30 + (z*23))) or
				  (x > (30 + (z*4)) and x <= (30 + (z*7)) and y > (30 + (z*22)) and y <= (30 + (z*23)))) then
			red_out <= writedata( 2 downto 0 );
      	green_out <= "010"; 
      	blue_out <= "000";
    	else
			-- if not traced, set it to "black" color
      	red_out <= "000";
      	green_out <= "000";
      	blue_out <= "000";
    	end if;end if;end if;
		end if;end if;end if;
		end if;end if;end if;
		end if;
		-- Here is the timing for horizontal synchronization.
		-- (Refer to p. 24, Xilinx, Spartan-3 Starter Kit Board User Guide)
	 	-- Pulse width: Tpw = 96 cycles @ 25 MHz
	 	-- Back porch: Tbp = 48 cycles
		-- Display time: Tdisp = 640 cycles
	 	-- Front porch: Tfp = 16 cycles
		-- Sync pulse time (total cycles) Ts = 800 cycles

    	if hcounter > 0 and hcounter < 97 then
      	hs_out <= '0';
    	else
      	hs_out <= '1';
    	end if;
		-- Here is the timing for vertical synchronization.
		-- (Refer to p. 24, Xilinx, Spartan-3 Starter Kit Board User Guide)
	 	-- Pulse width: Tpw = 1600 cycles (2 lines) @ 25 MHz
	 	-- Back porch: Tbp = 23200 cycles (29 lines)
		-- Display time: Tdisp = 38400 cycles (480 lines)
	 	-- Front porch: Tfp = 8000 cycles (10 lines)
		-- Sync pulse time (total cycles) Ts = 416800 cycles (521 lines)
    	if vcounter > 0 and vcounter < 3 then
      	vs_out <= '0';
    	else
      	vs_out <= '1';
    	end if;
	 	-- horizontal counts from 0 to 799
    	hcounter <= hcounter+1;
    	if hcounter = 800 then
      	vcounter <= vcounter+1;
      	hcounter <= 0;
    	end if;
	 	-- vertical counts from 0 to 519
    	if vcounter = 521 then		    
      	vcounter <= 0;
    	end if;
  end if;
end process;

end behavioral;

----------------------------------------------------------------------------
-- KEYBOARD
----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ps2_kbd is
  generic(
    FREQ     :     natural := 100_000   -- frequency of the main clock (KHz)
    );
  port(
    clk      : in  std_logic;           -- main clock
    rst      : in  std_logic;           -- asynchronous reset
    ps2_clk  : in  std_logic;           -- clock from keyboard
    ps2_data : in  std_logic;           -- data from keyboard
	 --writedata: in STD_LOGIC_VECTOR(31 downto 0);
	 we1:       in STD_LOGIC;
	 readdata1: out STD_LOGIC_VECTOR(31 downto 0);
    scancode : out std_logic_vector(7 downto 0);  -- key scancode
    parity   : out std_logic;           -- parity bit for scancode
    busy     : out std_logic;           -- busy receiving scancode
    rdy      : out std_logic;           -- scancode ready pulse
    error    : out std_logic            -- error receiving scancode
    );
end entity ps2_kbd;


architecture arch of ps2_kbd is

  constant YES         : std_logic                    := '1';
  constant NO          : std_logic                    := '0';
  constant PS2_FREQ    : natural                      := 10;  -- keyboard clock frequency (KHz)
  constant TIMEOUT     : natural                      := FREQ / PS2_FREQ;  -- ps2_clk quiet timeout
  constant KEY_RELEASE : std_logic_vector(7 downto 0) := "11110000";  -- scancode sent when key is released

  signal timer_x, timer_r     : natural range 0 to TIMEOUT;  -- counts time since last PS/2 clock edge
  signal bitcnt_x, bitcnt_r   : natural range 0 to 11;  -- counts number of received scancode bits
  signal ps2_clk_x, ps2_clk_r : std_logic_vector(5 downto 1);  -- PS/2 clock synchronization / edge detect shift register
  signal ps2_clk_fall_edge    : std_logic;  -- pulses on falling edge of PS/2 clock
  signal ps2_clk_rise_edge    : std_logic;  -- pulses on rising edge of PS/2 clock
  signal ps2_clk_edge         : std_logic;  -- pulses on either edge of PS/2 clock
  signal ps2_clk_quiet        : std_logic;  -- pulses when no edges on PS/2 clock for TIMEOUT
  signal sc_x, sc_r           : std_logic_vector(9 downto 0);  -- scancode shift register
  signal keyrel_x, keyrel_r   : std_logic;  -- this flag is set when the key release scancode is received
  signal scancode_rdy         : std_logic;  -- indicates when any scancode has been received
  signal rdy_x, rdy_r         : std_logic;  -- this flag is set when scancode for the pressed key is ready
  signal error_x, error_r     : std_logic;  -- this flag is set when an error occurs
  signal s_x                  : std_logic_vector(6 downto 0);  -- next state of LED segment

begin

  -- shift the level on the PS/2 clock into a shift register
  ps2_clk_x <= ps2_clk_r(4 downto 1) & ps2_clk;

  -- look at the PS/2 clock levels stored in the shift register and find rising or falling edges
  ps2_clk_fall_edge <= YES when ps2_clk_r(5 downto 2) = "1100" else NO;
  ps2_clk_rise_edge <= YES when ps2_clk_r(5 downto 2) = "0011" else NO;
  ps2_clk_edge      <= ps2_clk_fall_edge or ps2_clk_rise_edge;

  -- shift the keyboard scancode into the shift register on the falling edge of the PS/2 clock
  sc_x <= ps2_data & sc_r(9 downto 1) when ps2_clk_fall_edge = YES else sc_r;

  -- clear the timer right after a PS/2 clock edge and then keep incrementing it until the next edge
  timer_x <= 0 when ps2_clk_edge = YES else timer_r + 1;

  -- indicate when the PS/2 clock has stopped pulsing and is at a high level.
  ps2_clk_quiet <= YES when timer_r = TIMEOUT and ps2_clk_r(2) = '1' else NO;

  -- increment the bit counter on each falling edge of the PS/2 clock.
  -- reset the bit counter if the PS/2 clock stops pulsing or if there was an error receiving the scancode.
  -- otherwise, keep the bit counter unchanged.
  bitcnt_x <= bitcnt_r + 1 when ps2_clk_fall_edge = YES              else
              0            when ps2_clk_quiet = YES or error_r = YES else
              bitcnt_r;

  -- a scancode has been received if the bit counter is 11 and the PS/2 clock has stopped pulsing
  scancode_rdy <= YES when bitcnt_r = 11 and ps2_clk_quiet = YES else NO;

  -- look for the scancode sent when the key is released
  keyrel_x <= YES when sc_r(scancode'range) = KEY_RELEASE and scancode_rdy = YES else
              NO  when rdy_r = YES or error_r = YES                              else
              keyrel_r;

  -- the scancode for the pressed key arrives after receiving the key-release scancode 
  rdy_x <= YES when keyrel_r = YES and scancode_rdy = YES else NO;

  -- indicate an error if the clock is low for too long or if it stops pulsing in the middle of a scancode
  error_x <= YES when (timer_r = TIMEOUT and ps2_clk_r(2) = '0') or
             (ps2_clk_quiet = YES and bitcnt_r/=11 and bitcnt_r/=0) else
             error_r;

  scancode <= sc_r(scancode'range);     -- output scancode
  
  readdata1 <= X"000000" & sc_r(scancode'range);
  parity   <= sc_r(scancode'high+1);    -- output parity bit for the scancode
  busy     <= YES when bitcnt_r/=0 else NO;  -- output busy signal when receiving a scancode
  rdy      <= rdy_r;                    -- output scancode ready flag
  error    <= error_r;                  -- output error flag

  -- update the various registers
  process(rst, clk)
  begin
    if rst = YES then
      ps2_clk_r <= (others => '1');     -- start by assuming PS/2 clock has been high for a while
      sc_r      <= (others => '0');     -- clear scancode register
      keyrel_r  <= NO;                  -- key-release scancode has not been received yet
      rdy_r     <= NO;                  -- no scancodes received yet
      timer_r   <= 0;                   -- clear PS/2 clock pulse timer
      bitcnt_r  <= 0;                   -- clear scancode bit counter
      error_r   <= NO;                  -- clear any errors
    elsif rising_edge(clk) then
      ps2_clk_r <= ps2_clk_x;
      sc_r      <= sc_x;
      keyrel_r  <= keyrel_x;
      rdy_r     <= rdy_x;
      timer_r   <= timer_x;
      bitcnt_r  <= bitcnt_x;
      error_r   <= error_x;
    end if;
  end process;

end architecture arch;