import pandas as pd
from dbQueryFunctions import insertIntoDB
from datetime import datetime

base = pd.read_csv('./bases/base2.csv', low_memory=False)

for key, value in base.iterrows():


  sql = "INSERT IGNORE INTO tony.Base2 (\
                          DAT_FOTO,\
                          COD_GPON,\
                          COD_CLIENTE_RPON,\
                          PRODUTO,\
                          DATA_VENDA,\
                          NOM_STATUSDESCRICAO,\
                          NOM_STATUSRAZAO,\
                          MOTIVO,\
                          OBS)\
                          VALUES\
                          (%s, %s, %s, %s, %s, %s, %s, %s, %s)"

  val = (
    datetime.strptime(str(value['DAT_FOTO']), '%d/%m/%y'),
    str(value['COD-GPON']),
    str(value['COD_CLIENTE_RPON']),
    str(value['PRODUTO']),
    datetime.strptime(str(value['DATA_VENDA']), '%m/%d/%Y'),
    str(value['NOM_STATUSDESCRICAO']),
    str(value['NOM_STATUSRAZAO']),
    str(value['MOTIVO']),
    str(value['OBS']),
  )              

  insertIntoDB(sql, val)

