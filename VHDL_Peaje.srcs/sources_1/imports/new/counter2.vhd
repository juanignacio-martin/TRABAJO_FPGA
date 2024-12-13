----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2024 15:46:14
-- Design Name: 
-- Module Name: counter2 - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter2 is
    Port ( clk : in STD_LOGIC;
           CE : in STD_LOGIC;
           RST_N : in STD_LOGIC;
           code : out std_logic_vector(3 downto 0)
           );
end counter2;

architecture Behavioral of counter2 is
signal code_i : unsigned(code'range);
begin
    process (clk, RST_N)
    begin
        if RST_N = '0' then
            -- Restablecer el contador a 0 de manera asincrónica
            code_i <= (others => '0');
        elsif rising_edge(clk) then
            if CE = '1' then
                -- Incrementar el contador en el flanco positivo de CE
                code_i <= code_i + 1;
            end if;
        end if;
    end process;

    code <= std_logic_vector(code_i);
end Behavioral;
