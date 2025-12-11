# Marcus-video
Mini Project: MarcusVideo - Entertainment Online Platform
Mô tả: Nền tảng xem video trực tuyến tích hợp tương tác thời gian thực và quản trị nội dung.
Tech Stack:
Java 21, Jakarta EE 10 (Servlet, JSP), Hibernate 6.4 (JPA).
SQL Server, Maven, WebSocket, JavaMail, BCrypt.
Frontend: HTML5, Bootstrap 5, Fetch API (AJAX).

Điểm nhấn kỹ thuật (Key Highlights):
Architecture: Áp dụng mô hình Layered Architecture & Singleton Pattern quản lý kết nối Database hiệu quả.
Security: Xây dựng cơ chế Authentication/Authorization thủ công qua Servlet Filter (RBAC) và mã hóa mật khẩu BCrypt. Ngăn chặn SQL Injection bằng JPA Parameterized.
Real-time & Async: Phát triển tính năng Live Chat bằng WebSocket và xử lý gửi Email bất đồng bộ (Non-blocking) với CompletableFuture.
Performance: Tối ưu hiệu năng database bằng Server-side Pagination, Native Query (Random video) và giải quyết vấn đề N+1 / Lazy Loading trong Hibernate.
UX: Sử dụng Fetch API cho các tác vụ Like/Share video giúp tương tác mượt mà không reload trang.

Sử dụng IDE Spring tool suit.
