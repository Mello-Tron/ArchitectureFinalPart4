
library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
  port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
       memtoreg, memwrite: out STD_LOGIC;
       branch, branchctrl, alusrc:     out STD_LOGIC; --Pat
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       aluop:              out  STD_LOGIC_VECTOR(2 downto 0)); --Pat
end;

architecture behave of maindec is
  signal controls: STD_LOGIC_VECTOR(10 downto 0); -- now 10 downto 0 Patrick
begin
  process(op) begin
    case op is
      when "000000" => controls <= "01100000111"; -- Rtype 111 means rtype for aludec
      when "100011" => controls <= "01010010000"; -- LW
      when "101011" => controls <= "00X101X0000"; -- SW
      when "000100" => controls <= "00X010X0001"; -- BEQ
		when "000111" => controls <= "00X010X0110"; -- BGTZ
      when "001000" => controls <= "01010000000"; -- ADDI
      when "001101" => controls <= "01010000010"; -- ORI Pat
		when "000101" => controls <= "10X010X0011"; -- BNE Pat
      when "000010" => controls <= "00XXX0X1XXX"; -- J
		when "001010" => controls <= "01010000100"; -- SLTI Pat
		when "001110" => controls <= "01010000101"; -- XORI Pat
      when others   => controls <= "-----------"; -- illegal op
    end case;
  end process;

  branchctrl <= controls(10); -- Pat
  regwrite <= controls(9);
  regdst   <= controls(8);
  alusrc   <= controls(7);
  branch   <= controls(6);
  memwrite <= controls(5);
  memtoreg <= controls(4);
  jump     <= controls(3);
  aluop    <= controls(2 downto 0); -- Pat
end;


