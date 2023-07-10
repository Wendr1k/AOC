-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Multiplicador puramente combinacional
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplicador is
    generic (
        largura_dado : natural
    );

    port (
        entrada_a : in std_logic_vector((largura_dado - 1) downto 0);
        entrada_b : in std_logic_vector((largura_dado - 1) downto 0);
        saida     : out std_logic_vector((2 * largura_dado - 1) downto 0);
        overflow  : out std_logic
    );
end multiplicador;

architecture comportamental of multiplicador is
    signal aux_saida : std_logic_vector(2 * largura_dado - 1 downto 0);
begin
    aux_saida <= std_logic_vector(signed(entrada_a) * signed(entrada_b));
    saida <= aux_saida;
    ic: process(entrada_a, entrada_b) is
		begin
		  if (aux_saida < "1111111111111111111111111111111111111111111111111111111111111111") then
        overflow <='1'; 
        else
        overflow <='0';   
        end if;
    end process;

end comportamental;