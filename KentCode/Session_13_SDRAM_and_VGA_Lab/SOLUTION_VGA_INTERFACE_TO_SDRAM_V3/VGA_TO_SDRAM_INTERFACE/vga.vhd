library IEEE, unisim;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use unisim.vcomponents.all;
use work.common.all;

package vga_pckg is
  component vga
    generic (
      PIXEL_WIDTH     :     natural := 16;  -- pixel width: 1, 2, 4, 8, or 16 bits
      NUM_RGB_BITS    :     natural := 3  -- width of R, G and B color output buses (2 or 3 are only valid values)
      );
    port (
      rst             : in  std_logic;  -- reset
      clk50_in        : in  std_logic;  -- master clock	
      pixel_data_in   : in  std_logic_vector(PIXEL_WIDTH-1 downto 0);  -- input databus to pixel buffer
      r, g, b         : out std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- R,G,B color output buses
      hsync_n         : out std_logic;  -- horizontal sync pulse
      vsync_n         : out std_logic;  -- vertical sync pulse
		eof             : out std_logic		
      );
  end component vga;
end package vga_pckg;



library IEEE, unisim;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use unisim.vcomponents.all;
use work.common.all;

entity vga is
  generic (
      PIXEL_WIDTH     :     natural := 16;  -- pixel width: 1, 2, 4, 8, or 16 bits
      NUM_RGB_BITS    :     natural := 3  -- width of R, G and B color output buses (2 or 3 are only valid values)
    );
  port (
      rst             : in  std_logic;  -- reset
      clk50_in        : in  std_logic;  -- master clock	
      pixel_data_in   : in  std_logic_vector(PIXEL_WIDTH-1 downto 0);  -- input databus to pixel buffer
      r, g, b         : out std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- R,G,B color output buses
      hsync_n         : out std_logic;  -- horizontal sync pulse
      vsync_n         : out std_logic;  -- vertical sync pulse
		eof             : out std_logic	
    );
end entity vga;


architecture vga_arch of vga is

signal clk25      : std_logic;
signal hcounter   : integer range 0 to 800;
signal vcounter   : integer range 0 to 521;

begin

	-- generate a 25Mhz clock
	process (clk50_in)
	begin
	  if clk50_in'event and clk50_in='1' then
		 clk25 <= not clk25;
	  end if;
	end process;

	p2: process (clk25, hcounter, vcounter)
		variable x: integer range 0 to 639;
		variable y: integer range 0 to 479;
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
			if ( (( x > 50) and (x < 200)) and ((y > 200) and (y < 300)) ) then
				r <= std_logic_vector( pixel_data_in( 8 downto 6 ) );
				g <= std_logic_vector( pixel_data_in( 5 downto 3 ) ); 
				b <= std_logic_vector( pixel_data_in( 2 downto 0 ) );
			else
				-- if not traced, set it to "black" color
				r <= "000";
				g <= "000";
				b <= "000";
			end if;
			-- Here is the timing for horizontal synchronization.
			-- (Refer to p. 24, Xilinx, Spartan-3 Starter Kit Board User Guide)
			-- Pulse width: Tpw = 96 cycles @ 25 MHz
			-- Back porch: Tbp = 48 cycles
			-- Display time: Tdisp = 640 cycles
			-- Front porch: Tfp = 16 cycles
			-- Sync pulse time (total cycles) Ts = 800 cycles

			if hcounter > 0 and hcounter < 97 then
				hsync_n <= '0';
			else
				hsync_n <= '1';
			end if;
			-- Here is the timing for vertical synchronization.
			-- (Refer to p. 24, Xilinx, Spartan-3 Starter Kit Board User Guide)
			-- Pulse width: Tpw = 1600 cycles (2 lines) @ 25 MHz
			-- Back porch: Tbp = 23200 cycles (29 lines)
			-- Display time: Tdisp = 38400 cycles (480 lines)
			-- Front porch: Tfp = 8000 cycles (10 lines)
			-- Sync pulse time (total cycles) Ts = 416800 cycles (521 lines)
			if vcounter > 0 and vcounter < 3 then
				vsync_n <= '0';
			else
				vsync_n <= '1';
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

end vga_arch;