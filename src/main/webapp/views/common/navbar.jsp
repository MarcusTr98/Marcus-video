<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<nav
	class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm"
	style="background: linear-gradient(to right, #1a1a1a, #2c3e50);">
	<div class="container">
		<a
			class="navbar-brand fw-bold text-uppercase d-flex align-items-center"
			href="<c:url value='/home'/>"> <i
			class="bi bi-play-circle-fill text-danger fs-4 me-2"></i> <span>Marcus<span
				class="text-danger">Video</span></span>
		</a>

		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarNav">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav me-auto mb-2 mb-lg-0">
				<li class="nav-item"><a class="nav-link px-3 active"
					href="<c:url value='/home'/>"> <i
						class="bi bi-house-door-fill me-1"></i> Home
				</a></li>
				<li class="nav-item"><a class="nav-link px-3"
					href="<c:url value='/video/search'/>"> <i
						class="bi bi-search me-1"></i> Search
				</a></li>
			</ul>

			<div class="d-flex align-items-center gap-2">
				<c:choose>
					<%-- LOGGED IN --%>
					<c:when test="${not empty sessionScope.user}">
						<div class="dropdown">
							<button
								class="btn btn-outline-light border-0 dropdown-toggle d-flex align-items-center gap-2"
								type="button" data-bs-toggle="dropdown">
								<img
									src="${not empty sessionScope.user.avatar ? sessionScope.user.avatar : 'https://ui-avatars.com/api/?name=' += sessionScope.user.fullname}"
									class="rounded-circle" width="30" height="30" alt="Avatar">
								<span class="small fw-bold">Hi,
									${sessionScope.user.fullname}</span>
							</button>

							<ul
								class="dropdown-menu dropdown-menu-end shadow animate__animated animate__fadeIn">
								<li><h6 class="dropdown-header text-success">My
										Account</h6></li>
								<li><a class="dropdown-item text-success"
									href="<c:url value='/account/profile'/>"><i
										class="bi bi-person-gear me-2"></i>My Profile</a></li>
								<li><a class="dropdown-item text-success"
									href="<c:url value='/account/favorites'/>"><i
										class="bi bi-box2-heart me-2"></i>My Favorites</a></li>

								<%-- ADMIN MENU --%>
								<c:if test="${sessionScope.user.admin}">
									<li><hr class="dropdown-divider"></li>
									<li><h6 class="dropdown-header text-primary">Administration</h6></li>

									<li><a class="dropdown-item text-primary"
										href="<c:url value='/admin/dashboard'/>"> <i
											class="bi bi-bar-chart me-2"></i>Dashboard
									</a></li>
									<li><a class="dropdown-item text-primary"
										href="<c:url value='/admin/users'/>"> <i
											class="bi bi-people-fill me-2"></i>Users Management
									</a></li>
									<li><a class="dropdown-item text-primary"
										href="<c:url value='/admin/video'/>"> <i
											class="bi bi-film me-2"></i>Videos Management
									</a></li>
								</c:if>

								<li><hr class="dropdown-divider"></li>
								<li><a class="dropdown-item text-danger"
									href="<c:url value='/logout'/>"><i
										class="bi bi-box-arrow-right me-2"></i>Log Out</a></li>
							</ul>
						</div>
					</c:when>

					<%-- GUEST --%>
					<c:otherwise>
						<a href="<c:url value='/login'/>"
							class="btn btn-outline-light btn-sm fw-bold px-3"><i
							class="bi bi-box-arrow-in-right me-2"></i> Login</a>
						<a href="<c:url value='/register'/>"
							class="btn btn-danger btn-sm fw-bold px-3"><i
							class="bi bi-pencil-square me-2"></i>Register</a>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</nav>