from flask import Flask, jsonify, request, render_template, redirect
import json

app = Flask(__name__)

DATA_FILE = "data.json"

# đọc data
def load_data():
    with open(DATA_FILE, "r", encoding="utf-8") as f:
        return json.load(f)

# ghi data
def save_data(data):
    with open(DATA_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

# ===============================
# ROUTES
# ===============================

# Trang quản lý
@app.route("/")
def home():
    return render_template("quanlylichhenadmin.html")

# API: lấy danh sách lịch
@app.route("/api/appointments")
def get_appointments():
    data = load_data()
    return jsonify(data)

# API: lấy chi tiết
@app.route("/api/appointments/<id>")
def get_detail(id):
    data = load_data()
    for appt in data:
        if appt["id"] == id:
            return jsonify(appt)
    return jsonify({"error": "Not found"}), 404

# API: cập nhật lịch
@app.route("/api/appointments/<id>", methods=["PUT"])
def update_appointment(id):
    data = load_data()
    body = request.json

    for appt in data:
        if appt["id"] == id:
            appt["doctor"] = body.get("doctor", appt["doctor"])
            appt["department"] = body.get("department", appt["department"])
            appt["date"] = body.get("date", appt["date"])
            appt["time"] = body.get("time", appt["time"])
            appt["note"] = body.get("note", appt["note"])
            save_data(data)
            return jsonify({"message": "Updated"})

    return jsonify({"error": "Not found"}), 404

# API: hủy lịch
@app.route("/api/appointments/<id>/cancel", methods=["POST"])
def cancel_appointment(id):
    data = load_data()

    for appt in data:
        if appt["id"] == id:
            appt["status"] = "cancelled"
            save_data(data)
            return jsonify({"message": "Cancelled"})

    return jsonify({"error": "Not found"}), 404

@app.route("/detail/<id>")
def detail_page(id):
    return render_template("xemchitietlichhenadmin.html", id=id)

if __name__ == "__main__":
    app.run(debug=True)
