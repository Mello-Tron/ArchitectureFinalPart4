--------------------------------------------------------------------
-- Company : Whitworth University
-- Engineer : Kent Jones
-- Original Engineer : Dave Vanden Bout
-- Creation Date : 06/13/2005
-- Copyright : 2005, XESS Corp
-- Tool Versions : WebPACK 6.3.03i
--
-- Description:
-- This module tests the dualport module for the SDRAM controller.
-- A memory generator is connected to the port0 channel of the dualport
-- sdram module, and a VGA driver reads from the port1 channel of the 
-- dualport module.  
--
-- The VGA driver can read either from the same memory that the writer
-- is accessing or from a different area of memory.
--
--  +-----------+    +---------+    +--------------+    +---------------+    +-----------+
--  |           |    | memory  |    |              |    |               |    |           |
--  |           |    | writer  |<==>|              |    |               |    |           |
--  |           |    |   0     |    |              |    |               |    |           |
--  |   VGA     |    +---------+    |   dualport   |    |    SDRAM      |    |   SDRAM   |
--  |   DRIVER  |    | module  |<==>|  controller  |<==>|     chip      |<==>|           |
--  |           |    +---------+    |              |    |               |    |           |
--  |           |    | memory  |    |              |    |               |    |           |
--  |           |<==>| reader  |<==>|              |    |               |    |           |
--  |           |    |   1     |    |              |    |               |    |           |
--  +-----------+    +---------+    +--------------+    +---------------+    +-----------+
--                                                
-- Revision:
-- 2.0.0
--
-- Additional Comments:
--
-- License:
-- This code can be freely distributed and modified as long as
-- this header is not removed.
--------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use WORK.sdram.all;

package test_dualport_core_pckg is
  component test_dualport_core
    generic(
      PIXEL_WIDTH     :       natural := 8;  -- width of a pixel in memory
      NUM_RGB_BITS    :       natural := 3;  -- #bits in each R,G,B component of a pixel
      PIXELS_PER_LINE :       natural := 800;  -- width of image in pixels
      LINES_PER_FRAME :       natural := 600;  -- height of image in scanlines
      FIT_TO_SCREEN   :       boolean := true;  -- adapt video timing to fit image width x height
		
		
      FREQ            :       natural                       := 100_000;  -- frequency of operation in KHz
      CLK_DIV         :       real                          := 2.0;  -- divisor for FREQ (can only be 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 8.0 or 16.0)
      PIPE_EN         :       boolean                       := true;  -- enable fast, pipelined SDRAM operation
      DATA_WIDTH      :       natural                       := 16;  -- SDRAM data width
      SADDR_WIDTH     :       natural                       := 13;  -- SDRAM row/col address width
      NROWS           :       natural                       := 4096;  -- number of rows in the SDRAM
      NCOLS           :       natural                       := 256;  -- number of columns in each SDRAM row
      -- beginning and ending addresses for the entire SDRAM
      BEG_ADDR        :       natural                       := 16#00_0000#;
      END_ADDR        :       natural                       := 16#3F_FFFF#;
      -- beginning and ending address for port 0 if needed
      BEG_TEST_0      :       natural                       := 16#00_0000#;
      END_TEST_0      :       natural                       := 16#1F_FFFF#;
      -- beginning and ending address for port 1 if needed
      BEG_TEST_1      :       natural                       := 16#20_0000#;
      END_TEST_1      :       natural                       := 16#3F_FFFF#;
      -- allocate time slots between ports 0 and 1.  Port 1 gets 3/4 of the bandwidth, port 0 gets 1/4.
      PORT_TIME_SLOTS :       std_logic_vector(15 downto 0) := "1111111111110000"
      );
		
    port(
	 
      ---------------------------------------  
      -- GLOBAL CLOCK SIGNAL
	   ---------------------------------------  	 
      clk        : in    std_logic;  -- main clock input from external clock source
 
      ---------------------------------------
	   -- USER/EXTERNAL INTERFACE SIGNALS
      ---------------------------------------
      sw2_n      : in    std_logic;  -- active-low pushbutton input
      heartbeat  : out   std_logic;  -- heartbeat status (usually sent to parallel port status pin)
		led        : out   std_logic_vector(6 downto 0);  -- 7-segment LED
	
      -----------------------------------------------		
		-- VGA INTERFACE
		----------------------------------------------- 
		vsync_n : out   std_logic;  -- VGA vertical sync
		hsync_n : out   std_logic;  -- VGA horizontal sync
		red     : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA red signals
		green   : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA green signals
		blue    : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA blue signals

		-----------------------------------------------
		-- SDRAM interface signals 
      ----------------------------------------------- 
      sdram_clock_in_sclkfb : in    std_logic;         -- SDRAM clock feedback from SDRAM after PCB delays
      sdram_clock_out_sclk  : out   std_logic;         -- SDRAM clock derived from master clock
  	   sdram_control         : out control_pins_sdram;  -- SDRAM control pins
      sAddr                 : out   std_logic_vector(SADDR_WIDTH-1 downto 0);  -- SDRAM address bus
      sData                 : inout std_logic_vector(DATA_WIDTH-1 downto 0)    -- data bus to/from SDRAM

      );
  end component test_dualport_core;
end package test_dualport_core_pckg;




library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use WORK.common.all;
--use WORK.mem.all;
use WORK.xsasdram.all;
use WORK.sdram.all;
use WORK.vga_pckg.all;


entity test_dualport_core is
  generic(
    PIXEL_WIDTH     :       natural := 8;  -- width of a pixel in memory
    NUM_RGB_BITS    :       natural := 3;  -- #bits in each R,G,B component of a pixel
    PIXELS_PER_LINE :       natural := 1024;  -- width of image in pixels
    LINES_PER_FRAME :       natural := 768;  -- height of image in scanlines
    FIT_TO_SCREEN   :       boolean := true;  -- adapt video timing to fit image width x height

    FREQ            :       natural                       := 100_000;  -- frequency of operation in KHz
    CLK_DIV         :       real                          := 1.0;    -- divisor for FREQ (can only be 1.5, 2.0, 2.5, 3.0, 4.0, 5.0, 8.0 or 16.0)
    PIPE_EN         :       boolean                       := true;  -- enable fast, pipelined SDRAM operation
    DATA_WIDTH      :       natural                       := 16;  -- SDRAM data width
    SADDR_WIDTH     :       natural                       := 13;  -- SDRAM row/col address width
    NROWS           :       natural                       := 4096;  -- number of rows in the SDRAM
    NCOLS           :       natural                       := 256;  -- number of columns in each SDRAM row
    -- beginning and ending addresses for the entire SDRAM
    BEG_ADDR        :       natural                       := 16#00_0000#;
    END_ADDR        :       natural                       := 16#3F_FFFF#;
    -- beginning and ending address for use by port 0 if desired
    BEG_TEST_0      :       natural                       := 16#00_0000#;
    END_TEST_0      :       natural                       := 16#1F_FFFF#;
    -- beginning and ending address for use by port 1 if desired
    BEG_TEST_1      :       natural                       := 16#20_0000#;
    END_TEST_1      :       natural                       := 16#3F_FFFF#;
    -- allocate time slots between ports 0 and 1.  Port 1 gets 3/4 of the bandwidth, port 0 gets 1/4.
    PORT_TIME_SLOTS :       std_logic_vector(15 downto 0) := "1111111111110000"
    );
	 
	 
  port(
  
      ---------------------------------------  
      -- GLOBAL CLOCK SIGNAL
	   ---------------------------------------  	 
      clk        : in    std_logic;  -- main clock input from external clock source
 
      ---------------------------------------
	   -- USER/EXTERNAL INTERFACE SIGNALS
      ---------------------------------------
      sw2_n      : in    std_logic;  -- active-low pushbutton input
      heartbeat  : out   std_logic;  -- heartbeat status (usually sent to parallel port status pin)
		led        : out   std_logic_vector(6 downto 0);  -- 7-segment LED
	
      -----------------------------------------------		
		-- VGA INTERFACE
		----------------------------------------------- 
		vsync_n : out   std_logic;  -- VGA vertical sync
		hsync_n : out   std_logic;  -- VGA horizontal sync
		red     : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA red signals
		green   : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA green signals
		blue    : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA blue signals

		-----------------------------------------------
		-- SDRAM interface signals 
      ----------------------------------------------- 
      sdram_clock_in_sclkfb : in    std_logic;         -- SDRAM clock feedback from SDRAM after PCB delays
      sdram_clock_out_sclk  : out   std_logic;         -- SDRAM clock derived from master clock
  	   sdram_control         : out control_pins_sdram;  -- SDRAM control pins
      sAddr                 : out   std_logic_vector(SADDR_WIDTH-1 downto 0);  -- SDRAM address bus
      sData                 : inout std_logic_vector(DATA_WIDTH-1 downto 0)    -- data bus to/from SDRAM

    );
end entity;


architecture arch of test_dualport_core is
  constant HADDR_WIDTH : natural := log2(END_ADDR-BEG_ADDR+1);
  signal   rst_i       : std_logic;     -- internal reset signal
  signal   clk_i       : std_logic;     -- internal master clock signal
  signal   clk_b       : std_logic;     -- buffered input (non-DLL) clock
  signal   lock        : std_logic;     -- SDRAM clock DLL lock indicator
  signal   dataIn      : std_logic_vector(DATA_WIDTH-1 downto 0);  -- input databus from SDRAM
  signal   dataOut     : std_logic_vector(DATA_WIDTH-1 downto 0);  -- output databus to SDRAM
  signal   divCnt      : std_logic_vector(22 downto 0);  -- clock divider
  signal   syncButton  : std_logic_vector(1 downto 0);  -- button input sync'ed to clock domain

  -- signals that go through the dualport module port0 and port1 ports and to the SDRAM controller
  signal begun0, begun1, begun                : std_logic;  -- read/write operation started indicator
  signal earlyBegun0, earlyBegun1, earlyBegun : std_logic;  -- read/write operation started indicator
  signal rdPending0, rdPending1, rdPending    : std_logic;  -- read operation pending in SDRAM pipeline indicator
  signal done0, done1, done                   : std_logic;  -- read/write operation complete indicator
  signal rdDone0, rdDone1, rdDone             : std_logic;  -- read operation complete indicator
  signal hAddr0, hAddr1, hAddr                : std_logic_vector(HADDR_WIDTH-1 downto 0);  -- host-side address bus
  signal hDIn0, hDIn1, hDIn                   : std_logic_vector(DATA_WIDTH-1 downto 0);  -- host-side data to SDRAM
  signal hDOut0, hDOut1, hDOut                : std_logic_vector(DATA_WIDTH-1 downto 0);  -- host-side data from SDRAM
  signal rd0, rd1, rd                         : std_logic;  -- host-side read control signal
  signal wr0, wr1, wr                         : std_logic;  -- host-side write control signal
  signal rst                                  : std_logic;  -- SDRAM controller reset
  signal status                               : std_logic_vector(3 downto 0);  -- SDRAM controller status

  -- status signals that can be used for debugging purposes
  signal progress0, progress1 : std_logic_vector(1 downto 0);  -- test progress indicator
  signal err0, err1           : std_logic;  -- test error flag

  -- set the reset flag upon startup
  attribute INIT          : string;
  attribute INIT of rst_i : signal is "1";
  
  -- VGA Generator Signals
  signal eof          : std_logic;      -- end-of-frame signal from VGA controller
  signal full         : std_logic;      -- indicates when the VGA pixel buffer is full
 
  -- Color Signals to send to graphics memory
  signal color        : std_logic_vector(PIXEL_WIDTH-1 downto 0);
  constant COL_BLACK  : std_logic_vector(PIXEL_WIDTH-1 downto 0) := "00000000";
  constant COL_RED    : std_logic_vector(PIXEL_WIDTH-1 downto 0) := "11100000";
  constant COL_GREEN  : std_logic_vector(PIXEL_WIDTH-1 downto 0) := "00011000";
  constant COL_BLUE   : std_logic_vector(PIXEL_WIDTH-1 downto 0) := "00000111";
begin

  ------------------------------------------------------------------------
  -- internal reset flag is set active by config. bitstream
  -- and then gets reset after clocks start.
  ------------------------------------------------------------------------
  process(clk_b)
  begin
    if rising_edge(clk_b) then
      if lock = NO then
        rst_i <= YES;                   -- keep in reset until DLLs start up and lock
      else
        rst_i <= NO;                    -- release reset once DLLs lock
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------
  -- synchronize the pushbutton to the main clock.  The LSB of syncButton
  -- is high when the pushbutton is pressed.
  ------------------------------------------------------------------------
  process(clk_b)
  begin
    if rising_edge(clk_b) then
      syncButton <= not(sw2_n) & syncButton(syncButton'high downto 1);
    end if;
  end process;

  ---------------------------------------------------------------------------------
  -- Instantiate a process that writes to memory via port 0 of the dual port SDRAM
---------------------------------------------------------------------------------

  -- send the current color to the data input of memory port 0
  hDIn0  <= color ;
  
  write_to_memory_via_port_0 : process( clk_i )
  variable x : std_logic_vector( 9 downto 0)  := ( others => '0');
  variable y : std_logic_vector( 9 downto 0)  := ( others => '0');
  variable z : std_logic_vector( 9 downto 0)  := ( others => '0');
  variable draw : boolean := false;
  variable draw2 : boolean := false;
  variable col  : std_logic_vector( 7 downto 0 ) := ( others => '0');
  begin
    if rising_edge(clk_i) then
      wr0 <= YES;
      if hAddr0 = conv_std_logic_vector( END_TEST_0, hAddr0'length )  then
		  draw := false;
		  x := "0000000000";
		  y := "0000000000";
		  z := "0000000000";
		  hAddr0  <= conv_std_logic_vector( BEG_TEST_0, hAddr0'length );
		elsif earlyBegun0 = YES then
		  
		  hAddr0 <= hAddr0 + 1;         -- go to the next address once the read of the current address has begun


		  x := x + 1;

		  if ( x = 800 ) then
		        x := "0000000000";
				  if ( y = 10 ) then
					   y := "0000000000";
						draw := not draw;
					else
						y := y + 1;
					end if;
		  end if; 
		  
		  if ( draw ) then
		      col := COL_BLUE;
		  else
		      col := COL_RED;
		  end if;
		  
		  color <= col;
		  		  
      end if;
    end if;
  end process;  
  
  ---------------------------------------------------------------------------------------------------------
  -- Instantiate a process that reads from port 1 of dual port SDRAM and sends to VGA monitor input pipeline
  ----------------------------------------------------------------------------------------------------------
  rd1 <= not full;                 -- negate the full signal for use in controlling the SDRAM read operation
  read_from_memory_via_port_1 : process( clk_i )
  begin
    if rising_edge(clk_i) then
      if eof = YES then
        hAddr1 <= ( others => '0' );  -- reset the address at the end of a video frame
      elsif earlyBegun1 = YES then
        hAddr1 <= hAddr1 + 1;         -- go to the next address once the read of the current address has begun
      end if;
    end if;
  end process;
 
 --------------------------------------------------------------------------------------------------		  
 -- Instantiate another process for the VGA generator module the input to this comes from the process above
 --------------------------------------------------------------------------------------------------	 
  vga_generator_port1 : vga
    generic map (
      FREQ            => FREQ,
      CLK_DIV         => 2,
      PIXEL_WIDTH     => PIXEL_WIDTH,
      PIXELS_PER_LINE => PIXELS_PER_LINE,
      LINES_PER_FRAME => LINES_PER_FRAME,
      NUM_RGB_BITS    => NUM_RGB_BITS,
      FIT_TO_SCREEN   => FIT_TO_SCREEN
      )
    port map (
      rst             => rst,
      clk             => clk_i,         -- use the resync'ed master clock so VGA generator is in sync with SDRAM
      wr              => rdDone1,       -- write to pixel buffer when the data read from SDRAM is available
      pixel_data_in   => hDOut1,        -- pixel data from SDRAM that contains "color" information
      full            => full,          -- indicates when the pixel buffer is full
      eof             => eof,           -- indicates when the VGA generator has finished a video frame
      r               => red,           -- RGB components come out of the generator 
      g               => green,
      b               => blue,
      hsync_n         => hsync_n,       -- horizontal sync
      vsync_n         => vsync_n,       -- vertical sync
      blank           => open     
	  );

  ------------------------------------------------------------------------
  -- Instantiate the actual dualport module that allows us to talk to memory
  ------------------------------------------------------------------------
  u1 : dualport
    generic map(
      PIPE_EN         => PIPE_EN,
      PORT_TIME_SLOTS => PORT_TIME_SLOTS,
      DATA_WIDTH      => DATA_WIDTH,
      HADDR_WIDTH     => HADDR_WIDTH
      )
    port map(
      clk             => clk_i,
      --  SDRAM port 0 connections
      rst0            => rst_i,
      rd0             => rd0,
      wr0             => wr0,
      rdPending0      => rdPending0,
      opBegun0        => begun0,
      earlyOpBegun0   => earlyBegun0,
      rdDone0         => rdDone0,
      done0           => done0,
      hAddr0          => hAddr0,
      hDIn0           => hDIn0,
      hDOut0          => hDOut0,
      status0         => open,
      
		-- SDRAM port 1 connections
      rst1            => rst_i,
      rd1             => rd1,
      wr1             => wr1,
      rdPending1      => rdPending1,
      opBegun1        => begun1,
      earlyOpBegun1   => earlyBegun1,
      rdDone1         => rdDone1,
      done1           => done1,
      hAddr1          => hAddr1,
      hDIn1           => hDIn1,
      hDOut1          => hDOut1,
      status1         => open,
      
		-- connections to the SDRAM controller
      rst             => rst,
      rd              => rd,
      wr              => wr,
      rdPending       => rdPending,
      opBegun         => begun,
      earlyOpBegun    => earlyBegun,
      rdDone          => rdDone,
      done            => done,
      hAddr           => hAddr,
      hDIn            => hDIn,
      hDOut           => hDOut,
      status          => status
      );

  ------------------------------------------------------------------------
  -- Instantiate the SDRAM controller that connects to the dualport
  -- module and interfaces to the external SDRAM chip.
  ------------------------------------------------------------------------
  u2 : xsaSDRAMCntl
    generic map(
      FREQ         => FREQ,
      CLK_DIV      => CLK_DIV,
      PIPE_EN      => PIPE_EN,
      DATA_WIDTH   => DATA_WIDTH,
      NROWS        => NROWS,
      NCOLS        => NCOLS,
      HADDR_WIDTH  => HADDR_WIDTH,
      SADDR_WIDTH  => SADDR_WIDTH
      )
    port map(
      clk          => clk,              -- master clock from external clock source (unbuffered)
      bufclk       => clk_b,            -- buffered master clock output
      clk1x        => clk_i,            -- synchronized master clock (accounts for delays to external SDRAM)
      clk2x        => open,             -- synchronized doubled master clock
      lock         => lock,             -- DLL lock indicator
      rst          => rst,              -- reset
      rd           => rd,               -- host-side SDRAM read control from dualport
      wr           => wr,               -- host-side SDRAM write control from dualport
      rdPending    => rdPending,        -- read operation to SDRAM is in progress
      opBegun      => begun,            -- indicates memory read/write has begun
      earlyOpBegun => earlyBegun,       -- early indicator that memory operation has begun
      rdDone       => rdDone,           -- indicates SDRAM memory read operation is done
      done         => done,             -- indicates SDRAM memory read or write operation is done
      hAddr        => hAddr,            -- host-side address from dualport to SDRAM
      hDIn         => hDIn,             -- test data pattern from dualport to SDRAM
      hDOut        => hDOut,            -- SDRAM data output to dualport
      status       => status,           -- SDRAM controller state (for diagnostics)
      
		sdram_clock_in_sclkfb => sdram_clock_in_sclkfb,   -- SDRAM clock feedback with added external PCB delays
		sdram_clock_out_sclk  => sdram_clock_out_sclk,    -- SDRAM clock derived from master clock	
      sdram_control         => sdram_control,           -- SDRAM control outputs
 
      sAddr        => sAddr,                            -- SDRAM address
      sData        => sData                             -- SDRAM databus
 
      );

  ------------------------------------------------------------------------
  --  The progress0 signal can be used for debugging. Assign values to 
  --  progress0 to light up LEDs
  ------------------------------------------------------------------------
  led(2 downto 0) <= "001" when progress0 = "00" else  
                     "010" when progress0 = "01" else  
                     "100" when progress0 = "10" else  
                     "111" when err0 = YES       else  
                     "000";             

  ------------------------------------------------------------------------
  --  The progress1 signal can be used for debugging. Assign values to 
  --  progress1 to light up LEDs
  ------------------------------------------------------------------------
  led(5 downto 3) <= "001" when progress1 = "00" else  
                     "010" when progress1 = "01" else  
                     "100" when progress1 = "10" else  
                     "111" when err1 = YES       else  
                     "000";          
  led(6) <= '0';  -- top-most LED segment is always OFF

  ------------------------------------------------------------------------
  -- Generate some slow signals from the master clock.
  ------------------------------------------------------------------------
  process(clk_b)
  begin
    if rising_edge(clk_b) then
      divCnt <= divCnt+1;
    end if;
  end process;

  ------------------------------------------------------------------------
  -- Set a heartbeat signal for other timing purposes
  --   50% duty cycle -> test in progress
  --   75% duty cycle -> test passed
  --   25% duty cycle -> test failed
  ------------------------------------------------------------------------
  heartBeat <= divCnt(16);                            

end arch;
