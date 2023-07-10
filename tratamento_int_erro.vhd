library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity tratamento_int_erro is
	  generic (
        largura_IFR : natural:= 8
      );
	  port (
		Clock : in std_logic; --# System clock
		Reset : in std_logic; --# Asynchronous reset
	
		PC_atual  : in  std_logic_vector (31 downto 0);
		PC_saida  : out std_logic_vector (31 downto 0);
    control_interrup    : out std_logic;
    ligar_chave    : in std_logic;

    IFR_0 : in std_logic
	  );

end entity tratamento_int_erro;

architecture comportamental of tratamento_int_erro is
	signal IER : std_logic_vector(7 downto 0);
	signal EPC : std_logic_vector(31 downto 0);
	signal interrupt_loc : std_ulogic;
	signal novo_end: std_logic_vector(31 downto 0);
  signal IFR : std_logic_vector(7 downto 0);
  signal Chave_geral : std_logic;
	begin
	IER <="00000001";
	IFR (6 downto 0) <="0000000";
    IFR(0) <= IFR_0;
		ic: process(Clock, Reset) is
		begin
		  if (Reset = '1') then
        Chave_geral <='1'; 
      elsif (ligar_chave = '1') then
        Chave_geral <='1';
        PC_saida <= EPC;
		  elsif (rising_edge(Clock) and Chave_geral='1') then
			for i in IFR'low + 1 to IFR'high loop
				if IFR(i) = '1' and IER(i) = '1'then
					Chave_geral <='0'; 
					EPC <= PC_atual;
					if (i = 0) then 
					PC_saida <= "000000000000000000000010000000000";
          IFR(0) <= '0';
          control_interrup <='1';
						exit;
					end if;
				end if;
			  end loop;
        control_interrup <='0';
      elsif (rising_edge(Clock) and Chave_geral='0') then
        control_interrup <='0';
		  end if;
		end process;
		end comportamental;