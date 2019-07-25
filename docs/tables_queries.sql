create database tony;

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
