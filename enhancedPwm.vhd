----------------------------------------------------------------------------------
-- Company: CSM
-- Engineer: Jesus Ledezma
-- 
-- Create Date: 09/10/2025 09:16:35 AM
-- Design Name: 
-- Module Name: enhancedPwm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.basicBuildingBlocks_package.ALL; --AVOID declarations (component) --why not put file name?

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity enhancedPwm is
  Port (clk, resetn,enb: in std_logic;
        dutyCycle: in std_logic_vector(8 downto 0);
        pwmSignal, rollOver: out std_logic;
        pwmCount: out std_logic_vector(7 downto 0) );
end enhancedPwm;

architecture Behavioral of enhancedPwm is
    signal pwmCount_int : std_logic_vector(7 downto 0);
    signal dutyCycle_int : std_logic_vector(8 downto 0);
    signal dutyGreaterCnt : std_logic;
    signal E255 : std_logic;
    signal control : std_logic_vector(1 downto 0);
    signal pwmCount_9bit : std_logic_vector(8 downto 0);
    
    
    

begin
    pwmCount_9bit <= '0' & pwmCount_int;
    pwmCount <= pwmCount_int;

    counter_inst : genericCounter
        GENERIC MAP(8)
        PORT MAP(clk => clk, resetn => resetn,c => control, d => x"00", q => pwmCount_int); --need to create logic for generating c
    
    dtyCompare_inst : genericCompare
        GENERIC MAP(9)
        PORT MAP(x => dutyCycle_int, y => pwmCount_9bit, g => dutyGreaterCnt, l => open, e => open);
    
    waitCompare_inst : genericCompare
        GENERIC MAP(8)
        PORT MAP(x => x"FF", y => pwmCount_int, g => open, l => open, e => E255);
    
    dtyReg_inst : genericRegister
        GENERIC MAP(9)
        PORT MAP(clk => clk, resetn => resetn, load => E255, d => dutyCycle, q => dutyCycle_int);

    dFF_inst : genericRegister
        GENERIC MAP(1)
        PORT MAP(clk => clk, resetn => resetn, load => '1', d(0) => dutyGreaterCnt, q(0) => pwmSignal); --should load not always be 1?

--logic for when else statement
--control = 00 is hold, = 01 is load d into counter, = 10 increment count by 1, else clear to 0
control <= "00" when enb = '0' else --hold onto value (not enabled)
           "10" when enb = '1' and E255 = '0' else --count up by 1
           "11" when enb = '1' and E255 = '1' else --rollback to 0 
           "01"; --(load in d value of x"00") can't these last two conditions be swapped?
           
rollover <= '1' when control = "11" else
            '0'; --rollover is 1 when control set counter back to 0
    
end Behavioral;
