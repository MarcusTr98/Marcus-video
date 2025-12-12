<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
.stat-card {
	border-left: 4px solid;
	transition: transform 0.2s;
}

.stat-card:hover {
	transform: translateY(-5px);
}

.border-primary {
	border-color: #0d6efd !important;
}

.border-success {
	border-color: #198754 !important;
}

.border-danger {
	border-color: #dc3545 !important;
}
</style>
</head>
<body class="bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<div class="container py-4">

		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2 class="fw-bold text-dark m-0">
				<i class="bi bi-speedometer2 me-2"></i>Dashboard
			</h2>

			<div class="btn-group">
				<a href="<c:url value='/admin/users'/>"
					class="btn btn-outline-primary fw-bold"> <i
					class="bi bi-people-fill me-1"></i> Quản Lý User
				</a> <a href="<c:url value='/admin/video'/>"
					class="btn btn-outline-success fw-bold"> <i
					class="bi bi-film me-1"></i> Quản Lý Video
				</a>

				<button class="btn btn-outline-dark fw-bold"
					onclick="window.print()">
					<i class="bi bi-printer me-1"></i> Xuất Báo Cáo
				</button>
			</div>
		</div>

		<div class="row g-4 mb-4">
			<div class="col-md-4">
				<div class="card shadow-sm border-0 stat-card border-primary h-100">
					<div class="card-body">
						<div class="d-flex justify-content-between align-items-center">
							<div>
								<h6 class="text-muted fw-bold text-uppercase">Tổng Người
									Dùng</h6>
								<h3 class="fw-bold text-primary mb-0">${totalUsers}</h3>
							</div>
							<div class="fs-1 text-primary opacity-25">
								<i class="bi bi-people-fill"></i>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="card shadow-sm border-0 stat-card border-success h-100">
					<div class="card-body">
						<div class="d-flex justify-content-between align-items-center">
							<div>
								<h6 class="text-muted fw-bold text-uppercase">Tổng Video</h6>
								<h3 class="fw-bold text-success mb-0">${totalVideos}</h3>
							</div>
							<div class="fs-1 text-success opacity-25">
								<i class="bi bi-collection-play-fill"></i>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="card shadow-sm border-0 stat-card border-danger h-100">
					<div class="card-body">
						<div class="d-flex justify-content-between align-items-center">
							<div>
								<h6 class="text-muted fw-bold text-uppercase">Tổng Lượt
									Thích</h6>
								<h3 class="fw-bold text-danger mb-0">${totalLikes}</h3>
							</div>
							<div class="fs-1 text-danger opacity-25">
								<i class="bi bi-heart-fill"></i>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row mb-4">
			<div class="col-12">
				<div class="card shadow-sm border-0">
					<div class="card-header bg-white fw-bold">
						<i class="bi bi-bar-chart-line-fill me-2 text-primary"></i>Biểu Đồ
						Thống Kê Top Video
					</div>
					<div class="card-body">
						<canvas id="likeChart" height="100"></canvas>
					</div>
				</div>
			</div>
		</div>

		<div class="card shadow-sm border-0">
			<div
				class="card-header bg-white fw-bold d-flex justify-content-between">
				<span><i class="bi bi-table me-2 text-primary"></i>Chi Tiết
					Lượt Thích</span> <a href="<c:url value='/admin/video'/>"
					class="text-decoration-none small">Xem tất cả</a>
			</div>
			<div class="card-body p-0">
				<div class="table-responsive">
					<table class="table table-hover mb-0 align-middle">
						<thead class="table-light">
							<tr>
								<th>Video Title</th>
								<th>Số Lượt Thích</th>
								<th>Ngày Thích Mới Nhất</th>
								<th>Ngày Thích Cũ Nhất</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${videoStats}">
								<tr>
									<td class="fw-bold text-primary">${item.videoTitle}</td>
									<td><span class="badge bg-danger rounded-pill">${item.totalLikes}
											<i class="bi bi-heart-fill small"></i>
									</span></td>
									<td><fmt:formatDate value="${item.newestDate}"
											pattern="dd-MM-yyyy" /></td>
									<td><fmt:formatDate value="${item.oldestDate}"
											pattern="dd-MM-yyyy" /></td>
								</tr>
							</c:forEach>
							<c:if test="${empty videoStats}">
								<tr>
									<td colspan="4" class="text-center text-muted py-4">Chưa
										có dữ liệu thống kê.</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<script>
        const labels = [];
        const dataLikes = [];
        
        <c:forEach var="item" items="${videoStats}" begin="0" end="4">
        labels.push('${fn:escapeXml(item.videoTitle)}');
            dataLikes.push(${item.totalLikes});
        </c:forEach>

        const ctx = document.getElementById('likeChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Số lượt thích',
                    data: dataLikes,
                    backgroundColor: 'rgba(220, 53, 69, 0.6)',
                    borderColor: 'rgba(220, 53, 69, 1)',
                    borderWidth: 1,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'top' } },
                scales: { y: { beginAtZero: true } }
            }
        });
    </script>
</body>
</html>