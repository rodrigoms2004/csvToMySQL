import sys
from mysqlConnector import getMySqlConnector

def insertIntoDB(sql, val):
    try:
        dbConn = getMySqlConnector()
        dbCursor = dbConn.cursor()
        dbCursor.execute(sql, val)
        dbConn.commit()

        # print(dbCursor.rowcount, 'record inserted')
    except:
        print('SQL Error', sys.exc_info())
# end def