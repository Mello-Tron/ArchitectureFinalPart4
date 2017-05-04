
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
use WORK.test_dualport_core_pckg.all;
use WORK.vga_pckg.all;
use WORK.sdram.all;


entity test_dualport is
  port(
  
    ---------------------------------------  
    -- GLOBAL CLOCK SIGNAL
	 ---------------------------------------   
    clk    : in    std_logic;  -- master clock (frequency set by FREQ)

    ---------------------------------------
    -- FLASH Ram interface signals 
    ---------------------------------------
    ce_n   : out   std_logic;           -- Flash RAM chip-enable, set to '1' to disable flash ram
	 
    ---------------------------------------
	 -- USER/EXTERNAL INTERFACE SIGNALS
    ---------------------------------------	 
  	 sw2_n  : in    std_logic;           -- active-low pushbutton input
	 pps    : out   std_logic_vector(6 downto 3);  -- outputs to parallel port status bits
	 led    : out   std_logic_vector(6 downto 0);  -- 7-segment LED
	 
    ---------------------------------------
    -- SDRAM interface signals 
    ---------------------------------------
    sdram_clock_in_sclkfb : in    std_logic;         -- SDRAM clock feedback from SDRAM after PCB delays
    sdram_clock_out_sclk  : out   std_logic;         -- SDRAM clock derived from master clock
  	 sdram_control         : out control_pins_sdram;  -- SDRAM control pins
	 sAddr  : out   std_logic_vector(12 downto 0);    -- SDRAM address bus
	 sData  : inout std_logic_vector(15 downto 0);    -- data bus to/from SDRAM

    ---------------------------------------	 
	 -- VGA INTERFACE
    ---------------------------------------	 
    vsync_n: out   std_logic;  -- VGA vertical sync
    hsync_n: out   std_logic;  -- VGA horizontal sync
    red    : out   std_logic_vector(2 downto 0);  -- VGA red signals
    green  : out   std_logic_vector(2 downto 0);  -- VGA green signals
    blue   : out   std_logic_vector(2 downto 0)  -- VGA blue signals
	 
    );
end entity;

architecture arch of test_dualport is
begin

  ---------------------------------------------------------------------------
  -- disable Flash RAM so we can drive the decimal point of the LEDs safely
  ---------------------------------------------------------------------------
  ce_n <= '1';                          

  u0 : test_dualport_core
    generic map(
      FREQ        => 100_000,
      CLK_DIV     => 1.0,
      PIPE_EN     => true,
      DATA_WIDTH  => 16,
      SADDR_WIDTH => 13,
      NROWS       => 8192,
      NCOLS       => 512,
      BEG_ADDR    => 16#00_0000#,
      END_ADDR    => 16#FF_FFFF#,
      BEG_TEST_0  => 16#00_0000#,
      END_TEST_0  => 16#07_5300#,
      BEG_TEST_1  => 16#00_0000#,
      END_TEST_1  => 16#07_5300#
      )
    port map(
	   
	   clk         => clk, 
		sw2_n       => sw2_n,
		heartbeat   => pps(6),
		led         => led,

		sdram_clock_in_sclkfb => sdram_clock_in_sclkfb,   -- SDRAM clock feedback with added external PCB delays
		sdram_clock_out_sclk  => sdram_clock_out_sclk,    -- SDRAM clock derived from master clock	
      sdram_control         => sdram_control,           -- SDRAM control outputs
      sAddr                 => sAddr,                   -- SDRAM address outputs
      sData                 => sData,                   -- SDRAM data bus
	   
		vsync_n     => vsync_n,
		hsync_n     => hsync_n,
		red         => red,
		green       => green,
		blue        => blue
      );

end arch;

