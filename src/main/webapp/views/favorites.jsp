<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Video Đã Thích</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<div class="container py-5">
		<h3 class="fw-bold text-danger mb-4">
			<i class="bi bi-camera-reels"></i> My Favorites List
		</h3>

		<c:if test="${empty videos}">
			<div class="text-center py-5">
				<i class="bi bi-camera-reels display-1 text-muted"></i>
				<p class="mt-3 text-muted">Bạn chưa thích video nào cả.</p>
				<a href="<c:url value='/home'/>" class="btn btn-primary">Khám
					phá ngay</a>
			</div>
		</c:if>

		<div class="row row-cols-1 row-cols-md-3 g-4">
			<c:forEach var="v" items="${videos}">
				<div class="col">
					<div class="card h-100 shadow-sm border-0">
						<a href="<c:url value='/video?id=${v.id}'/>"> <img
							src="${v.poster}" class="card-img-top" alt="${v.title}"
							style="height: 200px; object-fit: cover;">
						</a>
						<div class="card-body">
							<h5 class="card-title text-truncate">
								<a href="<c:url value='/video?id=${v.id}'/>"
									class="text-decoration-none text-dark fw-bold"> ${v.title}
								</a>
							</h5>
							<p class="card-text small text-muted">
								<i class="bi bi-eye-fill"></i> ${v.views} lượt xem
							</p>
						</div>
						<div class="card-footer bg-white border-top-0 d-grid">
							<a href="<c:url value='/video?id=${v.id}'/>"
								class="btn btn-outline-danger btn-sm"> <i
								class="bi bi-play-circle me-1"></i> Xem lại
							</a>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>