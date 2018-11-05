from flask import Flask
import sqlalchemy
app = Flask(__name__)

@app.route("/")
def hello():
	engine = sqlalchemy.create_engine("mssql+pyodbc://anfranci:aaf@13Micro@anandmobiletestdb.database.windows.net/anandmobtestdb?driver=SQL+Server+Native+Client+11.0",echo=False)
	return "Hello World!"

if __name__ == "__main__":
    app.run()