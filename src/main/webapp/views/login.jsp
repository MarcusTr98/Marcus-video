<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<style>
.login-image {
	object-fit: cover;
	object-position: center;
	min-height: 100%;
}
</style>
</head>
<body class="bg-light">
	<c:url value="/login" var="loginAction" />
	<c:url value="/register" var="registerLink" />
	<c:url value="/img/login.jpg" var="imgLogin" />
	<c:url value="/forgot-password" var="forgot" />


	<div class="container py-5">
		<div class="card mx-auto shadow-lg border-0 overflow-hidden"
			style="max-width: 960px;">
			<div class="row g-0">
				<div class="col-md-6 d-none d-md-block bg-dark">
					<img src="${imgLogin}" class="img-fluid w-100 h-100 login-image"
						alt="Login Cover">
				</div>

				<div class="col-md-6 bg-white">
					<div class="card-body p-4 p-lg-5">
						<div class="text-center mb-4">
							<h2 class="fw-bold text-primary">
								<i class="bi bi-people-fill"></i> Login System
							</h2>
							<p class="text-muted small">Wellcome!</p>
						</div>

						<div class="mb-3">
							<c:if test="${not empty message}">
								<div
									class="alert alert-danger alert-dismissible fade show d-flex align-items-center"
									role="alert">
									<i class="bi bi-person-fill-x me-2"></i>
									<div>${message}</div>
									<button type="button" class="btn-close" data-bs-dismiss="alert"
										aria-label="Close"></button>
								</div>
							</c:if>
						</div>

						<form action="${loginAction}" method="post">
							<div class="form-floating mb-3">
								<input type="text" class="form-control" id="username"
									name="idOrEmail" placeholder="Username" required> <label
									for="username">Username</label>
							</div>

							<div class="form-floating mb-3">
								<input type="password" class="form-control" id="password"
									name="password" placeholder="Password" required> <label
									for="password">Password</label>
							</div>

							<div
								class="d-flex justify-content-between align-items-center mb-3">
								<div class="form-check">
									<input type="checkbox" class="form-check-input" id="remember"
										name="remember"> <label class="form-check-label small"
										for="remember"> Remember me! </label>
								</div>
								<a href="${forgot}" class="small text-decoration-none">Forgot
									Password</a>
							</div>

							<div class="d-grid gap-2 mb-4">
								<button type="submit"
									class="btn btn-primary btn-lg fw-bold shadow-sm">
									Login</button>
							</div>

							<div class="text-center">
								<p class="text-muted small mb-0">Don't have an account?</p>
								<a href="${registerLink}"
									class="btn btn-link text-decoration-none fw-bold"> Register
									<i class="bi bi-box-arrow-in-right"></i>
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
	<script>
		// Tự động lấy message từ URL (ví dụ: ?message=PleaseLogin) nếu Attribute rỗng
		const urlParams = new URLSearchParams(window.location.search);
		const msg = urlParams.get('message');

		if (msg === 'PleaseLogin') {
			alert('Vui lòng đăng nhập để tiếp tục!'); // Hoặc hiển thị vào div alert của bạn
		} else if (msg === 'AccessDenied') {
			alert('Bạn không có quyền truy cập trang này!');
		}
	</script>
</body>
</html>