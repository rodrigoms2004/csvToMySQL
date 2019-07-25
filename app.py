import pandas as pd
from dbQueryFunctions import insertIntoDB


base = pd.read_csv('./bases/base.csv', low_memory=False)


# print(base)

for key, value in base.iterrows():

  sql = "INSERT IGNORE INTO tony.Base (\
                          DAT_FOTO,\
                          COD_GPON,\
                          COD_CLIENTE_RPON,\
                          PRODUTO,\
                          DATA_VENDA,\
                          MOTIVO,\
                          MES,\
                          Status_dia,\
                          Aging,\
                          Parametro1,\
                          QtdDeRetorno,\
                          Bloco,\
                          AGING_DE_ENTRADA,\
                          BLOCO_DE_ENTRADA,\
                          Coluna1,\
                          Coluna2)\
                          VALUES\
                          (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

  val = (
    str(value['DAT_FOTO']),
    str(value['COD-GPON']),
    str(value['COD_CLIENTE_RPON']),
    str(value['PRODUTO']),
    str(value['DATA_VENDA']),
    str(value['MOTIVO']),
    str(value['MÊS']),
    str(value['Status dia']),
    str(value['Aging']),
    str(value['Parametro1']),
    str(value['Qtd de retorno']),
    str(value['Bloco']),
    str(value['AGING_DE_ENTRADA']),
    str(value['BLOCO DE ENTRADA']),
    str(value['Coluna1']),
    str(value['Coluna2']),
  )              

  insertIntoDB(sql, val)