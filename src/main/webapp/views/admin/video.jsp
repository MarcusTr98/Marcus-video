<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Quản lý Video</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<style>
.poster-preview {
	width: 100%;
	height: 180px;
	object-fit: cover;
	border-radius: 0.5rem;
	border: 1px solid #dee2e6;
	background-color: #000;
}

.table-poster {
	width: 80px;
	height: 45px;
	object-fit: cover;
	border-radius: 4px;
}

.form-label {
	font-weight: 600;
	font-size: 0.85rem;
	color: #495057;
	padding-top: calc(0.375rem + 1px);
}

.video-id-badge {
	font-family: monospace;
	font-size: 0.8rem;
	letter-spacing: 0.5px;
}

.action-col {
	white-space: nowrap;
	width: 100px;
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
						class="card-header bg-success text-white fw-bold d-flex justify-content-between align-items-center">
						<span><i class="bi bi-film me-2"></i>Thông Tin Video</span>
						<c:if test="${not empty video.id}">
							<span class="badge bg-white text-success">Mode: Edit</span>
						</c:if>
					</div>

					<div class="card-body bg-light">

						<c:if test="${not empty error}">
							<div class="alert alert-danger py-2 small mb-3">${error}</div>
						</c:if>
						<c:if test="${not empty sessionScope.message}">
							<div class="alert alert-success py-2 small mb-3">
								${sessionScope.message}
								<c:remove var="message" scope="session" />
							</div>
						</c:if>

						<c:set var="isEdit" value="${not empty video.id}" />
						<c:url
							value="${isEdit ? '/admin/video/update' : '/admin/video/create'}"
							var="actionUrl" />

						<form action="${actionUrl}" method="post">

							<div class="mb-3 position-relative">
								<img id="posterPreview"
									src="${not empty video.poster ? video.poster : 'https://placehold.co/600x400?text=Youtube+Poster'}"
									class="poster-preview shadow-sm"
									onerror="this.src='https://placehold.co/600x400?text=No+Image'">
								<div
									class="position-absolute bottom-0 end-0 m-2 badge bg-dark opacity-75">Preview</div>
							</div>

							<div class="row mb-2">
								<label class="col-sm-3 col-form-label">Youtube ID</label>
								<div class="col-sm-9">
									<div class="input-group input-group-sm">
										<span class="input-group-text"><i
											class="bi bi-youtube text-danger"></i></span> <input type="text"
											class="form-control" name="id" id="youtubeId"
											value="${video.id}" placeholder="VD: dQw4w9WgXcQ"
											required 
                                               ${isEdit ? 'readonly
											style="background-color: #e9ecef;"
											' : ''}
                                               oninput="autoGeneratePoster(this.value)">
									</div>
									<div class="form-text small" style="font-size: 0.7rem">Nhập
										ID hoặc link Youtube đầy đủ.</div>
								</div>
							</div>

							<div class="row mb-2">
								<label class="col-sm-3 col-form-label">Tiêu đề</label>
								<div class="col-sm-9">
									<input type="text" class="form-control form-control-sm"
										name="title" value="${video.title}" required
										placeholder="Nhập tiêu đề video...">
								</div>
							</div>

							<div class="row mb-2">
								<label class="col-sm-3 col-form-label">Poster URL</label>
								<div class="col-sm-9">
									<div class="input-group input-group-sm">
										<span class="input-group-text"><i class="bi bi-image"></i></span>
										<input type="text" class="form-control" name="poster"
											id="posterUrl" value="${video.poster}"
											placeholder="https://..."
											oninput="document.getElementById('posterPreview').src = this.value">
									</div>
								</div>
							</div>

							<div class="row mb-2 align-items-center">
								<label class="col-sm-3 col-form-label">Cấu hình</label>
								<div class="col-sm-9 d-flex gap-2">
									<div class="input-group input-group-sm w-50">
										<span class="input-group-text"><i class="bi bi-eye"></i></span>
										<input type="number" class="form-control" name="views"
											value="${video.views}" readonly title="Lượt xem tự động tăng">
									</div>
									<div class="form-check form-switch pt-1">
										<input class="form-check-input" type="checkbox" name="active"
											id="activeCheck" value="true"
											${video.active ? 'checked' : ''}> <label
											class="form-check-label small" for="activeCheck">Active</label>
									</div>
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label mb-1">Mô tả nội dung</label>
								<textarea class="form-control form-control-sm"
									name="description" rows="3"
									placeholder="Viết mô tả ngắn gọn...">${video.description}</textarea>
							</div>

							<div class="d-flex gap-2 pt-2 border-top">
								<button class="btn btn-success fw-bold w-50" type="submit">
									<i class="bi ${isEdit ? 'bi-check-lg' : 'bi-plus-lg'} me-1"></i>
									${isEdit ? 'Cập Nhật' : 'Thêm Mới'}
								</button>
								<a href="<c:url value='/admin/video/reset'/>"
									class="btn btn-outline-secondary w-50"> <i
									class="bi bi-arrow-counterclockwise me-1"></i> Làm Mới
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
						<h5 class="m-0 fw-bold text-success">
							<i class="bi bi-list-ul me-2"></i>Danh Sách Video
						</h5>
						<span class="badge bg-light text-dark border">Page
							${currentPage}/${totalPage}</span>
					</div>

					<div class="card-body p-0">
						<div class="table-responsive">
							<table class="table table-hover align-middle mb-0 text-nowrap">
								<thead class="table-light small text-uppercase text-muted">
									<tr>
										<th style="width: 100px;">Poster</th>
										<th>Tiêu đề / ID</th>
										<th class="text-center">Views</th>
										<th class="text-center">Status</th>
										<th class="text-end">Thao tác</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="v" items="${videos}">
										<tr class="${v.id == video.id ? 'table-active' : ''}">
											<td><img src="${v.poster}"
												class="table-poster border shadow-sm"
												onerror="this.src='https://placehold.co/80x45?text=Img'">
											</td>
											<td>
												<div class="fw-bold text-dark text-truncate"
													style="max-width: 200px;" title="${v.title}">
													${v.title}</div> <span
												class="badge bg-light text-secondary border video-id-badge">
													<i class="bi bi-youtube me-1 text-danger"></i>${v.id}
											</span>
											</td>
											<td class="text-center fw-bold text-muted">${v.views}</td>
											<td class="text-center"><c:choose>
													<c:when test="${v.active}">
														<span
															class="badge bg-success-subtle text-success border border-success-subtle">Active</span>
													</c:when>
													<c:otherwise>
														<span
															class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Hidden</span>
													</c:otherwise>
												</c:choose></td>
											<td class="text-end action-col"><a
												href="<c:url value='/admin/video/edit/${v.id}'/>"
												class="btn btn-sm btn-outline-success"> <i
													class="bi bi-pencil-square"></i>
											</a>

												<button type="button"
													class="btn btn-sm btn-outline-danger ms-1"
													data-bs-toggle="modal"
													data-bs-target="#deleteVideoModal${v.id}">
													<i class="bi bi-trash"></i>
												</button>

												<div class="modal fade" id="deleteVideoModal${v.id}"
													tabindex="-1">
													<div class="modal-dialog modal-dialog-centered modal-sm">
														<div class="modal-content">
															<div class="modal-body text-center p-4">
																<div class="text-danger display-4 mb-3">
																	<i class="bi bi-exclamation-circle"></i>
																</div>
																<h6 class="mb-2">Xác nhận xóa?</h6>
																<p class="small text-muted mb-4 text-wrap">
																	Video <b>${v.id}</b> sẽ bị xóa vĩnh viễn.
																</p>
																<div class="d-flex justify-content-center gap-2">
																	<button type="button" class="btn btn-light btn-sm px-3"
																		data-bs-dismiss="modal">Hủy</button>
																	<form action="<c:url value='/admin/video/delete'/>"
																		method="post">
																		<input type="hidden" name="id" value="${v.id}">
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
									<c:if test="${empty videos}">
										<tr>
											<td colspan="5" class="text-center py-5 text-muted"><i
												class="bi bi-inbox fs-1 d-block mb-2 opacity-50"></i> Chưa
												có dữ liệu</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
					</div>

					<c:if test="${totalPage > 1}">
						<div class="card-footer bg-white py-2">
							<nav>
								<ul class="pagination justify-content-center mb-0 pagination-sm">
									<li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
										<a class="page-link"
										href="<c:url value='/admin/video?page=${currentPage - 1}'/>"><i
											class="bi bi-chevron-left"></i></a>
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
										href="<c:url value='/admin/video?page=${currentPage + 1}'/>"><i
											class="bi bi-chevron-right"></i></a>
									</li>
								</ul>
							</nav>
						</div>
					</c:if>
				</div>
			</div>
		</div>
	</div>

	<script>
		function autoGeneratePoster(val) {
			let videoId = val;
			const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/;
			const match = val.match(regExp);
			if (match && match[2].length === 11) {
				videoId = match[2];
				document.getElementById('youtubeId').value = videoId;
			}

			if (videoId.length === 11) {
				const posterLink = 'https://img.youtube.com/vi/' + videoId
						+ '/maxresdefault.jpg';
				document.getElementById('posterUrl').value = posterLink;
				document.getElementById('posterPreview').src = posterLink;
			}
		}
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>