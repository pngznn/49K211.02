async function registerUser() {
  console.log("Da bam nut Dang ky");

  const fullName = document.getElementById("fullName").value.trim();
  const email = document.getElementById("email").value.trim();
  const phone = document.getElementById("phone").value.trim();
  const gender = document.getElementById("gender").value;
  const password = document.getElementById("password").value;
  const confirmPassword = document.getElementById("confirmPassword").value;

  console.log("Du lieu nhap:", {
    fullName,
    email,
    phone,
    gender,
    passwordLength: password.length,
    confirmPasswordLength: confirmPassword.length
  });

  if (!fullName || !email || !phone || !gender || !password || !confirmPassword) {
    alert("Vui lòng nhập đầy đủ thông tin.");
    return;
  }

  if (phone.length < 10) {
    alert("Số điện thoại không hợp lệ.");
    return;
  }

  if (password.length < 6) {
    alert("Mật khẩu phải có ít nhất 6 ký tự.");
    return;
  }

  if (password !== confirmPassword) {
    alert("Mật khẩu xác nhận không khớp.");
    return;
  }

  try {
    console.log("Sap gui request len backend...");

    const response = await fetch("http://localhost:3000/api/patient/register", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": "no-cache"
      },
      body: JSON.stringify({
        fullName,
        email,
        phone,
        gender,
        password,
        confirmPassword
      })
    });

    console.log("Status response:", response.status);

    const data = await response.json();
    console.log("Response backend:", data);

    if (data.success) {
      alert(data.message);

      document.getElementById("fullName").value = "";
      document.getElementById("email").value = "";
      document.getElementById("phone").value = "";
      document.getElementById("gender").value = "";
      document.getElementById("password").value = "";
      document.getElementById("confirmPassword").value = "";
    } else {
      alert(data.message || "Có lỗi xảy ra.");
    }
  } catch (error) {
    console.error("Lỗi fetch:", error);
    alert("Không thể kết nối tới server.");
  }
}