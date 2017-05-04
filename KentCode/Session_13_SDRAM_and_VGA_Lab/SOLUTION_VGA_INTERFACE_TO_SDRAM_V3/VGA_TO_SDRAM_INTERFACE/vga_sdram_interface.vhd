----------------------------------------------------------------------------------
-- This design reads an image from SDRAM and displays it on a VGA monitor
----------------------------------------------------------------------------------


library IEEE, unisim, work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use unisim.vcomponents.all;
use work.vga_pckg.all;
use work.xsasdram.all;
use work.common.all;


entity test_vga is
  generic(
    SDRAM_NROWS     :       natural := 8192; -- 4096 for XSA-50, XSA-100; 8192 for XSA-200, XSA-3S1000
    SDRAM_NCOLS     :       natural := 512;  -- 256 for XSA-50; 512 for XSA-100, XSA-200, XSA-3S1000
    DATA_WIDTH      :       natural := 16;   -- SDRAM databus width
    SADDR_WIDTH     :       natural := 13;   -- # of SDRAM address bits
    HADDR_WIDTH     :       natural := 24;   -- host-side address width
    FREQ            :       natural := 100_000;  -- 50 MHz for XSA-50, XSA-100; 100 MHz for XSA-200, XSA-3S1000
    CLK_DIV         :       natural := 2;    -- pixel clock = FREQ / CLK_DIV
	 PIXEL_WIDTH     :       natural := 16;   -- width of a pixel in memory
    NUM_RGB_BITS    :       natural := 3     -- #bits in each R,G,B component of a pixel
    );
  port(
    -- Pushbutton Reset Signal 
    rst_n           : in    std_logic;
    
	 -- VGA pins
 	 clk             : in    std_logic;  -- master clock (frequency set by FREQ)
	 clk50_in        : in    std_logic;  -- 50 MHZ clock
    vsync_n         : out   std_logic;  -- VGA vertical sync
    hsync_n         : out   std_logic;  -- VGA horizontal sync
    red             : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA red signals
    green           : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA green signals
    blue            : out   std_logic_vector(NUM_RGB_BITS-1 downto 0);  -- VGA blue signals
	 
	 --- LEDs for Debugging
	 led    : out   std_logic_vector(6 downto 0);  -- 7-segment LED
    
	 -- SDRAM I/O
    sclkfb          : in    std_logic;  -- clock from SDRAM after PCB delays
    sclk            : out   std_logic;  -- SDRAM clock sync'ed to master clock
    cke             : out   std_logic;  -- clock-enable to SDRAM
    cs_n            : out   std_logic;  -- chip-select to SDRAM
    ras_n           : out   std_logic;  -- SDRAM row address strobe
    cas_n           : out   std_logic;  -- SDRAM column address strobe
    we_n            : out   std_logic;  -- SDRAM write enable
    ba              : out   unsigned(1 downto 0);  -- SDRAM bank address bits
    sAddr           : out   unsigned(SADDR_WIDTH-1 downto 0);  -- SDRAM row/column address
    sData           : inout unsigned(DATA_WIDTH-1 downto 0);  -- SDRAM in/out databus
    dqmh            : out   std_logic;  -- high databits I/O mask
    dqml            : out   std_logic   -- low databits I/O mask
    );
end entity;



architecture arch of test_vga is

  signal clk1x        : std_logic;      -- sync'ed clock from SDRAM controller
  signal clk25_vga    : std_logic; 
  signal rst          : std_logic;      -- reset signal
  signal eof, eof_n   : std_logic;      -- end-of-frame signal from VGA controller
  signal earlyOpBegun : std_logic;      -- indicates when an SDRAM read operation has begun
  signal rdDone       : std_logic;      -- indicates when data read from the SDRAM is available
  signal address      : unsigned(HADDR_WIDTH-1 downto 0);  -- SDRAM address counter 
  signal pixel        : unsigned(DATA_WIDTH-1 downto 0);  -- pixel values from SDRAM
  
  -- FSM state machine variables to control reads from SDRAM
  signal startNextRead : std_logic := '1';      -- start the next Read from SDRAM
  type   stateType is ( SWAIT, SREAD );
  signal readerState : stateType := SREAD;
  signal readerNextState: stateType := SREAD;
  signal rd_from_ram  : std_logic;      -- we want to read from ram	

begin

	rst <= not rst_n;

   -- Start a new read once a second, toggle heartbeat
	p1: process (clk50_in, rst)
		variable cnt: integer;
	begin
		if clk50_in'event and clk50_in='1' then
			cnt := cnt + 1;
			if rst = '1' then
			   -- reset state, start read
			   cnt := 0;
				address <= TO_UNSIGNED(0, SADDR_WIDTH);
				startNextRead <= '1';
			elsif cnt = 25000000 then
			   -- Once per second increment to the next address and start read
			   address <= address + 1;
			   startNextRead <= '1';			
				cnt := 0;
		   else
			   startNextRead <= '0';
			end if;
		end if;
	end process;
	
  -- state register process
  process( clk1x ) begin
       if rising_edge(clk1x) then
			readerState <= readerNextState;
		 end if;
  end process;
   
  -- next state combinational logic
  process( clk1x, startNextRead, earlyOPBegun, rst ) 
  begin
		if ( rst = '1' ) then
			rd_from_ram <= '0';			
			readerNextState <= SWAIT;
		elsif ( readerState = SWAIT and startNextRead = '0' ) then	
			rd_from_ram <= '0';							
			readerNextState <= SWAIT;				
		elsif ( readerState = SWAIT and startNextRead = '1' ) then	
			rd_from_ram <= '1';							
			readerNextState <= SREAD;	
		elsif ( readerState = SREAD and earlyOPBegun = NO ) then
			rd_from_ram <= '1';					
			readerNextState <= SREAD;		
		else	 
			rd_from_ram <= '0';				
			readerNextState <= SWAIT; 			
		end if;		 
  end process;
  
  -- drive the LEDs with the next address bits to read
  led(6 downto 0) <= std_logic_vector( address(6 downto 0) );	

  -- XSA SDRAM controller used to get pixel data from the external SDRAM
  u0 : XSASDRAMCntl
    generic map(
      FREQ         => FREQ,
      PIPE_EN      => true,             -- use pipelining for maximum speed
      MAX_NOP      => 1000000,          -- disable self-refresh since it takes too long to re-awaken the SDRAM with video timing
      DATA_WIDTH   => DATA_WIDTH,
      NROWS        => SDRAM_NROWS,
      NCOLS        => SDRAM_NCOLS,
      HADDR_WIDTH  => HADDR_WIDTH,
      SADDR_WIDTH  => SADDR_WIDTH
      )
    port map(
      -- host side
      clk          => clk,              -- master clock
      clk1x        => clk1x,            -- master clock resync'ed to account for delays to external SDRAM
      rst          => rst,
      rd           => rd_from_ram,      -- initiate a read every second
      hAddr        => address,          -- the address to read from is stored in the address counter
      earlyOpBegun => earlyOpBegun,     -- indicate when the read operation has actually begun
      rdDone       => rdDone,           -- indicate when the data from the read operation is available
      hDOut        => pixel,            -- this is the pixel data that was read from the SDRAM
      wr           => '0',              -- no SDRAM writing is needed in this application
      hDIn         => TO_UNSIGNED(0, DATA_WIDTH),  -- set the SDRAM write-data bus to zeroes
      -- SDRAM side
      sclkfb       => sclkfb,
      sclk         => sclk,
      cke          => cke,
      cs_n         => cs_n,
      ras_n        => ras_n,
      cas_n        => cas_n,
      we_n         => we_n,
      ba           => ba,
      sAddr        => sAddr,
      sData        => sData,
      dqmh         => dqmh,
      dqml         => dqml
      );
		

  -- VGA generator
  u1 : vga
    generic map (
	 PIXEL_WIDTH    => PIXEL_WIDTH,   -- width of a pixel in memory
    NUM_RGB_BITS   => NUM_RGB_BITS   -- #bits in each R,G,B component of a pixel
    )
    port map (
      rst             => rst,
      clk50_in        => clk50_in,      -- use the resync'ed master clock so VGA generator is in sync with SDRAM	
      pixel_data_in   => std_logic_vector(pixel),         -- pixel data from SDRAM
      r               => red,           -- RGB components
      g               => green,
      b               => blue,
      hsync_n         => hsync_n,       -- horizontal sync
      vsync_n         => vsync_n,        -- vertical sync
		eof             => eof
      );
  
  eof_n <= not eof;                   -- negate the full signal for use in controlling the SDRAM read operation

end arch;
