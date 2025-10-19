
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity I2C_TB is
end I2C_TB;

architecture TestBench of I2C_TB is
component I2C is 
    PORT (
            clk              : in    STD_LOGIC;
            O_SCL            : out   STD_LOGIC;
            IO_SDA           : inout STD_LOGIC;
            I_Slave_Add      : in    STD_LOGIC_VECTOR(7 downto 0);
            I_Reg_Add        : in    STD_LOGIC_VECTOR(7 downto 0);
            I_Data_1           : in    STD_LOGIC_VECTOR(8 downto 0);
            I_Data_2         : in    STD_LOGIC_VECTOR(8 downto 0);
            I_Data_3         : in    STD_LOGIC_VECTOR(8 downto 0);
            Master_EN        : in    STD_LOGIC;
            O_Data           : out   STD_LOGIC_VECTOR(7 downto 0);
            I_Slave_Memory   : in STD_LOGIC_VECTOR(7 downto 0)        
        );
end component ;
signal clk : STD_LOGIC;
signal I_Slave_Add : STD_LOGIC_VECTOR(7 downto 0);
signal I_Reg_Add : STD_LOGIC_VECTOR(7 downto 0);
signal I_Data_1 : STD_LOGIC_VECTOR(8 downto 0);
signal I_Data_2 : STD_LOGIC_VECTOR(8 downto 0);
signal I_Data_3 : STD_LOGIC_VECTOR(8 downto 0);
signal Master_EN : STD_LOGIC;
signal Io_SDA : STD_LOGIC;		   
signal O_SCL : STD_LOGIC;
signal O_Data : STD_LOGIC_VECTOR(7 downto 0);
signal I_Slave_Memory :  STD_LOGIC_VECTOR(7 downto 0);
constant clk_period : time := 1 ns;

begin
    UUT : I2C_withoutfor PORT MAP(clk => clk, O_SCL => O_SCL,
     Io_SDA => Io_SDA, I_Slave_Add => I_Slave_Add,
      I_Reg_Add => I_Reg_Add, I_Data_1 => I_Data_1, I_Data_2 => I_Data_2 , I_Data_3 => I_Data_3 ,
       Master_EN => Master_EN, O_Data => O_Data , I_Slave_Memory => I_Slave_Memory);
       
    clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   
   	SimulationProcess : process
    begin    
        I_Data_1 <= "101001101" ;
        I_Data_2 <= "111100000" ;
        I_Data_3 <= "101100110" ;
        I_Reg_Add <= "11011011";
        I_Slave_Add <= "11110110"; 
        I_Slave_Memory <= "11100110";
        Master_EN <= '1';
        wait for 500ns;
        wait;
    end process;


end TestBench;
