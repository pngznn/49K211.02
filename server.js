const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const bcrypt = require("bcrypt");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
  console.log(`[${req.method}] ${req.url}`);
  next();
});

const db = mysql.createConnection({
  host: "127.0.0.1",
  user: "root",
  password: "",
  database: "clinicare"
});

db.connect((err) => {
  if (err) {
    console.error("Kết nối MySQL thất bại:", err);
    return;
  }
  console.log("Kết nối MySQL thành công!");
});

app.get("/api/test", (req, res) => {
  res.json({
    success: true,
    message: "Backend dang chay"
  });
});

app.post("/api/patient/register", async (req, res) => {
  try {
    console.log("Nhận dữ liệu đăng ký:", req.body);

    const { fullName, email, phone, gender, password, confirmPassword } = req.body;

    if (!fullName || !email || !phone || !gender || !password || !confirmPassword) {
      return res.status(400).json({
        success: false,
        message: "Vui lòng nhập đầy đủ thông tin."
      });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({
        success: false,
        message: "Email không hợp lệ."
      });
    }

    const cleanPhone = phone.replace(/\s/g, "");
    const phoneRegex = /^(0|\+84)[0-9]{9,10}$/;
    if (!phoneRegex.test(cleanPhone)) {
      return res.status(400).json({
        success: false,
        message: "Số điện thoại không hợp lệ."
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        message: "Mật khẩu phải có ít nhất 6 ký tự."
      });
    }

    if (password !== confirmPassword) {
      return res.status(400).json({
        success: false,
        message: "Mật khẩu xác nhận không khớp."
      });
    }

    const checkSql = "SELECT id FROM patients WHERE email = ? OR phone = ?";
    db.query(checkSql, [email, cleanPhone], async (checkErr, results) => {
      if (checkErr) {
        console.error("Lỗi kiểm tra trùng:", checkErr);
        return res.status(500).json({
          success: false,
          message: "Lỗi DB: " + checkErr.message
        });
      }

      if (results.length > 0) {
        return res.status(400).json({
          success: false,
          message: "Email hoặc số điện thoại đã được đăng ký."
        });
      }

      const hashedPassword = await bcrypt.hash(password, 10);

      const insertSql = `
        INSERT INTO patients (full_name, email, phone, gender, password)
        VALUES (?, ?, ?, ?, ?)
      `;

      db.query(insertSql, [fullName, email, cleanPhone, gender, hashedPassword], (insertErr, result) => {
        if (insertErr) {
          console.error("Lỗi INSERT MySQL:", insertErr);
          return res.status(500).json({
            success: false,
            message: "Lỗi DB: " + insertErr.message
          });
        }

        console.log("Đăng ký thành công, ID:", result.insertId);

        return res.status(201).json({
          success: true,
          message: "Đăng ký tài khoản thành công!",
          patientId: result.insertId
        });
      });
    });
  } catch (error) {
    console.error("Lỗi server tổng:", error);
    return res.status(500).json({
      success: false,
      message: "Lỗi server: " + error.message
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server chạy tại http://localhost:${PORT}`);
});