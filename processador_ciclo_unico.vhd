-- Universidade Federal de Minas Gerais
-- Escola de Engenharia
-- Departamento de Engenharia Eletrônica
-- Autoria: Professor Ricardo de Oliveira Duarte
library IEEE;
use IEEE.std_logic_1164.all;

entity processador_ciclo_unico is
	generic (
		DATA_WIDTH        : natural :=32; -- tamanho do barramento de dados em bits
		PROC_INSTR_WIDTH  : natural :=32; -- tamanho da instrução do processador em bits
		PROC_ADDR_WIDTH   : natural :=32; -- tamanho do endereço da memória de programa do processador em bits
		DP_CTRL_BUS_WIDTH : natural :=18 -- tamanho do barramento de controle em bits
	);
	port (
		--		Chaves_entrada 			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		--		Chave_enter				: in std_logic;
		Leds_vermelhos_saida : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		Chave_reset          : in std_logic;
		Clock                : in std_logic
	);
end processador_ciclo_unico;

architecture comportamento of processador_ciclo_unico is
	-- declare todos os componentes que serão necessários no seu processador_ciclo_unico a partir deste comentário
	component via_de_dados_ciclo_unico is
		generic (
			-- declare todos os tamanhos dos barramentos (sinais) das portas da sua via_dados_ciclo_unico aqui.
			DP_CTRL_BUS_WIDTH : natural := 18;  -- tamanho do barramento de controle da via de dados (DP) em bits
			DATA_WIDTH        : natural := 32; -- tamanho do dado em bits
			PC_WIDTH          : natural := 32;  -- tamanho da entrada de endereços da MI ou MP em bits (memi.vhd)
			FR_ADDR_WIDTH     : natural := 8;  -- tamanho da linha de endereços do banco de registradores em bits
			ula_ctrl_width    : natural := 3 
		);
		port (
			-- declare todas as portas da sua via_dados_ciclo_unico aqui.
			clock     : in std_logic;
			reset     : in std_logic;
			control_interrup    : in std_logic;
			controle  : in std_logic_vector (DP_CTRL_BUS_WIDTH - 1 downto 0);
			instruct   : out std_logic_vector (PC_WIDTH - 1 downto 0);
			saida     : out std_logic_vector (DATA_WIDTH - 1 downto 0);
			PC_atual :  out std_logic_vector(pc_width - 1 downto 0);
			PC_saida :  in std_logic_vector(pc_width - 1 downto 0);
			IFR_0 : out std_logic
		);
	end component;

	component unidade_de_controle_ciclo_unico is
		generic (
			INSTR_WIDTH       : natural := 32;
			OPCODE_WIDTH      : natural := 7;
			DP_CTRL_BUS_WIDTH : natural := 18; -- WE RW UL UL UL UL
			ULA_CTRL_WIDTH    : natural := 3
		);
		port (
			instrucao : in std_logic_vector(INSTR_WIDTH - 1 downto 0); 
			controle  : out std_logic_vector(DP_CTRL_BUS_WIDTH - 1 downto 0); -- controle da via
			ligar_chave :out std_logic
		);
	end component;

	component tratamento_int_erro is
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
	end component;
	-- Declare todos os sinais auxiliares que serão necessários no seu processador_ciclo_unico a partir deste comentário.
	-- Você só deve declarar sinais auxiliares se estes forem usados como "fios" para interligar componentes.
	-- Os sinais auxiliares devem ser compatíveis com o mesmo tipo (std_logic, std_logic_vector, etc.) e o mesmo tamanho dos sinais dos portos dos
	-- componentes onde serão usados.
	-- Veja os exemplos abaixo:

	-- A partir deste comentário faça associações necessárias das entradas declaradas na entidade do seu processador_ciclo_unico com 
	-- os sinais que você acabou de definir.
	-- Veja os exemplos abaixo:
	signal aux_instrucao : std_logic_vector(PROC_INSTR_WIDTH - 1 downto 0);
	signal aux_controle  : std_logic_vector(DP_CTRL_BUS_WIDTH - 1 downto 0);
	signal aux_endereco  : std_logic_vector(PROC_ADDR_WIDTH - 1 downto 0);
	signal controle_interrupcao  : std_logic;
	signal aux_pc_saida  : std_logic_vector(PROC_ADDR_WIDTH - 1 downto 0);
	signal aux_pc_atual  : std_logic_vector(PROC_ADDR_WIDTH - 1 downto 0);
	signal aux_ligar_chave  : std_logic;
	signal aux_IFR_0  : std_logic;
begin
	-- A partir deste comentário instancie todos o componentes que serão usados no seu processador_ciclo_unico.
	-- A instanciação do componente deve começar com um nome que você deve atribuir para a referida instancia seguido de : e seguido do nome
	-- que você atribuiu ao componente.
	-- Depois segue o port map do referido componente instanciado.
	-- Para fazer o port map, na parte da esquerda da atribuição "=>" deverá vir o nome de origem da porta do componente e na parte direita da 
	-- atribuição deve aparecer um dos sinais ("fios") que você definiu anteriormente, ou uma das entradas da entidade processador_ciclo_unico,
	-- ou ainda uma das saídas da entidade processador_ciclo_unico.
	-- Veja os exemplos de instanciação a seguir:

	instancia_unidade_de_controle_ciclo_unico : unidade_de_controle_ciclo_unico
	port map(
		instrucao => aux_instrucao,
		controle  => aux_controle,   -- controle da via
		ligar_chave => aux_ligar_chave
	);

	instancia_via_de_dados_ciclo_unico : via_de_dados_ciclo_unico
	port map(
		-- declare todas as portas da sua via_dados_ciclo_unico aqui.
		clock     => Clock,
		reset     => Chave_reset,
		control_interrup => controle_interrupcao,
		controle  => aux_controle,
		instruct => aux_instrucao,
		saida     => Leds_vermelhos_saida,
		PC_atual => aux_pc_atual,
		PC_saida => aux_pc_saida,
		IFR_0 => aux_IFR_0
	);

	instancia_controle_interrupcao : tratamento_int_erro
	port map(
		-- declare todas as portas da sua via_dados_ciclo_unico aqui.
		clock     => Clock,
		reset     => Chave_reset,
		PC_atual  => aux_pc_atual,
		PC_saida  => aux_pc_saida, 
		control_interrup => controle_interrupcao,
		ligar_chave => aux_ligar_chave,
		IFR_0 => aux_IFR_0
	);
end comportamento;