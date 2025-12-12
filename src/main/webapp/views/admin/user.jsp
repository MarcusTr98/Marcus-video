<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Người Dùng | Admin</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<div class="container-fluid py-4">
		<div class="row g-4">

			<div class="col-lg-4">
				<div class="card shadow-sm border-0 sticky-top"
					style="top: 80px; z-index: 1;">
					<div class="card-header bg-white fw-bold text-primary">
						<i class="bi bi-person-gear me-2"></i>Thông Tin Người Dùng
					</div>
					<div class="card-body">
						<c:if test="${not empty sessionScope.message}">
							<div class="alert alert-success alert-dismissible fade show"
								role="alert">
								<small>${sessionScope.message}</small>
								<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
								<%
								session.removeAttribute("message");
								%>
							</div>
						</c:if>
						<c:if test="${not empty error}">
							<div class="alert alert-danger alert-dismissible fade show"
								role="alert">
								<small>${error}</small>
								<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
							</div>
						</c:if>

						<c:url var="base" value="/admin/user" />

						<form action="${base}/index" method="post">
							<div class="mb-3">
								<label class="form-label small fw-bold">Tên đăng nhập
									(ID)</label> <input class="form-control" name="id" value="${user.id}"
									placeholder="Nhập ID..." required 
									${not empty
									user.id && user.id !=''? 'readonly' : ''}>
							</div>

							<div class="mb-3">
								<label class="form-label small fw-bold">Mật khẩu</label> <input
									type="password" class="form-control" name="password"
									placeholder="${not empty user.id ? 'Bỏ trống nếu không đổi pass' : 'Nhập mật khẩu...'}">
							</div>

							<div class="mb-3">
								<label class="form-label small fw-bold">Họ và tên</label> <input
									class="form-control" name="fullname" value="${user.fullname}"
									placeholder="Nhập họ tên..." required>
							</div>

							<div class="mb-3">
								<label class="form-label small fw-bold">Email</label> <input
									type="email" class="form-control" name="email"
									value="${user.email}" placeholder="email@example.com" required>
							</div>

							<div class="mb-3">
								<label class="form-label small fw-bold d-block">Vai trò</label>
								<div class="btn-group w-100" role="group">
									<input type="radio" class="btn-check" name="admin"
										id="roleUser" value="false" ${!user.admin ? 'checked' : ''}>
									<label class="btn btn-outline-primary w-50" for="roleUser">Người
										dùng</label> <input type="radio" class="btn-check" name="admin"
										id="roleAdmin" value="true" ${user.admin ? 'checked' : ''}>
									<label class="btn btn-outline-danger w-50" for="roleAdmin">Quản
										trị viên</label>
								</div>
							</div>

							<div class="mb-4">
								<label class="form-label small fw-bold d-block">Trạng
									thái</label>
								<div class="btn-group w-100" role="group">
									<input type="radio" class="btn-check" name="isActive"
										id="statusActive" value="true"
										${user.isActive ? 'checked' : ''}> <label
										class="btn btn-outline-success w-50" for="statusActive">Hoạt
										động</label> <input type="radio" class="btn-check" name="isActive"
										id="statusBanned" value="false"
										${!user.isActive ? 'checked' : ''}> <label
										class="btn btn-outline-secondary w-50" for="statusBanned">Khóa</label>
								</div>
							</div>

							<div class="d-grid gap-2">
								<div class="row g-2">
									<div class="col-6">
										<button class="btn btn-success w-100"
											formaction="${base}/create"
											${not empty user.id ? 'disabled' : ''}>
											<i class="bi bi-plus-circle"></i> Thêm
										</button>
									</div>
									<div class="col-6">
										<button class="btn btn-warning w-100"
											formaction="${base}/update"
											${empty user.id ? 'disabled' : ''}>
											<i class="bi bi-pencil-square"></i> Sửa
										</button>
									</div>
									<div class="col-6">
										<button class="btn btn-danger w-100"
											formaction="${base}/delete"
											${empty user.id ? 'disabled' : ''}
											onclick="return confirm('Bạn có chắc muốn xóa user này?');">
											<i class="bi bi-trash"></i> Xóa
										</button>
									</div>
									<div class="col-6">
										<button class="btn btn-secondary w-100"
											formaction="${base}/reset" formnovalidate>
											<i class="bi bi-arrow-counterclockwise"></i> Mới
										</button>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>

			<div class="col-lg-8">
				<div class="card shadow-sm border-0">
					<div
						class="card-header bg-white fw-bold d-flex justify-content-between align-items-center">
						<span><i class="bi bi-list-ul me-2"></i>Danh Sách Tài Khoản</span>
						<span class="badge bg-primary rounded-pill">${users.size()}
							users</span>
					</div>
					<div class="card-body p-0">
						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0">
								<thead class="table-light small text-uppercase">
									<tr>
										<th>ID</th>
										<th>Họ và tên</th>
										<th>Email</th>
										<th class="text-center">Vai trò</th>
										<th class="text-center">Trạng thái</th>
										<th class="text-end">Hành động</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="u" items="${users}">
										<tr>
											<td class="fw-bold text-primary">${u.id}</td>
											<td>${u.fullname}</td>
											<td>${u.email}</td>

											<td class="text-center"><c:choose>
													<c:when test="${u.admin}">
														<span class="badge bg-danger">Admin</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-secondary">User</span>
													</c:otherwise>
												</c:choose></td>

											<td class="text-center"><c:choose>
													<c:when test="${u.isActive}">
														<span class="badge bg-success">Active</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-dark">Locked</span>
													</c:otherwise>
												</c:choose></td>

											<td class="text-end"><a
												href="<c:url value='/admin/user/edit/${u.id}'/>"
												class="btn btn-sm btn-outline-primary"> <i
													class="bi bi-pencil-fill"></i> Edit
											</a></td>
										</tr>
									</c:forEach>
									<c:if test="${empty users}">
										<tr>
											<td colspan="6" class="text-center text-muted py-4">Không
												có dữ liệu.</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
					</div>

					<div class="card-footer bg-white py-3">
						<nav aria-label="Page navigation">
							<ul class="pagination justify-content-center mb-0">
								<li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
									<a class="page-link"
									href="<c:url value='/admin/users?page=${currentPage - 1}'/>">Previous</a>
								</li>
								<c:forEach begin="1" end="${totalPage}" var="i">
									<li class="page-item ${currentPage == i ? 'active' : ''}">
										<a class="page-link"
										href="<c:url value='/admin/users?page=${i}'/>">${i}</a>
									</li>
								</c:forEach>
								<li
									class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
									<a class="page-link"
									href="<c:url value='/admin/users?page=${currentPage + 1}'/>">Next</a>
								</li>
							</ul>
						</nav>
					</div>
				</div>
			</div>

		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>