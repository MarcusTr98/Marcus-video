<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<style>
.register-image {
	object-fit: cover;
	object-position: center;
	min-height: 100%;
}
</style>
</head>
<body class="bg-light">
	<c:url value="/img/register.jpg" var="imgRegister" />
	<c:url value="/register" var="registerAction" />
	<div class="container py-3">
		<div class="card mx-auto shadow-lg border-0 overflow-hidden"
			style="max-width: 1000px;">
			<div class="row g-0">

				<div class="col-md-6 d-none d-md-block bg-dark">

					<img src="${imgRegister}"
						class="img-fluid w-100 h-100 register-image" alt="Register Cover"
						onerror="this.src='https://placehold.co/600x800?text=PolyOE+Register'">
				</div>

				<div class="col-md-6 bg-white">
					<div class="card-body p-4 p-lg-5">

						<div class="text-center mb-2">
							<h2 class="fw-bold text-success">
								<i class="bi bi-person-plus-fill me-2"></i>Register Account
							</h2>
							<p class="text-muted small">Tạo tài khoản để tham gia cộng
								đồng PolyOE</p>
						</div>

						<div class="mb-2">
							<c:if test="${not empty message}">
								<div
									class="alert alert-warning alert-dismissible fade show d-flex align-items-center"
									role="alert">
									<i class="bi bi-exclamation-triangle-fill me-2"></i>
									<div>${message}</div>
									<button type="button" class="btn-close" data-bs-dismiss="alert"
										aria-label="Close"></button>
								</div>
							</c:if>
						</div>

						<form action="${registerAction}" method="post">

							<div class="form-floating mb-2">
								<input type="text" class="form-control" id="id" name="id"
									placeholder="Username" value="${user.id}" required> <label
									for="id">Username</label>
							</div>

							<div class="form-floating mb-2">
								<input type="text" class="form-control" id="fullname"
									name="fullname" placeholder="Họ và tên"
									value="${user.fullname}" required> <label
									for="fullname">Họ và tên</label>
							</div>

							<div class="form-floating mb-2">
								<input type="email" class="form-control" id="email" name="email"
									placeholder="Email" value="${user.email}" required> <label
									for="email">Địa chỉ Email</label>
							</div>

							<div class="form-floating mb-2">
								<input type="password" class="form-control" id="password"
									name="password" placeholder="Mật khẩu" required> <label
									for="password">Mật khẩu</label>
							</div>

							<div class="form-floating mb-2">
								<input type="password" class="form-control" id="confirmPassword"
									name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
								<label for="confirmPassword">Xác nhận mật khẩu</label>
							</div>

							<div class="d-grid gap-2 mb-2">
								<button type="submit"
									class="btn btn-success btn-lg fw-bold shadow-sm">Register
									Now!</button>
							</div>

							<div class="text-center">
								<p class="text-muted small mb-0">Have an account?</p>
								<a href="<c:url value='/login'/>"
									class="btn btn-link text-decoration-none fw-bold"> <i
									class="bi bi-box-arrow-in-left"></i> Login now!
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
		const form = document.querySelector('form');
		const pass = document.getElementById('password');
		const confirm = document.getElementById('confirmPassword');

		form.addEventListener('submit', function(e) {
			if (pass.value !== confirm.value) {
				e.preventDefault(); // Chặn gửi form
				alert('Mật khẩu xác nhận không khớp!');
				confirm.focus();
			}
		});
	</script>
</body>
</html>