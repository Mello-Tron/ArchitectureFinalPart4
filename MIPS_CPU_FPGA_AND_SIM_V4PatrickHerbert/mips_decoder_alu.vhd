library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity aludec is -- ALU control decoder
  port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
       aluop:      in  STD_LOGIC_VECTOR(2 downto 0);
       alucontrol: out STD_LOGIC_VECTOR(4 downto 0));
end;

architecture behave of aludec is
begin
  process(aluop, funct) begin
    case aluop is
      when "000" => alucontrol <= "00100"; -- add (for lb/sb/addi)
      when "001" => alucontrol <= "10100"; -- sub (for beq)
	   when "010" => alucontrol <= "00010"; -- or  (for ori)          --Pat
		when "011" => alucontrol <= "10100"; -- sub (for bnq)          --Pat
		when "100" => alucontrol <= "10111"; -- set on less (for slti) --Pat
		when "101" => alucontrol <= "00101"; -- xor (for xori)         --Pat
		when "110" => alucontrol <= "00111"; -- sgt (for bgtz)       --Pat
      when others => case funct is         -- R-type instructions
								 when "000000" => alucontrol <= "00011"; -- sll (for sll) --Pat
								 when "000010" => alucontrol <= "00110"; -- srl (for srl) --Pat
                         when "100000" => alucontrol <= "00100"; -- add (for add)
                         when "100010" => alucontrol <= "10100"; -- subtract (for sub)
                         when "100100" => alucontrol <= "00000"; -- logical and (for and)
                         when "100101" => alucontrol <= "00010"; -- logical or (for or)
                         when "101010" => alucontrol <= "11111"; -- set on less (for slt)
                         when others   => alucontrol <= "-----"; -- should never happen
                     end case;
    end case;
  end process;
end;

