##https://parzibyte.me/blog/2018/09/18/python-3-mysql-crud-ejemplos-conexion/

import json
import pymysql
import os

def lambda_handler(event, context):
    try:
        conexion = pymysql.connect(host=os.environ["HOST"],
                                user=os.environ["USER"],
                                password=os.environ["PASSWORD"],
                                db=os.environ["DB"])
        print("Conexión correcta")
        return {
            'statusCode': 200,
            'body': json.dumps('successful connection  from Lambda!')
        }    
    except (pymysql.err.OperationalError, pymysql.err.InternalError) as e:
        print("Ocurrió un error al conectar: ", e)
        return {
            'statusCode': 400,
            'body': json.dumps('Error!')
        }


