<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    // --- CẤU HÌNH CHUNG ---
    Chart.defaults.font.family = "'Segoe UI', 'Arial', sans-serif";

    // --------------------------------------------------------
    // CHART 1: TOP LIKES (Bar Chart)
    // --------------------------------------------------------
    const ctxLike = document.getElementById('likeChart');
    if (ctxLike) {
        const labelsLike = [];
        const dataLikes = [];
        
        <c:forEach var="item" items="${videoStats}" begin="0" end="4">
            labelsLike.push('${fn:escapeXml(item.videoTitle)}');
            dataLikes.push(${item.totalLikes});
        </c:forEach>

        new Chart(ctxLike, {
            type: 'bar',
            data: {
                labels: labelsLike,
                datasets: [{
                    label: 'Lượt thích',
                    data: dataLikes,
                    backgroundColor: 'rgba(220, 53, 69, 0.7)',
                    borderColor: 'rgba(220, 53, 69, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });
    }

    // --------------------------------------------------------
    // CHART 2: TOP VIEWS (Bar Chart)
    // --------------------------------------------------------
    const ctxView = document.getElementById('viewChart');
    if (ctxView) {
        const labelsView = [];
        const dataViews = [];

        <c:forEach var="item" items="${videoViews}" begin="0" end="4">
            labelsView.push('${fn:escapeXml(item.title)}');
            dataViews.push(${item.value});
        </c:forEach>

        new Chart(ctxView, {
            type: 'bar',
            data: {
                labels: labelsView,
                datasets: [{
                    label: 'Lượt xem',
                    data: dataViews,
                    backgroundColor: 'rgba(13, 110, 253, 0.7)',
                    borderColor: 'rgba(13, 110, 253, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });
    }

    // --------------------------------------------------------
    // CHART 3: NEW USERS (Line Chart)
    // --------------------------------------------------------
    const ctxUser = document.getElementById('userChart');
    if (ctxUser) {
        const labelsUser = [];
        const dataUser = [];

        <c:forEach var="item" items="${userStats}">
            // Cắt chuỗi ngày cho gọn (yyyy-MM-dd)
            labelsUser.push('${item.title}'.substring(0, 10)); 
            dataUser.push(${item.value});
        </c:forEach>

        new Chart(ctxUser, {
            type: 'line',
            data: {
                labels: labelsUser,
                datasets: [{
                    label: 'Người dùng mới',
                    data: dataUser,
                    backgroundColor: 'rgba(25, 135, 84, 0.2)',
                    borderColor: 'rgba(25, 135, 84, 1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: { responsive: true }
        });
    }

    // --------------------------------------------------------
    // CHART 4: VIDEO STATUS (Pie/Doughnut Chart)
    // --------------------------------------------------------
    const ctxStatus = document.getElementById('statusChart');
    if (ctxStatus) {
        const labelsStatus = [];
        const dataStatus = [];

        <c:forEach var="item" items="${videoStatus}">
            // --- FIX LỖI FONT & DỊCH THUẬT ---
            // Backend trả về 'Active' hoặc 'Inactive' (Tiếng Anh không dấu)
            // Frontend tự dịch sang Tiếng Việt để hiển thị đẹp
            var statusRaw = '${item.title}'; 
            var statusVN = (statusRaw === 'Active' || statusRaw === 'true') ? 'Đang Hoạt Động' : 'Đã Ẩn/Khóa';
            
            labelsStatus.push(statusVN);
            dataStatus.push(${item.value});
        </c:forEach>

        new Chart(ctxStatus, {
            type: 'doughnut',
            data: {
                labels: labelsStatus,
                datasets: [{
                    data: dataStatus,
                    backgroundColor: [
                        'rgba(108, 117, 125, 0.8)', // Xám (Inactive)
                        'rgba(25, 135, 84, 0.8)' // Xanh (Active)
                    ],
                    hoverOffset: 4
                }]
            },
            options: { responsive: true }
        });
    }
</script>