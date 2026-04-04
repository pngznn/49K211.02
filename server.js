const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const bcrypt = require("bcrypt");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

const db = mysql.createPool({
  host: "127.0.0.1",
  user: "root",
  password: "",
  database: "clinicare",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
  // Nếu MySQL máy bạn chạy cổng khác, thêm:
  // port: 3307
});

db.getConnection((err, connection) => {
  if (err) {
    console.error("Kết nối MySQL thất bại:", err);
    return;
  }
  console.log("Kết nối MySQL thành công!");
  connection.release();
});

app.get("/api/patient/test", (req, res) => {
  res.json({
    success: true,
    message: "Backend dang nhap benh nhan dang chay"
  });
});

app.post("/api/patient/login", (req, res) => {
  try {
    console.log("Nhận dữ liệu đăng nhập bệnh nhân:", req.body);

    const { email, password, rememberMe } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: "Vui lòng nhập đầy đủ email và mật khẩu."
      });
    }

    const sql = "SELECT * FROM patients WHERE email = ?";

    db.query(sql, [email], async (err, results) => {
      if (err) {
        console.error("Lỗi DB login BN:", err);
        return res.status(500).json({
          success: false,
          message: "Lỗi DB: " + err.message
        });
      }

      if (results.length === 0) {
        return res.status(401).json({
          success: false,
          message: "Email không tồn tại."
        });
      }

      const user = results[0];
      const isMatch = await bcrypt.compare(password, user.password);

      if (!isMatch) {
        return res.status(401).json({
          success: false,
          message: "Mật khẩu không đúng."
        });
      }

      return res.status(200).json({
        success: true,
        message: "Đăng nhập thành công!",
        patient: {
          id: user.id,
          email: user.email,
          fullName: user.full_name
        },
        rememberMe: !!rememberMe
      });
    });
  } catch (error) {
    console.error("Lỗi server:", error);
    return res.status(500).json({
      success: false,
      message: "Lỗi server."
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server chạy tại http://localhost:${PORT}`);
});