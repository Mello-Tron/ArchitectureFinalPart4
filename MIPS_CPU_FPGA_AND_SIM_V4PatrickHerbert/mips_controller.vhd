library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is -- single cycle control decoder
  port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
       zero:               in  STD_LOGIC;
       memtoreg, memwrite: out STD_LOGIC;
       pcsrc, alusrc:      out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       alucontrol:         out STD_LOGIC_VECTOR(4 downto 0));
end;

architecture struct of controller is
  component maindec
    port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
         memtoreg, memwrite: out STD_LOGIC;
         branch, branchctrl, alusrc:     out STD_LOGIC; --Pat
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         aluop:              out  STD_LOGIC_VECTOR(2 downto 0));
  end component;
  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(2 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(4 downto 0));
  end component;
  component mux2cont
    port(d0, d1: in  STD_LOGIC;
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC);
  end component;
  signal aluop: STD_LOGIC_VECTOR(2 downto 0);
  signal branch: STD_LOGIC;
  signal branchctrl: STD_LOGIC; --Pat
  signal branchandresult: STD_LOGIC; --Pat
  signal notbranchandresult: STD_LOGIC; --Pat
begin
  md: maindec port map(op, memtoreg, memwrite, branch, branchctrl,
                       alusrc, regdst, regwrite, jump, aluop);
  ad: aludec port map(funct, aluop, alucontrol);

  branchandresult <= branch and zero;
  notbranchandresult <= not branchandresult;
  
  branchmux: mux2cont port map(branchandresult, notbranchandresult, branchctrl, pcsrc); --Pat

  -- needs to check for branch not equal -> now is branch mux
  -- pcsrc <= branch and zero;
end;


