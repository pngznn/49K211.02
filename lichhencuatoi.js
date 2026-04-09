const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "", 
  database: "cliniccare"
});

db.connect(err => {
  if (err) {
    console.log(" Lỗi kết nối DB");
    return;
  }
  console.log(" MySQL connected");
});



app.get("/appointments", (req, res) => {
  const sql = "SELECT * FROM appointments ORDER BY date ASC";

  db.query(sql, (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
  });
});


app.get("/appointments/:id", (req, res) => {
  const sql = "SELECT * FROM appointments WHERE id = ?";
  
  db.query(sql, [req.params.id], (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result[0]);
  });
});


app.post("/appointments", (req, res) => {
  const {
    patientName,
    phone,
    doctorName,
    department,
    date,
    time,
    room,
    note
  } = req.body;

  const sql = `
    INSERT INTO appointments 
    (patientName, phone, doctorName, department, date, time, room, status, note)
    VALUES (?, ?, ?, ?, ?, ?, ?, 'confirmed', ?)
  `;

  db.query(
    sql,
    [patientName, phone, doctorName, department, date, time, room, note],
    (err, result) => {
      if (err) return res.status(500).json(err);
      res.json({ message: "Tạo lịch thành công", id: result.insertId });
    }
  );
});


app.put("/appointments/:id", (req, res) => {
  const {
    patientName,
    phone,
    doctorName,
    department,
    date,
    time,
    room,
    note
  } = req.body;

  const sql = `
    UPDATE appointments SET
    patientName = ?,
    phone = ?,
    doctorName = ?,
    department = ?,
    date = ?,
    time = ?,
    room = ?,
    note = ?
    WHERE id = ?
  `;

  db.query(
    sql,
    [
      patientName,
      phone,
      doctorName,
      department,
      date,
      time,
      room,
      note,
      req.params.id
    ],
    (err) => {
      if (err) return res.status(500).json(err);
      res.json({ message: "Cập nhật thành công" });
    }
  );
});


app.patch("/appointments/:id/cancel", (req, res) => {
  const sql = "UPDATE appointments SET status = 'cancelled' WHERE id = ?";

  db.query(sql, [req.params.id], (err) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Đã hủy lịch" });
  });
});


app.listen(3000, () => {
  console.log("Server chạy tại http://localhost:3000");
});