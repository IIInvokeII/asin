from flask import Flask, request, Response
import sqlite3, json

app = Flask(__name__);

db_locale = "serial.db"

@app.route("/add", methods=['POST'])
def add_record():
    if request.method=='POST':
        conn = sqlite3.connect(db_locale)
        c = conn.cursor()
        c.execute(
            """INSERT INTO serial(serialNumber, seriesName, seriesRating) VALUES(?,?,?)""", 
            (request.headers["serialNumber"], request.headers["seriesName"], request.headers["seriesRating"],)
        )
        conn.commit()
        conn.close()
        return Response(status=200)

@app.route("/view_all", methods=['GET'])
def view_one():
    if request.method=='GET':
        conn = sqlite3.connect(db_locale)
        c = conn.cursor()
        sqlres = c.execute("select * from serial").fetchall()
        conn.commit()
        conn.close()
        res=[]
        for sno in sqlres:
            resp={}
            resp['serialNumber']=sno[0]
            resp['seriesName']=sno[1]
            resp['seriesRating']=sno[2]
            res.append(resp)
        finalres={}
        finalres['result'] = res
        return json.dumps(finalres)

@app.route('/update', methods=['POST'])
def update():
    conn = sqlite3.connect(db_locale);
    c = conn.cursor()
    c.execute(
        """update serial set seriesName=?, seriesRating=? where serialNumber=?""", 
        (
            request.headers['seriesName'],
            request.headers['seriesRating'],
            request.headers['serialNumber'],
        )
    )
    conn.commit()
    conn.close()
    return Response(status=200)

@app.route('/delete', methods=['DELETE'])
def delete_rec():
    if request.method=='DELETE':
        conn = sqlite3.connect(db_locale);
        c = conn.cursor()
        c.execute(
            "delete from serial where serialNumber=?",
            (
                request.headers['serialNumber']
            )
        )
        conn.commit()
        conn.close()
        return Response(status=200)

if __name__ == '__main__':
    app.run(host="0.0.0.0",port=5000)