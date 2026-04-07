document.addEventListener('DOMContentLoaded', () => {
    const deptGrid = document.querySelector('.dept-grid');
    const modal = document.getElementById('doctorModal');
    const drGrid = document.getElementById('doctorGrid');
    const modalDeptName = document.getElementById('modalDeptName');
    const profileModal = document.getElementById('doctorProfileModal');

    // ===== DỮ LIỆU 19 KHOA - GIỮ NGUYÊN HOÀN TOÀN =====
    const departments = [
        { 
            id: 1, name: "Khoa Nội", location: "Tầng 2 - Toà A", 
            doctorsList: [
                { id: "NOI01", name: "BS. Nguyễn Phan Anh", rank: "Trưởng khoa", gender: "Nam", exp: "15 năm", spec: "Nội tổng quát", phone: "0901234501", email: "anh.np@clinicare.vn", dob: "12/03/1985", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Chuyên gia nội khoa." },
                { id: "NOI02", name: "BS. Trịnh Thu Thủy", rank: "Bác sĩ", gender: "Nữ", exp: "12 năm", spec: "Nội tiết", phone: "0901234502", email: "thuy.tt@clinicare.vn", dob: "20/05/1988", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Điều trị tiểu đường." },
                { id: "NOI03", name: "BS. Lê Hữu Phước", rank: "Bác sĩ", gender: "Nam", exp: "10 năm", spec: "Nội tiêu hóa", phone: "0901234503", email: "phuoc.lh@clinicare.vn", dob: "15/11/1990", workDays: "Thứ 2, 6", workTime: "08:00 - 17:00", desc: "Tận tâm với bệnh nhân." },
                { id: "NOI04", name: "BS. Phạm Minh Tuyết", rank: "Bác sĩ", gender: "Nữ", exp: "7 năm", spec: "Nội khoa", phone: "0901234504", email: "tuyet.pm@clinicare.vn", dob: "08/09/1993", workDays: "Thứ 4, 7", workTime: "08:00 - 17:00", desc: "Khám nội tổng quát." },
                { id: "NOI05", name: "BS. Đỗ Hoàng Long", rank: "Bác sĩ", gender: "Nam", exp: "5 năm", spec: "Nội khoa", phone: "0901234505", email: "long.dh@clinicare.vn", dob: "22/01/1995", workDays: "Thứ 3, 5", workTime: "08:00 - 17:00", desc: "Bác sĩ trẻ triển vọng." },
                { id: "NOI06", name: "BS. Ngô Thanh Vân", rank: "Bác sĩ", gender: "Nữ", exp: "6 năm", spec: "Nội tiết", phone: "0901234506", email: "van.nt@clinicare.vn", dob: "30/10/1994", workDays: "Thứ 2, 4", workTime: "08:00 - 17:00", desc: "Chăm sóc bệnh nhân chu đáo." }
            ] 
        },
        { 
            id: 2, name: "Khoa Ngoại", location: "Tầng 3 - Toà B", 
            doctorsList: [
                { id: "NGO01", name: "BS. Trần Cao Minh", rank: "Trưởng khoa", gender: "Nam", exp: "22 năm", spec: "Ngoại lồng ngực", phone: "0912000001", email: "minh.tc@clinicare.vn", dob: "05/04/1978", workDays: "Thứ 2, 4, 6", workTime: "07:30 - 16:30", desc: "Bàn tay vàng phẫu thuật." },
                { id: "NGO02", name: "BS. Vũ Đức Đam", rank: "Phó khoa", gender: "Nam", exp: "18 năm", spec: "Ngoại tiêu hóa", phone: "0912000002", email: "dam.vd@clinicare.vn", dob: "10/08/1982", workDays: "Thứ 3, 5, 7", workTime: "07:30 - 16:30", desc: "Chuyên gia nội soi ngoại khoa." },
                { id: "NGO03", name: "BS. Lâm Khánh Chi", rank: "Bác sĩ", gender: "Nữ", exp: "11 năm", spec: "Ngoại tổng quát", phone: "0912000003", email: "chi.lk@clinicare.vn", dob: "22/11/1989", workDays: "Thứ 2, 5", workTime: "07:30 - 16:30", desc: "Tỉ mỉ trong từng ca mổ." },
                { id: "NGO04", name: "BS. Huỳnh Đông", rank: "Bác sĩ", gender: "Nam", exp: "9 năm", spec: "Ngoại chấn thương", phone: "0912000004", email: "dong.h@clinicare.vn", dob: "15/06/1991", workDays: "Thứ 4, 6", workTime: "07:30 - 16:30", desc: "Phẫu thuật xương khớp." },
                { id: "NGO05", name: "BS. Quách Ngọc Ngoan", rank: "Bác sĩ", gender: "Nam", exp: "8 năm", spec: "Ngoại khoa", phone: "0912000005", email: "ngoan.qn@clinicare.vn", dob: "10/01/1992", workDays: "Thứ 3, 7", workTime: "07:30 - 16:30", desc: "Bác sĩ ngoại khoa giỏi." }
            ] 
        },
        { 
            id: 3, name: "Khoa Nhi", location: "Tầng 3 - Toà B", 
            doctorsList: [
                { id: "NHI01", name: "BS. Lý Nhã Kỳ", rank: "Trưởng khoa", gender: "Nữ", exp: "14 năm", spec: "Nhi sơ sinh", phone: "0913000901", email: "ky.ln@clinicare.vn", dob: "20/07/1986", workDays: "Thứ 2 - Thứ 6", workTime: "08:00 - 17:00", desc: "Yêu trẻ như con." },
                { id: "NHI02", name: "BS. Phan Anh", rank: "Bác sĩ", gender: "Nam", exp: "12 năm", spec: "Nhi tổng quát", phone: "0913000902", email: "anh.p@clinicare.vn", dob: "15/05/1988", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Tư vấn tâm lý nhi khoa." },
                { id: "NHI03", name: "BS. Nguyễn Hồng Nhung", rank: "Bác sĩ", gender: "Nữ", exp: "9 năm", spec: "Hô hấp nhi", phone: "0913000903", email: "nhung.nh@clinicare.vn", dob: "10/10/1991", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Điều trị hen phế quản trẻ em." },
                { id: "NHI04", name: "BS. Dương Triệu Vũ", rank: "Bác sĩ", gender: "Nam", exp: "7 năm", spec: "Dinh dưỡng nhi", phone: "0913000904", email: "vu.dt@clinicare.vn", dob: "01/01/1993", workDays: "Thứ 3, 6", workTime: "08:00 - 17:00", desc: "Chuyên gia dinh dưỡng." },
                { id: "NHI05", name: "BS. Bảo Thy", rank: "Bác sĩ", gender: "Nữ", exp: "6 năm", spec: "Nhi khoa", phone: "0913000905", email: "thy.b@clinicare.vn", dob: "02/06/1994", workDays: "Thứ 4, 7", workTime: "08:00 - 17:00", desc: "Khám nhi tổng quát." }
            ] 
        },
        { 
            id: 4, name: "Khoa Tim Mạch", location: "Tầng 2 - Toà A", 
            doctorsList: [
                { id: "TIM01", name: "BS. Trần Tiến", rank: "Trưởng khoa", gender: "Nam", exp: "25 năm", spec: "Tim mạch", phone: "0914000801", email: "tien.t@clinicare.vn", dob: "15/08/1975", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Chuyên gia nhịp tim." },
                { id: "TIM02", name: "BS. Thanh Lam", rank: "Bác sĩ", gender: "Nữ", exp: "20 năm", spec: "Tim mạch nội", phone: "0914000802", email: "lam.t@clinicare.vn", dob: "10/06/1980", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Điều trị bệnh mạch vành." },
                { id: "TIM03", name: "BS. Tùng Dương", rank: "Bác sĩ", gender: "Nam", exp: "11 năm", spec: "Can thiệp tim", phone: "0914000803", email: "duong.t@clinicare.vn", dob: "18/09/1989", workDays: "Thứ 2, 5", workTime: "08:00 - 17:00", desc: "Bác sĩ can thiệp tim mạch." }
            ] 
        },
        { 
            id: 5, name: "Khoa Tiêu Hóa", location: "Tầng 2 - Toà B", 
            doctorsList: [
                { id: "THO01", name: "BS. Trấn Thành", rank: "Trưởng khoa", gender: "Nam", exp: "15 năm", spec: "Tiêu hóa", phone: "0915000701", email: "thanh.t@clinicare.vn", dob: "05/02/1985", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Chẩn đoán hình ảnh tiêu hóa." },
                { id: "THO02", name: "BS. Hari Won", rank: "Bác sĩ", gender: "Nữ", exp: "10 năm", spec: "Dạ dày - Tá tràng", phone: "0915000702", email: "won.h@clinicare.vn", dob: "22/06/1990", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Điều trị bệnh lý dạ dày." },
                { id: "THO03", name: "BS. Lê Giang", rank: "Bác sĩ", gender: "Nữ", exp: "18 năm", spec: "Gan mật", phone: "0915000703", email: "giang.l@clinicare.vn", dob: "10/10/1982", workDays: "Thứ 2, 6", workTime: "08:00 - 17:00", desc: "Chuyên gia gan mật." },
                { id: "THO04", name: "BS. Anh Đức", rank: "Bác sĩ", gender: "Nam", exp: "8 năm", spec: "Tiêu hóa", phone: "0915000704", email: "duc.a@clinicare.vn", dob: "15/01/1992", workDays: "Thứ 4, 7", workTime: "08:00 - 17:00", desc: "Khám tiêu hóa tổng quát." }
            ] 
        },
        { 
            id: 6, name: "Khoa Da Liễu", location: "Tầng 2 - Toà A", 
            doctorsList: [
                { id: "DAL01", name: "BS. Hồ Ngọc Hà", rank: "Trưởng khoa", gender: "Nữ", exp: "16 năm", spec: "Da liễu thẩm mỹ", phone: "0916000601", email: "ha.hn@clinicare.vn", dob: "25/11/1984", workDays: "Thứ 2, 4, 6", workTime: "08:30 - 17:30", desc: "Chuyên gia chăm sóc da." },
                { id: "DAL02", name: "BS. Kim Lý", rank: "Bác sĩ", gender: "Nam", exp: "12 năm", spec: "Bệnh lý da", phone: "0916000602", email: "ly.k@clinicare.vn", dob: "13/11/1988", workDays: "Thứ 3, 5, 7", workTime: "08:30 - 17:30", desc: "Điều trị vảy nến, viêm da." },
                { id: "DAL03", name: "BS. S.T Sơn Thạch", rank: "Bác sĩ", gender: "Nam", exp: "7 năm", spec: "Da liễu", phone: "0916000603", email: "thach.st@clinicare.vn", dob: "10/12/1993", workDays: "Thứ 2, 5", workTime: "08:30 - 17:30", desc: "Tư vấn điều trị mụn." }
            ] 
        },
        { 
            id: 7, name: "Khoa Hô Hấp", location: "Tầng 3 - Toà A", 
            doctorsList: [
                { id: "HOH01", name: "BS. Quang Lê", rank: "Trưởng khoa", gender: "Nam", exp: "20 năm", spec: "Hô hấp", phone: "0917000501", email: "le.q@clinicare.vn", dob: "24/01/1980", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Điều trị phổi tắc nghẽn." },
                { id: "HOH02", name: "BS. Như Quỳnh", rank: "Bác sĩ", gender: "Nữ", exp: "18 năm", spec: "Phế quản", phone: "0917000502", email: "quynh.n@clinicare.vn", dob: "09/09/1982", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Chuyên gia về hô hấp." },
                { id: "HOH03", name: "BS. Mạnh Quỳnh", rank: "Bác sĩ", gender: "Nam", exp: "15 năm", spec: "Hô hấp", phone: "0917000503", email: "quynh.m@clinicare.vn", dob: "10/01/1985", workDays: "Thứ 2, 6", workTime: "08:00 - 17:00", desc: "Khám và điều trị lao phổi." },
                { id: "HOH04", name: "BS. Phi Nhung", rank: "Bác sĩ", gender: "Nữ", exp: "14 năm", spec: "Hô hấp", phone: "0917000504", email: "nhung.p@clinicare.vn", dob: "10/04/1986", workDays: "Thứ 4, 7", workTime: "08:00 - 17:00", desc: "Khám hô hấp nhi/người lớn." }
            ] 
        },
        { 
            id: 8, name: "Khoa Tai Mũi Họng", location: "Tầng 1 - Toà B", 
            doctorsList: [
                { id: "TMH01", name: "BS. Xuân Bắc", rank: "Trưởng khoa", gender: "Nam", exp: "20 năm", spec: "Tai Mũi Họng", phone: "0918000401", email: "bac.x@clinicare.vn", dob: "21/08/1980", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Chuyên gia phẫu thuật xoang." },
                { id: "TMH02", name: "BS. Công Lý", rank: "Bác sĩ", gender: "Nam", exp: "22 năm", spec: "Họng - Thanh quản", phone: "0918000402", email: "ly.c@clinicare.vn", dob: "16/10/1978", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Điều trị các bệnh về thanh quản." },
                { id: "TMH03", name: "BS. Vân Dung", rank: "Bác sĩ", gender: "Nữ", exp: "15 năm", spec: "Tai Mũi Họng", phone: "0918000403", email: "dung.v@clinicare.vn", dob: "11/10/1985", workDays: "Thứ 2, 5", workTime: "08:00 - 17:00", desc: "Khám nội soi TMH." }
            ] 
        },
        { 
            id: 9, name: "Khoa Sản", location: "Tầng 2 - Toà C", 
            doctorsList: [
                { id: "SAN01", name: "BS. Mỹ Tâm", rank: "Trưởng khoa", gender: "Nữ", exp: "20 năm", spec: "Sản khoa", phone: "0919000301", email: "tam.m@clinicare.vn", dob: "16/01/1981", workDays: "Thứ 2 - Thứ 6", workTime: "08:00 - 17:00", desc: "Chuyên gia sản khoa hàng đầu." },
                { id: "SAN02", name: "BS. Đàm Vĩnh Hưng", rank: "Bác sĩ", gender: "Nam", exp: "18 năm", spec: "Sản - Phụ khoa", phone: "0919000302", email: "hung.dv@clinicare.vn", dob: "02/10/1982", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Bác sĩ sản giỏi." },
                { id: "SAN03", name: "BS. Thu Phương", rank: "Bác sĩ", gender: "Nữ", exp: "15 năm", spec: "Phụ khoa", phone: "0919000303", email: "phuong.t@clinicare.vn", dob: "09/10/1985", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Điều trị bệnh lý phụ khoa." },
                { id: "SAN04", name: "BS. Tuấn Hưng", rank: "Bác sĩ", gender: "Nam", exp: "12 năm", spec: "Sản khoa", phone: "0919000304", email: "hung.t@clinicare.vn", dob: "05/10/1988", workDays: "Thứ 4, 7", workTime: "08:00 - 17:00", desc: "Hỗ trợ sinh sản." },
                { id: "SAN05", name: "BS. Lệ Quyên", rank: "Bác sĩ", gender: "Nữ", exp: "11 năm", spec: "Sản khoa", phone: "0919000305", email: "quyen.l@clinicare.vn", dob: "02/04/1989", workDays: "Thứ 3, 6", workTime: "08:00 - 17:00", desc: "Chăm sóc tiền sản." }
            ] 
        },
        { 
            id: 10, name: "Khoa Răng Hàm Mặt", location: "Tầng 1 - Toà A", 
            doctorsList: [
                { id: "RHM01", name: "BS. Quyền Linh", rank: "Trưởng khoa", gender: "Nam", exp: "20 năm", spec: "Răng Hàm Mặt", phone: "0920000201", email: "linh.q@clinicare.vn", dob: "08/12/1980", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Chuyên gia cấy ghép Implant." },
                { id: "RHM02", name: "BS. Cát Tường", rank: "Bác sĩ", gender: "Nữ", exp: "15 năm", spec: "Chỉnh nha", phone: "0920000202", email: "tuong.c@clinicare.vn", dob: "12/12/1985", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Chuyên gia niềng răng." },
                { id: "RHM03", name: "BS. Trường Giang", rank: "Bác sĩ", gender: "Nam", exp: "10 năm", spec: "Răng trẻ em", phone: "0920000203", email: "giang.t@clinicare.vn", dob: "20/04/1990", workDays: "Thứ 2, 5", workTime: "08:00 - 17:00", desc: "Nhổ răng không đau." },
                { id: "RHM04", name: "BS. Nhã Phương", rank: "Bác sĩ", gender: "Nữ", exp: "8 năm", spec: "Nha khoa thẩm mỹ", phone: "0920000204", email: "phuong.n@clinicare.vn", dob: "20/05/1992", workDays: "Thứ 4, 7", workTime: "08:00 - 17:00", desc: "Tẩy trắng răng thẩm mỹ." }
            ] 
        },
        { 
            id: 11, name: "Khoa Thần Kinh", location: "Tầng 4 - Toà B", 
            doctorsList: [
                { id: "TKI01", name: "BS. Hoài Linh", rank: "Trưởng khoa", gender: "Nam", exp: "25 năm", spec: "Thần kinh", phone: "0921000101", email: "linh.h@clinicare.vn", dob: "18/12/1975", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Chẩn đoán thần kinh học." },
                { id: "TKI02", name: "BS. Việt Hương", rank: "Bác sĩ", gender: "Nữ", exp: "18 năm", spec: "Thần kinh nội tiết", phone: "0921000102", email: "huong.v@clinicare.vn", dob: "15/10/1982", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Điều trị đau đầu, mất ngủ." },
                { id: "TKI03", name: "BS. Chí Tài", rank: "Bác sĩ", gender: "Nam", exp: "20 năm", spec: "Thần kinh", phone: "0921000103", email: "tai.c@clinicare.vn", dob: "15/08/1980", workDays: "Thứ 4, 7", workTime: "08:00 - 17:00", desc: "Bác sĩ tâm lý thần kinh." }
            ] 
        },
        { 
            id: 12, name: "Khoa Tiết Niệu", location: "Tầng 3 - Toà C", 
            doctorsList: [
                { id: "TNI01", name: "BS. Xuân Hinh", rank: "Trưởng khoa", gender: "Nam", exp: "22 năm", spec: "Tiết niệu", phone: "0922000001", email: "hinh.x@clinicare.vn", dob: "10/10/1978", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Chuyên gia sỏi thận." },
                { id: "TNI02", name: "BS. Thanh Thanh Hiền", rank: "Bác sĩ", gender: "Nữ", exp: "15 năm", spec: "Tiết niệu", phone: "0922000002", email: "hien.tt@clinicare.vn", dob: "15/10/1985", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Khám tiết niệu nữ." },
                { id: "TNI03", name: "BS. Tự Long", rank: "Bác sĩ", gender: "Nam", exp: "14 năm", spec: "Nam học", phone: "0922000003", email: "long.t@clinicare.vn", dob: "02/02/1986", workDays: "Thứ 2, 5", workTime: "08:00 - 17:00", desc: "Điều trị bàng quang." }
            ] 
        },
        { 
            id: 13, name: "Khoa Nam Khoa", location: "Tầng 5 - Toà B", 
            doctorsList: [
                { id: "NAM01", name: "BS. Đan Trường", rank: "Trưởng khoa", gender: "Nam", exp: "18 năm", spec: "Nam học", phone: "0923000901", email: "truong.d@clinicare.vn", dob: "29/11/1982", workDays: "Thứ 3, 6", workTime: "08:00 - 17:00", desc: "Chăm sóc sức khỏe nam giới." },
                { id: "NAM02", name: "BS. Lam Trường", rank: "Bác sĩ", gender: "Nam", exp: "18 năm", spec: "Nam học", phone: "0923000902", email: "truong.l@clinicare.vn", dob: "14/10/1982", workDays: "Thứ 2, 4, 7", workTime: "08:00 - 17:00", desc: "Tư vấn sức khỏe sinh sản." },
                { id: "NAM03", name: "BS. Quang Vinh", rank: "Bác sĩ", gender: "Nam", exp: "12 năm", spec: "Nam khoa", phone: "0923000903", email: "vinh.q@clinicare.vn", dob: "18/05/1988", workDays: "Thứ 3, 5", workTime: "08:00 - 17:00", desc: "Hoàng tử nam khoa." }
            ] 
        },
        { 
            id: 14, name: "Khoa Ung Bướu", location: "Tầng 6 - Toà A", 
            doctorsList: [
                { id: "UNB01", name: "BS. Ánh Tuyết", rank: "Trưởng khoa", gender: "Nữ", exp: "25 năm", spec: "Ung bướu", phone: "0924000801", email: "tuyet.a@clinicare.vn", dob: "10/01/1975", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Chuyên gia hóa trị." },
                { id: "UNB02", name: "BS. Trọng Tấn", rank: "Bác sĩ", gender: "Nam", exp: "15 năm", spec: "Ung bướu", phone: "0924000802", email: "tan.t@clinicare.vn", dob: "15/12/1985", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Xạ trị ung thư." },
                { id: "UNB03", name: "BS. Anh Thơ", rank: "Bác sĩ", gender: "Nữ", exp: "12 năm", spec: "Ung bướu", phone: "0924000803", email: "tho.a@clinicare.vn", dob: "10/10/1988", workDays: "Thứ 2, 5", workTime: "08:00 - 17:00", desc: "Tầm soát ung thư cổ tử cung." },
                { id: "UNB04", name: "BS. Đăng Dương", rank: "Bác sĩ", gender: "Nam", exp: "14 năm", spec: "Ung bướu", phone: "0924000804", email: "duong.d@clinicare.vn", dob: "15/06/1986", workDays: "Thứ 4, 7", workTime: "08:00 - 17:00", desc: "Điều trị khối u lành tính." }
            ] 
        },
        { 
            id: 15, name: "Khoa Chấn Thương", location: "Tầng 2 - Toà B", 
            doctorsList: [
                { id: "CHT01", name: "BS. Phan Văn Đức", rank: "Trưởng khoa", gender: "Nam", exp: "10 năm", spec: "Chỉnh hình", phone: "0925000701", email: "duc.pv@clinicare.vn", dob: "11/04/1990", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Chấn thương chỉnh hình." },
                { id: "CHT02", name: "BS. Đỗ Hùng Dũng", rank: "Bác sĩ", gender: "Nam", exp: "8 năm", spec: "Chấn thương", phone: "0925000702", email: "dung.dh@clinicare.vn", dob: "08/09/1992", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Phẫu thuật cơ xương khớp." },
                { id: "CHT03", name: "BS. Phạm Tuấn Hải", rank: "Bác sĩ", gender: "Nam", exp: "6 năm", spec: "Chấn thương", phone: "0925000703", email: "hai.pt@clinicare.vn", dob: "19/05/1994", workDays: "Thứ 3, 6", workTime: "08:00 - 17:00", desc: "Y học thể thao." }
            ] 
        },
        { 
            id: 16, name: "Khoa Cấp Cứu", location: "Tầng 1 - Sảnh G", 
            doctorsList: [
                { id: "CCU01", name: "BS. Nguyễn Văn Toàn", rank: "Trưởng khoa", gender: "Nam", exp: "12 năm", spec: "Cấp cứu", phone: "0926000601", email: "toan.nv@clinicare.vn", dob: "12/04/1988", workDays: "Hàng ngày", workTime: "24/24", desc: "Xử lý tình huống khẩn cấp." },
                { id: "CCU02", name: "BS. Vũ Văn Thanh", rank: "Bác sĩ", gender: "Nam", exp: "10 năm", spec: "Hồi sức", phone: "0926000602", email: "thanh.vv@clinicare.vn", dob: "14/04/1990", workDays: "Hàng ngày", workTime: "24/24", desc: "Cấp cứu đa khoa." }
            ] 
        },
        { 
            id: 17, name: "Khoa Chẩn Đoán", location: "Tầng Hầm - Toà A", 
            doctorsList: [
                { id: "CDO01", name: "BS. Phan Thanh Bình", rank: "Trưởng khoa", gender: "Nam", exp: "15 năm", spec: "CĐHA", phone: "0927000501", email: "binh.pt@clinicare.vn", dob: "10/10/1985", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Đọc kết quả hình ảnh chính xác." },
                { id: "CDO02", name: "BS. Lê Huỳnh Đức", rank: "Bác sĩ", gender: "Nam", exp: "25 năm", spec: "X-Quang", phone: "0927000502", email: "duc.lh@clinicare.vn", dob: "20/04/1975", workDays: "Thứ 3, 5, 7", workTime: "08:00 - 17:00", desc: "Chuyên gia chẩn đoán hình ảnh." }
            ] 
        },
        { 
            id: 18, name: "Khoa Dinh Dưỡng", location: "Tầng 1 - Toà D", 
            doctorsList: [
                { id: "DDU01", name: "BS. Tăng Thanh Hà", rank: "Trưởng khoa", gender: "Nữ", exp: "15 năm", spec: "Dinh dưỡng", phone: "0928000401", email: "ha.tt@clinicare.vn", dob: "24/10/1985", workDays: "Thứ 2, 4, 6", workTime: "08:00 - 17:00", desc: "Xây dựng thực đơn y khoa." }
            ] 
        },
        { 
            id: 19, name: "Khoa Vật Lý Trị Liệu", location: "Tầng 2 - Toà D", 
            doctorsList: [
                { id: "VLT01", name: "BS. Quế Ngọc Hải", rank: "Trưởng khoa", gender: "Nam", exp: "13 năm", spec: "Phục hồi chức năng", phone: "0929000301", email: "hai.qn@clinicare.vn", dob: "15/05/1987", workDays: "Thứ 2, 4, 7", workTime: "08:00 - 17:00", desc: "Chuyên gia vật lý trị liệu." }
            ] 
        }
    ];

    // ===== HÀM HIỂN THỊ - GIỮ NGUYÊN =====
    function renderDepartments(data) {
        if(!deptGrid) return;
        deptGrid.innerHTML = ''; 
        data.forEach(dept => {
            const card = document.createElement('div');
            card.className = 'dept-card';
            card.innerHTML = `
                <div class="dept-name">${dept.name.toUpperCase()}</div>
                <div class="dept-info">Vị trí: ${dept.location}</div>
                <div class="dept-info">Đội ngũ: ${dept.doctorsList.length} Bác sĩ</div>
            `;
            card.addEventListener('click', () => openDoctorModal(dept));
            deptGrid.appendChild(card);
        });
    }

    function openDoctorModal(dept) {
        modalDeptName.innerText = dept.name;
        drGrid.innerHTML = dept.doctorsList.map((dr, index) => `
            <div class="patient-dr-card">
                <div class="dr-avatar-circle"><i class="fa-solid fa-user-doctor"></i></div>
                <div class="dr-name-text">${dr.name}</div>
                <div class="dr-position-text">${dr.rank}</div>
                <button class="btn-book" onclick="showDrDetail(${dept.id}, ${index})">Xem chi tiết</button>
            </div>
        `).join('');
        modal.style.display = 'flex';
    }

    window.showDrDetail = function(deptId, drIndex) {
        const dept = departments.find(d => d.id === deptId);
        const dr = dept.doctorsList[drIndex];

        document.getElementById('p-name').innerText = dr.name;
        document.getElementById('p-rank').innerText = dr.rank;
        document.getElementById('p-dob').innerText = dr.dob;
        document.getElementById('p-gender').innerText = dr.gender;
        document.getElementById('p-exp').innerText = dr.exp;
        document.getElementById('p-spec').innerText = dr.spec; 
        document.getElementById('p-desc').innerText = dr.desc; 

        document.getElementById('p-schedule').innerHTML = `
            <div style="background: #f1f5f9; padding: 12px; border-radius: 10px; border-left: 5px solid #3152B8; color: #334155;">
                <i class="fa-regular fa-clock" style="margin-right: 8px; color: #3152B8;"></i>
                <strong>${dr.workDays}</strong> | ${dr.workTime}
            </div>
        `;
        profileModal.style.display = 'flex';
    };

    // ===== ĐÓNG MODAL & TÌM KIẾM - ĐÃ CHỈNH SỬA LẠI LOGIC TÁCH BIỆT =====
    
    // Nút đóng của Modal Danh sách khoa (Ảnh 2)
    const closeMainModal = document.querySelector('.close-modal');
    if(closeMainModal) {
        closeMainModal.onclick = () => {
            modal.style.display = 'none';
        };
    }

    // Nút đóng của Modal Chi tiết bác sĩ (Ảnh 1)
    const closeProfileModal = document.querySelector('.close-profile');
    if(closeProfileModal) {
        closeProfileModal.onclick = () => {
            profileModal.style.display = 'none'; // CHỈ ẩn phần chi tiết, giữ nguyên nền danh sách khoa
        };
    }

    // Xử lý khi click vào vùng trống bên ngoài
    window.onclick = (event) => {
        // Nếu click ra ngoài vùng chi tiết -> chỉ đóng chi tiết
        if (event.target == profileModal) {
            profileModal.style.display = 'none';
        } 
        // Nếu click ra ngoài vùng danh sách khoa -> đóng danh sách khoa
        else if (event.target == modal) {
            modal.style.display = 'none';
        }
    };

    const searchInput = document.getElementById('searchInput');
    if(searchInput) {
        searchInput.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase();
            const filtered = departments.filter(d => 
                d.name.toLowerCase().includes(term) || 
                d.doctorsList.some(dr => dr.name.toLowerCase().includes(term))
            );
            renderDepartments(filtered);
        });
    }

    renderDepartments(departments);
});