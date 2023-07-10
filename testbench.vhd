library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end entity;

architecture sim of testbench is
    constant CLK_PERIOD : time := 20 ns;  -- Período do clock de 50MHz
    signal clk : std_logic := '0';        -- Sinal de clock
    signal rst : std_logic := '0';        -- Sinal de reset
begin

    -- Processo de geração de clock
    clk_process: process
    begin
        while now < 5000 ns loop  -- Executa por 100us
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Processo de geração do reset
    reset_process: process
    begin
        rst <= '0';
        wait for 120 ns;  -- Aguarda 120ns
        rst <= '1';      -- Ativa o reset
        wait;
    end process;

    uut: via_de_dados_ciclo_unico generic map ( DATA_WIDTH  => 32,
                                                PROC_INSTR_WIDTH  => 32,
                                                PROC_ADDR_WIDTH => ,
                                                DP_CTRL_BUS_WIDTH => 
        )
                                    port map ( Leds_vermelhos_saida    => ent_rs_dado,
                                               Chave_reset             => ent_rt_ende,
                                               Clock                   => ent_tipo_deslocamento,
                                               sai_rd_dado             => sai_rd_dado );
    
    stimulus: process
    begin
    
        -- Put inition code here
    ent_rs_dado <= "10000000000000000000000000000000";
    ent_rt_ende <= "00000010";
    ent_tipo_deslocamento <= "00";
    
        -- Put test bench stimulus code here
    
        wait;
    end process;
    

end architecture;