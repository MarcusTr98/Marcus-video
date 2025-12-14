<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Hồ sơ: ${user.fullname}</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
/* Card chính bo tròn và đổ bóng mềm */
.profile-card {
	border-radius: 1rem;
	overflow: hidden; /* Để ảnh nền không bị tràn ra ngoài bo góc */
}

/* Cột bên trái chứa Avatar */
.profile-sidebar {
	background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
	border-right: 1px solid #dee2e6;
}

/* Avatar Style */
.avatar-container {
	position: relative;
	width: 150px;
	height: 150px;
	margin: 0 auto;
	cursor: pointer;
}

.profile-img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	border: 5px solid white;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	transition: all 0.3s ease;
}

/* Hiệu ứng hover lên avatar: Hiện icon máy ảnh */
.avatar-overlay {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.4);
	border-radius: 50%;
	display: flex;
	justify-content: center;
	align-items: center;
	opacity: 0;
	transition: opacity 0.3s;
	color: white;
	font-size: 2rem;
	border: 5px solid transparent; /* Giữ kích thước khớp border ảnh */
}

.avatar-container:hover .avatar-overlay {
	opacity: 1;
}

/* Input read-only style tối giản */
.form-control-plaintext.system-info {
	font-weight: 600;
	color: #495057;
	padding-left: 0;
}

.system-info-label {
	font-size: 0.85rem;
	text-transform: uppercase;
	color: #6c757d;
	font-weight: 700;
	letter-spacing: 0.5px;
}

#fileInput {
	display: none;
}
</style>
</head>

<body class="d-flex flex-column min-vh-100 bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<main class="container py-5 flex-grow-1">

		<div class="card profile-card border-0 shadow-lg">
			<div class="row g-0">

				<div
					class="col-lg-4 profile-sidebar p-5 text-center d-flex flex-column justify-content-center">

					<div class="avatar-container mb-3"
						onclick="document.getElementById('fileInput').click();">
						<img id="avatarPreview"
							src="${pageContext.request.contextPath}/${user.avatar}"
							onerror="this.src='https://placehold.co/150?text=Avatar'"
							class="rounded-circle profile-img" alt="Avatar">

						<div class="avatar-overlay rounded-circle">
							<i class="bi bi-camera-fill"></i>
						</div>
					</div>

					<h4 class="fw-bold mb-1">${user.fullname}</h4>
					<p class="text-muted mb-4">@${user.id}</p>

					<c:if test="${sessionScope.user.id == user.id}">
						<a href="<c:url value='/account/change-password'/>"
							class="btn btn-outline-dark rounded-pill px-4"> <i
							class="bi bi-shield-lock me-2"></i>Đổi mật khẩu
						</a>
					</c:if>
				</div>

				<div class="col-lg-8 bg-white p-5">

					<div class="d-flex justify-content-between align-items-center mb-4">
						<h4 class="fw-bold text-primary m-0">Thông tin cá nhân</h4>
						<c:if test="${user.admin}">
							<span
								class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill">
								<i class="bi bi-star-fill me-1"></i> Admin
							</span>
						</c:if>
					</div>

					<c:if test="${not empty message}">
						<div
							class="alert alert-success alert-dismissible fade show border-0 bg-success-subtle text-success">
							<i class="bi bi-check-circle-fill me-2"></i>${message}
							<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
						</div>
					</c:if>
					<c:if test="${not empty error}">
						<div
							class="alert alert-danger alert-dismissible fade show border-0 bg-danger-subtle text-danger">
							<i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
							<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
						</div>
					</c:if>

					<c:url value="/account/profile" var="postUrl" />
					<form action="${postUrl}" method="post"
						enctype="multipart/form-data">
						<input type="file" id="fileInput" name="avatarFile"
							accept="image/*" onchange="previewImage(this)">

						<div class="row g-3 mb-4">
							<div class="col-md-6">
								<label class="form-label fw-bold">Họ và tên</label>
								<div class="input-group">
									<span class="input-group-text bg-light border-end-0"><i
										class="bi bi-person"></i></span> <input type="text"
										class="form-control border-start-0 ps-0" name="fullname"
										value="${user.fullname}" required>
								</div>
							</div>
							<div class="col-md-6">
								<label class="form-label fw-bold">Email</label>
								<div class="input-group">
									<span class="input-group-text bg-light border-end-0"><i
										class="bi bi-envelope"></i></span> <input type="email"
										class="form-control border-start-0 ps-0" name="email"
										value="${user.email}" required>
								</div>
							</div>
							<div class="col-12">
								<label class="form-label fw-bold d-block">Giới tính</label>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="gender"
										id="genderMale" value="true" ${user.gender ? 'checked' : ''}>
									<label class="form-check-label" for="genderMale">Nam</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="gender"
										id="genderFemale" value="false"
										${!user.gender ? 'checked' : ''}> <label
										class="form-check-label" for="genderFemale">Nữ</label>
								</div>
							</div>
						</div>

						<div class="bg-light rounded-3 p-4 mb-4">
							<h6 class="fw-bold text-muted mb-3 border-bottom pb-2">
								<i class="bi bi-hdd-rack me-2"></i>THÔNG TIN HỆ THỐNG
							</h6>
							<div class="row g-3">
								<div class="col-md-4">
									<div class="system-info-label">ID Đăng nhập</div>
									<div class="form-control-plaintext system-info">${user.id}</div>
								</div>
								<div class="col-md-4">
									<div class="system-info-label">Ngày tham gia</div>
									<div class="form-control-plaintext system-info">
										<fmt:formatDate value='${user.createdDate}'
											pattern='dd/MM/yyyy' />
									</div>
								</div>
								<div class="col-md-4">
									<div class="system-info-label">Trạng thái</div>
									<div
										class="form-control-plaintext system-info ${user.isActive ? 'text-success' : 'text-danger'}">
										<i class="bi bi-circle-fill small me-1"></i>${user.isActive ? 'Active' : 'Locked'}
									</div>
								</div>
							</div>
						</div>

						<div class="d-flex justify-content-end gap-2">
							<button type="reset" class="btn btn-light px-4">Hủy</button>
							<button type="submit" class="btn btn-primary px-4 fw-bold">
								<i class="bi bi-floppy2-fill me-2"></i>Lưu thay đổi
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</main>

	<script>
		function previewImage(input) {
			if (input.files && input.files[0]) {
				var reader = new FileReader();
				reader.onload = function(e) {
					document.getElementById('avatarPreview').src = e.target.result;
				}
				reader.readAsDataURL(input.files[0]);
			}
		}
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>