
-- VHDL Instantiation Created from source file vgatest.vhd -- 16:16:07 05/09/2017
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT vgatest
	PORT(
		clk50_in : IN std_logic;
		scancode : IN std_logic_vector(7 downto 0);
		writedata : IN std_logic_vector(31 downto 0);
		we2 : IN std_logic;          
		red_out : OUT std_logic_vector(2 downto 0);
		green_out : OUT std_logic_vector(2 downto 0);
		blue_out : OUT std_logic_vector(2 downto 0);
		hs_out : OUT std_logic;
		vs_out : OUT std_logic
		);
	END COMPONENT;

	Inst_vgatest: vgatest PORT MAP(
		clk50_in => ,
		scancode => ,
		writedata => ,
		we2 => ,
		red_out => ,
		green_out => ,
		blue_out => ,
		hs_out => ,
		vs_out => 
	);


