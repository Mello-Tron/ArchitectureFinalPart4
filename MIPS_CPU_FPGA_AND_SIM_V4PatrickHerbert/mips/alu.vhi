
-- VHDL Instantiation Created from source file alu.vhd -- 09:44:54 04/06/2017
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT alu
	PORT(
		a : IN std_logic_vector(31 downto 0);
		b : IN std_logic_vector(31 downto 0);
		alucontrol : IN std_logic_vector(3 downto 0);
		shamt : IN std_logic_vector(4 downto 0);    
		result : INOUT std_logic_vector(31 downto 0);      
		zero : OUT std_logic
		);
	END COMPONENT;

	Inst_alu: alu PORT MAP(
		a => ,
		b => ,
		alucontrol => ,
		shamt => ,
		result => ,
		zero => 
	);


