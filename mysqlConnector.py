import mysql.connector

# pip install mysql-connector

mydb = mysql.connector.connect(
  host="172.16.105.153",
  user="root",
  passwd="cisco"
)

def getMySqlConnector():
  return mydb
# end def
