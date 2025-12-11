<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Find Video</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<div class="container py-5">

		<div class="row justify-content-center mb-4">
			<div class="col-md-8">
				<div class="card shadow-sm border-0">
					<div class="card-body p-4">
						<h3 class="text-center fw-bold text-primary mb-4">
							<i class="bi bi-search me-2"></i>Tìm kiếm Video
						</h3>

						<c:url var="searchAction" value="/video/search" />
						<form action="${searchAction}" method="post">
							<div class="input-group input-group-lg">
								<span class="input-group-text bg-white border-end-0 text-muted">
									<i class="bi bi-search"></i>
								</span> <input type="text" class="form-control border-start-0 ps-0"
									name="keyword" value="${keyword}"
									placeholder="Nhập tiêu đề video cần tìm..." required>
								<button type="submit" class="btn btn-primary fw-bold px-4">Tìm
									kiếm</button>
							</div>
						</form>

						<c:if test="${not empty message}">
							<div
								class="alert alert-info mt-3 mb-0 text-center border-0 bg-info-subtle text-info-emphasis">
								<i class="bi bi-info-circle-fill me-2"></i>${message}
							</div>
						</c:if>
					</div>
				</div>
			</div>
		</div>

		<div class="card shadow-sm border-0">
			<div class="card-header bg-white py-3">
				<div class="d-flex justify-content-between align-items-center">
					<h5 class="m-0 fw-bold text-secondary">
						<i class="bi bi-list-ul me-2"></i>Kết quả tìm kiếm
					</h5>
					<c:if test="${not empty param.keyword}">
						<span class="badge bg-light text-dark border"> Từ khóa: <span
							class="text-primary fw-bold">"${param.keyword}"</span>
						</span>
					</c:if>
				</div>
			</div>

			<div class="card-body p-0">
				<div class="table-responsive">
					<table class="table table-hover align-middle mb-0">
						<thead class="table-light text-uppercase small text-muted">
							<tr>
								<th class="text-center" style="width: 50px;">#</th>
								<th>Tiêu đề Video</th>
								<th class="text-center">Lượt thích</th>
								<th class="text-center">Trạng thái</th>
								<th class="text-end pe-4">Hành động</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="v" items="${videos}" varStatus="stt">
								<tr>
									<td class="text-center fw-bold text-secondary">${stt.count}</td>
									<td>
										<div class="d-flex align-items-center">
											<div class="bg-light rounded p-2 me-3 text-danger">
												<i class="bi bi-youtube fs-4"></i>
											</div>
											<div>
												<h6 class="mb-0 fw-bold text-dark">${v.title}</h6>
												<small class="text-muted">Views: ${v.views}</small>
											</div>
										</div>
									</td>
									<td class="text-center"><span
										class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill">
											<i class="bi bi-heart-fill me-1"></i>${v.favorites.size()}
									</span></td>
									<td class="text-center"><c:choose>
											<c:when test="${v.active}">
												<span
													class="badge bg-success-subtle text-success border border-success-subtle">Hoạt
													động</span>
											</c:when>
											<c:otherwise>
												<span
													class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Đã
													khóa</span>
											</c:otherwise>
										</c:choose></td>
									<td class="text-end pe-4"><a
										href="<c:url value='/video?id=${v.id}'/>"
										class="btn btn-sm btn-outline-primary"> <i
											class="bi bi-play-fill me-1"></i>Xem ngay
									</a></td>
								</tr>
							</c:forEach>

							<c:if test="${empty list && not empty param.keyword}">
								<tr>
									<td colspan="5" class="text-center py-5">
										<div class="text-muted opacity-50 mb-2">
											<i class="bi bi-search display-4"></i>
										</div>
										<p class="h5 text-muted">Không tìm thấy video nào.</p>
										<p class="small text-secondary">Thử tìm với từ khóa khác
											xem sao!</p>
									</td>
								</tr>
							</c:if>

							<c:if test="${empty param.keyword && empty list}">
								<tr>
									<td colspan="5" class="text-center py-5">
										<p class="text-muted small">Vui lòng nhập từ khóa để bắt
											đầu tìm kiếm.</p>
									</td>
								</tr>
							</c:if>
						</tbody>
					</table>
					<div class="d-flex justify-content-center mt-4">
						<nav aria-label="Page navigation">
							<ul class="pagination">

								<c:set var="reqKeyword"
									value="${not empty keyword ? '&keyword=' : ''}${not empty keyword ? keyword : ''}" />

								<li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
									<a class="page-link"
									href="?page=${currentPage - 1}${reqKeyword}">Previous</a>
								</li>

								<c:forEach begin="1" end="${totalPage}" var="i">
									<li class="page-item ${currentPage == i ? 'active' : ''}">
										<a class="page-link" href="?page=${i}${reqKeyword}">${i}</a>
									</li>
								</c:forEach>

								<li
									class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
									<a class="page-link"
									href="?page=${currentPage + 1}${reqKeyword}">Next</a>
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