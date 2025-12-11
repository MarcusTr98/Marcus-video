<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đổi mật khẩu</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<style>
.profile-header-img {
	width: 120px;
	height: 120px;
	object-fit: cover;
	border: 4px solid #fff;
	box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
}
</style>
</head>

<body class="d-flex flex-column min-vh-100 bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<main class="container flex-grow-1 py-5">

		<nav aria-label="breadcrumb" class="mb-4">
			<ol class="breadcrumb">
				<li class="breadcrumb-item"><a href="<c:url value='/home'/>">Trang
						chủ</a></li>
				<li class="breadcrumb-item"><a
					href="<c:url value='/account/profile'/>">Hồ sơ cá nhân</a></li>
				<li class="breadcrumb-item active">Đổi mật khẩu</li>
			</ol>
		</nav>

		<div class="row g-4 justify-content-center">

			<div class="col-md-4">
				<div class="card border-0 shadow-sm text-center h-100">
					<div class="card-body py-5">
						<img src="${user.avatar}" alt="Avatar"
							class="rounded-circle profile-header-img mb-3">

						<h4 class="fw-bold mb-1">${sessionScope.user.fullname}</h4>
						<p class="text-muted mb-3">@${sessionScope.user.id}</p>

						<div class="d-grid gap-2 col-10 mx-auto">
							<a href="<c:url value='/account/profile'/>"
								class="btn btn-outline-secondary btn-sm"> <i
								class="bi bi-arrow-left me-1"></i> Quay lại hồ sơ
							</a>
						</div>
					</div>
				</div>
			</div>

			<div class="col-md-8">
				<div class="card border-0 shadow-sm h-100">
					<div class="card-header bg-white border-bottom-0 pt-4 ps-4">
						<h5 class="card-title fw-bold text-danger">
							<i class="bi bi-shield-lock-fill me-2"></i>Bảo mật tài khoản
						</h5>
					</div>
					<div class="card-body p-4">

						<c:if test="${not empty error}">
							<div class="alert alert-danger alert-dismissible fade show"
								role="alert">
								<i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
								<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
							</div>
						</c:if>

						<c:if test="${not empty message}">
							<div class="alert alert-success alert-dismissible fade show"
								role="alert">
								<i class="bi bi-check-circle-fill me-2"></i> ${message}
								<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
							</div>
						</c:if>

						<c:url value="/account/change-password" var="postUrl" />
						<form action="${postUrl}" method="post">

							<div class="mb-3">
								<label class="form-label fw-semibold">Mật khẩu hiện tại</label>
								<div class="input-group">
									<span class="input-group-text bg-light"><i
										class="bi bi-key"></i></span> <input type="password"
										class="form-control" name="currentPass" required
										placeholder="Nhập mật khẩu đang sử dụng">
								</div>
							</div>

							<hr class="my-4 border-light">

							<div class="mb-3">
								<label class="form-label fw-semibold">Mật khẩu mới</label>
								<div class="input-group">
									<span class="input-group-text bg-light"><i
										class="bi bi-lock"></i></span> <input type="password"
										class="form-control" name="newPass" required
										placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)">
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label fw-semibold">Xác nhận mật khẩu
									mới</label>
								<div class="input-group">
									<span class="input-group-text bg-light"><i
										class="bi bi-lock-fill"></i></span> <input type="password"
										class="form-control" name="confirmPass" required
										placeholder="Nhập lại mật khẩu mới">
								</div>
							</div>

							<div class="d-flex justify-content-end mt-4">
								<button type="submit" class="btn btn-danger px-4">
									<i class="bi bi-save me-1"></i> Lưu mật khẩu
								</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</main>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>