<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>${video.title}</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

	<jsp:include page="/views/common/navbar.jsp" />

	<div class="container py-4">
		<div class="row">
			<div class="col-lg-8">
				<div class="card shadow-sm border-0 mb-4">
					<div class="ratio ratio-16x9 bg-black">
						<div id="player"></div>
					</div>

					<div class="card-body">
						<h3 class="card-title fw-bold text-dark">${video.title}</h3>

						<div
							class="d-flex justify-content-between align-items-center mt-3">
							<div class="text-muted small">
								<i class="bi bi-eye-fill me-1"></i>
								<fmt:formatNumber value="${video.views}" />
								lượt xem <span class="mx-2">•</span> <span
									class="text-success fw-bold">Active</span>
							</div>

							<div class="btn-group">
								<button id="btnLike" class="btn btn-outline-danger"
									onclick="toggleLike('${video.id}')">
									<i class="bi bi-heart"></i> Thích <span id="likeCount">${video.favorites.size()}</span>
								</button>

								<button class="btn btn-outline-primary" data-bs-toggle="modal"
									data-bs-target="#shareModal">
									<i class="bi bi-share"></i> Chia sẻ
								</button>
							</div>
						</div>

						<hr>
						<h5 class="fw-bold">Mô tả</h5>
						<p class="text-secondary">${not empty video.description ? video.description : 'Chưa có mô tả cho video này.'}
						</p>
					</div>
				</div>

				<div class="card shadow-sm border-0 mt-4">
					<div
						class="card-header bg-white fw-bold d-flex justify-content-between align-items-center">
						<span><i class="bi bi-chat-dots-fill text-primary me-2"></i>Live
							Chat</span> <span class="badge bg-success rounded-pill" id="statusBadge">Online</span>
					</div>

					<div class="card-body p-3" id="chatBox"
						style="height: 300px; overflow-y: auto; background: #f8f9fa;">
						<div class="text-center text-muted small my-2">-- Bắt đầu
							cuộc trò chuyện --</div>
					</div>

					<div class="card-footer bg-white">
						<div class="input-group">
							<input type="text" id="chatInput" class="form-control border-0"
								placeholder="Nhập tin nhắn..." disabled>
							<button class="btn btn-primary" id="btnSend"
								onclick="sendMessage()" disabled>
								<i class="bi bi-send-fill"></i>
							</button>
						</div>
					</div>
				</div>
			</div>

			<div class="col-lg-4">
				<h5 class="fw-bold mb-3">Video đề xuất</h5>
				<div class="list-group shadow-sm">
					<c:forEach var="item" items="${relatedVideos}">
						<a href="<c:url value='/video?id=${item.id}'/>"
							class="list-group-item list-group-item-action d-flex gap-3 py-3"
							aria-current="true"> <img src="${item.poster}"
							alt="${item.title}" width="120" class="rounded flex-shrink-0"
							style="object-fit: cover; height: 70px;"
							onerror="this.src='https://placehold.co/120x70?text=No+Img'">

							<div class="d-flex gap-2 w-100 justify-content-between">
								<div>
									<h6 class="mb-0 fw-bold small text-truncate"
										style="max-width: 180px;">${item.title}</h6>
									<p class="mb-0 opacity-75 small text-muted">
										<i class="bi bi-eye-fill me-1"></i>${item.views} views
									</p>
								</div>
							</div>
						</a>
					</c:forEach>

					<c:if test="${empty relatedVideos}">
						<div class="p-3 text-center text-muted small">Không có video
							đề xuất nào.</div>
					</c:if>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="shareModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Chia sẻ video</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<div class="mb-3">
						<label class="form-label">Link Video:</label>
						<div class="input-group mb-2">
							<input type="text" class="form-control" id="shareLinkInput"
								readonly>
							<button class="btn btn-outline-secondary"
								onclick="copyToClipboard()">Copy</button>
						</div>

						<label class="form-label">Nhập email người nhận:</label> <input
							type="email" class="form-control" id="shareEmailInput"
							placeholder="friend@example.com">
						<div id="shareError" class="text-danger small mt-1"
							style="display: none;"></div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Đóng</button>
					<button type="button" class="btn btn-primary" id="btnConfirmShare"
						onclick="sendShareVideo()">
						<i class="bi bi-send"></i> Gửi ngay
					</button>
				</div>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

	<script>
        // --- 0. INIT SHARE LINK ---
        // Tự động điền link hiện tại vào modal share khi mở trang
        document.addEventListener("DOMContentLoaded", function() {
            const shareInput = document.getElementById('shareLinkInput');
            if(shareInput) shareInput.value = window.location.href;
        });

        // --- 1. LOGIC LIKE VIDEO ---
        function toggleLike(videoId) {
            const btn = document.getElementById('btnLike');
            const countSpan = document.getElementById('likeCount');
            const icon = btn.querySelector('i');
            const url = '<c:url value="/api/video/like" />';
            
            const params = new URLSearchParams();
            params.append('id', videoId);

            fetch(url, { method: 'POST', body: params })
            .then(response => {
                if (response.status === 401) {
                    alert('Vui lòng đăng nhập để thích video!');
                    window.location.href = '<c:url value="/login" />';
                    return;
                }
                return response.json();
            })
            .then(data => {
                if (data && data.status === 'success') {
                    countSpan.innerText = data.totalLikes;
                    if (data.isLiked) {
                        btn.classList.replace('btn-outline-danger', 'btn-danger');
                        icon.classList.replace('bi-heart', 'bi-heart-fill');
                    } else {
                        btn.classList.replace('btn-danger', 'btn-outline-danger');
                        icon.classList.replace('bi-heart-fill', 'bi-heart');
                    }
                }
            })
            .catch(err => console.error('Lỗi Like:', err));
        }

        // --- 2. LOGIC CHAT (WEBSOCKET) ---
        let websocket;
        const username = "${not empty sessionScope.user ? sessionScope.user.fullname : 'Khách'}";
        const isLoggedIn = ${not empty sessionScope.user};

        function connectWebSocket() {
            const protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
            const endpoint = protocol + window.location.host + "${pageContext.request.contextPath}/chat";
            
            console.log("Connecting to: " + endpoint);
            websocket = new WebSocket(endpoint);

            websocket.onopen = function(event) {
                console.log("Chat Connected!");
                updateChatStatus(true);
            };

            websocket.onmessage = function(event) {
                try {
                    const data = JSON.parse(event.data);
                    displayMessage(data.sender, data.content);
                } catch (e) {
                    console.log("Non-JSON message:", event.data);
                }
            };
            
            websocket.onclose = function(event) {
                console.log("Chat Disconnected!");
                updateChatStatus(false);
            };
        }

        function updateChatStatus(connected) {
            const badge = document.getElementById("statusBadge");
            const input = document.getElementById("chatInput");
            const btn = document.getElementById("btnSend");

            if (connected) {
                badge.className = "badge bg-success rounded-pill";
                badge.innerText = "Live";
                input.disabled = false;
                btn.disabled = false;
            } else {
                badge.className = "badge bg-danger rounded-pill";
                badge.innerText = "Offline";
                input.disabled = true;
                btn.disabled = true;
            }
        }

        function sendMessage() {
            const input = document.getElementById("chatInput");
            const content = input.value.trim();
            
            if (content !== "" && websocket && websocket.readyState === WebSocket.OPEN) {
                const message = { sender: username, content: content };
                websocket.send(JSON.stringify(message));
                input.value = "";
                input.focus();
            }
        }

        function displayMessage(sender, content) {
            const chatBox = document.getElementById("chatBox");
            const isMe = sender === username;
            
            const div = document.createElement("div");
            div.className = isMe ? "d-flex justify-content-end mb-2" : "d-flex justify-content-start mb-2";
            const bubbleColor = isMe ? "bg-primary text-white" : "bg-white text-dark border";
            
            div.innerHTML = `
                <div class="p-2 rounded shadow-sm \${bubbleColor}" style="max-width: 75%;">
                    <div class="small fw-bold opacity-75" style="font-size: 0.75rem;">\${sender}</div>
                    <div>\${content}</div>
                </div>
            `;
            
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        }

        // Init Chat
        document.addEventListener("DOMContentLoaded", function() {
            if (isLoggedIn) {
                connectWebSocket();
                document.getElementById("chatInput").addEventListener("keypress", function(e) {
                    if (e.key === "Enter") sendMessage();
                });
            } else {
                document.getElementById("chatInput").placeholder = "Vui lòng đăng nhập để chat!";
            }
        });

        // --- 3. YOUTUBE IFRAME API (Logic MỚI) ---
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        var player;
        function onYouTubeIframeAPIReady() {
            player = new YT.Player('player', {
                height: '100%',
                width: '100%',
                // LƯU Ý: Đảm bảo video.id ở đây là ID chuỗi của Youtube (vd: dQw4w9WgXcQ)
                // Nếu video.id trong DB là số, code này sẽ lỗi.
                videoId: '${video.id}', 
                playerVars: {
                    'playsinline': 1,
                    'autoplay': 1,
                    'rel': 0
                },
                events: {
                    'onStateChange': onPlayerStateChange
                }
            });
        }

        function onPlayerStateChange(event) {
            // 0 là trạng thái ENDED
            if (event.data === 0) {
                playNextVideo();
            }
        }

        function playNextVideo() {
            // Tìm video kế tiếp trong list group
            const nextVideoLink = document.querySelector('.list-group-item');
            if (nextVideoLink) {
                console.log("Auto playing next video...");
                window.location.href = nextVideoLink.href;
            } else {
                console.log("No related video found.");
            }
        }
        
     // --- 4. LOGIC SHARE VIDEO ---
        function sendShareVideo() {
            const emailInput = document.getElementById('shareEmailInput');
            const linkInput = document.getElementById('shareLinkInput');
            const btnSend = document.getElementById('btnConfirmShare');
            const errorDiv = document.getElementById('shareError');
            
            const email = emailInput.value.trim();
            const videoId = '${video.id}'; // Lấy ID video từ server side
            
            // Reset lỗi
            errorDiv.style.display = 'none';
            errorDiv.innerText = '';

            // Validate cơ bản
            if (!email) {
                errorDiv.innerText = 'Vui lòng nhập email người nhận!';
                errorDiv.style.display = 'block';
                return;
            }
            
            // Validate định dạng email (Regex đơn giản)
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                errorDiv.innerText = 'Email không hợp lệ!';
                errorDiv.style.display = 'block';
                return;
            }

            // Hiệu ứng Loading
            const originalText = btnSend.innerHTML;
            btnSend.disabled = true;
            btnSend.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang gửi...';

            // Gọi API (AJAX)
            const url = '<c:url value="/api/video/share" />';
            const params = new URLSearchParams();
            params.append('videoId', videoId);
            params.append('email', email);

            fetch(url, { method: 'POST', body: params })
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    alert('Đã gửi chia sẻ thành công!');
                    // Đóng modal
                    const modalEl = document.getElementById('shareModal');
                    const modal = bootstrap.Modal.getInstance(modalEl);
                    modal.hide();
                    // Xóa trắng ô email
                    emailInput.value = '';
                } else {
                    errorDiv.innerText = data.message || 'Có lỗi xảy ra, vui lòng thử lại!';
                    errorDiv.style.display = 'block';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                errorDiv.innerText = 'Lỗi kết nối Server!';
                errorDiv.style.display = 'block';
            })
            .finally(() => {
                // Trả lại trạng thái nút
                btnSend.disabled = false;
                btnSend.innerHTML = originalText;
            });
        }
    </script>
</body>
</html>