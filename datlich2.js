const doctors = {
  'cardiology': [
    { id: '1', name: 'BS. Nguyễn Văn A' },
    { id: '2', name: 'BS. Trần Thị B' }
  ],
  'pediatrics': [
    { id: '3', name: 'BS. Lê Văn C' }
  ],
  'internal-medicine': [
    { id: '4', name: 'BS. Phạm Thị D' }
  ],
  'surgery': [
    { id: '5', name: 'BS. Hoàng Văn E' }
  ],
  'dermatology': [
    { id: '6', name: 'BS. Võ Thị F' }
  ]
};

const departments = {
  'internal-medicine': 'Khoa nội',
  'surgery': 'Khoa ngoại',
  'pediatrics': 'Khoa nhi',
  'cardiology': 'Khoa tim mạch',
  'gastroenterology': 'Khoa tiêu hóa',
  'dermatology': 'Khoa da liễu',
  'respiratory': 'Khoa hô hấp',
  'ent': 'Khoa tai mũi họng',
  'obstetrics': 'Khoa sản',
  'dentistry': 'Khoa răng hàm mặt',
  'neurology': 'Khoa thần kinh',
  'urology': 'Khoa tiết niệu',
  'andrology': 'Khoa nam khoa',
  'oncology': 'Khoa ung bướu',
  'orthopedics': 'Khoa chấn thương chỉnh hình',
  'emergency': 'Khoa hồi sức cấp cứu',
  'imaging': 'Khoa chẩn đoán hình ảnh',
  'nutrition': 'Khoa dinh dưỡng',
  'physical-therapy': 'Khoa vật lý trị liệu'
};

const departmentRooms = {
  'internal-medicine':  '101',
  'surgery':            '201',
  'pediatrics':         '102',
  'cardiology':         '202',
  'gastroenterology':   '103',
  'dermatology':        '203',
  'respiratory':        '104',
  'ent':                '105',
  'obstetrics':         '204',
  'dentistry':          '205',
  'neurology':          '301',
  'urology':            '302',
  'andrology':          '303',
  'oncology':           '304',
  'orthopedics':        '305',
  'emergency':          '001',
  'imaging':            '106',
  'nutrition':          '107',
  'physical-therapy':   '108'
};

let formData = null;

// Handle department change to update doctor list
document.getElementById('department').addEventListener('change', function(e) {
  const department = e.target.value;
  const doctorSelect = document.getElementById('doctor');

  doctorSelect.innerHTML = '<option value="">Chọn bác sĩ</option>';

  if (department && doctors[department]) {
    doctorSelect.disabled = false;
    doctors[department].forEach(doctor => {
      const option = document.createElement('option');
      option.value = doctor.id;
      option.textContent = doctor.name;
      doctorSelect.appendChild(option);
    });
  } else {
    doctorSelect.disabled = true;
  }
});

// Handle time slot selection
document.querySelectorAll('.time-slot').forEach(button => {
  button.addEventListener('click', function() {
    document.querySelectorAll('.time-slot').forEach(btn => btn.classList.remove('selected'));
    this.classList.add('selected');
    document.getElementById('appointmentTime').value = this.dataset.time;
    // Xóa thông báo lỗi giờ khám khi đã chọn
    var errEl = document.getElementById('apptTimeError');
    if (errEl) errEl.style.display = 'none';
  });
});

// Handle form submission
document.getElementById('appointmentForm').addEventListener('submit', function(e) {
  e.preventDefault();

  const form = e.target;
  const data = new FormData(form);

  // ── Validate ngày sinh ──────────────────────────────────────────────────────
  const dobValue = data.get('dateOfBirth');
  const dobErr   = validateDOB(dobValue);
  const dobInput = document.getElementById('dateOfBirth');
  let   dobErrEl = document.getElementById('dobError');

  // Tạo element hiển thị lỗi nếu chưa có
  if (!dobErrEl) {
    dobErrEl = document.createElement('div');
    dobErrEl.id = 'dobError';
    dobErrEl.style.cssText = 'color:#EF4444;font-size:12px;margin-top:4px;display:none;';
    dobInput.parentNode.insertBefore(dobErrEl, dobInput.nextSibling);
  }

  if (dobErr) {
    dobInput.style.borderColor = '#EF4444';
    dobErrEl.textContent = '⚠ ' + dobErr;
    dobErrEl.style.display = 'block';
    dobInput.focus();
    return; // Dừng submit
  } else {
    dobInput.style.borderColor = '';
    dobErrEl.style.display = 'none';
  }
  // ────────────────────────────────────────────────────────────────────────────

  // ── Validate ngày khám ──────────────────────────────────────────────────────
  const apptDateValue  = data.get('appointmentDate');
  const apptDateDisplay = document.getElementById('apptDateDisplay');
  let apptDateErrEl = document.getElementById('apptDateError');
  if (!apptDateErrEl) {
    apptDateErrEl = document.createElement('div');
    apptDateErrEl.id = 'apptDateError';
    apptDateErrEl.style.cssText = 'color:#EF4444;font-size:12px;margin-top:4px;display:none;';
    // Chèn sau hidden input, bên trong cột form-field của ngày khám
    const apptDateHidden = document.getElementById('appointmentDate');
    apptDateHidden.parentNode.insertBefore(apptDateErrEl, apptDateHidden.nextSibling);
  }
  if (!apptDateValue) {
    apptDateDisplay.style.borderColor = '#EF4444';
    apptDateErrEl.textContent = '⚠ Vui lòng chọn ngày khám';
    apptDateErrEl.style.display = 'block';
    apptDateDisplay.scrollIntoView({ behavior: 'smooth', block: 'center' });
    return;
  } else {
    apptDateDisplay.style.borderColor = '';
    apptDateErrEl.style.display = 'none';
  }
  // ────────────────────────────────────────────────────────────────────────────

  // ── Validate giờ khám ───────────────────────────────────────────────────────
  const apptTimeValue   = data.get('appointmentTime');
  const timeSlotSection = document.getElementById('timeSlotSection');
  let apptTimeErrEl = document.getElementById('apptTimeError');
  if (!apptTimeErrEl) {
    apptTimeErrEl = document.createElement('div');
    apptTimeErrEl.id = 'apptTimeError';
    apptTimeErrEl.style.cssText = 'color:#EF4444;font-size:12px;margin-top:4px;display:none;';
    timeSlotSection.appendChild(apptTimeErrEl);
  }
  if (!apptTimeValue) {
    // Nếu chưa xác nhận ngày (time slot section bị ẩn), nhắc xác nhận ngày trước
    if (timeSlotSection.style.display === 'none') {
      apptDateDisplay.style.borderColor = '#EF4444';
      apptDateErrEl.textContent = '⚠ Vui lòng xác nhận ngày khám để chọn giờ';
      apptDateErrEl.style.display = 'block';
      apptDateDisplay.scrollIntoView({ behavior: 'smooth', block: 'center' });
    } else {
      apptTimeErrEl.textContent = '⚠ Vui lòng chọn giờ khám';
      apptTimeErrEl.style.display = 'block';
      timeSlotSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    return;
  } else {
    apptTimeErrEl.style.display = 'none';
  }
  // ────────────────────────────────────────────────────────────────────────────

  formData = {
    fullName: data.get('fullName'),
    phoneNumber: data.get('phoneNumber'),
    gender: data.get('gender'),
    dateOfBirth: data.get('dateOfBirth'),
    department: data.get('department'),
    doctor: data.get('doctor'),
    appointmentDate: data.get('appointmentDate'),
    appointmentTime: data.get('appointmentTime'),
    reasonForVisit: data.get('reasonForVisit')
  };

  showModal();
});

function showModal() {
  const departmentLabel = departments[formData.department];
  const doctorName = formData.doctor ? getDoctorName(formData.doctor) : null;
  const roomNumber = departmentRooms[formData.department] || '—';

  const formatDate = (dateStr) => {
    if (!dateStr) return '';
    // If already dd/mm/yyyy, return as-is
    if (/^\d{2}\/\d{2}\/\d{4}$/.test(dateStr)) return dateStr;
    // Otherwise parse ISO yyyy-mm-dd
    const [y, m, d] = dateStr.split('-');
    return `${d}/${m}/${y}`;
  };

  const summaryHtml = `
    <div class="summary-row">
      <span class="summary-label">Họ và tên:</span>
      <span class="summary-value">${formData.fullName}</span>
    </div>
    <div class="summary-row">
      <span class="summary-label">Số điện thoại:</span>
      <span class="summary-value">${formData.phoneNumber}</span>
    </div>
    <div class="summary-divider"></div>
    <div class="summary-row">
      <span class="summary-label">Khoa khám:</span>
      <span class="summary-value">${departmentLabel}</span>
    </div>
    <div class="summary-row">
      <span class="summary-label">Phòng khám:</span>
      <span class="summary-value">Phòng ${roomNumber}</span>
    </div>
    <div class="summary-row">
      <span class="summary-label">Bác sĩ:</span>
      <span class="summary-value">${doctorName || 'Không chọn'}</span>
    </div>
    <div class="summary-divider"></div>
    <div class="summary-row">
      <span class="summary-label">Ngày khám:</span>
      <span class="summary-value summary-highlight">${formatDate(formData.appointmentDate)}</span>
    </div>
    <div class="summary-row">
      <span class="summary-label">Giờ khám:</span>
      <span class="summary-value summary-highlight">${formData.appointmentTime}</span>
    </div>
    <div class="summary-divider"></div>
    <div class="summary-full">
      <span class="summary-label">Ghi chú:</span>
      <span class="summary-value">${formData.reasonForVisit}</span>
    </div>
  `;

  document.getElementById('modalSummary').innerHTML = summaryHtml;
  document.getElementById('modalOverlay').classList.add('show');
  document.getElementById('modalContainer').classList.add('show');
}

function closeModal() {
  document.getElementById('modalOverlay').classList.remove('show');
  document.getElementById('modalContainer').classList.remove('show');
}

function confirmAppointment() {
  closeModal();

  const apptId = 'LH' + Math.floor(100000 + Math.random() * 900000);
  const bookedDate = new Date().toLocaleDateString('vi-VN');

  const formatDate = (dateStr) => {
    if (!dateStr) return '';
    if (/^\d{2}\/\d{2}\/\d{4}$/.test(dateStr)) return dateStr;
    const [y, m, d] = dateStr.split('-');
    return `${d}/${m}/${y}`;
  };

  const departmentLabel = departments[formData.department] || formData.department;
  const doctorName = formData.doctor ? getDoctorName(formData.doctor) : 'Chưa chỉ định';

  // Icon helpers
  const svgIcon = (path) =>
    `<svg viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="${path}"/></svg>`;

  const iconDoc   = svgIcon('M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z');
  const iconUser  = svgIcon('M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z');
  const iconCal   = svgIcon('M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z');
  const iconClock = svgIcon('M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z');
  const iconHosp  = svgIcon('M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4');
  const iconRoom  = svgIcon('M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6');

  const roomNumber = departmentRooms[formData.department] || '—';
  const iconPhone = svgIcon('M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z');
  const iconPerson= svgIcon('M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z');

  // Build a detail-item cell
  const detailItem = (icon, label, value) => `
    <div class="detail-item">
      ${icon}
      <div class="detail-item-content">
        <div class="detail-item-label">${label}</div>
        <div class="detail-item-value">${value}</div>
      </div>
    </div>`;

  document.getElementById('detailContent').innerHTML = `
    <div class="detail-header">
      <div>
        <h2>Thông tin lịch khám
          <span class="room-badge">
            <svg viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
            Phòng ${roomNumber}
          </span>
        </h2>
        <span class="status-badge">Đã xác nhận</span>
      </div>
    </div>

    <div class="detail-grid">
      ${detailItem(iconDoc,    'Mã lịch hẹn',    apptId)}
      ${detailItem(iconUser,   'Bác sĩ',          doctorName)}
      ${detailItem(iconCal,    'Ngày hẹn khám',   formatDate(formData.appointmentDate))}
      ${detailItem(iconHosp,   'Khoa',            departmentLabel)}
      ${detailItem(iconClock,  'Khung giờ khám',  formData.appointmentTime)}
      ${detailItem(iconPhone,  'Số điện thoại',   formData.phoneNumber)}
      ${detailItem(iconCal,    'Ngày đặt lịch',   bookedDate)}
      ${detailItem(iconPerson, 'Ngày sinh',       formatDate(formData.dateOfBirth))}
    </div>

    <div class="detail-note">
      ${iconDoc}
      <div class="detail-note-content">
        <div class="detail-note-label">Ghi chú</div>
        <div class="detail-note-value">${formData.reasonForVisit}</div>
      </div>
    </div>

    <div class="detail-actions">
      <button class="btn btn-primary" onclick="editAppointment()">Chỉnh sửa</button>
      <button class="btn btn-danger" onclick="cancelAppointment()">Hủy lịch</button>
    </div>
  `;

  // Switch views
  document.getElementById('formView').classList.add('hide');
  document.getElementById('detailView').classList.add('show');

  showToast('Đặt lịch hẹn thành công!');
}

function backToForm() {
  document.getElementById('detailView').classList.remove('show');
  document.getElementById('formView').classList.remove('hide');
}

function editAppointment() {
  backToForm();
  showToast('Bạn có thể chỉnh sửa thông tin lịch hẹn');
}

function cancelAppointment() {
  if (confirm('Bạn có chắc chắn muốn hủy lịch hẹn này?')) {
    backToForm();
    resetForm();
    showToast('Đã hủy lịch hẹn thành công');
  }
}

function showToast(message) {
  document.getElementById('toastMessage').textContent = message;
  document.getElementById('toastContainer').classList.add('show');

  setTimeout(closeToast, 5000);
}

function closeToast() {
  document.getElementById('toastContainer').classList.remove('show');
}

function resetForm() {
  document.getElementById('appointmentForm').reset();
  document.querySelectorAll('.time-slot').forEach(btn => btn.classList.remove('selected'));
  document.getElementById('doctor').disabled = true;
  formData = null;
  // Xóa các thông báo lỗi ngày/giờ
  var apptDateDisp = document.getElementById('apptDateDisplay');
  var apptDateErr  = document.getElementById('apptDateError');
  var apptTimeErr  = document.getElementById('apptTimeError');
  if (apptDateDisp) apptDateDisp.style.borderColor = '';
  if (apptDateErr)  apptDateErr.style.display = 'none';
  if (apptTimeErr)  apptTimeErr.style.display = 'none';
}

function getDoctorName(doctorId) {
  for (const dept in doctors) {
    const doctor = doctors[dept].find(d => d.id === doctorId);
    if (doctor) return doctor.name;
  }
  return null;
}


// ── Custom Calendar for appointmentDate ──────────────────────────────────────
(function () {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  let calYear  = today.getFullYear();
  let calMonth = today.getMonth();
  let selectedDate = null;

  const MONTHS_VI = ['Tháng 1','Tháng 2','Tháng 3','Tháng 4','Tháng 5','Tháng 6',
                     'Tháng 7','Tháng 8','Tháng 9','Tháng 10','Tháng 11','Tháng 12'];
  const DAYS_VI   = ['CN','T2','T3','T4','T5','T6','T7'];

  function pad(n) { return String(n).padStart(2,'0'); }
  function formatDDMMYYYY(d) { return `${pad(d.getDate())}/${pad(d.getMonth()+1)}/${d.getFullYear()}`; }
  function toISODate(d) { return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`; }

  function renderCalendar() {
    const cal = document.getElementById('apptCalendar');
    if (!cal) return;
    const firstDay    = new Date(calYear, calMonth, 1).getDay();
    const daysInMonth = new Date(calYear, calMonth + 1, 0).getDate();

    let html = `
      <div class="cal-header">
        <button type="button" id="calPrev">&#8249;</button>
        <span class="cal-month-year">${MONTHS_VI[calMonth]} ${calYear}</span>
        <button type="button" id="calNext">&#8250;</button>
      </div>
      <div class="cal-weekdays">${DAYS_VI.map(d=>`<span>${d}</span>`).join('')}</div>
      <div class="cal-days">`;

    for (let i = 0; i < firstDay; i++) {
      html += `<button type="button" class="cal-day empty" disabled></button>`;
    }
    for (let d = 1; d <= daysInMonth; d++) {
      const date = new Date(calYear, calMonth, d);
      date.setHours(0,0,0,0);
      const isPast     = date < today;
      const isWeekend  = date.getDay() === 0 || date.getDay() === 6;
      const isDisabled = isPast || isWeekend;
      const isToday    = date.getTime() === today.getTime();
      const isSelected = selectedDate && date.getTime() === selectedDate.getTime();
      let cls = 'cal-day';
      if (isDisabled)  cls += ' disabled';
      if (isWeekend)   cls += ' weekend';
      if (isToday)     cls += ' today';
      if (isSelected)  cls += ' selected';
      html += `<button type="button" class="${cls}" ${isDisabled?'disabled':''} data-ts="${date.getTime()}">${d}</button>`;
    }
    html += `</div>`;
    cal.innerHTML = html;

    // Bind nav buttons
    document.getElementById('calPrev').addEventListener('click', function(e){
      e.stopPropagation();
      calMonth--; if (calMonth < 0) { calMonth = 11; calYear--; }
      renderCalendar();
    });
    document.getElementById('calNext').addEventListener('click', function(e){
      e.stopPropagation();
      calMonth++; if (calMonth > 11) { calMonth = 0; calYear++; }
      renderCalendar();
    });

    // Bind day buttons
    cal.querySelectorAll('.cal-day:not(.empty):not(.disabled)').forEach(function(btn){
      btn.addEventListener('click', function(e){
        e.stopPropagation();
        selectedDate = new Date(parseInt(btn.dataset.ts));
        document.getElementById('appointmentDate').value = toISODate(selectedDate);
        const txt = document.getElementById('apptDateText');
        if (txt) { txt.textContent = formatDDMMYYYY(selectedDate); txt.style.color = '#374151'; }
        cal.classList.remove('open');
        renderCalendar();
        // Xóa lỗi ngày khám khi đã chọn
        var _dispEl = document.getElementById('apptDateDisplay');
        var _errEl  = document.getElementById('apptDateError');
        if (_dispEl) _dispEl.style.borderColor = '';
        if (_errEl)  _errEl.style.display = 'none';
      });
    });
  }

  window.toggleApptCalendar = function(e) {
    if (e) e.stopPropagation();
    const cal = document.getElementById('apptCalendar');
    if (!cal) return;
    if (cal.classList.contains('open')) {
      cal.classList.remove('open');
    } else {
      if (selectedDate) { calYear = selectedDate.getFullYear(); calMonth = selectedDate.getMonth(); }
      else { calYear = today.getFullYear(); calMonth = today.getMonth(); }
      cal.classList.add('open');
      renderCalendar();
    }
  };

  document.addEventListener('click', function(e) {
    const wrapper = document.getElementById('apptDateWrapper');
    if (wrapper && !wrapper.contains(e.target)) {
      const cal = document.getElementById('apptCalendar');
      if (cal) cal.classList.remove('open');
    }
  });

  // Patch resetForm to clear picker
  const _origReset = window.resetForm;
  window.resetForm = function() {
    if (_origReset) _origReset();
    selectedDate = null;
    const txt = document.getElementById('apptDateText');
    if (txt) { txt.textContent = 'Chọn ngày khám'; txt.style.color = '#9CA3AF'; }
    const hidden = document.getElementById('appointmentDate');
    if (hidden) hidden.value = '';
    const cal = document.getElementById('apptCalendar');
    if (cal) cal.classList.remove('open');
  };
})();

// ── Validate ngày sinh dd/mm/yyyy < ngày hiện tại ───────────────────────────
function validateDOB(value) {
  if (!value || value.length < 10) return 'Vui lòng nhập ngày sinh (DD/MM/YYYY)';
  const parts = value.split('/');
  if (parts.length !== 3) return 'Định dạng ngày sinh không hợp lệ (DD/MM/YYYY)';
  const [dd, mm, yyyy] = parts.map(Number);
  if (!dd || !mm || !yyyy) return 'Vui lòng nhập ngày sinh hợp lệ';
  if (dd < 1 || dd > 31 || mm < 1 || mm > 12 || yyyy < 1900)
    return 'Ngày sinh không hợp lệ';
  const dateObj = new Date(yyyy, mm - 1, dd);
  if (dateObj.getFullYear() !== yyyy || dateObj.getMonth() !== mm - 1 || dateObj.getDate() !== dd)
    return 'Ngày không tồn tại, vui lòng kiểm tra lại';
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (dateObj >= today) return 'Ngày sinh phải nhỏ hơn ngày hiện tại';
  return null;
}

// ── Ngày sinh: auto-format dd/mm/yyyy khi nhập tay ──────────────────────────
(function () {
  const dobInput = document.getElementById('dateOfBirth');
  if (!dobInput) return;

  dobInput.addEventListener('input', function () {
    let raw = this.value.replace(/\D/g, '');
    let formatted = '';
    if (raw.length > 0) formatted = raw.substring(0, 2);
    if (raw.length > 2) formatted += '/' + raw.substring(2, 4);
    if (raw.length > 4) formatted += '/' + raw.substring(4, 8);
    this.value = formatted;
    // Xoá lỗi khi người dùng đang nhập
    const errEl = document.getElementById('dobError');
    if (errEl) errEl.style.display = 'none';
    dobInput.style.borderColor = '';
  });
})();
// ── Confirm Date Button Logic ────────────────────────────────────────────────
function checkConfirmDateBtn() {
  const dept = document.getElementById('department').value;
  const date = document.getElementById('appointmentDate').value;
  const btn  = document.getElementById('confirmDateBtn');
  if (!btn) return;
  // Enable button if khoa + ngày đã chọn (bác sĩ không bắt buộc)
  btn.disabled = !(dept && date);
}

function confirmDateSelection() {
  const btn     = document.getElementById('confirmDateBtn');
  const section = document.getElementById('timeSlotSection');
  if (!section) return;
  section.style.display = 'block';
  btn.classList.add('confirmed');
  btn.innerHTML = `
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
      <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
    </svg>
    Đã xác nhận
  `;
  btn.disabled = true;
}

// Watch department + date changes to enable/disable confirm btn
document.getElementById('department').addEventListener('change', checkConfirmDateBtn);

// Patch calendar date selection to also trigger check
(function () {
  const _origSet = window.storage ? null : null; // no-op placeholder
  // Override appointmentDate hidden input watcher via MutationObserver
  const hiddenDate = document.getElementById('appointmentDate');
  if (hiddenDate) {
    const observer = new MutationObserver(checkConfirmDateBtn);
    observer.observe(hiddenDate, { attributes: true, attributeFilter: ['value'] });
  }

  // Also patch the calendar click: after a day is picked, re-check btn
  const _origToggle = window.toggleApptCalendar;
  // We hook into the apptDateText change instead via a small polling shim
  const apptDateInput = document.getElementById('appointmentDate');
  let _lastDateVal = '';
  setInterval(function () {
    const cur = apptDateInput ? apptDateInput.value : '';
    if (cur !== _lastDateVal) {
      _lastDateVal = cur;
      checkConfirmDateBtn();
      // If date changed after confirmed, reset the time section
      const btn     = document.getElementById('confirmDateBtn');
      const section = document.getElementById('timeSlotSection');
      if (btn && btn.classList.contains('confirmed')) {
        btn.classList.remove('confirmed');
        btn.disabled = false;
        btn.innerHTML = `
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          Xác nhận
        `;
        if (section) section.style.display = 'none';
        // Clear selected time
        document.querySelectorAll('.time-slot').forEach(b => b.classList.remove('selected'));
        const timeInput = document.getElementById('appointmentTime');
        if (timeInput) timeInput.value = '';
      }
    }
  }, 200);
})();

// Patch resetForm to also hide time slots & reset confirm btn
const _origResetConfirm = window.resetForm;
window.resetForm = function () {
  if (_origResetConfirm) _origResetConfirm();
  const btn     = document.getElementById('confirmDateBtn');
  const section = document.getElementById('timeSlotSection');
  if (btn) {
    btn.disabled = true;
    btn.classList.remove('confirmed');
    btn.innerHTML = `
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16">
        <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
      Xác nhận
    `;
  }
  if (section) section.style.display = 'none';
};