create database tony;

SELECT * FROM tony.Base where DAT_FOTO is null;

use tony;

CREATE TABLE IF NOT EXISTS `tony`.`Base` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DAT_FOTO` VARCHAR(45) NULL,
  `COD_GPON` VARCHAR(45) NULL,
  `COD_CLIENTE_RPON` VARCHAR(45) NULL,
  `PRODUTO` VARCHAR(45) NULL,
  `DATA_VENDA` VARCHAR(45) NULL,
  `MOTIVO` VARCHAR(45) NULL,
  `MES` VARCHAR(45) NULL,
  `Status_dia` VARCHAR(45) NULL,
  `Aging` VARCHAR(45) NULL,
  `Parametro1` VARCHAR(45) NULL,
  `QtdDeRetorno` VARCHAR(45) NULL,
  `Bloco` VARCHAR(45) NULL,
  `AGING_DE_ENTRADA` VARCHAR(45) NULL,
  `BLOCO_DE_ENTRADA` VARCHAR(45) NULL,
  `Coluna1` VARCHAR(45) NULL,
  `Coluna2` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;

SELECT
	str_to_date(ba.DAT_FOTO, '%d/%m/%Y') AS DAT_FOTO
FROM tony.Base AS ba
WHERE str_to_date(ba.DAT_FOTO, '%d/%m/%Y') > "2019-12-06";


select * from Base;

SELECT 
  ba.ID,
  str_to_date(ba.DAT_FOTO, '%d/%m/%Y') AS DAT_FOTO,
  ba.COD_GPON,
  ba.COD_CLIENTE_RPON,
  ba.PRODUTO,
  str_to_date(ba.DATA_VENDA, '%d/%m/%Y') AS DATA_VENDA,
  ba.MOTIVO,
  ba.MES,
  ba.Status_dia,
  ba.Aging,
  str_to_date(ba.Parametro1, '%d/%m/%Y') AS Parametro1,
  ba.QtdDeRetorno,
  ba.Bloco,
  ba.AGING_DE_ENTRADA,
  ba.BLOCO_DE_ENTRADA,
  ba.Coluna1,
  ba.Coluna2
FROM tony.Base AS ba;
-- WHERE str_to_date(ba.DAT_FOTO, '%d/%m/%Y') > "2019-12-06";


# verifica se a duplicação
SELECT 
  ba.COD_CLIENTE_RPON
  -- count(ba.COD_CLIENTE_RPON) AS numeroOcorrencias
FROM tony.Base AS ba 
GROUP BY ba.COD_CLIENTE_RPON
HAVING count(ba.COD_CLIENTE_RPON) = 1
ORDER BY count(ba.COD_CLIENTE_RPON);


# quantidade de clientes 8399
SELECT 
  ba.COD_CLIENTE_RPON
FROM tony.Base AS ba 
GROUP BY ba.COD_CLIENTE_RPON;




CREATE INDEX idx_COD_CLIENTE_RPON ON Base(COD_CLIENTE_RPON);

SELECT * 
FROM tony.Base AS ba1
WHERE ba1.COD_CLIENTE_RPON IN (
	SELECT 
	  ba2.COD_CLIENTE_RPON
	FROM tony.Base AS ba2 
	GROUP BY ba2.COD_CLIENTE_RPON
    HAVING count(ba2.COD_CLIENTE_RPON) = 1
);



-- WHERE str_to_date(ba.DAT_FOTO, '%d/%m/%Y') > "2019-12-06";


/*
Status dia: novo e pendente

novo 
	única entrada EM COD_CLIENTE_RPON
    se o MOTIVO ALTEROU-SE APÓS ENTRADA ANTERIOR 
	se passou mais de um dia útil fora da base, pela DAT_FOTO
    
pendente
	se não bater, é pendente

*/


# Avaliação de motivos

select count(*) from tony.Base; # 58535

drop table if exists ultimoRegistro;
drop table if exists registrosAnteriores;
drop table if exists registrosAnterioresTemp;
drop table if exists penultimoRegistro;

# cria tabela os ultimos registros de cada cliente
CREATE TEMPORARY TABLE ultimoRegistro 
SELECT 
	ba1.ID,
	ba1.COD_CLIENTE_RPON,
    ba1.MOTIVO,
	ba1.DAT_FOTO
FROM tony.Base ba1
WHERE ba1.ID IN
(
SELECT 
	MAX(ID) AS ID
FROM tony.Base
GROUP BY (COD_CLIENTE_RPON)
);

# cria tabela com outros registros 
CREATE TEMPORARY TABLE registrosAnteriores 
SELECT 
	ba1.ID,
	ba1.COD_CLIENTE_RPON,
    ba1.MOTIVO,
	ba1.DAT_FOTO
FROM tony.Base ba1
WHERE ba1.ID NOT IN
(
SELECT 
	MAX(ID) AS ID
FROM tony.Base
GROUP BY (COD_CLIENTE_RPON)
);

# cria tabela temporária para dupla operação de select
CREATE TEMPORARY TABLE registrosAnterioresTemp SELECT * FROM registrosAnteriores;

# cria tabela dos penultimos registros 6810
CREATE TEMPORARY TABLE penultimoRegistro
SELECT 
	ra.ID,
	ra.COD_CLIENTE_RPON,
    ra.MOTIVO,
	ra.DAT_FOTO
FROM registrosAnteriores ra
WHERE ra.ID IN
(
SELECT 
	MAX(ID) AS ID
FROM registrosAnterioresTemp
GROUP BY (COD_CLIENTE_RPON)
);


# junta ultimoRegistro com penultimo registro
SELECT
	ur.ID,
	ur.COD_CLIENTE_RPON,
    ur.MOTIVO,
	str_to_date(ur.DAT_FOTO, '%d/%m/%Y') AS DAT_FOTO
FROM ultimoRegistro ur

UNION

SELECT
	pr.ID,
	pr.COD_CLIENTE_RPON,
    pr.MOTIVO,
	str_to_date(pr.DAT_FOTO, '%d/%m/%Y') AS DAT_FOTO
FROM penultimoRegistro pr
ORDER BY COD_CLIENTE_RPON;


##############

# seleciona registros cujo motivo se alterou
SELECT
	ur.ID,
	ur.COD_CLIENTE_RPON,
    ur.MOTIVO,
    ur.DAT_FOTO
FROM ultimoRegistro ur
LEFT JOIN penultimoRegistro pr ON ur.COD_CLIENTE_RPON = pr.COD_CLIENTE_RPON
WHERE ur.motivo <> pr.motivo AND ur.motivo <> 'DUPLICIDADE';



