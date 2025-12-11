<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Profile ${user.fullname}</title>
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
				<c:if test="${sessionScope.user.admin}">
					<li class="breadcrumb-item"><a
						href="<c:url value='/admin/users'/>">Quản lý User</a></li>
				</c:if>
				<li class="breadcrumb-item active">Hồ sơ cá nhân</li>
			</ol>
		</nav>

		<div class="row g-4">
			<div class="col-md-4">
				<div class="card border-0 shadow-sm text-center h-100">
					<div class="card-body py-5">
						<img
							src="${user.avatar}"
							alt="Avatar" class="rounded-circle profile-header-img mb-3">

						<h4 class="fw-bold mb-1">${user.fullname}</h4>
	
					<p class="text-muted mb-3">@${user.id}</p>

						<c:if test="${sessionScope.user.id == user.id}">
							<div class="d-grid gap-2 col-8 mx-auto">
								<a href="<c:url value='/account/change-password'/>"
									class="btn btn-outline-danger btn-sm"> <i
									class="bi bi-key-fill me-1"></i> Đổi mật khẩu
								</a>
							</div>
						</c:if>
					</div>
				</div>
			</div>

			<div class="col-md-8">
				<div class="card border-0 shadow-sm h-100">
					<div class="card-header bg-white border-bottom-0 pt-4 ps-4">
						<h5 class="card-title fw-bold text-primary">
							<i class="bi bi-person-lines-fill me-2"></i>Thông tin tài khoản
						</h5>
					</div>
					<div class="card-body p-4">

						<c:if test="${not empty message}">
							<div class="alert alert-info alert-dismissible fade show">
								${message}
								<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
							</div>
						</c:if>

						<c:url value="/account/profile" var="postUrl" />
						<form action="${postUrl}" method="post">

							<div class="mb-3 row">
								<label class="col-sm-3 col-form-label text-muted">Tên
									đăng nhập</label>
								<div class="col-sm-9">
									<input type="text" readonly
										class="form-control-plaintext fw-bold" name="id"
										value="${user.id}">
								</div>
							</div>

							<div class="mb-3 row">
								<label class="col-sm-3 col-form-label">Họ và tên</label>
								<div class="col-sm-9">
									<input type="text" class="form-control" name="fullname"
										value="${user.fullname}" required>
								</div>
							</div>

							<div class="mb-3 row">
								<label class="col-sm-3 col-form-label">Email</label>
								<div class="col-sm-9">
									<input type="email" class="form-control" name="email"
										value="${user.email}" required>
								</div>
							</div>

							<hr class="my-4">

							<div class="mb-3 row">
								<label class="col-sm-3 col-form-label text-muted">Vai
									trò</label>
								<div class="col-sm-9 d-flex align-items-center">
									<c:choose>
										<c:when test="${user.admin}">
											<span class="badge bg-danger">Quản trị viên</span>
										</c:when>
										<c:otherwise>
											<span class="badge bg-secondary">Thành viên</span>
										</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="d-flex justify-content-end mt-4">
								<button type="submit" class="btn btn-primary px-4">
									<i class="bi bi-save me-1"></i> Lưu thay đổi
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