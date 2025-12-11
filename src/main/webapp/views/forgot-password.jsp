<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Forgot Password</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
.forgot-image {
	object-fit: cover;
	object-position: center;
	min-height: 100%;
}
</style>
</head>
<body class="bg-light">

	<div class="container py-5">
		<div class="card mx-auto shadow-lg border-0 overflow-hidden"
			style="max-width: 960px;">
			<div class="row g-0">

				<div class="col-md-6 d-none d-md-block bg-dark">
					<c:url value="/img/management.jpg" var="imgForgot" />
					<img src="${imgForgot}" class="img-fluid w-100 h-100 forgot-image"
						alt="Forgot Password Cover"
						onerror="this.src='https://placehold.co/600x800?text=PolyOE+Recover'">
				</div>

				<div class="col-md-6 bg-white">
					<div class="card-body p-4 p-lg-5">

						<div class="text-center mb-4">
							<h2 class="fw-bold text-primary">
								<i class="bi bi-shield-lock-fill me-2"></i>Khôi Phục Mật Khẩu
							</h2>
							<p class="text-muted small">Nhập email của bạn để nhận lại
								mật khẩu</p>
						</div>

						<div class="mb-3">
							<c:if test="${not empty message}">
								<div
									class="alert alert-info alert-dismissible fade show d-flex align-items-center"
									role="alert">
									<i class="bi bi-info-circle-fill me-2"></i>
									<div>${message}</div>
									<button type="button" class="btn-close" data-bs-dismiss="alert"
										aria-label="Close"></button>
								</div>
							</c:if>
						</div>

						<form action="<c:url value='/forgot-password'/>" method="post">

							<div class="form-floating mb-4">
								<input type="email" class="form-control" id="email" name="email"
									placeholder="name@example.com" required> <label
									for="email">Địa chỉ Email đã đăng ký</label>
							</div>

							<div class="d-grid gap-2 mb-4">
								<button type="submit"
									class="btn btn-primary btn-lg fw-bold shadow-sm">
									<i class="bi bi-envelope-paper-fill me-2"></i>Gửi Mật Khẩu
								</button>
							</div>

							<div class="text-center border-top pt-3">
								<p class="text-muted small mb-2">Bạn đã nhớ lại mật khẩu?</p>
								<a href="<c:url value='/login'/>"
									class="btn btn-outline-secondary btn-sm"> <i
									class="bi bi-arrow-left me-1"></i> Quay lại Đăng nhập
								</a>
							</div>

						</form>
					</div>
				</div>

			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>