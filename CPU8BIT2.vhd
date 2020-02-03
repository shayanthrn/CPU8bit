----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:51:23 01/04/2020 
-- Design Name: 
-- Module Name:    CPU8BIT2 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU8BIT2 is
	port ( data_out: out std_logic_vector(7 downto 0);
		data_in: in std_logic_vector(7 downto 0);
		rst: in std_logic;
		clk: in std_logic);
	end;
	
architecture CPU_ARCH of CPU8BIT2 is
	signal acc: std_logic_vector(7 downto 0);
	signal adreg: std_logic_vector(4 downto 0);
	signal pc: std_logic_vector(4 downto 0);
	signal states: std_logic_vector(2 downto 0);
	
	type ram is array (31 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
	signal memory : ram;
	
begin	
	Process(clk,rst)
		variable IR : STD_LOGIC_VECTOR( 7 downto 0);
		variable DR : STD_LOGIC_VECTOR( 7 downto 0);
		begin
			If (rst = '0') then
		
				memory(1) <= "11000000";
				memory(2) <= "00100111";
				memory(3) <= "01001000";
				memory(4) <= "01100010";
				memory(5) <= "10100000";
				memory(6) <= "10000111";
				memory(7) <= "00000111";
				memory(8) <= "00000001";
				
				
				IR := (others => '0');
				adreg <= (others => '0');
				states <= (others => '0');
				acc <= (others => '0');
				pc <= (others => '0');
			elsIf rising_edge(clk) then
				-- PC / Adress path
				If (states = "000") then
					pc <= STD_LOGIC_VECTOR(unsigned(adreg) + 1);
					IR := memory(to_integer(unsigned(pc)));
				else
				
					DR := memory(to_integer(unsigned(IR(4 downto 0))));
					adreg <= pc;
				end If;
				-- ALU / Data Path
				Case states is
					when "001" => acc <= STD_LOGIC_VECTOR(unsigned(acc(7 downto 0)) + unsigned(DR)); -- add
					when "010" => acc(7 downto 0) <= STD_LOGIC_VECTOR(unsigned(acc(7 downto 0)) - unsigned(DR)); -- sub
					when "011" => acc(7 downto 0) <= acc(7 downto 0) or data_in; -- or
					when "100" => acc(7 downto 0) <= "00000000"; ---clear acc
					when "101" => acc(7 downto 0) <= acc(7 downto 0) and data_in; -- and
					when "110" => acc <= STD_LOGIC_VECTOR(unsigned(acc(7 downto 0)) + unsigned(data_in)); -- add data_in
					when "111" => acc(7 downto 0) <= STD_LOGIC_VECTOR(unsigned(acc(7 downto 0)) - unsigned(data_in)); -- sub Data_in 
					when others => null; 
				end Case;
				-- State machine
				If (states /= "000") then states <= "000"; -- fetch next opcode
				else states <=  IR(7 downto 5); -- execute instruction
				end If;
			end If;
	end Process;
	-- output
	data_out <= acc(7 downto 0);
end CPU_ARCH;

