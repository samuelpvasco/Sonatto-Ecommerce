-- Tabelas do Ecommerce
-- DROP DATABASE dbSonatto;
CREATE DATABASE dbSonatto;
USE dbSonatto;

-- Tabela de Usuario
CREATE TABLE tbUsuario (
    IdUsuario INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(50) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Senha VARCHAR(100) NOT NULL,
    CPF VARCHAR(11) NOT NULL UNIQUE,
    Endereco VARCHAR(150) NOT NULL,
    Telefone VARCHAR(11) NOT NULL,
    Estado BIT NOT NULL DEFAULT 1
);

-- Tabela Nivel de acesso
CREATE TABLE tbNivelAcesso(
	idNivel INT PRIMARY KEY AUTO_INCREMENT,
    NomeNivel VARCHAR(50) NOT NULL
);
INSERT INTO tbNivelAcesso(NomeNivel)
VALUES
	('Nivel 1'),
	('Nivel 2'),
	('Nivel 3'),
    ('Administrador');


-- Tabela Nivel de referenciamento Nivel de acesso
CREATE TABLE tbUsuNivel(
	IdUsuario INT,
    IdNivel INT,
    PRIMARY KEY (IdUsuario, IdNivel),
  	CONSTRAINT fk_IdUsuario FOREIGN KEY(IdUsuario) REFERENCES tbUsuario(IdUsuario),
    CONSTRAINT fk_IdNivel FOREIGN KEY(IdNivel) REFERENCES tbNivelAcesso(IdNivel)
);

-- Tabela de Produto
CREATE TABLE tbProduto(
    IdProduto INT PRIMARY KEY AUTO_INCREMENT,
    NomeProduto VARCHAR(100) NOT NULL,
    Descricao VARCHAR(2500) NOT NULL,
    Preco DECIMAL(8,2) NOT NULL,
	Marca VARCHAR(100) NOT NULL,
    Categoria VARCHAR(100) NOT NULL,
    Avaliacao DECIMAL (2,1) NOT NULL,
    EstadoProduto BIT NOT NULL
);
-- Tabela de Imagens dos Produtos
CREATE TABLE tbImagens(
	IdImagem INT AUTO_INCREMENT PRIMARY KEY,
    IdProduto INT NOT NULL,
    UrlImagem varchar(255) NOT NULL,
    CONSTRAINT fk_ImgIdProduto FOREIGN KEY(IdProduto) REFERENCES tbProduto(IdProduto)
);

-- Tabela de Estoque
CREATE TABLE tbEstoque(
    IdEstoque INT PRIMARY KEY AUTO_INCREMENT,
    IdProduto INT NOT NULL,
    QtdEstoque INT NOT NULL,
    Disponibilidade BIT NOT NULL,
    CONSTRAINT fk_IdEstoque_IdProduto FOREIGN KEY(IdProduto) REFERENCES tbProduto(IdProduto)
);


-- Tabela de Venda
CREATE TABLE tbVenda(
    IdVenda INT PRIMARY KEY AUTO_INCREMENT,
    IdUsuario INT NOT NULL,
    TipoPag VARCHAR(50) NOT NULL,
    QtdTotal INT NOT NULL,
    ValorTotal DECIMAL(8,2) NOT NULL,
    DataVenda DATETIME NOT NULL, 
    CONSTRAINT fk_idVenda_IdUsuario FOREIGN KEY(IdUsuario) REFERENCES tbUsuario(IdUsuario)
);

-- Tabela de ItemVenda
CREATE TABLE tbItemVenda(
	IdItemVenda INT AUTO_INCREMENT PRIMARY KEY,
    IdVenda INT NOT NULL,
    IdProduto INT NOT NULL,
    PrecoUni DECIMAL(8,2),
    Qtd INT NOT NULL,
    SubTotal DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_IdItemVenda_IdVenda FOREIGN KEY(IdVenda) REFERENCES tbVenda(IdVenda),
    CONSTRAINT fk_IdItemVenda_IdProduto FOREIGN KEY(IdProduto) REFERENCES tbProduto(IdProduto)
);


CREATE TABLE tbCarrinho(
	IdCarrinho INT PRIMARY KEY AUTO_INCREMENT,
	IdUsuario INT NOT NULL,
	DataCriacao DATE NOT NULL,
    Estado BIT NOT NULL,
    ValorTotal DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (IdUsuario) REFERENCES tbUsuario(IdUsuario)
);

CREATE TABLE tbItemCarrinho(
	IdItemCarrinho INT PRIMARY KEY AUTO_INCREMENT,
    IdCarrinho INT NOT NULL,
    IdProduto INT NOT NULL,
    QtdItemCar INT NOT NULL,
    PrecoUnidadeCar DECIMAL(8,2) NOT NULL,
    SubTotal DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (IdCarrinho) REFERENCES tbCarrinho(IdCarrinho),
    FOREIGN KEY (IdProduto) REFERENCES tbProduto(IdProduto)
);

CREATE TABLE tbHistoricoAcao(
	IdHistorico INT PRIMARY KEY AUTO_INCREMENT,
    IdUsuario INT NOT NULL,
    IdNivel INT NOT NULL,
    Acao VARCHAR(50) NOT NULL,
    DataAcao DATETIME NOT NULL,
    FOREIGN KEY (IdUsuario) REFERENCES tbUsuario(IdUsuario),
    FOREIGN KEY (IdNivel) REFERENCES tbNivelAcesso(IdNivel)
);

-- Procedures 
-- IN => Valor de entrada
-- OUT => Valor de saída
-- procedure para criar usuario
-- drop procedure sp_CadastroUsu
DELIMITER $$
CREATE PROCEDURE sp_CadastroUsu(
    IN vEmail VARCHAR(50),
    IN vNome VARCHAR(100),
    IN vSenha VARCHAR(100),
    IN vCPF VARCHAR(11),
    IN vEndereco VARCHAR(150),
    IN vTelefone VARCHAR(11),
    OUT vIdCli INT
)
BEGIN
	INSERT INTO tbUsuario (Email, Nome, Senha, CPF, Endereco, Telefone)
    VALUES (vEmail, vNome, vSenha, vCPF, vEndereco, vTelefone);

    SET vIdCli = LAST_INSERT_ID();
END $$
DELIMITER ;

-- call da procedure de cadastro:
CALL sp_CadastroUsu(
    'arthur@gmail.com',
    'Arthur dos Santos Reimberg',
    'artReimberg',
    '12345678901',
    'Rua Lucas Padilla, Número 54',
    '11945302356',
    @vIdCli
);

CALL sp_CadastroUsu(
    'lucas@gmail.com',
    'Lucas Hora',
    'luc123',
    '12345678912',
    'Rua Algum Lugar, Número 40',
    '11945302359',
    @vIdCli
);

DELIMITER $$
CREATE PROCEDURE sp_AlterarUsu(
	vIdUsuario INT,
    vEmail VARCHAR(50),
    vNome VARCHAR(100),
    vSenha VARCHAR(100),
    vCPF VARCHAR(11),
    vEndereco VARCHAR(150),
    vTelefone VARCHAR(11)
)
BEGIN
	UPDATE tbUsuario
		SET Email = vEmail,
			Nome = vNome,
            Senha = vSenha,
            CPF = vCPF,
            Endereco = vEndereco,
            Telefone = vTelefone
	WHERE IdUsuario = vIdUsuario;
END $$
DELIMITER ;


select * from tbUsuario


-- procedure adicionar nivel de acesso
DELIMITER $$
CREATE PROCEDURE sp_GerenciarNivel(
	vIdUsuario INT,
    vAcao varchar(50),
    vIdNivel INT
)
BEGIN
	IF(vAcao = 'adicionar') THEN
	INSERT INTO tbUsuNivel(IdUsuario, IdNivel)
    VALUES(vIdUsuario, vIdNivel);
    
    ELSE IF (vAcao = 'remover') THEN
    DELETE FROM tbUsuNivel WHERE IdUsuario = vIdUsuario AND IdNivel= vIdNivel;
    END IF;
    END IF;
    
END$$

select * from tbproduto;
DELIMITER ;
select * from tbusuario
-- call sp_AdicionarNivel(1,1)
-- Procedure Cadastrar Produto
-- drop procedure sp_CadastrarProduto
DELIMITER $$
CREATE PROCEDURE sp_CadastrarProduto(
	vNomeProduto VARCHAR(100),
    vPreco DECIMAL(8,2),
    vDescricao varchar(2500),
    vMarca VARCHAR(100),
    vAvaliacao DECIMAL(2,1),
    vCategoria VARCHAR(100),
    vQtdEstoque INT,
    vIdUsuario INT
)
BEGIN
	DECLARE vIdProduto INT;
    
    -- Salva os valores do produto
	INSERT INTO tbProduto(NomeProduto, Descricao, Preco, Marca, Categoria,Avaliacao, EstadoProduto)
    VALUES(vNomeProduto, vDescricao, vPreco, vMarca, vCategoria,vAvaliacao, true);
    SET vIdProduto = LAST_INSERT_ID();

    -- Salva a quantidade em estoque
    INSERT INTO tbEstoque(IdProduto, QtdEstoque, Disponibilidade)
    VALUES(vIdProduto, vQtdEstoque, true);
    
    -- Salva o histórico de inserção
    INSERT INTO tbHistoricoAcao(IdNivel, Acao, IdUsuario, DataAcao)
    VALUES(1 ,'Adicionar Produto', vIdUsuario, CURRENT_TIMESTAMP());
    -- Retorna o ID do produto recém-inserido
    SELECT vIdProduto AS IdProduto;
END $$
DELIMITER ;

SELECT a.IdHistorico, a.IdUsuario, a.Acao, a.IdNivel, a.DataAcao, n.NomeNivel
FROM tbHistoricoAcao a
LEFT JOIN tbNivelAcesso n ON a.IdNivel = n.IdNivel
WHERE a.IdUsuario = 1;

select * from tbproduto;
DELIMITER $$
CREATE PROCEDURE sp_AlterarProduto(
	vIdProduto INT,
	vNomeProduto VARCHAR(100),
    vPreco DECIMAL(8,2),
    vDescricao varchar(2500),
    vMarca VARCHAR(100),
    vAvaliacao DECIMAL(2,1),
    vCategoria VARCHAR(100),
    vQtd INT,
    vIdUsuario INT,
    vAcao varchar(50)
)
BEGIN
	IF(vAcao = 'alterar') THEN
		-- Atualiza os valores do produto
		UPDATE tbProduto 
			SET NomeProduto = vNomeProduto, 
			Descricao =vDescricao, 
			Preco =vPreco, 
			Marca = vMarca, 
			Categoria = vCategoria,
			Avaliacao = vAvaliacao, 
			EstadoProduto = true
		WHERE IdProduto = vIdProduto;
        -- Atualiza o estoque
		UPDATE tbEstoque
			SET QtdEstoque = vQtd
		WHERE IdProduto = vIdProduto;
		-- Salva o histórico da alteração  
		INSERT INTO tbHistoricoAcao(IdNivel,Acao, IdUsuario, DataAcao)
		VALUES(2,'Alterar Produto',vIdUsuario ,CURRENT_TIMESTAMP());
        
	   ELSE IF(vAcao = 'deletar') THEN
			UPDATE tbProduto
				SET EstadoProduto = false
            WHERE IdProduto = vIdProduto;
            
            UPDATE tbEstoque
				SET Disponibilidade = false
            WHERE IdProduto = vIdProduto;
			-- Salva o histórico da exclusão/desativação do produto
			INSERT INTO tbHistoricoAcao(IdNivel,Acao, IdUsuario, DataAcao)
			VALUES(3 ,'Deletar Produto', vIdUsuario,CURRENT_TIMESTAMP() );
		END IF;
    END IF;
END $$
DELIMITER ;

call sp_AlterarProduto(1,"teste", 11.99, 'teste', 'teste', 4.5, 'Cordas', 20, 1, 'alterar')

SELECT * FROM TBHISTORICOACAO
select * from tbproduto where idproduto = 1
DELIMITER $$
CREATE PROCEDURE sp_AdicionarImagens( 
	vIdProduto INT,
    vImagemUrl VARCHAR(255)
)
BEGIN
    INSERT INTO tbImagens(IdProduto,UrlImagem)
    VALUES(vIdProduto,vImagemUrl);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_RemoverImagemProduto(
    IN vIdProduto INT,
    IN vImagemUrl VARCHAR(1000)
)
BEGIN
    DECLARE rows_affected INT DEFAULT 0;

    START TRANSACTION;

    DELETE FROM tbImagens
    WHERE IdProduto = vIdProduto
      AND UrlImagem = vImagemUrl
    LIMIT 1;

    SET rows_affected = ROW_COUNT();
    COMMIT;

    SELECT rows_affected AS Affected;
END $$
DELIMITER ;
SELECT * FROM TBIMAGENS;
call sp_RemoverImagemProduto(1,'https://http2.mlstatic.com/D_NQ_NP_2X_927664-MLB89452613385_082025-F.webp');

DELIMITER $$
CREATE PROCEDURE sp_AdministrarCarrinho(
    IN vIdUsuario INT,
    IN vIdProduto INT,
    IN vQtd INT
)
BEGIN
    DECLARE vIdCarrinho INT DEFAULT NULL;
    DECLARE vPrecoUnidadeCar DECIMAL(8,2);
    DECLARE vSubTotal DECIMAL(8,2);
    DECLARE vIdItemCarrinho INT DEFAULT NULL;

    -- Verifica se o carrinho do usuário já existe (ativo)
    SELECT IdCarrinho 
    INTO vIdCarrinho 
    FROM tbCarrinho 
    WHERE IdUsuario = vIdUsuario AND Estado = 1;

    -- Se o carrinho ainda não existir, cria um novo
    IF vIdCarrinho IS NULL THEN
        SELECT Preco INTO vPrecoUnidadeCar 
        FROM tbProduto 
        WHERE IdProduto = vIdProduto;

        SET vSubTotal = vPrecoUnidadeCar * vQtd;

        INSERT INTO tbCarrinho (IdUsuario, DataCriacao, Estado, ValorTotal)
        VALUES (vIdUsuario, CURDATE(), 1, vSubTotal);

        SET vIdCarrinho = LAST_INSERT_ID();

        INSERT INTO tbItemCarrinho (IdCarrinho, IdProduto, QtdItemCar, PrecoUnidadeCar, SubTotal)
        VALUES (vIdCarrinho, vIdProduto, vQtd, vPrecoUnidadeCar, vSubTotal);

    ELSE
        -- Carrinho já existe, verificar se o produto já foi adicionado
        SELECT IdItemCarrinho 
        INTO vIdItemCarrinho 
        FROM tbItemCarrinho 
        WHERE IdCarrinho = vIdCarrinho AND IdProduto = vIdProduto;

        IF vIdItemCarrinho IS NULL THEN
            -- Produto ainda não está no carrinho
            SELECT Preco INTO vPrecoUnidadeCar 
            FROM tbProduto 
            WHERE IdProduto = vIdProduto;

            SET vSubTotal = vPrecoUnidadeCar * vQtd;

            INSERT INTO tbItemCarrinho (IdCarrinho, IdProduto, QtdItemCar, PrecoUnidadeCar, SubTotal)
            VALUES (vIdCarrinho, vIdProduto, vQtd, vPrecoUnidadeCar, vSubTotal);
            -- Atualiza o total do carrinho com base na soma dos subtotais
			UPDATE tbCarrinho
			SET ValorTotal = ValorTotal + vSubTotal
			WHERE IdCarrinho = vIdCarrinho;
        END IF;
    END IF;
END $$
DELIMITER ;

-- call sp_AdministrarCarrinho(1,11,1)

DELIMITER $$

CREATE PROCEDURE sp_AlterarQuantidadeItem(
    IN vIdCarrinho INT,
    IN vIdProduto INT,
    IN vNovaQtd INT
)
BEGIN
    DECLARE vPrecoUnidade DECIMAL(8,2);
    DECLARE vSubTotalAntigo DECIMAL(8,2);
    DECLARE vSubTotalNovo DECIMAL(8,2);
    DECLARE vDiferenca DECIMAL(8,2);
    DECLARE vIdItemCarrinho INT;

    -- Busca o item no carrinho
    SELECT IdItemCarrinho, PrecoUnidadeCar, SubTotal
    INTO vIdItemCarrinho, vPrecoUnidade, vSubTotalAntigo
    FROM tbItemCarrinho
    WHERE IdCarrinho = vIdCarrinho AND IdProduto = vIdProduto;

    -- Calcula novos valores
    SET vSubTotalNovo = vPrecoUnidade * vNovaQtd;
    SET vDiferenca = vSubTotalNovo - vSubTotalAntigo;

    -- Atualiza o item
    UPDATE tbItemCarrinho
    SET QtdItemCar = vNovaQtd,
        SubTotal = vSubTotalNovo
    WHERE IdItemCarrinho = vIdItemCarrinho;

    -- Atualiza total do carrinho
    UPDATE tbCarrinho
    SET ValorTotal = ValorTotal + vDiferenca
    WHERE IdCarrinho = vIdCarrinho;

END $$

DELIMITER ;

-- CALL sp_AlterarQuantidadeItem(1,1,5);

DELIMITER $$

CREATE PROCEDURE sp_RemoverItemCarrinho(
    IN vIdItemCarrinho INT
)
BEGIN
    DECLARE vIdCarrinho INT;
    DECLARE vSubTotal DECIMAL(8,2);

    -- Busca o item e seu subtotal
    SELECT IdCarrinho, SubTotal
    INTO vIdCarrinho, vSubTotal
    FROM tbItemCarrinho
    WHERE IdItemCarrinho = vIdItemCarrinho;

    -- Atualiza o valor total do carrinho
    UPDATE tbCarrinho
    SET ValorTotal = ValorTotal - vSubTotal
    WHERE IdCarrinho = vIdCarrinho;

    -- Remove o item
    DELETE FROM tbItemCarrinho
    WHERE IdItemCarrinho = vIdItemCarrinho;

END $$

DELIMITER ;

-- call sp_RemoverItemCarrinho(1,1);

select * from tbcarrinho;
SELECT * FROM TBITEMCARRINHO;


DELIMITER $$

CREATE PROCEDURE sp_GerarVenda(
    IN vIdUsuario INT, 
    IN vTipoPag VARCHAR(50),
    IN vIdCarrinho INT
)
BEGIN
    DECLARE vIdVenda INT;
    DECLARE vIdProduto INT;
    DECLARE vQtdItem INT;
    DECLARE vPreco DECIMAL(8,2);
    DECLARE vQtdTotal INT;
    DECLARE vValorTotal DECIMAL(8,2);
    DECLARE vSubTotal DECIMAL(8,2);
    DECLARE done INT DEFAULT 0;
    DECLARE vNovoEstoque INT;
    -- CURSOR para os itens do carrinho
    DECLARE curItens CURSOR FOR
        SELECT IdProduto, QtdItemCar, PrecoUnidadeCar
        FROM tbItemCarrinho
        WHERE IdCarrinho = vIdCarrinho;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Valor total do carrinho
    SELECT ValorTotal INTO vValorTotal
    FROM tbCarrinho
    WHERE IdCarrinho = vIdCarrinho AND Estado = 1;

    -- Quantidade total
    SELECT SUM(QtdItemCar) INTO vQtdTotal
    FROM tbItemCarrinho
    WHERE IdCarrinho = vIdCarrinho;

    -- Criar a venda
    INSERT INTO tbVenda(IdUsuario, TipoPag, QtdTotal, ValorTotal, DataVenda)
    VALUES(vIdUsuario, vTipoPag, vQtdTotal, vValorTotal, NOW());

    SET vIdVenda = LAST_INSERT_ID();

    -- Processa os itens
    OPEN curItens;
    read_loop: LOOP
        FETCH curItens INTO vIdProduto, vQtdItem, vPreco;
        IF done THEN 
            LEAVE read_loop;
        END IF;

        SET vSubTotal = vPreco * vQtdItem;

        -- Inserir item de venda
        INSERT INTO tbItemVenda(IdVenda, IdProduto, PrecoUni, Qtd, SubTotal)
        VALUES(vIdVenda, vIdProduto, vPreco, vQtdItem, vSubTotal);

        -- Atualizar estoque
        SELECT QtdEstoque - vQtdItem INTO vNovoEstoque
        FROM tbEstoque
        WHERE IdProduto = vIdProduto;

        UPDATE tbEstoque
        SET QtdEstoque = vNovoEstoque,
            Disponibilidade = IF(vNovoEstoque <= 0, 0, 1)
        WHERE IdProduto = vIdProduto;

    END LOOP;
    CLOSE curItens;

    -- Finalizar carrinho
    UPDATE tbCarrinho
    SET Estado = 0
    WHERE IdCarrinho = vIdCarrinho;
END $$

DELIMITER ;

-- call sp_GerarVenda(1, 'Débito', 5);
select * from tbVenda;
select * from tbitemVenda;

DELIMITER $$

CREATE PROCEDURE sp_ExibirProduto(IN vIdProduto INT)
BEGIN
    SELECT *
    FROM vw_ExibirProdutos
    WHERE IdProduto = vIdProduto;
END $$

DELIMITER ;

-- Views

-- Buscar Produtos
create view vw_ExibirProdutos as
SELECT 
	p.IdProduto,
    p.NomeProduto,
	p.Descricao,
	p.Preco,
    p.Marca,
    p.Avaliacao,
    p.Categoria,
    ip.UrlImagem,
    e.Disponibilidade,
    e.QtdEstoque
FROM tbProduto AS p 
INNER JOIN tbImagens AS ip
	ON p.IdProduto = ip.IdProduto
INNER JOIN tbImagens AS i
	ON ip.IdImagem = i.IdImagem
INNER JOIN tbEstoque AS e
	ON p.IdProduto = e.IdProduto
WHERE e.Disponibilidade = 1;

SELECT * FROM vw_ExibirProdutos;



-- Exibição de Vendas
CREATE VIEW vw_VendaDetalhada AS
SELECT 
    v.IdVenda,
    v.IdUsuario,
    u.Nome AS NomeUsuario,
    v.TipoPag,
    iv.IdProduto,
    p.NomeProduto AS NomeProduto,
    iv.PrecoUni,
    iv.Qtd AS QtdItem,
    (iv.PrecoUni * iv.Qtd) AS Subtotal
FROM tbVenda AS v
INNER JOIN tbItemVenda AS iv ON v.IdVenda = iv.IdVenda
INNER JOIN tbProduto AS p ON iv.IdProduto = p.IdProduto
INNER JOIN tbUsuario AS u ON v.IdUsuario = u.IdUsuario
ORDER BY IdVenda DESC;

select * from vw_VendaDetalhada ;


CREATE VIEW vw_HistoricoAcao AS
SELECT
	u.IdUsuario,
	u.Nome,
    n.NomeNivel,
    h.Acao,
    h.DataAcao
FROM tbUsuario AS u
INNER JOIN tbHistoricoAcao AS h ON u.IdUsuario = h.IdUsuario
INNER JOIN tbNivelAcesso AS n ON h.IdNivel = n.IdNivel;

CREATE VIEW vw_NiveisFunc AS
SELECT 
	u.IdUsuario,
    u.Nome,
    GROUP_CONCAT(n.NomeNivel ORDER BY n.IdNivel SEPARATOR ', ') AS ListaNiveis
FROM tbUsuario u
LEFT JOIN tbUsuNivel un ON u.IdUsuario = un.IdUsuario
LEFT JOIN tbNivelAcesso n ON un.IdNivel = n.IdNivel
GROUP BY u.IdUsuario, u.Nome;
 
CALL sp_CadastrarProduto( 'Piano Caziuk Clasic 02 Preto Brilho 88 Teclas', 33000.00, 'Os pianos cenográficos CAZIUK esta em alta entre os artistas, por ser leve, fácil de transportar, não desafina, produto durável, surpreende com a sua presença, dando um glamour onde se encontra, um item de decoração de luxo, seu brilho atraia a atenção de todos, é bem requisitado em festas de casamento, e outros eventos, seu valor ainda esta bem acessível, o investimento se retorna rapidamente com os alugueis, que hj esta na faixa de 2000,00 a 3000,00 á diária. nunca desvaloriza. fácil manutenção, para os pianistas, tecladista, decoradores de festas, pode se tornar mais uma fonte de renda fixa com seu aluguel, uma linda decoração para seu comercio, sala e Igrejas, seu valor de mercado apresenta alta, pela procura mantendo a valorização por ser um item único. Os pianos Cenográficos CAZIUK são fabricado por um Luthier profissional, que tem o extremo cuidado na fabricação de seus pianos. ADQUIRA LOGO O SEU PIANO CENOGRAFICO CAZIUK. Prazo para a fabricação de 120 A 150 dias, entrega depende da distancia da localidade . O piano de cauda cenográfico irá acompanhado de um sistema de amplificação no seu interior para fonte 12v , 110v, 220v , com ajuste de volume, grave, médio e agudos, contando com alto falante de 10 polegadas JBL 200watts rms, uma corneta e um twiter divisor de frequência passivo no interior do piano, como se fosse uma grande caixa de som ativa, de forma imperceptível, produzindo o som em seu próprio corpo. *Devido as curvas da cauda do piano cenográfico, o permite produzir um som muito mais aparente de um piano acústico real ,com reverberação, devido a este formato curvado, do que caixas quadradas ou até mesmo cubos. fazendo que os timbres de seu instrumento fique muito mais parecido com os originais acústicos. Cor; Black Piano *Borda da tampa moldurada. os pés contem negativos. * possui tampa com regulagem sobre as teclas. * Banqueta de brinde ate 28 de julho de 2025 Os pés do piano contem rodinhas com travastes, seus pés e suporte de pedal são removíveis, pois são somente encaixados, sua retirada facilitar o transporte. Regulagem internas de altura ajustável para pianos de: 11cm a 17cm, comprimento do encaixe do piano de 1,28 a 1,445 , largura ajustável de 21cm a 26cm, possibilitando o uso de vários modelos de piano digitais. Medidas de altura da caixa externa 30cm a 37cm. Medidas dos pés 63cm a 70 cm. Comprimento 1,60cm Largura 1,50cm.', 'CAZIUK', 4.5, 'Teclas', 20, 1 );
CALL sp_AdicionarImagens(1,'https://http2.mlstatic.com/D_NQ_NP_2X_927664-MLB89452613385_082025-F.webp');
CALL sp_AdicionarImagens(1,'https://http2.mlstatic.com/D_Q_NP_2X_712318-MLB76839082850_062024-R.webp');
CALL sp_AdicionarImagens(1,'https://http2.mlstatic.com/D_Q_NP_2X_923933-MLB82554997263_022025-R.webp');

CALL sp_CadastrarProduto( 'Orgão Eletrônico 44 + 44 Teclas Tokai Md-10 Evo Cor Marrom-escuro', 10359.00, '- 44 teclas fechadas - 13 notas na pedaleira - Presets 160 sons - Drawbars completo para ambos teclados - Dual voice para ambos teclados e pedaleira, possibilitando utilizar 2 Presets simultaneamente. - Mudança de registração no pedal de volume (Igual Yamaha) - Controle de intensidade: Vibrato, chorus e sustain - Metrônomo simples e composto (com vozes Ex 4 por 4: 1, 2, 3, 4) - Pedaleira maior para melhor execução - QR code no visor para manual online. - Novo sistema acústico - Banqueta personalizada MD-10 Evo Wengue (Marrom)', 'Tokai', 4.5, 'Teclas', 20, 1);

CALL sp_AdicionarImagens(2,'https://http2.mlstatic.com/D_NQ_NP_2X_907425-MLU77761939047_072024-F.webp');
CALL sp_AdicionarImagens(2,'https://http2.mlstatic.com/D_Q_NP_2X_783167-MLU77544050746_072024-R.webp');
CALL sp_AdicionarImagens(2,'https://http2.mlstatic.com/D_Q_NP_2X_676579-MLU77761939123_072024-R.webp');

CALL sp_CadastrarProduto( 'Acordeon 80 Baixos Michael Acm8007n Spb C\ Bag Rodinhas Cor Preto sólido', 7721.00, 'ACORDEON MICHAEL ACM8007N SPB 80 BAIXOS O Michael ACM8007N é um acordeon de 80 baixos, confortável e com timbre intenso. Possui 7 registros para a mão direita e 2 para a esquerda, além de 37 teclas macias. É construído com madeira de lei, uma matéria-prima robusta, e conta com componentes de qualidade, como as palhetas de aço inoxidável e o fole de linho e couro, protegido por cantoneiras de metal. Acompanha case e alça para facilitar o transporte. ESPECIFICAÇÕES TÉCNICAS: • Acordeon 80 baixos • Palheta em aço inoxidável • 37 teclas • 7 registros de mão direita e 2 registros de mão esquerda • Terça de Voz • Estrutura de madeira nobre • Acabamento refinado – Alto Brilho • Fole com revestimento em linho e couro • Cantoneiras externas do fole em metal • Acompanha case com rodinhas, alça retrátil, bolso externo e alças para acordeon', 'Micheal', 4.7, 'Teclas', 20, 1);

CALL sp_AdicionarImagens(3,'https://http2.mlstatic.com/D_NQ_NP_2X_670924-MLA94167840158_102025-F.webp');
CALL sp_AdicionarImagens(3,'https://http2.mlstatic.com/D_Q_NP_2X_884625-MLA94167622038_102025-R.webp');
CALL sp_AdicionarImagens(3,'https://http2.mlstatic.com/D_Q_NP_2X_865741-MLA94167512582_102025-R.webp');

CALL sp_CadastrarProduto('Harmonium Harmonio Indiano Sarat Sardar And Sons 1950', 5400.00, 'peça maravilhosa, dos anos 50 è uma peça herdada, nao sei tocar, nao sou musicista, nao sei sobre afinação. porem enchendo o fole, está acionando todas as teclas, e botoes madeira integra, minimas sinais do tempo e do uso, porem sem danos lindissimo', 'Calcutá', 3.5, 'Teclas', 20, 1);

CALL sp_AdicionarImagens(4,'https://kirtanyogaworld.com/914-large_default/manoj-kumar-sardar-harmonium-9-scale-changer.jpg');CALL sp_AdicionarImagens(4,'https://5.imimg.com/data5/BT/KF/MY-30699112/11-scale-changer-harmonium.jpg');
CALL sp_AdicionarImagens(4,'https://i0.wp.com/www.binaswar.com/wp-content/uploads/2019/08/AB0_2287.jpg?fit=1200%2C651&ssl=1');

CALL sp_CadastrarProduto( 'Teclado Arranjador Casio Mz-x500 Com 61 Teclas Sensitivas Cor Azul', 4823.90, 'A Casio é uma empresa com uma longa trajetória no mercado que se destaca por oferecer produtos originais e inovadores. Sem dúvida, seus teclados musicais são uma excelente opção. Vá para o próximo nível Com suas 61 teclas, você poderá tocar uma grande variedade de obras e mergulhar no mundo do intérprete musical. Ideal para níveis intermediários que querem se superar e seguir o caminho dos grandes músicos. Interpretações que transportam As teclas sensíveis ao toque capturam a força e a velocidade com que são pressionadas e permitem ajustar a intensidade do som para obter maior expressividade ao tocar. Prepare-se para brilhar! Mais ritmos, mais música Desfrute de um grande banco de estilos e ritmos musicais. Deixe-se guiar e atreva-se a improvisar nas pistas. Sonoridades múltiplas A grande variedade de timbres que ele oferece permitirá que você escolha entre diferentes instrumentos ao compor e enriquecer sua interpretação. Valorize suas melhores interpretações Graças ao seu gravador, você poderá ouvir suas execuções repetidas vezes, aperfeiçoar sua digitação e salvar suas versões favoritas. Construa seu estúdio de produção Com o controlador MIDI, você poderá conectar seu instrumento ao seu computador e a outros dispositivos para retratar suas composições, ajustar parâmetros e criar obras exclusivas. Afinação garantida Possui controle de afinação, função que o permite afinar quando necessário para que seu instrumento soe sempre perfeito.', 'Casio', 4.9, 'Teclas', 20,1 );

CALL sp_AdicionarImagens(5,'https://http2.mlstatic.com/D_NQ_NP_2X_889605-MLA95359295085_102025-F.webp');
CALL sp_AdicionarImagens(5,'https://http2.mlstatic.com/D_Q_NP_2X_973100-MLA94466256207_102025-R.webp');
CALL sp_AdicionarImagens(5,'https://http2.mlstatic.com/D_Q_NP_2X_636209-MLA94466295941_102025-R.webp');

CALL sp_CadastrarProduto( 'Rhodes Suitcase Mark I Eighty Eight Piano Elétrico Vintage', 50000.00, 'Piano Fender Vintage funcionando perfeitamente sem quaisquer problemas.', 'Rhodes', 3.7, 'Teclas', 20, 1);

CALL sp_AdicionarImagens(6,'https://a.1stdibscdn.com/fender-rhodes-eighty-eight-electric-piano-for-sale/1121189/f_114424531532153096942/11442453_master.jpg');
CALL sp_AdicionarImagens(6,'https://images.equipboard.com/uploads/item/image/11889/fender-rhodes-mark-i-stage-73-xl.webp?v=1761762293');
CALL sp_AdicionarImagens(6,'https://images.equipboard.com/uploads/item_image/image/12387/fender-rhodes-mark-i-stage-73-00-xl.jpg');

CALL sp_CadastrarProduto( 'Escaleta De Sopro 32 Teclas C/ Capa Melodica Infantil Preta Bertô Mangueira e Bocal', 109.85, 'Escaleta Melodica Bertô Preta 32 Teclas + Capa Brinde Instrumento de sopro, acompanha capa para proteção contra respingos e poeiras. A Escaleta é um instrumento de sopro popular hoje em dia. Seu timbre harmonioso e suave é semelhante à da gaita e tem a aparência de um teclado. Tendo seu uso principalmente em aulas de apreciação musical para crianças, contudo também grandes instrumentistas aproveitam sua agilidade e presteza para lindas melodias e solos. Com uma extensão de teclas pequena e em si menores do que de um piano normal são muito leves, o que facilita ao músico levá-la à boca e assoprar pelo bocal. Sem a necessidade de eletricidade, força física ou afinação específica. Especificações • Fabricante: Bertô • Cor: Preto • Acompanha Bocal e Mangueira • Palhetas: 32 • Acompanha Bag de Fábrica • Equipada com placa de palhetas com ótima resposta sonora Conteúdo da Embalagem: • Escaleta Melodica Bertô Preta 32 Teclas.', 'Bertô', 3.2, 'Teclas', 20, 1 );

CALL sp_AdicionarImagens(7,'https://http2.mlstatic.com/D_NQ_NP_604336-MLA94383632387_102025-F-escaleta-concert-m37-37-teclas-capa-acessorios-cor-preta.webp');
CALL sp_AdicionarImagens(7,'https://http2.mlstatic.com/D_NQ_NP_2X_794357-MLA84313823302_052025-F.webp');
CALL sp_AdicionarImagens(7,'https://http2.mlstatic.com/D_NQ_NP_2X_756615-MLA84611246555_052025-F.webp');

CALL sp_CadastrarProduto( 'Teclado Musical Profissional Piano Eletronico 61 Teclas Cor Preto', 379.00, 'Melhore suas habilidades, explore novos sons e deixe sua criatividade fluir. Preencha sua vida com música! Vá para o próximo nível Com suas 61 teclas, você poderá tocar uma grande variedade de obras e mergulhar no mundo do intérprete musical. Ideal para níveis intermediários que querem se superar e seguir o caminho dos grandes músicos. Mais ritmos, mais música Desfrute de um grande banco de estilos e ritmos musicais. Deixe-se guiar e atreva-se a improvisar nas pistas.', 'SmartVox', 4.6, 'Teclas', 20, 1);

CALL sp_AdicionarImagens(8,'https://http2.mlstatic.com/D_NQ_NP_2X_608318-MLA94949295910_102025-F.webp');
CALL sp_AdicionarImagens(8,'https://http2.mlstatic.com/D_Q_NP_2X_993137-MLA94467413363_102025-R.webp');
CALL sp_AdicionarImagens(8,'https://http2.mlstatic.com/D_Q_NP_2X_886407-MLA94018522398_102025-R.webp');

CALL sp_CadastrarProduto( 'Teclado Musical (piano Elétrico) Com 88 Teclas Responsivas', 1677.77, 'Este teclado digital de 88 teclas oferece uma experiência musical completa, desde os iniciantes até os músicos mais experientes. Com sua ampla gama de recursos, vasta biblioteca de sons e ritmos, conectividade Bluetooth e entrada USB-C, você poderá explorar diversos estilos musicais e aprimorar suas habilidades. 88 Teclas Sensitivas: Desfrute de uma experiência de toque autêntica, similar a um piano acústico, com teclas sensíveis que respondem à sua intensidade. Biblioteca de Sons: Explore uma vasta biblioteca de sons de alta qualidade, incluindo piano, órgão, cordas, instrumentos de percussão e muito mais. Personalize seus sons e crie paisagens sonoras únicas. Ritmos Automáticos: Acompanhe suas performances com uma variedade de ritmos pré-definidos, cobrindo diversos gêneros musicais, como pop, rock, jazz, clássica e muitos outros. Conectividade Bluetooth: Conecte seu teclado a smartphones, tablets e computadores sem fios para tocar junto com suas músicas favoritas ou aplicativos de aprendizado musical. Entrada USB-C: Entrada de energia USB tipo C. Design Compacto e Portátil: Leve seu teclado para onde quiser! Seu design compacto e leve torna o transporte fácil e conveniente. Construção Durabilidade: Fabricado com materiais de alta qualidade, garantindo durabilidade e longa vida útil.', 'Waver', 4.3, 'Teclas', 20, 1);

CALL sp_AdicionarImagens(9,'https://m.media-amazon.com/images/I/51+pKmHwcFL.jpg');
CALL sp_AdicionarImagens(9,'https://m.media-amazon.com/images/I/51MtkSdSv1L._AC_SL1200_.jpg');
CALL sp_AdicionarImagens(9,'https://m.media-amazon.com/images/I/6124TFQdmQL._AC_SL1200_.jpg');

CALL sp_CadastrarProduto( 'Orgão Eletronico Acordes Classic', 5190.00, 'O Órgão Eletrônico Acordes Classic proporciona móvel laminado com veias imitando madeira e clave de sol na lateral, sendo 100% em MDF. Neste órgão você terá um agradável som e facilidade no manuseio das funções no painel de registração.', 'ACORDES', 4.5, 'Teclas', 20, 1);
CALL sp_AdicionarImagens(10,'https://http2.mlstatic.com/D_NQ_NP_2X_957015-MLB89576569286_082025-F-orgo-eletronico-acordes-classic-loja-jubi.webp');
CALL sp_AdicionarImagens(10,'https://http2.mlstatic.com/D_Q_NP_2X_700892-MLB89576529710_082025-R-orgo-eletronico-acordes-classic-loja-jubi.webp');
CALL sp_AdicionarImagens(10,'https://http2.mlstatic.com/D_Q_NP_2X_725920-MLB81326194060_122024-R-orgo-eletronico-acordes-classic-loja-jubi.webp');

CALL sp_CadastrarProduto( 'Timpano Magnum Em Fibra De Vidro 26 Com Estojo', 15225.00, 'Sistema pedal para bloco de estilo europeu, também conhecido como embreagem e post, permite a ação suave e precisa do pedal independentemente da tensão de cabeça. A ação de bloqueio do pedal assegura cada afinação no seu devido lugar. A chave do tímpano é usada para bloquear e desbloquear as pernas para variadas posições de altura. As pernas são rapidamente e facilmente ajustáveis na altura do músico e retraem-se na base para facilitar o transporte. Leve e facilmente transportável, um conjunto de tímpanos pode facilmente caber em um carro médio. Posicionamento de afinações, chave de afinação e feltro-mudo são padrão estão inclusos. Fuste de fibra de vidro parabólico. Os fustes de fibra de vidro parabólico Magnum projetam um som cheio, claro e limpo.', 'Magnum',   4.5, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(11,'https://x5music.vtexassets.com/arquivos/ids/206195-800-auto?v=638209817532430000&width=800&height=auto&aspect=true');
CALL sp_AdicionarImagens(11,'https://x5music.vtexassets.com/arquivos/ids/206199-800-auto?v=638209818058630000&width=800&height=auto&aspect=true');
CALL sp_AdicionarImagens(11,'https://x5music.vtexassets.com/arquivos/ids/206201-800-auto?v=638209818383270000&width=800&height=auto&aspect=true');

CALL sp_CadastrarProduto( 'Bateria Eletrônica com Peles esh DM-110 - Nux', 3255.88, 'A NUX DM-110 é um kit de bateria digital portátil de alto desempenho e nível básico da série NUX. Ele apresenta uma estrutura de metal elegante e pads e pratos de bateria compactos, proporcionando funcionalidade e desempenho excepcionais sem concessões. A bateria eletrônica NUX DM-110 aprimora a aparência e a estrutura do pad de bateria do DM-1X, oferecendo um design mais compacto e compacto. Em comparação com o DM-1X, a estrutura do DM-110 se alinha melhor ao layout de baterias acústicas, garantindo uma experiência de execução mais confortável e natural.', 'Nux', 4.1, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(12,'https://ninjasom.vtexassets.com/arquivos/ids/208918-1600-auto');
CALL sp_AdicionarImagens(12,'https://ninjasom.vtexassets.com/arquivos/ids/208919-1600-auto');
CALL sp_AdicionarImagens(12,'https://ninjasom.vtexassets.com/arquivos/ids/208920-1600-auto');

CALL sp_CadastrarProduto( 'Pad de tom PDA120L-BK', 1483.59, 'Construído em madeira premium, o pad de tom PDA120L-BK de 12 polegadas proporciona conforto e resposta precisa a cada toque, com um visual autêntico de tambor premium. Ideal para expandir seu kit V-Drums ou V-Drums Acoustic Design, cada componente foi projetado para dar ao músico a sensação mais parecida de um tambor acústico.', 'Roland', 3.4, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(13,'https://ninjasom.vtexassets.com/arquivos/ids/180789-1600-auto');
CALL sp_AdicionarImagens(13,'https://ninjasom.vtexassets.com/arquivos/ids/180787-1600-auto');
CALL sp_AdicionarImagens(13,'https://ninjasom.vtexassets.com/arquivos/ids/180788-1600-auto');

CALL sp_CadastrarProduto( 'Tamborim 6 Frisadp Reels Lilás 595-ALRL - Gope', 137.08, 'Corpo: Alumínio Polegadas: 06" Cor: Reels Lilás Aro: Reels Lilás Pele: Leitosa', 'GOPE', 4.5, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(14,'https://ninjasom.vtexassets.com/arquivos/ids/204048-1600-auto');
CALL sp_AdicionarImagens(14,'https://ninjasom.vtexassets.com/arquivos/ids/204049-1600-auto');
CALL sp_AdicionarImagens(14,'https://ninjasom.vtexassets.com/arquivos/ids/204050-1600-auto');

CALL sp_CadastrarProduto( 'Reco Reco ALuminio G2 Lilás 766-L - Gope', 219.88, 'O Reco Reco G2 da Gope é um instrumento percussivo versátil e de alta qualidade, ideal para adicionar um efeito rítmico vibrante e contínuo. Fabricado pela Gope, uma referência em instrumentos de percussão, este reco reco com 3 molas oferece durabilidade e uma sonoridade clara e ressonante. Sua construção cuidadosa garante um instrumento robusto e resistente, pronto para enriquecer a seção rítmica em diversos estilos musicais.', 'GOPE', 3.9, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(15,'https://ninjasom.vtexassets.com/arquivos/ids/206888-1600-auto');
CALL sp_AdicionarImagens(15,'https://ninjasom.vtexassets.com/arquivos/ids/206889-1600-auto');
CALL sp_AdicionarImagens(15,'https://ninjasom.vtexassets.com/arquivos/ids/206890-1600-auto');

CALL sp_CadastrarProduto( 'Ganza Twist Medium LP-441T-M - LP', 219.88, 'A série LP Twist Shakers são um conjunto de shakers que possui um mecanismo patenteado de trava giratória que permite ao musico usa-los como conjunto, um em cada mão ou então adicionar outro complemento. Modelo: LP441T-M Linha: Twist Material: Plástico resistente Cor: Azul Volume: Médio (Medium) Comprimento: 17cm Diâmetro de cada shaker: 4cm Peso: 200g', 'Twist', 4.5, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(16,'https://ninjasom.vtexassets.com/arquivos/ids/209734-1600-auto');
CALL sp_AdicionarImagens(16,'https://ninjasom.vtexassets.com/arquivos/ids/209735-1600-auto');
CALL sp_AdicionarImagens(16,'https://ninjasom.vtexassets.com/arquivos/ids/209736-1600-auto');

CALL sp_CadastrarProduto( 'Stagg BW-200-BK Bongôs latinos de madeira', 703.80, '6,5 polegadas e 7,5 polegadas 6,5 polegadas e 7,5 polegadas Jantes e fundos de aço cromado de alta resistência Inclui chave de afinação Cabeça de couro de vaca', 'Stagg', 4.5, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(17,'https://x5music.vtexassets.com/arquivos/ids/178664-800-auto?v=636687220111670000&width=800&height=auto&aspect=true');
CALL sp_AdicionarImagens(17,'https://x5music.vtexassets.com/arquivos/ids/178665-800-auto?v=636687220260670000&width=800&height=auto&aspect=true');
CALL sp_AdicionarImagens(17,'https://www.altomusic.com/cdn/shop/files/stagg-BW200BK-0.png?v=1692023907&width=1946');

CALL sp_CadastrarProduto( 'Cowbell Pearl 4 PCB4', 154.80, 'Tamanho pequeno 4" Ideal para colocar em cima do bumbo Timbre agudo Bom volume Com presilha móvel, pronto para encaixar no clamp', 'Pearl', 4.8, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(18,'https://d58a5eovtl12n.cloudfront.net/Custom/Content/Products/68/46/68466_cowbell-pearl-4-primero-pcb4_z2_637836415655836169.webp');
CALL sp_AdicionarImagens(18,'https://d58a5eovtl12n.cloudfront.net/Custom/Content/Products/68/46/68466_cowbell-pearl-4-primero-pcb4_z1_637836415644898057.webp');
CALL sp_AdicionarImagens(18,'https://d58a5eovtl12n.cloudfront.net/Custom/Content/Products/68/46/68466_cowbell-pearl-4-primero-pcb4_z1_637836415643492407.webp');

CALL sp_CadastrarProduto( 'Atabaque c Borda 1m de altura', 898.99, '- Feito em madeira de reflorestamento, casco fabricado em ripas de pinus ajustadas e coladas uma a uma, devido a curvatura das ripas moldadas resulta em um ótimo som. - Madeira Reflorestada. - Produto De Procedência - Material E Acabamento De Qualidade - Otimo Acabamento. - Produto Altamente Resistente - Otimo Som - Produto Envernizado. - Pele De Boi Couro Natural - Aro Confortável Na Cor Preta - Pode Ser Usado Por Iniciantes E Profissionais. Ficha Técnica. - Ferragens; Cintas em volta do casco em metal. - Ajuste E Afinação: Por cinco tarraxas (parafusos e porcas metálicas, suportes feitos de fibra e resina) (muito resistente) - Borda: Fabricada de fibra e resina. - Produto é enviado montado, com couro (pele) já aplicado, exatamente como esta na foto do anuncio. Medidas. - Circunferência Total Boca: 93 cm - Diâmetro De Borda: 33 cm - Diâmetro Do Couro: 25 cm - Circunferência Da Base: 55 cm - Diâmetro Da Base: 14,5 cm - Inclui Suporte E 2 Brindes', 'Jair', 4.0, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(19,'https://atabaquejair.com.br/wp-content/uploads/2020/02/ataabqueBrtinde.jpg');
CALL sp_AdicionarImagens(19,'https://atabaquejair.com.br/wp-content/uploads/2020/02/ataabqueBrtinde.jpg');
CALL sp_AdicionarImagens(19,'https://atabaquejair.com.br/wp-content/uploads/2020/02/ataabqueBrtinde.jpg');

CALL sp_CadastrarProduto( 'Agogo Contmeporanea Duplo cromado 01c', 212.35, 'O Agogo Duplo Cromado Contemporânea é um instrumento de percussão de alta qualidade, ideal para profissionais que buscam um som autêntico e poderoso. Com corpo em alumínio cromado, este agogo é resistente e durável, garantindo longa vida útil. Este modelo, 01C, apresenta duas campânulas, uma maior com dimensões de 18cm x 9cm e uma menor de 14cm x 8cm. A combinação dessas duas campânulas permite uma variedade de sons, tornando este instrumento versátil para diferentes estilos musicais. O tamanho total do instrumento é de 33cm de comprimento, 19cm de altura e 10cm de largura, com um peso aproximado de 350g, tornando-o fácil de manusear e transportar. O Agogo Duplo Cromado Contemporânea vem na cor prateada, adicionando um toque de elegância ao seu design. Além disso, este instrumento inclui uma baqueta, permitindo que você comece a tocar imediatamente. Fabricado pela Contemporânea, uma marca reconhecida pela qualidade e inovação em instrumentos musicais, este agogo é uma excelente escolha para músicos exigentes.', 'Contemporanea', 4.7, 'Percussão', 20, 1);
CALL sp_AdicionarImagens(20,'https://images.tcdn.com.br/img/img_prod/635998/agogo_contemporanea_duplo_cromado_01c_56_3_9be3feecc20581835805a37be6b045f7.png');
CALL sp_AdicionarImagens(20,'https://images.tcdn.com.br/img/img_prod/635998/agogo_duplo_cromado_56_2_20180720095303.jpg');
CALL sp_AdicionarImagens(20,'https://images.tcdn.com.br/img/img_prod/635998/agogo_duplo_cromado_56_1_20180720095302.jpg');

CALL sp_CadastrarProduto( 'Gaita De Boca Hohner Harmônica Golden Melody G', 497.90, 'A Hohner Golden Melody passou por uma revisão radical para melhorar seu manuseio, estabilidade e estanqueidade. Embora mantendo o tom quente que a tornou um favorito dos tocadores de melodias de uma única nota em muitos estilos diferentes, o novo Golden Melody Progressive oferece um som mais completo e poderoso, combinado com um conforto ideal ao tocar. E também uma nova estética!', 'Hohner', 4.2, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(21,'https://images.tcdn.com.br/img/img_prod/1280588/gaita_de_boca_harmonica_golden_melody_542_20_g_sol_hohner_2061_1_e132ef5f1bce96513b0a6524a14490d7.jpg');
CALL sp_AdicionarImagens(21,'https://images.tcdn.com.br/img/img_prod/1280588/gaita_de_boca_harmonica_golden_melody_542_20_g_sol_hohner_2061_2_376901769bb1844431328bf30d8b14d1.jpeg');
CALL sp_AdicionarImagens(21,'https://images.tcdn.com.br/img/img_prod/1280588/gaita_de_boca_harmonica_golden_melody_542_20_g_sol_hohner_2061_4_b1d3e320d397006f5115c46663a42412.jpg');

CALL sp_CadastrarProduto( 'Flauta Transversal Spring C Niquelada 16 Chaves Profissional', 1550.99, 'Flauta Transversal Spring C Niquelada – Ideal para Iniciantes e Estudantes A Flauta Transversal Spring C é uma excelente escolha para quem está começando a explorar o universo da música. Fabricada com materiais de alta qualidade, ela combina precisão sonora, conforto no toque e durabilidade, sendo perfeita tanto para iniciantes quanto para estudantes que desejam evoluir com um instrumento confiável.', 'Panorama', 4.9, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(22,'https://acdn-us.mitiendanube.com/stores/006/539/932/products/flauta-jahnke-niquelada-1-1500x1500-7192f2e7411992d39017539628545439-480-0.webp');
CALL sp_AdicionarImagens(22,'https://http2.mlstatic.com/D_NQ_NP_634969-MLA95222828202_102025-O.webp');
CALL sp_AdicionarImagens(22,'https://http2.mlstatic.com/D_NQ_NP_823069-MLA84554053020_052025-O.webp');

CALL sp_CadastrarProduto( 'Eagle Clarinete 17 Chaves Sib Cl04n Cor Preto Cor das chaves Niqueladas', 1299.90, 'O Clarinete CL 04 da Eagle apresenta um acabamento brilhante com chaves niqueladas com um design ergonômico contemporâneo, proporcionando uma aparência elegante e maior resistência às condições de uso. Destaca-se pela qualidade de sua construção e pelos materiais que a compõem. As chaves ergonômicas, ajustadas manualmente, oferecem maior conforto, respostas rápidas e afinação precisa.', 'Eagle', 3.1, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(23,'https://http2.mlstatic.com/D_NQ_NP_990213-MLU79281441613_092024-O.webp');
CALL sp_AdicionarImagens(23,'https://http2.mlstatic.com/D_NQ_NP_810736-MLU75603359656_042024-O.webp');
CALL sp_AdicionarImagens(23,'https://http2.mlstatic.com/D_NQ_NP_2X_686988-MLA96121939531_102025-F.webp');

CALL sp_CadastrarProduto( 'Saxofone Alto Jupiter Jas 767 Laqueado Dourado', 5990.00, '- Afinação em Eb (Mi bemol) - Corpo em latão - Acabamento laqueado dourado - Chaves forjadas em latão - Chaves de PALM ajustáveis (patenteadas), oferecem mais conforto e flexibilidade - Chave G com parafuso de ajuste (patentada), melhora a eficiência de entonação da chave G - Molas agulha em Blue Steel - Chaves C# e Bb conectadas, fornecem alternativas de digitação - Chave F# agudo - F frontal - Articulação ajustável nas chaves C#, G#, Bb e F frontal - Feltros de proteção ajustáveis - Campana removível - Tudél com anel de proteção - Apoio de polegar ajustável - Construção robusta e reforçada com design e acabamento - Acompanha estojo e boquilha - Dimensões (L x P x A): 120 x 210 x 700 mm - Peso: 8,5 Kg - Conteúdo da embalagem: 1 Saxofone, 1 Case e 1 Manual.', 'Jupiter', 5.0, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(24,'https://http2.mlstatic.com/D_NQ_NP_2X_951157-MLA95497815348_102025-F.webp');
CALL sp_AdicionarImagens(24,'https://http2.mlstatic.com/D_NQ_NP_2X_663294-MLA95937466779_102025-F.webp');
CALL sp_AdicionarImagens(24,'https://http2.mlstatic.com/D_NQ_NP_2X_759756-MLA95937476645_102025-F.webp');

CALL sp_CadastrarProduto( 'Trompete Bb Pro Laq. - Quasar Infinity Symphonic Qtr3003m-if Dourado', 3299.00, 'O Trompete Bb Profissional Quasar Infinity Symphonic QTR3003M-IF foi projetado para músicos exigentes que buscam excelência sonora, durabilidade e precisão. Seu design robusto e a utilização de materiais premium garantem um som encorpado, projeção excepcional e resposta rápida, tornando-o ideal para orquestras, bandas sinfônicas e apresentações solo.', 'Quasar', 4.5, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(25,'https://http2.mlstatic.com/D_NQ_NP_2X_916348-MLB95923815645_102025-F.webp');
CALL sp_AdicionarImagens(25,'https://http2.mlstatic.com/D_NQ_NP_2X_668720-MLB80327424905_102024-F.webp');
CALL sp_AdicionarImagens(25,'https://http2.mlstatic.com/D_NQ_NP_2X_946364-MLB80327424907_102024-F.webp');

CALL sp_CadastrarProduto( 'Trombone De Vara Tenor Bb/f Hsl-801l Laqueado Harmonics', 2865.10, 'Apresentamos o Trombone De Vara Harmonics Tenor HSL 801 Bb/F Laqueado Cor Dourado, um instrumento de sopro de alta qualidade que irá elevar a sua performance musical a um novo patamar. Este trombone de vara, com afinação Bb/F (Sí Bemol e Fá), é ideal para músicos que buscam um som rico e cheio de personalidade. O Trombone De Vara Harmonics Tenor HSL 801 Bb/F Laqueado Cor Dourado é um instrumento de alta qualidade, com um calibre de 13,90 mm, que proporciona uma sonoridade única e poderosa. A sua cor dourada laqueada confere-lhe uma aparência elegante e sofisticada, que irá certamente impressionar tanto a audiência como os outros músicos.', 'Harmonics', 3.2, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(26,'https://static.mundomax.com.br/produtos/53812/1000/2.webp');
CALL sp_AdicionarImagens(26,'https://static.mundomax.com.br/produtos/53812/1000/1.webp');
CALL sp_AdicionarImagens(26,'https://static.mundomax.com.br/produtos/53812/1000/5.webp');

CALL sp_CadastrarProduto( 'Euphonium Bb Compensado (3+1) Quasar Infinity Qep1002nl-if Prateado', 9199.00, 'O Euphonium Bb Compensado 3+1 Quasar Infinity QEP1002NL IF é a escolha definitiva para músicos exigentes que valorizam sonoridade refinada, afinação estável e acabamento de alto padrão. Um instrumento desenvolvido para entregar performance profissional com requinte e confiabilidade.', 'Quasar', 3.0, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(27,'https://http2.mlstatic.com/D_NQ_NP_2X_831047-MLB80504120612_112024-F.webp');
CALL sp_AdicionarImagens(27,'https://http2.mlstatic.com/D_NQ_NP_2X_815070-MLB80504120616_112024-F.webp');
CALL sp_AdicionarImagens(27,'https://http2.mlstatic.com/D_NQ_NP_2X_677989-MLB95937325395_102025-F.webp');

CALL sp_CadastrarProduto( 'Oboé Alfa Ggob 100 Preto Corpo Em Baquelite Em Dó', 5980.00, 'Descubra a excelência musical com os oboés da linha Alfa, projetados para oferecer qualidade sonora a um preço acessível. Se você busca um instrumento confiável e versátil, o Oboé GGOB-100 Alfa é a escolha perfeita para estudantes, músicos iniciantes e entusiastas que desejam explorar novas possibilidades musicais sem comprometer o orçamento.', 'Alfa', 3.5, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(28,'https://www.lojafiladelfia.com.br/img/products/oboe-ggob-100-alfa_3_2000.webp');
CALL sp_AdicionarImagens(28,'https://www.lojafiladelfia.com.br/img/products/oboe-ggob-100-alfa_1_2000.png');
CALL sp_AdicionarImagens(28,'https://www.lojafiladelfia.com.br/img/products/oboe-ggob-100-alfa_2_2000.png');

CALL sp_CadastrarProduto( 'Sax Soprano Eagle Sp-502 Sib Laqueado C/estojo', 4879.98, 'O SP 502 é um saxofone tradicional da linha de metais da Eagle. Destaca-se pela qualidade da sua construção e pelos materiais que o compõem. As chaves ergonômicas são ajustadas manualmente, proporcionando maior conforto, respostas rápidas e afinação precisa. Este modelo tem um visual impressionante e uma sonoridade excepcional.', 'Eagle', 2.9, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(29,'https://http2.mlstatic.com/D_NQ_NP_2X_782316-MLA96135686361_102025-F.webp');
CALL sp_AdicionarImagens(29,'https://http2.mlstatic.com/D_NQ_NP_2X_950930-MLA83488158471_042025-F.webp');
CALL sp_AdicionarImagens(29,'https://http2.mlstatic.com/D_NQ_NP_2X_926347-MLA83487903189_042025-F.webp');

CALL sp_CadastrarProduto( 'Flauta Transversal Hoyden HFL-25D', 659.99, 'Flauta Transversal Hoyden HFL-25D é uma combinação de elegância e desempenho que encanta músicos de todos os níveis.', 'Hoyden', 4.5, 'Sopro', 20, 1);
CALL sp_AdicionarImagens(30,'https://images.tcdn.com.br/img/img_prod/958595/flauta_transversal_hoyden_hfl_25d_usada_2975_1_cfde2467dba320f537453983e443fd72.png');
CALL sp_AdicionarImagens(30,'https://images.tcdn.com.br/img/img_prod/958595/flauta_transversal_hoyden_hfl_25d_usada_2975_2_a1475a9f4fee6a6b9e5ff8666982d227.png');
CALL sp_AdicionarImagens(30,'https://images.tcdn.com.br/img/img_prod/958595/flauta_transversal_hoyden_hfl_25d_usada_2975_3_00e2d3a37cbd0877a86d74a132bc7631.png');

CALL sp_CadastrarProduto( 'Guitalele Gl1 Natural Ukulele Yamaha Gl-1', 899.00, 'Este é um violão estilo ukulele, de cordas de nylon e escala de 433mm. Apesar de seu corpo compacto, ele foi projetado como um violão de cordas de nylon autêntico. Carregue este violão exclusivo para qualquer lugar! Violão com encordoamento de náilon com escala de 433mm (17 pol.) Tampo em abeto Gig bag original incluída Especificações: Formato corpo: Corpo Pequeno Original Guitalele Comprimento da escala: 433 mm (17 ") Comprimento do corpo: 319 mm (12 9/16 ") Comprimento total: 698 mm (27 1/2 ") Largura do corpo: 229 mm (9 ") Profundidade Corpo: 70 mm (2 3/4 ") Largura do braço: 48 mm (1 7/8 ") Espaçamento das cordas: 10,2 mm Material tampo: Spruce Material do fundo: Locally Sourced Tonewood ** Material Lateral: Locally Sourced Tonewood ** Material do braço: Locally Sourced Tonewood ** Material da escala: Rosewood Raio da escala: Flat Material ponte: Maple Material do nut: Uréia Tarraxas: Chrome (RM-1252X) Encadernação Corpo: Preto (Nenhum para variação de cor BL) Acabamento do corpo: Matt Acabamento do braço: Matt Cordas: Médio Estojo: Gig Bag', 'Yamaha', 4.2, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(31,'https://http2.mlstatic.com/D_NQ_NP_2X_933226-MLB80884628777_112024-F.webp');
CALL sp_AdicionarImagens(31,'https://m.magazineluiza.com.br/a-static/420x420/guitalele-gl1-natural-ukulele-yamaha-gl-1/boleromusic/gl125/110db0c1877fa36fd20e77a5296faa13.jpeg');
CALL sp_AdicionarImagens(31,'https://a-static.mlcdn.com.br/420x420/guitalele-gl1-natural-ukulele-yamaha-gl-1/boleromusic/gl125/7d025c481545230de19f7efb316ab1a7.jpeg');

CALL sp_CadastrarProduto( 'Guitarra Jackson Arch Top JS22 Dinky DKA Metallic Blue', 1954.15, 'Rápidas, mortais e acessíveis, as guitarras da série Jackson JS dão um salto épico, tornando mais fácil do que nunca obter o tom clássico, a aparência e a tocabilidade da Jackson sem estourar o orçamento. O JS Series Dinky® Arch Top JS22 DKA tem um corpo de álamo ou nato (apenas óleo natural) com topo arqueado, braço de bordo parafusado de rápida execução com reforço de grafite e uma escala de amaranto com raio composto de 12"-16", encordoadas com 24 trastes jumbo e marcações peroladas de barbatana de tubarão. Um par de captadores humbucking de alta saída da Jackson com ímãs de cerâmica oferece um tom claro com muita densidade e pode ser moldado com um interruptor de três posições e controles individuais de volume e tom. Este modelo também apresenta hardware totalmente preto, incluindo uma ponte tremolo de fulcro sincronizado, botões de alça padrão e tarraxas fundidas.', 'Jackson', 4.3, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(32,'https://static.mundomax.com.br/produtos/83260/550/1.webp');
CALL sp_AdicionarImagens(32,'https://static.musiaudio.com.br/media/catalog/product/cache/bb0656022d85965a9fca0501b955b0c0/J/A/JACKSON_JS22_DINKY_ARCH_TOP_DKA_Metallic_Blue_5.webp');
CALL sp_AdicionarImagens(32,'https://static.musiaudio.com.br/media/catalog/product/cache/bb0656022d85965a9fca0501b955b0c0/J/A/JACKSON_JS22_DINKY_ARCH_TOP_DKA_Metallic_Blue_2.webp');

CALL sp_CadastrarProduto( 'Guitarra Wgs Sunburst Winner', 714.49, 'GUITARRA WGS SUNBURST WINNER A Guitarra Winner WGS Sunburst é uma excelente opção para músicos que buscam qualidade e versatilidade em um instrumento de cordas. Abaixo, apresento suas principais especificações: Especificações Técnicas: • Modelo: Stratocaster • Corpo: Basswood (Tília), proporcionando leveza e timbre equilibrado. • Braço: Maple (Bordo), garantindo durabilidade e estabilidade. • Escala: Rosewood (Jacarandá), oferecendo suavidade ao toque. • Orientação: Destro. • Cor: Sunburst. • Acabamento do Corpo: Brilhante. • Quantidade de Cordas: 6. • Comprimento da Escala: 25,5" (aproximadamente 64,77 cm). • Trastes: 22 trastes jumbo, facilitando a execução de notas e bends. • Ponte: Trêmolo com alavanca, permitindo efeitos de vibrato. • Captadores: 3 Single Coil cerâmicos, distribuídos nas posições braço, meio e ponte, garantindo versatilidade tonal. • Tarraxas: Blindadas cromadas, assegurando estabilidade na afinação. • Marcação de Braço: Dots (pontos). • Largura da Pestana (Nut): 42 mm. • Tipo de Pestana: Plástico. Observações: Público-Alvo: Ideal para iniciantes que desejam explorar o som da guitarra com um investimento acessível. Versatilidade: Adequada para diversos estilos musicais, incluindo rock, blues, pop e country.', 'Winner', 3.9, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(33,'https://m.media-amazon.com/images/I/61x-Acspv6L._AC_SY879_.jpg');
CALL sp_AdicionarImagens(33,'https://izzomusical.vtexassets.com/arquivos/ids/162160-800-auto?v=638045854414200000&width=800&height=auto&aspect=true');
CALL sp_AdicionarImagens(33,'https://cdn.awsli.com.br/800x800/1920/1920376/produto/20815893168568dd5c9.jpg');

CALL sp_CadastrarProduto( 'Guitarra elétrica profissional Ibanez GRGR131EX de 6 cordas', 1100.98, 'Guitarra Ibanez GRGR131EX BKF , Super Strato com captadores na configuração HH. Possui Headstock Invertido e marcação Estilo Dente de Tubarão (Sharktooth) Reversa. Disponível na cor Black Flat (BKF). A Série Gio da Ibanez prova que as guitarras não precisam ter um custo alto para ter um som de qualidade. Esta série foi desenvolvida por músicos que buscam justamente isso, custo/benefício. Com rigorosa inspeção, a construção e garantia são as mesmas dos modelos mais caros.', 'Ibanez', 4.9, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(34,'https://static.mundomax.com.br/produtos/83640/550/1.webp');
CALL sp_AdicionarImagens(34,'https://static.mundomax.com.br/produtos/83640/550/2.webp');
CALL sp_AdicionarImagens(34,'https://static.mundomax.com.br/produtos/83640/550/3.webp'); 

CALL sp_CadastrarProduto( 'Guitarra Strinberg Lps230 Bl Blue Burst Destro Blue Burst Madeira Técnica', 1690.00, 'Características Gerais - Modelo: LPS230 - Formato do Corpo: Les Paul - Madeira do Corpo: Basswood Sólido - Tampo: Basswood - Cor: Blue Burst (BL) - Acabamento: Brilhante - Braço: Maple - Construção: Bolt-On Neck (Junção Parafusada) - Escala: Technical Wood 24,75" - Marcações: Trapezoidais - Tensor: Sim. Bilateral - Nut (Capo Traste): 43mm - Número de Trastes: 22 - Encordoamento: .09 / .042 - Número de Cordas: 6 - Ponte: Tune-O-Matic - Captador Ponte: Humbucker Passivo - Captador Meio: N/A - Captador Braço: Humbucker Passivo - Jack: P10 - Tarraxas: Blindadas Cromadas - Escudo: Ivory - Utilização/Mão: Destro - Controles: Potenciômetro de Volume (2), Potenciômetro de Tonalidade (2) e Chave Seletora de 3 Posições.', 'Strinberg', 5.0, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(35,'https://http2.mlstatic.com/D_NQ_NP_2X_714421-MLB92348137747_092025-F.webp');
CALL sp_AdicionarImagens(35,'https://http2.mlstatic.com/D_NQ_NP_847492-MLA46365746912_062021-O.webp');
CALL sp_AdicionarImagens(35,'https://http2.mlstatic.com/D_NQ_NP_726089-MLA46365789724_062021-O.webp');

CALL sp_CadastrarProduto( 'Guitarra 6 Cordas S By Solar Sb4.6frfbr Vermelha Floyd Rose', 3799.00, 'Espelhando a função de ponta e design de grandes irmãs da série Solar S, a S by Solar Type SB é a porta de entrada para rasgar o céu. Com recursos aprimorados e desenvolvidos para guitarristas de rock, metal e progressivo, essas guitarras vem equipadas com Floyd Rose e oferecem uma sonoridade rápida, tocabilidade precisa e conforto para elevar sua música para o próximo nível. • Escala em TechWood com trastes Jumbo • Corpo em Poplar • Escala de 25,5” • Tarraxas seladas Die cast, pretas • Braço com acesso total • Ponte Floyd Rose Special, preta • Captadores Humbuckers Solar Designed de alta saída • Controles: 1 Volume, 1 Tone, 3 vias switch • Acabamentos flamed vermelho sangue e flamed azul ambas com "binding" preto', 'S by Solar', 3.7, 'Cordas', 20,1 );
CALL sp_AdicionarImagens(36,'https://http2.mlstatic.com/D_NQ_NP_2X_876093-MLB90261559634_082025-F.webp');
CALL sp_AdicionarImagens(36,' https://barramusic.com.br/wp-content/uploads/2025/05/SB4_6FRFBR_0002.webp');
CALL sp_AdicionarImagens(36,'https://http2.mlstatic.com/D_NQ_NP_951619-MLB90261559632_082025-O.webp');

CALL sp_CadastrarProduto( 'Baixo Elétrico Pearl River BPJ60-N - 4 Cordas, Corpo em Jacarandá', 4185.00, 'O Baixo Elétrico Pearl River BPJ60-N é um instrumento profissional de 4 cordas, projetado para oferecer um timbre encorpado e sustain prolongado. Com corpo em jacarandá e braço em maple, ele combina qualidade sonora e conforto. Equipado com captadores ativos de alta sensibilidade, ponte ajustável e tarraxas seladas, garante afinação precisa. Seu design moderno e acabamento em verniz brilhante proporcionam estilo e durabilidade, tornando-o ideal para diversos gêneros musicais, do rock ao jazz. O produto inclui estojo acolchoado e alça ajustável para maior praticidade.', 'PEARL RIVER', 3.5, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(37,'https://www.teclacenter.com.br/media/catalog/product/cache/0ea5c2a2792b81c0f087964bbcb6e251/t/c/tc_pearl_river_bpj60-n_-_03.jpg');
CALL sp_AdicionarImagens(37,'https://www.teclacenter.com.br/media/catalog/product/cache/3381773bcf29e72c83e97f358e3accef/t/c/tc_pearl_river_bpj60-n_-_01.webp');
CALL sp_AdicionarImagens(37,'https://www.teclacenter.com.br/media/catalog/product/cache/3381773bcf29e72c83e97f358e3accef/t/c/tc_pearl_river_bpj60-n_-_06.webp');

CALL sp_CadastrarProduto( 'VIOLINO EAGLE VE441 4/4', 1090.22, 'O violino Eagle 4/4 VE441 é um dos grandes sucessos de vendas da Eagle. Isso porque possui uma das melhores relações custo x benefício do mercado, fornecendo Alta Qualidade em um instrumento com baixissimo preço. O VE441 permite uma perfeita regulagem do cavalete, do estandarte e da alma proporcionando harmonia ideal para uma melhor ressonância. Sua madeira selecionada faz com que o som tenha uma qualidade muito boa. Este Violino da Eagle possui excelente acabamento e matéria-prima de primeira linha. Desenvolvido com madeiras maciças de Spruce e Maple, ele atende os músicos que buscam qualidade, beleza e uma sonoridade envolvente. Não há porque arriscar em violinos de marcas menos expressivas, dê preferência a um instrumento que seja reconhecido no mercado. Aproveite! Tampo:Abeto (Spruce) Faixa e Fundo:Maple Braço:Maple Escala:Ébano Acabamento:Envernizado Cravelhas:Boxwood Queixeira:Boxwood Pesquisa:violino 4/4 ve441 ve 441 ve-441 envernizado Acessórios:Estojo Térmico Extra Luxo Retangular Arco:Madeira com "Olho Paris" e Crina Animal Genuína - Estandarte: Boxwood - Micro Afinação: 4 Cordas', 'EAGLE', 3.8, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(38,'https://m.media-amazon.com/images/I/71JlgP1p-FL._AC_SX679_.jpg');
CALL sp_AdicionarImagens(38,'https://serenata.vteximg.com.br/arquivos/ids/3106682-1000-1000/VIOLINO-EAGLE-VE244-4-4-ENV_IMG2.jpg?v=638525030894570000');
CALL sp_AdicionarImagens(38,'https://cdn.awsli.com.br/2500x2500/149/149537/produto/52420502/96b501a7cd.jpg');

CALL sp_CadastrarProduto( 'Violoncelo Cecílio CCO-100(Com Bag)', 1600.00, 'O violoncelo Cecilio CCO-100 é ideal para violoncelistas iniciantes ou estudantes, com tampo em abeto à prova de rachaduras, fundo, braço e laterais em bordo. Este violoncelo é equipado com um estojo leve acolchoado com bolsos e alças de mochila ajustáveis (tornando-o conveniente para carregar para a escola ou orquestra), um arco de pau-brasil com crina crua, suporte de violoncelo e um bolo de breu. Corpo: Tampo em spruce à prova de rachaduras com braço, fundo e laterais em maple Escala: Bordo Estacas: Bordo', 'CECÍLIO', 3.8, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(39,'https://cdn11.bigcommerce.com/s-c3f06q9uvc/images/stencil/640w/products/299399/1285325/89347b6c-2f6c-4d4b-992c-ed7bb662fd58__72884.1752782941.jpg?c=1');
CALL sp_AdicionarImagens(39,'https://cdn11.bigcommerce.com/s-c3f06q9uvc/images/stencil/1280x1280/products/383492/1497174/5e87efc4-2630-4a4d-97c1-37f0fdb88e7c__86106.1757961992.jpg?c=1');
CALL sp_AdicionarImagens(39,'https://cdn11.bigcommerce.com/s-c3f06q9uvc/images/stencil/640w/products/299399/1285332/b1b43314-5019-47d4-bb59-cf0295130235__33520.1752782941.jpg?c=1');

CALL sp_CadastrarProduto( 'Ukulele Kalani Kayke Concert Natural Sapele com Bag', 377.66, 'Ukulele Kalani série Kayke, modelo Concert, construído em Natural Sapele, acompanha bag. KALANI KAYKE proporciona a oportunidade de se expressar através da música com um instrumento de qualidade. Explore sua criatividade musical e expanda seus limites com KALANI KAYKE. Concert tamanho: 24" Madeira do Tampo: Mahogany Madeira do Corpo: Mahogany Madeira do Braço: Okoumé Madeira da Escala: Blackwood Madeira do Cavalete: Blackwood Binding: ABS Roseta: ABS Acompanha: Bag Código Izzo: 15421', 'Kalani', 4.2, 'Cordas', 20, 1);
CALL sp_AdicionarImagens(40,'https://http2.mlstatic.com/D_NQ_NP_2X_933864-MLU74996459517_032024-F.webp');
CALL sp_AdicionarImagens(40,'https://cdn.awsli.com.br/1795/1795431/produto/270037788/ukulele-kalani-kayke-concerto-sapele-acustico-com-bag-kal-300-cs-1-cn3kju78s2.jpg');
CALL sp_AdicionarImagens(40,'https://madeinbrazil.fbitsstatic.net/img/p/ukulele-kalani-concert-kal-220-cs-serie-tribes-com-bag-129331/342392-2.jpg?w=800&h=800&v=no-value');


-- call sp_GerenciarNivel(2,"remover",3)

select * from tbEstoque;

SELECT * FROM vw_HistoricoAcao  WHERE IdUsuario = 1 ORDER BY DataAcao DESC;