--------------------------------------------------
-- mipssingletop.vhd
-- David_Harris@hmc.edu 30 May 2006
-- Single Cycle MIPS testbench & mem
-- Modified and updated to standard libraries by Kent Jones
--------------------------------------------------

---------------------------------------------------------
-- Entity Declarations
---------------------------------------------------------

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity top is -- top-level design for testing
	generic(
    FREQ     :     natural := 100_000   -- frequency of main clock (KHz)
    );
  port(clk, reset:         in     STD_LOGIC;
       ps2_clk   : in  std_logic;           -- keyboard clock
		 ps2_data  : in  std_logic;           -- keyboard data
		 clk50_in : in std_logic;
		 s         : out std_logic_vector(6 downto 0);  -- LED display
		 red_out : out std_logic_vector(2 downto 0);
		 green_out : out std_logic_vector(2 downto 0);
		 blue_out : out std_logic_vector(2 downto 0);
		 hs_out : out std_logic;
		 vs_out : out std_logic;
       writedata, dataadr: inout STD_LOGIC_VECTOR(31 downto 0);
       memwrite:           inout STD_LOGIC;
		 pc:                 inout STD_LOGIC_VECTOR(31 downto 0) );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

architecture test of top is

	component ps2_kbd is
	  generic(
		 FREQ     :     natural := 100_000   -- frequency of the main clock (KHz)
		 );
	  port(
		 clk      : in  std_logic;           -- main clock
		 rst      : in  std_logic;           -- asynchronous reset
		 ps2_clk  : in  std_logic;           -- clock from keyboard
		 ps2_data : in  std_logic;           -- data from keyboard
		 --writedata: in STD_LOGIC_VECTOR(31 downto 0);
		 we1      : in STD_LOGIC;
		 readdata1: out STD_LOGIC_VECTOR(31 downto 0);
		 scancode : out std_logic_vector(7 downto 0);  -- key scancode
		 parity   : out std_logic;           -- parity bit for scancode
		 busy     : out std_logic;           -- busy receiving scancode
		 rdy      : out std_logic;           -- scancode ready pulse
		 error    : out std_logic            -- error receiving scancode
		 );
	end component ps2_kbd;

	component vgatest is
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
	end component;

  component imem
    port(a:  in  STD_LOGIC_VECTOR(5 downto 0);
         rd: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  
  component dmem
    port(clk, we:  in STD_LOGIC;
         a, wd:    in STD_LOGIC_VECTOR(31 downto 0);
         rd:       out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  
  component mips 
    port(clk, reset:        in  STD_LOGIC;
         pc:                inout STD_LOGIC_VECTOR(31 downto 0);
         instr:             in  STD_LOGIC_VECTOR(31 downto 0);
         memwrite:          out STD_LOGIC;
			wem, we1, we2:     out STD_LOGIC;
			rdsel:             out STD_LOGIC;
         aluout, writedata: inout STD_LOGIC_VECTOR(31 downto 0);
			s:                 out STD_LOGIC_VECTOR(6 downto 0);
         readdata:          in  STD_LOGIC_VECTOR(31 downto 0));
  end component;
  
  component mux2 generic(width: integer);
    port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;

  signal instr: STD_LOGIC_VECTOR(31 downto 0);
  signal wem, we1, we2: STD_LOGIC;
  signal rdsel: STD_LOGIC;
  signal readdata: STD_LOGIC_VECTOR(31 downto 0);
  signal readdatam: STD_LOGIC_VECTOR(31 downto 0); --memory
  signal readdata1: STD_LOGIC_VECTOR(31 downto 0); --keyboard
  --signal readdata2: STD_LOGIC_VECTOR(31 downto 0); --vga
  --signal scancode_to_vga: STD_LOGIC_VECTOR(7 downto 0);
  
  --constant YES : std_logic := '1';
  --constant NO  : std_logic := '0';

  signal rdy       : std_logic;         -- indicates when scancode is available
  --signal s_x       : std_logic_vector(6 downto 0);  -- next state of LED segments
  signal kbd_error : std_logic;         -- error receiving scancode from keyboard
  signal scancode  : std_logic_vector(7 downto 0);
  --signal scancodeExtended : STD_LOGIC_VECTOR(31 downto 0);
  
  -- LED segment activation patterns for various numbers and letters
--  constant DIG_1    : std_logic_vector(6 downto 0) := "0010010";
--  constant DIG_2    : std_logic_vector(6 downto 0) := "1011101";
--  constant DIG_3    : std_logic_vector(6 downto 0) := "1011011";
--  constant DIG_4    : std_logic_vector(6 downto 0) := "0111010";
--  constant DIG_5    : std_logic_vector(6 downto 0) := "1101011";
--  constant DIG_6    : std_logic_vector(6 downto 0) := "1101111";
--  constant DIG_7    : std_logic_vector(6 downto 0) := "1010010";
--  constant DIG_8    : std_logic_vector(6 downto 0) := "1111111";
--  constant DIG_9    : std_logic_vector(6 downto 0) := "1111011";
--  constant DIG_0    : std_logic_vector(6 downto 0) := "1110111";
--  constant LETTER_E : std_logic_vector(6 downto 0) := "1101101";
begin
  -- instantiate processor and memories
  mips1: mips port map(clk, reset, pc, instr, memwrite, wem, we1, we2, rdsel, dataadr, writedata, s, readdata);
  --keyboard: ps2_kbd port map(clk, reset, ps2_clk, ps2_data, we1, readdata1, scancode); --need to fix ps2_clk and ps2_data
  
  keyboard : ps2_kbd     -- Make an object of type ps2_kbd
    generic map(
      FREQ     => FREQ
      )
    port map(
      clk      => clk,                  -- clock for the keyboard interface
      rst      => kbd_error,            -- reset the keyboard intfc whenever there is an error receiving a scancode
      ps2_clk  => ps2_clk,              -- clock from the keyboard
      ps2_data => ps2_data,             -- serial data from the keyboard (valid on falling edge of ps2_clk)
		we1 => we1,
		readdata1 => readdata1,
      scancode => scancode,             -- the scancode received from the keyboard
      rdy      => rdy,                  -- indicates when a scancode from the keyboard is available
      error    => kbd_error             -- indicates an error in receiving a scancode from the keyboard
      );
  
  display: vgatest port map(clk50_in, readdata(7 downto 0), writedata, we2, red_out, green_out, blue_out, hs_out, vs_out); -- need to fix clk50_in and scancode
  imem1: imem port map(pc(7 downto 2), instr);
  dmem1: dmem port map(clk, wem, dataadr, writedata, readdatam);
  readmux: mux2 generic map(32) port map(readdata1, readdatam, rdsel, readdata);
  --readmux: mux3 generic map(32) port map(readdatam, readdata1, readdata2, rdsel, readdata);
  
  --scancodeExtended <= X"000000" & scancode;
  
  -- this maps the scancode received from the keyboard into a pattern on the 7-segment display
--  s_x <= DIG_1 when scancode = "00010110" else
--         DIG_2 when scancode = "00011110" else
--         DIG_3 when scancode = "00100110" else
--         DIG_4 when scancode = "00100101" else
--         DIG_5 when scancode = "00101110" else
--         DIG_6 when scancode = "00110110" else
--         DIG_7 when scancode = "00111101" else
--         DIG_8 when scancode = "00111110" else
--         DIG_9 when scancode = "01000110" else
--         DIG_0 when scancode = "01000101" else
--         LETTER_E;
			
			 -- update the LED display
--  process(clk, s_x, rdy)
--  begin
--    if rising_edge(clk) then
--      if rdy = YES then
--        s <= s_x;                       -- update the display each time a scancode is received
--		  --scancode_bus <= scancode;        -- output the scancode to the VGA each time it's recieved
--      end if;
--    end if;
--  end process;
  --s <= writedata(s'range); 
  --s <= "000000" & wem;


end;


