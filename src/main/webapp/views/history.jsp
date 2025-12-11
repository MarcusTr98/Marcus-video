<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Watch History</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<div class="container py-5">
		<h3 class="fw-bold text-dark mb-4">
			<i class="bi bi-clock-history me-2"></i>Watch History
		</h3>

		<c:if test="${empty histories}">
			<div class="text-center py-5">
				<i class="bi bi-hourglass text-muted display-1"></i>
				<p class="mt-3 text-muted">Bạn chưa xem video nào.</p>
				<a href="<c:url value='/home'/>" class="btn btn-primary">Xem
					ngay</a>
			</div>
		</c:if>

		<div class="row row-cols-1 row-cols-md-4 g-4">
			<c:forEach var="item" items="${histories}">
				<div class="col">
					<div class="card h-100 shadow-sm border-0">
						<a href="<c:url value='/video?id=${item.video.id}'/>"> <img
							src="${item.video.poster}" class="card-img-top"
							style="height: 160px; object-fit: cover;"
							onerror="this.src='https://placehold.co/300x200'">
						</a>
						<div class="card-body">
							<h6 class="card-title text-truncate">
								<a href="<c:url value='/video?id=${item.video.id}'/>"
									class="text-decoration-none text-dark"> ${item.video.title}
								</a>
							</h6>
							<p class="card-text small text-muted mb-0">
								<i class="bi bi-calendar-check me-1"></i>
								<fmt:formatDate value="${item.viewDate}"
									pattern="dd/MM/yyyy HH:mm" />
							</p>
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