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

		// 1. Sinh mật khẩu ngẫu nhiên (Ví dụ: 6 số)
		String newPassword = String.valueOf((int) (Math.random() * 900000) + 100000);

		// 2. Cập nhật mật khẩu mới vào User
		user.setPassword(newPassword);
		userService.update(user);

		// 3. Gửi Email
		CompletableFuture.runAsync(() -> {
			try {
				EmailUtils.send(user, newPassword); // Gửi pass thô chưa hash
			} catch (Exception e) {
				e.printStackTrace();
			}
		});

		req.setAttribute("message", "Mật khẩu mới đã được gửi về email " + email + ". Vui lòng check cả hòm thư Spam.");
		req.getRequestDispatcher("/views/forgot-password.jsp").forward(req, resp);
	}
}