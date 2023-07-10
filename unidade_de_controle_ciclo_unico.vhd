-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
-- Unidade de controle ciclo único (look-up table) do processador
-- puramente combinacional
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- unidade de controle
entity unidade_de_controle_ciclo_unico is
    generic (
        INSTR_WIDTH       : natural := 32;
        OPCODE_WIDTH      : natural := 7;
        DP_CTRL_BUS_WIDTH : natural := 18;
        ULA_CTRL_WIDTH    : natural := 3
    );
    port (
        instrucao : in std_logic_vector(INSTR_WIDTH - 1 downto 0);       -- instrução
        controle  : out std_logic_vector(DP_CTRL_BUS_WIDTH - 1 downto 0); -- controle da via
        ligar_chave :out std_logic
    );
end unidade_de_controle_ciclo_unico;

architecture beh of unidade_de_controle_ciclo_unico is
    -- As linhas abaixo não produzem erro de compilação no Quartus II, mas no Modelsim (GHDL) produzem.	
    --signal inst_aux : std_logic_vector (INSTR_WIDTH-1 downto 0);			-- instrucao
    --signal opcode   : std_logic_vector (OPCODE_WIDTH-1 downto 0);			-- opcode
    --signal ctrl_aux : std_logic_vector (DP_CTRL_BUS_WIDTH-1 downto 0);		-- controle

    signal inst_aux : std_logic_vector (31 downto 0); -- instrucao
    signal opcode   : std_logic_vector (6 downto 0);  -- opcode
    signal ctrl_aux : std_logic_vector (17 downto 0);  -- controle

begin
    inst_aux <= instrucao;
    -- A linha abaixo não produz erro de compilação no Quartus II, mas no Modelsim (GHDL) produz.	
    --	opcode <= inst_aux (INSTR_WIDTH-1 downto INSTR_WIDTH-OPCODE_WIDTH);
    opcode <= inst_aux (6 downto 0);

    process (opcode)
    begin
        case opcode is
                -- ADD
            when "0000000" =>
                ctrl_aux <= "010001101100000000";
                -- SUB
            when "0000001" =>
                ctrl_aux <= "010001101100010000";
                -- AND
            when "0000010" =>
                ctrl_aux <= "010001101100100000";
                -- OR	
            when "0000011" =>
                ctrl_aux <= "010001101100110000";
                -- NOT
            when "0000100" =>
                ctrl_aux <= "010001101101110000";
                --SRR
            when "0000101" =>
                ctrl_aux <= "010000001000000010";
                --SLR
            when "0000110" =>
                ctrl_aux <= "010000101000000010";
                --MULTI
            when "0000111" =>
                ctrl_aux <= "011001100000000000";
                --JALR
            when "0001000" =>
                ctrl_aux <= "010011101100000000";
                --LW
            when "0001001" =>
                ctrl_aux <= "010001101010000001";
                --SW
            when "0001010" =>
                ctrl_aux <= "010001100010000100";
                --ADDI
            when "0001011" =>
                ctrl_aux <= "010001101110000000";
                --BEQ
            when "0001100" =>
                ctrl_aux <= "010001100000001000";
                --SYSCALL
            when "0001101" =>
                ctrl_aux <= "010000000000000000";
                --JUMP
            when "0001110" =>
                ctrl_aux <= "010001110000000000";
                --MOVEHI
            when "0001111" =>
                ctrl_aux <= "010101101100000011";
                --MOVELO
            when "0010000" =>
                ctrl_aux <= "010001101100000011";
            when "0010001" =>
                ctrl_aux <= "100000000000000000";
            when others =>
                --ctrl_aux <= (others => '1');
                ctrl_aux <= "010000000000000000";
        end case;
    end process;
    ligar_chave <= ctrl_aux(17);
    controle <= ctrl_aux;
end beh;