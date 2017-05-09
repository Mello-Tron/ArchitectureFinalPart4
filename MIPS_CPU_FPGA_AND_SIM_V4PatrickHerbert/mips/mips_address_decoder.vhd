----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addressdec is
	port(memwrite      :  in  STD_LOGIC;
        address       :  in STD_LOGIC_VECTOR(4 downto 0);
		  wem, we1, we2 :  out STD_LOGIC;
		  rdsel         :  out STD_LOGIC_VECTOR(1 downto 0));
end;

architecture Behavioral of addressdec is
	signal addresscontrols : STD_LOGIC_VECTOR(4 downto 0);
begin
	process(address) begin
		 case address is
			when "01110" => addresscontrols <= "01001"; -- I/O Device 1 Keyboard (using register $t6)
			when "01111" => addresscontrols <= "00110"; -- I/O Device 2 VGA (using register $t7)
			when others  => addresscontrols <= "10000"; -- use data memory
		 end case;
	  end process;

  wem <= addresscontrols(4);
  we1 <= addresscontrols(3);
  we2 <= addresscontrols(2);
  rdsel <= addresscontrols(1 downto 0);

end Behavioral;

