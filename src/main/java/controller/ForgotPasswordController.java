package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.CompletableFuture;

import entity.UserEntity;
import service.UserService;
import service.UserServiceImpl;
import utils.EmailUtils;
import utils.BCryptUtils;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = req.getParameter("email");
		UserEntity user = userService.findByEmail(email);

		if (user == null) {
			req.setAttribute("message", "Email không tồn tại trong hệ thống!");
			req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
			return;
		}

		// 1. Sinh mật khẩu ngẫu nhiên (dạng thô - Plain Text)
		String newPasswordRaw = String.valueOf((int) (Math.random() * 900000) + 100000);

		// 2. [QUAN TRỌNG] Mã hóa mật khẩu trước khi lưu vào DB
		String hashedPassword = BCryptUtils.hashPassword(newPasswordRaw);

		// 3. Cập nhật mật khẩu ĐÃ MÃ HÓA vào entity
		user.setPassword(hashedPassword);
		userService.update(user);

		// 4. Chuẩn bị nội dung Email (Gửi mật khẩu THÔ - newPasswordRaw)
		String subject = "MarcusVideo - Cấp lại mật khẩu mới";
		String content = "<div style='font-family: Arial, sans-serif; padding: 20px; border: 1px solid #ddd;'>"
				+ "<h2 style='color: #0d6efd;'>MarcusVideo Support</h2>" + "<p>Xin chào <b>" + user.getFullname()
				+ "</b>,</p>"
				+ "<p>Mật khẩu mới của bạn là: <b style='font-size: 20px; color: red; letter-spacing: 2px;'>"
				+ newPasswordRaw + "</b></p>"
				+ "<p>Vì lý do bảo mật, vui lòng đăng nhập và đổi lại mật khẩu này ngay lập tức.</p>"
				+ "<br><p>Trân trọng,<br>MarcusVideo Team</p>" + "</div>";

		// 5. Gửi Email (Bất đồng bộ)
		CompletableFuture.runAsync(() -> {
			try {
				EmailUtils.sendEmail(email, subject, content);
			} catch (Exception e) {
				e.printStackTrace();
			}
		});

		req.setAttribute("message", "Mật khẩu mới đã được gửi về email " + email + ".");
		req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
	}
}