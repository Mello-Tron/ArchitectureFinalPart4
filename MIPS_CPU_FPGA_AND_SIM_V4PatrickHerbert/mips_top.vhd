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
  port(clk, reset:         in     STD_LOGIC;
       ps2_clk   : in  std_logic;           -- keyboard clock
		 ps2_data  : in  std_logic;           -- keyboard data
		 clk50_in : in std_logic;
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
		 writedata: in STD_LOGIC_VECTOR(31 downto 0);
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
  signal scancode_to_vga: STD_LOGIC_VECTOR(7 downto 0);
begin
  -- instantiate processor and memories
  mips1: mips port map(clk, reset, pc, instr, memwrite, wem, we1, we2, rdsel, dataadr, writedata, readdata);
  keyboard: ps2_kbd port map(clk, reset, ps2_clk, ps2_data, writedata, readdata1); --need to fix ps2_clk and ps2_data
  display: vgatest port map(clk50_in, scancode_to_vga, writedata); -- need to fix clk50_in and scancode
  imem1: imem port map(pc(7 downto 2), instr);
  dmem1: dmem port map(clk, wem, dataadr, writedata, readdatam);
  readmux: mux2 generic map(32) port map(readdatam, readdata1, rdsel, readdata);
  --readmux: mux3 generic map(32) port map(readdatam, readdata1, readdata2, rdsel, readdata);

end;


