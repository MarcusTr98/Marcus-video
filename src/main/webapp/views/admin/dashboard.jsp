<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

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

.border-warning {
	border-color: #ffc107 !important;
} /* Thêm màu vàng cho User */
</style>
</head>
<body class="bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<div class="container py-4">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2 class="fw-bold text-dark m-0">
				<i class="bi bi-speedometer2 me-2"></i>Dashboard
			</h2>
		</div>
		<div
			class="btn-group d-flex justify-content-between align-items-center mb-4">
			<a href="<c:url value='/admin/users'/>"
				class="btn btn-outline-primary fw-bold"> <i
				class="bi bi-people-fill me-1"></i> Quản Lý User
			</a> <a href="<c:url value='/admin/video'/>"
				class="btn btn-outline-success fw-bold"> <i
				class="bi bi-film me-1"></i> Quản Lý Video
			</a>
			<button class="btn btn-outline-dark fw-bold" onclick="window.print()">
				<i class="bi bi-printer me-1"></i> Xuất Báo Cáo
			</button>
		</div>
		<div class="row g-4 mb-4"></div>

		<div class="row mb-4">
			<div class="col-md-6">
				<div class="card shadow-sm border-0 h-100">
					<div class="card-header bg-white fw-bold">
						<i class="bi bi-heart-fill me-2 text-danger"></i>Top Video Yêu
						Thích
					</div>
					<div class="card-body">
						<canvas id="likeChart"></canvas>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="card shadow-sm border-0 h-100">
					<div class="card-header bg-white fw-bold">
						<i class="bi bi-eye-fill me-2 text-primary"></i>Top Video Xem
						Nhiều
					</div>
					<div class="card-body">
						<canvas id="viewChart"></canvas>
					</div>
				</div>
			</div>
		</div>

		<div class="row mb-4">
			<div class="col-md-8">
				<div class="card shadow-sm border-0 h-100">
					<div class="card-header bg-white fw-bold">
						<i class="bi bi-person-plus-fill me-2 text-success"></i>Người Dùng
						Mới (Gần đây)
					</div>
					<div class="card-body">
						<canvas id="userChart" style="max-height: 300px;"></canvas>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card shadow-sm border-0 h-100">
					<div class="card-header bg-white fw-bold">
						<i class="bi bi-pie-chart-fill me-2 text-secondary"></i>Trạng Thái
						Video
					</div>
					<div class="card-body">
						<div style="width: 80%; margin: 0 auto;">
							<canvas id="statusChart"></canvas>
						</div>
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
								<th>Ngày Mới Nhất</th>
								<th>Ngày Cũ Nhất</th>
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

	<jsp:include page="/views/admin/components/chart-scripts.jsp" />

</body>
</html>