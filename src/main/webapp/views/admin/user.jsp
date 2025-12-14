<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản lý Người Dùng</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<style>
.avatar-preview {
	width: 80px;
	height: 80px;
	object-fit: cover;
	border: 2px solid #dee2e6;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.table-avatar {
	width: 36px;
	height: 36px;
	object-fit: cover;
}

.form-label {
	font-weight: 600;
	font-size: 0.9rem;
	color: #495057;
	margin-bottom: 0;
	padding-top: calc(0.375rem + 1px);
}

.action-col {
	white-space: nowrap;
	width: 100px;
}

.card-body-form {
	padding: 1.5rem;
}
</style>
</head>
<body class="bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<div class="container-fluid py-4">
		<div class="row g-4">

			<div class="col-lg-5">
				<div class="card shadow-sm border-0 h-100">
					<div
						class="card-header bg-primary text-white fw-bold d-flex justify-content-between align-items-center">
						<span><i class="bi bi-person-gear me-2"></i>Thông Tin User</span>
						<c:if test="${not empty user.id}">
							<span class="badge bg-white text-primary">Mode: Edit</span>
						</c:if>
					</div>

					<div class="card-body card-body-form bg-light">

						<c:if test="${not empty error}">
							<div class="alert alert-danger py-2 small mb-3">${error}</div>
						</c:if>

						<c:set var="isEdit"
							value="${not empty user.id and not empty user.password}" />
						<c:url
							value="${isEdit ? '/admin/user/update' : '/admin/user/create'}"
							var="actionUrl" />

						<form action="${actionUrl}" method="post">

							<div class="d-flex align-items-center mb-4">
								<img id="imgPreview" src="${user.avatar}"
									onerror="this.src='https://placehold.co/150?text=No+Image'"
									class="rounded-circle avatar-preview me-3">
								<div class="flex-grow-1">
									<div class="input-group input-group-sm">
										<span class="input-group-text"><i
											class="bi bi-link-45deg"></i></span> <input type="text"
											class="form-control" name="avatar"
											placeholder="Paste link avatar..." value="${user.avatar}"
											oninput="updatePreview(this.value)" required>
									</div>
									<div class="form-text small" style="font-size: 0.75rem">Dán
										đường dẫn ảnh (JPG/PNG)</div>
								</div>
							</div>

							<hr class="text-muted opacity-25">

							<div class="row mb-3">
								<label class="col-sm-3 col-form-label">User ID</label>
								<div class="col-sm-9">
									<input type="text" class="form-control form-control-sm"
										name="id" value="${user.id}"
										${isEdit ? 'readonly style="background-color: #e9ecef;"' : ''}
										required placeholder="Nhập ID...">
								</div>
							</div>

							<div class="row mb-3">
								<label class="col-sm-3 col-form-label">Họ tên</label>
								<div class="col-sm-9">
									<input type="text" class="form-control form-control-sm"
										name="fullname" value="${user.fullname}" required
										placeholder="Nhập họ tên...">
								</div>
							</div>

							<div class="row mb-3">
								<label class="col-sm-3 col-form-label">Email</label>
								<div class="col-sm-9">
									<input type="email" class="form-control form-control-sm"
										name="email" value="${user.email}" required
										placeholder="example@mail.com">
								</div>
							</div>

							<div class="row mb-3">
								<label class="col-sm-3 col-form-label">Mật khẩu</label>
								<div class="col-sm-9">
									<input type="password" class="form-control form-control-sm"
										name="password"
										placeholder="${isEdit ? '****** (Giữ nguyên)' : 'Nhập mật khẩu'}"
										${isEdit ? '' : 'required'}>
								</div>
							</div>

							<div class="row mb-3 align-items-center">
								<label class="col-sm-3 col-form-label">Giới tính</label>
								<div class="col-sm-9">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="gender"
											id="gM" value="true" ${user.gender ? 'checked' : ''}>
										<label class="form-check-label small" for="gM">Nam</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="gender"
											id="gF" value="false" ${!user.gender ? 'checked' : ''}>
										<label class="form-check-label small" for="gF">Nữ</label>
									</div>
								</div>
							</div>

							<div class="row mb-4">
								<label class="col-sm-3 col-form-label">Cấu hình</label>
								<div class="col-sm-9 d-flex gap-2">
									<select class="form-select form-select-sm" name="admin">
										<option value="false" ${!user.admin ? 'selected' : ''}>User</option>
										<option value="true" ${user.admin ? 'selected' : ''}>Admin</option>
									</select> <select class="form-select form-select-sm" name="isActive">
										<option value="true" ${user.isActive ? 'selected' : ''}>Active</option>
										<option value="false" ${!user.isActive ? 'selected' : ''}>Locked</option>
									</select>
								</div>
							</div>

							<div class="d-flex gap-2 pt-2 border-top">
								<button class="btn btn-primary fw-bold w-50" type="submit">
									<i class="bi bi-floppy2-fill me-1"></i> ${isEdit ? 'Cập Nhật' : 'Thêm Mới'}
								</button>
								<a href="<c:url value='/admin/user/reset'/>"
									class="btn btn-outline-secondary w-50"> <i
									class="bi bi-arrow-counterclockwise me-1"></i> Làm mới
								</a>
							</div>
						</form>
					</div>
				</div>
			</div>

			<div class="col-lg-7">
				<div class="card shadow-sm border-0 h-100">
					<div
						class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
						<h5 class="m-0 fw-bold text-primary">
							<i class="bi bi-list-ul me-2"></i>Danh Sách User
						</h5>
						<c:if test="${not empty message}">
							<span class="badge bg-success shadow-sm p-2"><i
								class="bi bi-check-circle me-1"></i>${message}</span>
						</c:if>
					</div>

					<div class="card-body p-0">
						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0 text-nowrap">
								<thead class="table-light">
									<tr>
										<th style="width: 50px;">Avatar</th>
										<th>Thông tin User</th>
										<th>Ngày đăng ký</th>
										<th>Vai trò</th>
										<th>Trạng thái</th>
										<th class="text-end">Hành động</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="item" items="${users}">
										<tr class="${item.id == user.id ? 'table-active' : ''}">
											<td class="text-center"><img src="${item.avatar}"
												class="rounded-circle table-avatar border"
												onerror="this.src='https://placehold.co/40?text=U'"></td>
											<td>
												<div class="fw-bold text-dark">${item.fullname}</div>
												<div class="text-muted small" style="font-size: 0.8rem;">
													<i class="bi bi-envelope me-1"></i>${item.email}
												</div>
											</td>
											<td><span class="fw-bold text-secondary"
												style="font-size: 0.85rem;"> <fmt:formatDate
														value="${item.createdDate}" pattern="dd/MM/yyyy" />
											</span></td>
											<td><c:choose>
													<c:when test="${item.admin}">
														<span class="badge bg-danger rounded-pill">Admin</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-secondary rounded-pill">User</span>
													</c:otherwise>
												</c:choose></td>
											<td><c:choose>
													<c:when test="${item.isActive}">
														<span
															class="badge bg-success-subtle text-success border border-success-subtle">Active</span>
													</c:when>
													<c:otherwise>
														<span
															class="badge bg-danger-subtle text-danger border border-danger-subtle">Locked</span>
													</c:otherwise>
												</c:choose></td>
											<td class="text-end action-col"><a
												href="<c:url value='/admin/user/edit/${item.id}'/>"
												class="btn btn-sm btn-outline-primary"> <i
													class="bi bi-pencil-square"></i>
											</a>
												<button type="button"
													class="btn btn-sm btn-outline-danger ms-1"
													data-bs-toggle="modal"
													data-bs-target="#deleteModal${item.id}">
													<i class="bi bi-trash"></i>
												</button>

												<div class="modal fade" id="deleteModal${item.id}"
													tabindex="-1">
													<div class="modal-dialog modal-dialog-centered modal-sm">
														<div class="modal-content">
															<div class="modal-body text-center p-4">
																<div class="text-danger display-4 mb-3">
																	<i class="bi bi-exclamation-circle"></i>
																</div>
																<h6 class="mb-2">Xác nhận xóa?</h6>
																<p class="small text-muted mb-4">
																	Bạn có chắc muốn xóa user <b>${item.id}</b>?
																</p>
																<div class="d-flex justify-content-center gap-2">
																	<button type="button" class="btn btn-light btn-sm px-3"
																		data-bs-dismiss="modal">Không</button>
																	<form action="<c:url value='/admin/user/delete'/>"
																		method="post">
																		<input type="hidden" name="id" value="${item.id}">
																		<button type="submit"
																			class="btn btn-danger btn-sm px-3">Xóa</button>
																	</form>
																</div>
															</div>
														</div>
													</div>
												</div></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>

					<div class="card-footer bg-white py-2">
						<nav>
							<ul class="pagination justify-content-center mb-0 pagination-sm">
								<c:forEach begin="1" end="${totalPage}" var="i">
									<li class="page-item ${i == currentPage ? 'active' : ''}">
										<a class="page-link"
										href="<c:url value='/admin/users?page=${i}'/>">${i}</a>
									</li>
								</c:forEach>
							</ul>
						</nav>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		function updatePreview(url) {
			const img = document.getElementById('imgPreview');
			if (!url || url.trim() === '') {
				img.src = 'https://placehold.co/150?text=No+Image';
				return;
			}
			img.src = url;
			img.onerror = function() {
				this.src = 'https://placehold.co/150?text=Error';
			};
		}
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>