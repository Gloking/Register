library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_file is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (2 downto 0);
           din : in STD_LOGIC_VECTOR (3 downto 0);
           dout : out STD_LOGIC_VECTOR (3 downto 0));
end reg_file;

architecture structural of reg_file is

    component mux_8to1 is
    generic( n: integer := 8); 
    Port ( s : in STD_LOGIC_VECTOR (2 downto 0);
           din0 : in STD_LOGIC_VECTOR (n-1 downto 0);
           din1 : in STD_LOGIC_VECTOR (n-1 downto 0);
           din2 : in STD_LOGIC_VECTOR (n-1 downto 0);
           din3 : in STD_LOGIC_VECTOR (n-1 downto 0);
           din4 : in STD_LOGIC_VECTOR (n-1 downto 0);
           din5 : in STD_LOGIC_VECTOR (n-1 downto 0);
           din6 : in STD_LOGIC_VECTOR (n-1 downto 0);
           din7 : in STD_LOGIC_VECTOR (n-1 downto 0);
           dout : out STD_LOGIC_VECTOR (n-1 downto 0));
end component;
--- add register module and decoder as components in the same way.
---decoder 3to8
--- en: in std_logic
--- din: in std_logic_vector(2 downto 0)
--- dout: out std_logic_vector(7 downto 0)
    component decoder_3to8 IS
    PORT (
            din : IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
            en : IN STD_LOGIC ;
            dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
            ) ;
END component ;
---reg_module 
---clk: in std_logic
--- rst: in std_logic
--- we: in std_logic
--- din: in std_logic_vector(n-1 downto 0)
--- dout: out std_logic_vector(n-1 downto 0)
component reg_module is
    
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           we : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR(3 downto 0);
           dout : out STD_LOGIC_VECTOR (3 downto 0)
           );
end component;

--- decoder to register signal:
signal reg_en : std_logic_vector(7 downto 0);

---register module to mux signal:
type array_8of4 is array (0 to 7) of std_logic_vector(3 downto 0);
signal mux_in : array_8of4;

begin
--- instantiation:
decoder_inst: decoder_3to8
port map(
    en   =>  we,
    din  =>  addr,
    dout =>  reg_en
);

reg_module_gen: for i in 0 to 7 generate
    reg_module_inst: reg_module
--    generic map(n => 4)
    port map(
        clk   => clk ,
        rst  => rst ,
        we =>  reg_en(i),
        din => din ,
        dout => mux_in(i)
        );
end generate;
mux_inst: mux_8to1
generic map(n => 4)
port map(
    s   => addr ,
    din0=>  mux_in(0),
    din1=> mux_in(1) ,
    din2=> mux_in(2) ,
    din3=> mux_in(3) , 
    din4=> mux_in(4) ,
    din5=> mux_in(5) , 
    din6=> mux_in(6) ,  
    din7=>  mux_in(7),
    dout=> dout
);


end structural;
