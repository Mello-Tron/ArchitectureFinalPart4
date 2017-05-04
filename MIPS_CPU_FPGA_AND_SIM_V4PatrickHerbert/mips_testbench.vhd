--------------------------------------------------
-- mipstest.vhd
-- Sarah_Harris@hmc.edu 27 May 2007
-- Test bench for MIPS processor
--------------------------------------------------


library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
entity testbench is
end;

architecture test_simulation of testbench is
  component alu is -- Arithmetic/Logic unit with add/sub, AND, OR, set less than
  port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0); --Pat
       alucontrol: in  STD_LOGIC_VECTOR(4 downto 0);
		 shamt: in STD_LOGIC_VECTOR(4 downto 0); --Pat
       result:     inout STD_LOGIC_VECTOR(31 downto 0);
       zero:       out STD_LOGIC);
	end component;
	
	signal a, b, result : STD_LOGIC_VECTOR(31 downto 0);
	signal alucontrol, shamt : STD_LOGIC_VECTOR(4 downto 0);
begin

  -- instantiate device to be tested
  myalu: alu port map(a, b, alucontrol, shamt, result);

  --AND result should be 1
  a <= X"00000001" after 5 ns;
  b <= X"00000001" after 5 ns;
  alucontrol <= "00000" after 5 ns;
  
  --NAND result should be 0
  a <= X"00000001" after 15 ns;
  b <= X"00000001" after 15 ns;
  alucontrol <= "00001" after 15 ns;
  
  --OR result should be 1
  a <= X"00000000" after 30 ns;
  b <= X"00000001" after 30 ns;
  alucontrol <= "00010" after 30 ns;
  
  --SLL result should be X"00000002"
  a <= X"00000001" after 45 ns;
  shamt <= "00001" after 45 ns;
  alucontrol <= "00011" after 45 ns;
  
  --...finish the rest...
  
  assert (alucontrol = "00000" and result = X"00000001") --and
  or (alucontrol = "00001" and result = X"00000000") --nand
  or (alucontrol = "00010" and result = X"00000001") --or
  or (alucontrol = "00011" and result = X"00000002") --sll
  report "There is an error"
  severity error;
  
end test_simulation;