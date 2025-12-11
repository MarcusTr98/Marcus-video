<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản Lý Video</title>
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

			<div class="col-lg-5">
				<div class="card shadow-sm border-0 sticky-top"
					style="top: 80px; z-index: 1;">
					<div class="card-header bg-white fw-bold text-success">
						<i class="bi bi-film me-2"></i>Thông Tin Video
					</div>
					<div class="card-body">
						<c:if test="${not empty error}">
							<div class="alert alert-danger alert-dismissible fade show">
								${error}
								<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
							</div>
						</c:if>
						<c:if test="${not empty sessionScope.message}">
							<div class="alert alert-success alert-dismissible fade show">
								${sessionScope.message}
								<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
								<c:remove var="message" scope="session" />
							</div>
						</c:if>

						<c:url var="base" value="/admin/video" />

						<form action="${base}/index" method="post">

							<div class="mb-3">
								<label class="form-label small fw-bold">Youtube ID /
									Link</label>
								<div class="input-group">
									<span class="input-group-text bg-light"><i
										class="bi bi-link-45deg"></i></span> <input class="form-control"
										name="id" value="${video.id}" placeholder="Ví dụ: dQw4w9WgXcQ"
										required 
										   ${not empty video.id && video.id !=''? 'readonly' : ''}>
								</div>
								<div class="form-text text-muted small">Nhập ID hoặc link
									Youtube đầy đủ.</div>
							</div>

							<div class="mb-3">
								<label class="form-label small fw-bold">Tiêu đề Video</label> <input
									class="form-control" name="title" value="${video.title}"
									required placeholder="Nhập tiêu đề...">
							</div>

							<div class="mb-3">
								<label class="form-label small fw-bold">Poster (URL)</label> <input
									class="form-control" name="poster" value="${video.poster}"
									placeholder="https://...">

								<div class="mt-2 text-center bg-dark rounded p-1">
									<img
										src="${not empty video.poster ? video.poster : 'https://placehold.co/600x400?text=Poster'}"
										class="rounded" style="max-height: 150px; max-width: 100%;"
										onerror="this.src='https://placehold.co/600x400?text=Error+Image'">
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label small fw-bold">Lượt xem (Views)</label>
								<input type="number" class="form-control" name="views"
									value="${video.views}" readonly>
							</div>

							<div class="mb-3">
								<label class="form-label small fw-bold">Mô tả</label>
								<textarea class="form-control" name="description" rows="3">${video.description}</textarea>
							</div>

							<div class="mb-4 form-check form-switch">
								<input type="checkbox" class="form-check-input" name="active"
									id="activeCheck" value="true" ${video.active ? 'checked' : ''}>
								<label class="form-check-label small fw-bold" for="activeCheck">Đang
									hoạt động (Active)</label>
							</div>

							<div class="d-grid gap-2">
								<div class="row g-2">
									<div class="col-6">
										<button class="btn btn-success w-100"
											formaction="${base}/create"
											${not empty video.id && video.id != '' ? 'disabled' : ''}>
											<i class="bi bi-plus-circle"></i> Thêm
										</button>
									</div>
									<div class="col-6">
										<button class="btn btn-warning w-100"
											formaction="${base}/update"
											${empty video.id ? 'disabled' : ''}>
											<i class="bi bi-pencil-square"></i> Sửa
										</button>
									</div>
									<div class="col-6">
										<button class="btn btn-danger w-100"
											formaction="${base}/delete"
											${empty video.id ? 'disabled' : ''}
											onclick="return confirm('Bạn có chắc chắn muốn xóa video này?');">
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

			<div class="col-lg-7">
				<div class="card shadow-sm border-0">
					<div
						class="card-header bg-white fw-bold d-flex justify-content-between align-items-center">
						<span><i class="bi bi-list-ul me-2"></i>Danh Sách Video</span> <span
							class="badge bg-success rounded-pill">Trang
							${currentPage}/${totalPage}</span>
					</div>
					<div class="card-body p-0">
						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0">
								<thead class="table-light small text-uppercase">
									<tr>
										<th>Poster</th>
										<th>Thông tin</th>
										<th class="text-center">Views</th>
										<th class="text-center">Trạng thái</th>
										<th class="text-end">Hành động</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="v" items="${videos}">
										<tr>
											<td width="100"><img src="${v.poster}" width="80"
												class="rounded border"
												onerror="this.src='https://placehold.co/120x80?text=No+Img'">
											</td>
											<td>
												<div class="fw-bold text-success text-truncate"
													style="max-width: 250px;">${v.title}</div>
												<div class="small text-muted font-monospace">${v.id}</div>
											</td>
											<td class="text-center">${v.views}</td>
											<td class="text-center"><c:choose>
													<c:when test="${v.active}">
														<span class="badge bg-success">Active</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-secondary">Inactive</span>
													</c:otherwise>
												</c:choose></td>
											<td class="text-end"><a
												href="<c:url value='/admin/video/edit/${v.id}'/>"
												class="btn btn-sm btn-outline-success"> <i
													class="bi bi-pencil-fill"></i> Edit
											</a></td>
										</tr>
									</c:forEach>
									<c:if test="${empty videos}">
										<tr>
											<td colspan="5" class="text-center py-5 text-muted"><i
												class="bi bi-inbox fs-1 d-block mb-2"></i> Chưa có dữ liệu
												video nào.</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
					</div>
					<br>
					<c:if test="${totalPage > 1}">
						<div class="card-footer bg-white border-top-0 py-3">
							<nav aria-label="Page navigation">
								<ul class="pagination justify-content-center mb-0">
									<li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
										<a class="page-link"
										href="<c:url value='/admin/video?page=${currentPage - 1}'/>">Previous</a>
									</li>

									<c:forEach begin="1" end="${totalPage}" var="i">
										<li class="page-item ${currentPage == i ? 'active' : ''}">
											<a class="page-link"
											href="<c:url value='/admin/video?page=${i}'/>">${i}</a>
										</li>
									</c:forEach>

									<li
										class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
										<a class="page-link"
										href="<c:url value='/admin/video?page=${currentPage + 1}'/>">Next</a>
									</li>
								</ul>
							</nav>
						</div>
					</c:if>

				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>