<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MarcusVideo - Trang chủ</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
/* CSS cho Card Video đẹp hơn */
.video-card {
	transition: all 0.3s ease;
	border: none;
	overflow: hidden;
}

.video-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1) !important;
}

.poster-wrapper {
	position: relative;
	padding-top: 56.25%; /* Tỷ lệ 16:9 chuẩn Youtube */
	background-color: #000;
	overflow: hidden;
}

.poster-img {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: transform 0.3s ease;
}

.video-card:hover .poster-img {
	transform: scale(1.05); /* Zoom nhẹ ảnh khi hover */
}

.play-overlay {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0.4);
	display: flex;
	align-items: center;
	justify-content: center;
	opacity: 0;
	transition: opacity 0.3s ease;
}

.video-card:hover .play-overlay {
	opacity: 1;
}
/* Style phân trang */
.page-link {
	color: #dc3545;
}

.page-item.active .page-link {
	background-color: #dc3545;
	border-color: #dc3545;
}

.page-link:hover {
	color: #b02a37;
}
</style>
</head>

<body class="bg-light d-flex flex-column min-vh-100">

	<jsp:include page="/views/common/navbar.jsp" />

	<header class="bg-white border-bottom mb-4 py-5 shadow-sm">
		<div class="container text-center">
			<h1 class="fw-bold display-5 mb-3">
				Khám phá thế giới <span class="text-danger">Marcus Video</span>
			</h1>
			<p class="lead text-secondary mx-auto" style="max-width: 600px;">
				Nền tảng chia sẻ video giải trí hàng đầu dành cho mọi người.</p>
		</div>
	</header>

	<div class="container mb-5 flex-grow-1">

		<div
			class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
			<h4 class="fw-bold text-dark m-0">
				<i class="bi bi-fire text-danger me-2"></i>Video Mới Nhất
			</h4>
			<span class="badge bg-secondary rounded-pill">Trang
				${currentPage}/${totalPage}</span>
		</div>

		<div class="row row-cols-1 row-cols-md-3 row-cols-lg-3 g-4">

			<c:forEach var="v" items="${videos}">
				<div class="col">
					<div class="card h-100 shadow-sm video-card rounded-3">
						<div class="poster-wrapper">
							<img src="${v.poster}" class="poster-img"
								onerror="this.src='https://placehold.co/600x400?text=No+Image'"
								alt="${v.title}">
							<div class="play-overlay">
								<i
									class="bi bi-play-circle-fill text-white display-1 opacity-75"></i>
							</div>
						</div>

						<div class="card-body">
							<h6 class="card-title fw-bold text-dark text-truncate mb-2"
								title="${v.title}">${v.title}</h6>
							<p class="card-text small text-muted text-truncate mb-3">
								${not empty v.description ? v.description : 'Không có mô tả'}</p>

							<div
								class="d-flex justify-content-between align-items-center small border-top pt-3">
								<span class="text-secondary"> <i
									class="bi bi-eye-fill me-1"></i>${v.views} lượt xem
								</span> <span class="text-danger fw-bold"> <i
									class="bi bi-heart-fill me-1"></i>${not empty v.favorites ? v.favorites.size() : 0}
								</span>
							</div>
						</div>

						<a href="<c:url value='/video?id=${v.id}'/>"
							class="stretched-link"></a>
					</div>
				</div>
			</c:forEach>

			<c:if test="${empty videos}">
				<div class="col-12 text-center py-5">
					<div class="text-muted display-1">
						<i class="bi bi-emoji-frown"></i>
					</div>
					<p class="fs-5 mt-3">Chưa có video nào để hiển thị.</p>
				</div>
			</c:if>

		</div>
		<c:if test="${totalPage > 1}">
			<div class="d-flex justify-content-center mt-5">
				<nav aria-label="Page navigation">
					<ul class="pagination shadow-sm">

						<c:set var="reqKeyword"
							value="${not empty keyword ? '&keyword=' : ''}${not empty keyword ? keyword : ''}" />

						<li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
							<a class="page-link" href="?page=${currentPage - 1}${reqKeyword}"
							aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						</a>
						</li>

						<c:forEach begin="1" end="${totalPage}" var="i">
							<li class="page-item ${currentPage == i ? 'active' : ''}"><a
								class="page-link" href="?page=${i}${reqKeyword}">${i}</a></li>
						</c:forEach>

						<li
							class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
							<a class="page-link" href="?page=${currentPage + 1}${reqKeyword}"
							aria-label="Next"> <span aria-hidden="true">&raquo;</span>
						</a>
						</li>
					</ul>
				</nav>
			</div>
		</c:if>

	</div>

	<footer class="bg-white border-top py-4 mt-auto">
		<div class="container text-center">
			<p class="text-muted small mb-0">
				&copy; 2025 <strong>Marcus Video</strong> - Nền tảng chia sẻ video
				hữu ích hàng đầu dành cho mọi người.
			</p>
		</div>
	</footer>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>