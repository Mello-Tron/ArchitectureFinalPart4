library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;

entity alu is -- Arithmetic/Logic unit with add/sub, AND, OR, set less than
  port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0); --Pat
       alucontrol: in  STD_LOGIC_VECTOR(4 downto 0);
		 shamt: in STD_LOGIC_VECTOR(4 downto 0); --Pat
       result:     inout STD_LOGIC_VECTOR(31 downto 0);
       zero:       out STD_LOGIC);
end;

architecture behave of alu is
  component ShiftLeft --Pat
	 port ( a : in STD_LOGIC_VECTOR(31 downto 0);
			  shamt : in STD_LOGIC_VECTOR(4 downto 0);
			  c : out STD_LOGIC_VECTOR(31 downto 0) );
  end component;
  
  component ShiftRight --Pat
	 port ( a : in STD_LOGIC_VECTOR(31 downto 0);
			  shamt : in STD_LOGIC_VECTOR(4 downto 0);
			  c : out STD_LOGIC_VECTOR(31 downto 0) );
  end component;
  
  signal b2, sum, slt, sgt, shiftleftout, shiftrightout: STD_LOGIC_VECTOR(31 downto 0); --Pat
begin

  b2 <= not b when alucontrol(4) = '1' else b;
  sum <= a + b2 + alucontrol(4);
  -- slt should be 1 if most significant bit of sum is 1
  slt <= X"00000001" when sum(31) = '1' else X"00000000";
  sgt <= X"00000001" when sum(31) = '0' AND sum /= X"00000000" else X"00000000";
  with alucontrol(3 downto 0) select result <=
	 a and b       when "0000",
	 not (a and b) when "0001", --Pat
	 a or b        when "0010",
	 shiftleftout  when "0011", --Pat
	 sum           when "0100",
	 a xor b       when "0101",
	 shiftrightout when "0110", --Pat
	 sgt				when "0111", --Pat
	 slt           when others;
  zero <= '1' when result = X"00000000" else '0';
  
  alushiftleft : ShiftLeft port map(b, shamt, shiftleftout); --Pat
  alushiftright : ShiftRight port map(b, shamt, shiftrightout); --Pat
end;
