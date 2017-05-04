--------------------------------------------------------------------
-- Company       : WHitworth
-- Engineer      : Kent Jones
-- Original Engineer      : Dave Vanden Bout
-- Creation Date : 05/17/2005
-- Copyright     : 2005, XESS Corp
-- Tool Versions : WebPACK 6.3.03i
--
-- Description:
--    Memory-testing routine
--
-- Revision:
--    1.0.0
--
-- Additional Comments:
--    1.0.0:
--        Initial release.
--        Modified from memtest.vhd
--
-- License:
--    This code can be freely distributed and modified as long as
--    this header is not removed.
--------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;

package ball is

  component bounceTest
    generic(
      PIPE_EN    :     boolean := false;  -- enable pipelined operations
      DATA_WIDTH :     natural := 16;   -- memory data width
      ADDR_WIDTH :     natural := 23;   -- memory address width
      BEG_TEST   :     natural := 16#00_0000#;  -- beginning test range address
      END_TEST   :     natural := 16#7F_FFFF#  -- ending test range address
      );
    port(
      clk        : in  std_logic;       -- master clock input
      rst        : in  std_logic;       -- reset
      doAgain    : in  std_logic;       -- re-do memory test
      begun      : in  std_logic;       -- memory operation begun indicator
      done       : in  std_logic;       -- memory operation done indicator
      dIn        : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- data from memory
      rdPending  : in  std_logic;       -- read operations in progress indicator                                         
      rd         : out std_logic;       -- memory read control signal
      wr         : out std_logic;       -- memory write control signal
      addr       : out std_logic_vector(ADDR_WIDTH-1 downto 0);  -- address to memory
      dOut       : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- data to memory
      progress   : out std_logic_vector(1 downto 0);  -- memory test progress indicator
      err        : out std_logic        -- memory error flag
      );
  end component;

end package ball;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.common.all;
use WORK.rand.all;

entity draw is
  generic(
    PIPE_EN    :     boolean := false;  -- enable pipelined operations
    DATA_WIDTH :     natural := 16;     -- memory data width
    ADDR_WIDTH :     natural := 23;     -- memory address width
    BEG_TEST   :     natural := 16#00_0000#;  -- beginning test range address
    END_TEST   :     natural := 16#7F_FFFF#  -- ending test range address
    );
  port(
    clk        : in  std_logic;         -- master clock input
    rst        : in  std_logic;         -- reset
    doAgain    : in  std_logic;         -- re-do memory test
    begun      : in  std_logic;         -- memory operation begun indicator
    done       : in  std_logic;         -- memory operation done indicator
    dIn        : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- data from memory
    rdPending  : in  std_logic;         -- read operations in progress indicator                                         
    rd         : out std_logic;         -- memory read control signal
    wr         : out std_logic;         -- memory write control signal
    addr       : out std_logic_vector(ADDR_WIDTH-1 downto 0);  -- address to memory
    dOut       : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- data to memory
    progress   : out std_logic_vector(1 downto 0);  -- memory test progress indicator
    err        : out std_logic          -- memory error flag
    );
end draw;


architecture arch of draw is

    -- registers
  signal addr_r, addr_x : unsigned(addr'range);  -- address register
 
  -- internal signals
  signal ld   : std_logic;              -- load random number gen with seed value
  signal cke  : std_logic;              -- clock-enable for random number gen
  signal memdat : std_logic_vector(dOut'range);  -- random number from generator
  signal seed : std_logic_vector(dIn'range);  -- random number starting seed

begin

  
  addr <= std_logic_vector(addr_r);   -- linear memory addressing
  dOut <= memdat;                     -- always output the data to memory
 
  process(  )
  begin

   -- update the SDRAM address counter
  d1 : process(clk)
  begin
    if rising_edge(clk) then
      if addr = (2**DATA_WIDTH-1)  then
        addr <= ( others => '0' );  -- reset the address at the end of a video frame
      elsif earlyBegun0 = YES then
        addr <= addr + 1;         -- go to the next address once the read of the current address has begun
      end if;
    end if;
  end process;  

  end process;


 end arch;
