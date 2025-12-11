<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>500 - Lỗi hệ thống</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<style>
body {
	background: #e9ecef;
	height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
}

.error-card {
	max-width: 550px;
	border: none;
	box-shadow: 0 1rem 3rem rgba(0, 0, 0, .175);
	border-radius: 1rem;
	overflow: hidden;
}

.header-bg {
	background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
	padding: 2rem;
}
</style>
</head>
<body>
	<div class="container text-center">
		<div class="card error-card mx-auto">
			<div class="header-bg text-white">
				<i class="bi bi-cone-striped display-1"></i>
				<h2 class="mt-3 fw-bold">Hệ thống đang bảo trì</h2>
			</div>

			<div class="card-body p-5 bg-white">
				<h5 class="text-dark fw-bold mb-3">Đã xảy ra lỗi không mong
					muốn :(</h5>
				<p class="text-muted">
					Server của chúng tôi đang gặp chút sự cố kỹ thuật. <br> Kỹ
					thuật (Marcus) đã được thông báo và đang xử lý.
				</p>

				<hr class="my-4">

				<%-- 
                <div class="alert alert-warning text-start overflow-auto" style="max-height: 150px;">
                    <small><strong>Error Details:</strong> ${pageContext.exception}</small>
                </div> 
                --%>

				<div class="d-flex justify-content-center gap-3">
					<button onclick="history.back()"
						class="btn btn-outline-secondary btn-lg rounded-pill px-4">
						<i class="bi bi-arrow-left me-2"></i>Quay lại
					</button>
					<a href="<c:url value='/home'/>"
						class="btn btn-warning btn-lg rounded-pill px-4 text-white fw-bold">
						<i class="bi bi-house-door-fill me-2"></i>Trang chủ
					</a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>