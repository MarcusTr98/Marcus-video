package controller;

import java.io.IOException;
import constant.SessionAttr;
import entity.UserEntity;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.UserService;
import service.UserServiceImpl;
import utils.UploadUtils;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet("/account/profile")
public class ProfileController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session != null && session.getAttribute(SessionAttr.CURRENT_USER) != null) {
			// Reload lại user từ DB để đảm bảo dữ liệu mới nhất (tránh session cũ)
			UserEntity sessionUser = (UserEntity) session.getAttribute(SessionAttr.CURRENT_USER);
			UserEntity freshUser = userService.findById(sessionUser.getId());

			req.setAttribute("user", freshUser); // Đẩy user mới nhất ra view
			req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/login");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		HttpSession session = req.getSession(false);

		if (session == null || session.getAttribute(SessionAttr.CURRENT_USER) == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		// Lấy user hiện tại từ Session (Đây là đối tượng gốc, chứa đầy đủ id, password,
		// admin, date...)
		UserEntity currentUser = (UserEntity) session.getAttribute(SessionAttr.CURRENT_USER);

		try {
			// 1. Lấy dữ liệu CHO PHÉP SỬA
			String fullname = req.getParameter("fullname");
			String email = req.getParameter("email");
			// Lấy giới tính (true = Nam, false = Nữ)
			boolean gender = Boolean.parseBoolean(req.getParameter("gender"));

			// 2. Validate Email
			if (!email.equals(currentUser.getEmail()) && userService.findByEmail(email) != null) {
				req.setAttribute("error", "Email này đã được sử dụng bởi người khác!");
				req.setAttribute("user", currentUser);
				req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
				return;
			}

			// 3. Xử lý Upload Avatar
			String avatarPath = UploadUtils.processUploadField("avatarFile", req, "uploads");
			if (avatarPath != null) {
				currentUser.setAvatar(avatarPath);
			}

			// 4. Cập nhật các trường CHO PHÉP (Các trường khác như id, admin, createdDate
			// GIỮ NGUYÊN)
			currentUser.setFullname(fullname);
			currentUser.setEmail(email);
			currentUser.setGender(gender);

			// 5. Lưu xuống DB
			UserEntity updatedUser = userService.update(currentUser);

			// Cập nhật lại Session và View
			session.setAttribute(SessionAttr.CURRENT_USER, updatedUser);
			req.setAttribute("user", updatedUser); // Quan trọng: đẩy user mới ra để hiển thị
			req.setAttribute("message", "Cập nhật hồ sơ thành công!");

		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
			req.setAttribute("user", currentUser);
		}

		req.getRequestDispatcher("/views/profile.jsp").forward(req, resp);
	}
}