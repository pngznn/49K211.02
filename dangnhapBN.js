document.addEventListener("DOMContentLoaded", function () {
  const emailInput = document.getElementById("email");
  const passwordInput = document.getElementById("password");
  const rememberMeInput = document.getElementById("rememberMe");
  const loginButton = document.getElementById("loginBtn");

  async function loginUser() {
    const email = emailInput.value.trim();
    const password = passwordInput.value;
    const rememberMe = rememberMeInput.checked;

    console.log("Da bam nut Dang nhap BN");

    if (!email || !password) {
      alert("Vui lòng nhập đầy đủ email và mật khẩu.");
      return;
    }

    if (!email.includes("@") || !email.includes(".")) {
      alert("Email không hợp lệ.");
      return;
    }

    if (password.length < 6) {
      alert("Mật khẩu phải có ít nhất 6 ký tự.");
      return;
    }

    try {
      const response = await fetch("http://localhost:3000/api/patient/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          email,
          password,
          rememberMe
        })
      });

      const data = await response.json();
      console.log("Response backend BN:", data);

      if (data.success) {
        if (rememberMe) {
          localStorage.setItem("patientInfo", JSON.stringify(data.patient));
        } else {
          sessionStorage.setItem("patientInfo", JSON.stringify(data.patient));
        }

        alert(data.message);

        // Bật dòng dưới nếu muốn giống admin: đăng nhập xong chuyển trang
        // window.location.href = "dashboardBN.html";
      } else {
        alert(data.message || "Có lỗi xảy ra.");
      }
    } catch (error) {
      console.error("Lỗi fetch:", error);
      alert("Không thể kết nối tới server.");
    }
  }

  loginButton.addEventListener("click", loginUser);

  passwordInput.addEventListener("keypress", function (event) {
    if (event.key === "Enter") loginUser();
  });

  emailInput.addEventListener("keypress", function (event) {
    if (event.key === "Enter") loginUser();
  });
});