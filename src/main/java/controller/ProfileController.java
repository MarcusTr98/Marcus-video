package controller;

import java.io.IOException;

import constant.SessionAttr; // Import class constant của bạn
import entity.UserEntity;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.UserService;
import service.UserServiceImpl;

@WebServlet("/account/profile")
public class ProfileController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session != null && session.getAttribute(SessionAttr.CURRENT_USER) != null) {
			UserEntity currentUser = (UserEntity) session.getAttribute(SessionAttr.CURRENT_USER);
			req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/login");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		HttpSession session = req.getSession(false);

		if (session != null && session.getAttribute(SessionAttr.CURRENT_USER) != null) {
			UserEntity currentUser = (UserEntity) session.getAttribute(SessionAttr.CURRENT_USER);
			String fullname = req.getParameter("fullname");
			String email = req.getParameter("email");

			try {
				// Check trùng Email: Nếu email thay đổi VÀ email mới đã tồn tại trong DB
				if (!email.equals(currentUser.getEmail()) && userService.findByEmail(email) != null) {
					req.setAttribute("error", "Email này đã được sử dụng bởi người khác!");
					req.setAttribute("user", currentUser); // Trả lại user cũ để fill vào form
					req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
					return;
				}
				currentUser.setFullname(fullname);
				currentUser.setEmail(email);
				UserEntity updatedUser = userService.update(currentUser);
				session.setAttribute(SessionAttr.CURRENT_USER, updatedUser);
				req.setAttribute("message", "Cập nhật hồ sơ thành công!");

			} catch (Exception e) {
				e.printStackTrace();
				req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
			}

			req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/login");
		}
	}
}