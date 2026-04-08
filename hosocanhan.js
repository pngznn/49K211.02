document.addEventListener('DOMContentLoaded', () => {
    // 1. XỬ LÝ TÌM KIẾM (An toàn)
    // Thay .search-bar bằng .search-box để khớp với class trong HTML của bạn
    const searchInput = document.querySelector('.search-box input');
    if (searchInput) {
        searchInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                const query = searchInput.value.trim();
                if (query) {
                    console.log('Đang tìm kiếm:', query);
                    // Thêm logic tìm kiếm tại đây
                }
            }
        });
    }

    // 2. XỬ LÝ CHATBOT (Dùng Class thay vì can thiệp trực tiếp .style)
    const chatBtn = document.querySelector('.floating-chat'); // Đổi đúng class floating-chat
    if (chatBtn) {
        chatBtn.addEventListener('click', () => {
            console.log('Nút Chatbot đã được nhấn');
            // Logic mở khung chat sẽ viết ở đây
        });
    }

});