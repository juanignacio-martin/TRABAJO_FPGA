----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2024 12:49:52
-- Design Name: 
-- Module Name: FSM - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
entity FSM is
    Generic(
        N_VEHICULOS: POSITIVE := 3; --es el numero de tipos de vehiculo (camnion, moto, coche)
        N_ESTADOS: POSITIVE := 7;
        N_DISPLAYS: POSITIVE := 8;
        SIZE_CUENTA: POSITIVE := 10;
        SIZE_CODE: POSITIVE :=9          
    );
    Port( 
        CLK : in STD_LOGIC;
        DETECTOR : in STD_LOGIC;
        --PAGAR : in STD_LOGIC;
        PAGO_OK : in STD_LOGIC;
        TIPO_VEHICULO: in STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0);
        --ERROR_COUNTER : in STD_LOGIC;
        SIGNAL_CHANGE : in STD_LOGIC_VECTOR (SIZE_CUENTA - 1 downto 0);
        BARRERA_UP : in STD_LOGIC;
		BARRERA_DOWN : in STD_LOGIC;
        --CONTROL_IN : in STD_LOGIC_VECTOR (N_DISPLAYS * N_ESTADOS - 1 downto 0);
        --CODE_IN:in STD_LOGIC_VECTOR (SIZE_CODE * N_ESTADOS - 1 downto 0);
        RESET : in STD_LOGIC;
        ERROR : out STD_LOGIC;
        BARRERA_UP_LED : out STD_LOGIC;
        BARRERA_DOWN_LED : out STD_LOGIC;
        --ESTADOS_OUT : out STD_LOGIC_VECTOR(N_ESTADOS - 1 downto 0);
        --CONTROL_OUT : out STD_LOGIC_VECTOR (N_DISPLAYS - 1 downto 0);
        --CODE_OUT: out STD_LOGIC_VECTOR (SIZE_CODE - 1 downto 0)
        ESTADO_ACTUAL : out STD_LOGIC_VECTOR(3 downto 0)
    );
end FSM;

architecture Behavioral of FSM is

type STATES is (S0,S1,S2,S3,S30,S4,S5);
signal CURRENT_STATE: STATES := S0;
signal NEXT_STATE: STATES;

begin

    state_register: process(RESET, CLK)
    begin
        if RESET = '0' then
            CURRENT_STATE <= S0;
        elsif rising_edge(CLK) then
            CURRENT_STATE <= NEXT_STATE;
        end if;
    end process;
    
    nextstate: process(CLK) --, PAGAR, PAGO_OK, ERROR_COUNTER, CURRENT_STATE)
    begin
        NEXT_STATE <= CURRENT_STATE;
        case CURRENT_STATE is 
            when S0 =>
                if DETECTOR = '1' then 
                    NEXT_STATE <= S1;
                end if;                
            when S1 =>
                if TIPO_VEHICULO /="000" then 
                    NEXT_STATE <= S2;
                end if;                
            when S2 =>
                if PAGO_OK = '1' AND SIGNAL_CHANGE = "0000000000" then
                    NEXT_STATE <= S3;
                elsif SIGNAL_CHANGE /= "0000000000" then
                    NEXT_STATE <= S30;
                end if;
            when S3 =>
                if BARRERA_UP = '1' then
                    NEXT_STATE <= S4;
                end if;
            when s30 =>
                if BARRERA_UP='1' then 
                    NEXT_STATE <= S4;
                end if;
            when s4 => 
                if BARRERA_DOWN  = '1' then
                    NEXT_STATE <= s5;
                end if; 
            when s5 => 
                if DETECTOR='0' then
                    NEXT_STATE <= s0;
                end if; 

           
                  
        end case;
        
    end process;
    
    output_control: process(CLK, CURRENT_STATE)
    begin
        case CURRENT_STATE is 
            when S0 =>
                ERROR <= '0';
                BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '0';
          		ESTADO_ACTUAL<="0000";
                --ESTADOS_OUT <= "0001";
                --CONTROL_OUT <= CONTROL_IN(N_DISPLAYS - 1 DOWNTO 0);
                --CODE_OUT <= CODE_IN(SIZE_CODE - 1 DOWNTO 0);
                
            when S1 =>
                ERROR <= '0';
                BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '0';
          		ESTADO_ACTUAL<="0001";
                --ESTADOS_OUT  <= "0010";
                --CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 2) - 1 DOWNTO N_DISPLAYS);
                --CODE_OUT <= CODE_IN((SIZE_CODE * 2) - 1 DOWNTO SIZE_CODE);
            when S2 =>
                ERROR <= '0';
                BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '0';
          		ESTADO_ACTUAL<="0010";
                --ESTADOS_OUT  <= "0010";
                --CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 2) - 1 DOWNTO N_DISPLAYS);
                --CODE_OUT <= CODE_IN((SIZE_CODE * 2) - 1 DOWNTO SIZE_CODE);
            when S3 =>
                ERROR <= '0';
              BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '0';
          		ESTADO_ACTUAL<="0011";
                --ESTADOS_OUT  <= "0010";
                --CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 2) - 1 DOWNTO N_DISPLAYS);
                --CODE_OUT <= CODE_IN((SIZE_CODE * 2) - 1 DOWNTO SIZE_CODE);
          when S30 =>
                ERROR <= '0';
               BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '0';
          		ESTADO_ACTUAL<="0111";
                --ESTADOS_OUT  <= "0010";
                --CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 2) - 1 DOWNTO N_DISPLAYS);
                --CODE_OUT <= CODE_IN((SIZE_CODE * 2) - 1 DOWNTO SIZE_CODE);
          when S4 =>
                ERROR <= '0';
                BARRERA_UP_LED <= '1';
          		BARRERA_DOWN_LED <= '0';
          		ESTADO_ACTUAL<="0100";
                --ESTADOS_OUT  <= "0010";
                --CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 2) - 1 DOWNTO N_DISPLAYS);
                --CODE_OUT <= CODE_IN((SIZE_CODE * 2) - 1 DOWNTO SIZE_CODE);
         
          when S5 =>
                ERROR <= '0';
                BARRERA_UP_LED <= '1';
          		BARRERA_DOWN_LED <= '0';
          		ESTADO_ACTUAL<="0101";
                --ESTADOS_OUT  <= "0010";
                --CONTROL_OUT <= CONTROL_IN((N_DISPLAYS * 2) - 1 DOWNTO N_DISPLAYS);
                --CODE_OUT <= CODE_IN((SIZE_CODE * 2) - 1 DOWNTO SIZE_CODE);
         
        end case;
        
    end process;

end Behavioral;


