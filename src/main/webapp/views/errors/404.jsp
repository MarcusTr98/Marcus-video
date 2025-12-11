<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>404 - Không tìm thấy trang</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<style>
body {
	background: #f8f9fa;
	height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
}

.error-card {
	max-width: 500px;
	border: none;
	box-shadow: 0 1rem 3rem rgba(0, 0, 0, .175);
	border-radius: 1rem;
}

.error-icon {
	font-size: 5rem;
	color: #6c757d;
}

.btn-home {
	border-radius: 50px;
	padding: 10px 30px;
	font-weight: bold;
	text-transform: uppercase;
	letter-spacing: 1px;
	transition: all 0.3s;
}

.btn-home:hover {
	transform: translateY(-3px);
	box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
}
</style>
</head>
<body>
	<div class="container text-center">
		<div class="card error-card mx-auto p-5">
			<div class="card-body">
				<div class="mb-4">
					<i class="bi bi-emoji-dizzy error-icon text-danger"></i>
				</div>

				<h1 class="display-1 fw-bold text-dark">404</h1>
				<h4 class="mb-3 text-secondary">Úi! Đã có lỗi xảy ra.</h4>
				<p class="text-muted mb-4">Đường dẫn bạn truy cập có thể bị hỏng
					hoặc trang đã bị xóa. Đừng lo, hãy quay lại trang chủ nhé!</p>

				<a href="<c:url value='/home'/>" class="btn btn-danger btn-home">
					<i class="bi bi-house-fill me-2"></i>Về Trang Chủ
				</a>
			</div>
		</div>
		<div class="mt-4 text-muted small">&copy; 2025 MarcusVideo
			Entertainment</div>
	</div>
</body>
</html>