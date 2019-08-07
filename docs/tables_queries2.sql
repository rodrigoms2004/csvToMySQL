
CREATE TABLE IF NOT EXISTS `tony`.`Base2` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `DAT_FOTO` DATE NULL,
  `COD_GPON` VARCHAR(45) NULL,
  `COD_CLIENTE_RPON` VARCHAR(45) NULL,
  `PRODUTO` VARCHAR(45) NULL,
  `DATA_VENDA` DATE NULL,
  `NOM_STATUSDESCRICAO` VARCHAR(45) NULL,
  `NOM_STATUSRAZAO` VARCHAR(45) NULL,
  `MOTIVO` VARCHAR(45) NULL,
  `OBS` VARCHAR(45) NULL,

  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


SELECT * FROM tony.Base2;

-- drop table Base2;

CREATE INDEX idx_COD_CLIENTE_RPON ON Base2(COD_CLIENTE_RPON);
CREATE INDEX idx_DAT_FOTO ON Base2(DAT_FOTO);

/*
Status dia: monitorar numero de dias 

novo 
	única entrada EM COD_CLIENTE_RPON, definido como NOVO
    
    ou
    se o MOTIVO ALTEROU-SE APÓS ENTRADA ANTERIOR 
	se passou mais de um dia útil fora da base, pela DAT_FOTO
    
pendente
	se não bater, é pendente

*/

###############################################
# verifica se a duplicação, 2299
SELECT 
  ba.COD_CLIENTE_RPON,
  count(ba.COD_CLIENTE_RPON) AS numeroOcorrencias
FROM tony.Base2 AS ba 
GROUP BY ba.COD_CLIENTE_RPON
HAVING count(ba.COD_CLIENTE_RPON) = 1
ORDER BY count(ba.COD_CLIENTE_RPON);

SELECT DISTINCT ba.COD_CLIENTE_RPON FROM tony.Base2 ba; # 15700



###############################################

SELECT 
	ba1.ID,
    ba1.DAT_FOTO,
    ba1.COD_GPON,
	ba1.COD_CLIENTE_RPON,
    ba1.PRODUTO,
    ba1.DATA_VENDA,
    ba1.NOM_STATUSDESCRICAO,
    ba1.NOM_STATUSRAZAO,
    ba1.MOTIVO,
	ba1.OBS,
    IF(MOTIVO = 'DISTRIBUÍDO', 'enabled', 'disabled') AS statusDia
FROM tony.Base2 ba1
WHERE ba1.ID IN
(
SELECT 
	MAX(ID) AS ID
FROM tony.Base2
GROUP BY (COD_CLIENTE_RPON)
);

-- 8-A57EF359193-1
SELECT 
	ba1.ID,
    ba1.DAT_FOTO,
--     ba1.COD_GPON,
	ba1.COD_CLIENTE_RPON,
    ba1.PRODUTO,
--     ba1.DATA_VENDA,
--     ba1.NOM_STATUSDESCRICAO,
--     ba1.NOM_STATUSRAZAO,
--     ba1.MOTIVO,
	ba1.OBS,
    (
        CASE
			WHEN (SELECT weekday(ba1.DAT_FOTO)) = 0 THEN "Segunda"
			WHEN (SELECT weekday(ba1.DAT_FOTO)) = 1 THEN "Terça"
			WHEN (SELECT weekday(ba1.DAT_FOTO)) = 2 THEN "Quarta"
			WHEN (SELECT weekday(ba1.DAT_FOTO)) = 3 THEN "Quinta"
			WHEN (SELECT weekday(ba1.DAT_FOTO)) = 4 THEN "Sexta"
			WHEN (SELECT weekday(ba1.DAT_FOTO)) = 5 THEN "Sábado"
			WHEN (SELECT weekday(ba1.DAT_FOTO)) = 6 THEN "Domingo"
			ELSE "na"
        END
        
        -- 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 5 = Saturday, 6 = Sunday
    ) AS diaDaSemana,
    (
		SELECT COUNT(ba.COD_CLIENTE_RPON)
        FROM tony.Base2 ba
        WHERE 
        ba.COD_CLIENTE_RPON = ba1.COD_CLIENTE_RPON 
        AND ba.DAT_FOTO < ba1.DAT_FOTO
        AND ba.MOTIVO = ba1.MOTIVO
    ) AS Aging,
    (
		SELECT DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)
    ) AS AgingEntrada,
    /*
		0 a 7 dias
        8 a 15 dias
        16 a 25 dias
        26 a 60 dias
        > 60 dias
    */
    -- IF(DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA) > 60, '> 61 dias', 'ok') AS BlocoEntrada
    (
		
		CASE
			WHEN (DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)) > 0 AND
				(DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)) < 8 THEN "0 a 07 dias"
                
			WHEN (DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)) >= 8 AND
				(DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)) < 16 THEN "08 a 15 dias"
			
			WHEN (DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)) >= 16 AND
				(DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)) < 26 THEN "16 a 25 dias"
                
			WHEN (DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)) >= 26 AND
				(DATEDIFF(ba1.DAT_FOTO, ba1.DATA_VENDA)) < 61 THEN "26 a 60 dias"
                
			ELSE "> 61 dias"
        END
        
    ) AS BlocoEntrada
    
FROM tony.Base2 ba1
ORDER BY COD_CLIENTE_RPON, DAT_FOTO;


-- SELECT TIMEDIFF('2019-07-10 00:00:00', '2019-07-05 00:00:00');

-- SELECT DATEDIFF('2019-07-10', '2019-07-05');


