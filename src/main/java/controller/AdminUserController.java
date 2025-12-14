package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import entity.UserEntity;
import service.UserService;
import service.UserServiceImpl;
import utils.BCryptUtils;

@WebServlet({ "/admin/users", "/admin/user/create", "/admin/user/update", "/admin/user/delete", "/admin/user/edit/*",
		"/admin/user/reset" })
public class AdminUserController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// Thêm Logger
	private static final Logger logger = LogManager.getLogger(AdminUserController.class);
	private UserService userService = new UserServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
		UserEntity formUser = new UserEntity();

		// Default values cho form thêm mới
		formUser.setIsActive(true);
		formUser.setGender(true); // Default Nam
		formUser.setAvatar("https://placehold.co/150?text=Avatar"); // Ảnh mặc định

		// 1. Logic Edit
		if (path.contains("edit")) {
			String id = req.getPathInfo();
			if (id != null && id.length() > 1) {
				id = id.substring(1);
				try {
					formUser = userService.findById(id);
				} catch (Exception e) {
					logger.error("Lỗi tìm user ID: " + id, e);
				}
			}
		}

		// 2. Logic Phân trang
		int page = 1;
		int pageSize = 6; // Giảm xuống 6 để vừa màn hình hơn vì bảng nhiều cột
		try {
			if (req.getParameter("page") != null) {
				page = Integer.parseInt(req.getParameter("page"));
			}
		} catch (Exception e) {
			page = 1;
		}

		List<UserEntity> list = userService.findAll(page, pageSize);
		int totalPage = userService.getTotalPage(pageSize);

		req.setAttribute("user", formUser);
		req.setAttribute("users", list);
		req.setAttribute("currentPage", page);
		req.setAttribute("totalPage", totalPage);

		req.getRequestDispatcher("/views/admin/user.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String path = req.getServletPath();

		// Lấy thông tin người thực hiện để ghi log (Audit)
		UserEntity adminAction = (UserEntity) req.getSession().getAttribute("user");
		String adminId = (adminAction != null) ? adminAction.getId() : "Unknown";

		// A. Xử lý DELETE
		if (path.contains("delete")) {
			String id = req.getParameter("id");
			try {
				// Không cho phép tự xóa chính mình
				if (id.equals(adminId)) {
					req.getSession().setAttribute("error", "Không thể tự xóa tài khoản đang đăng nhập!");
				} else {
					userService.deleteById(id);
					req.getSession().setAttribute("message", "Xóa tài khoản thành công!");
					logger.info("ADMIN: " + adminId + " | DELETED User: " + id);
				}
			} catch (Exception e) {
				logger.error("Error deleting user", e);
				req.getSession().setAttribute("error", "Không thể xóa: " + e.getMessage());
			}
			resp.sendRedirect(req.getContextPath() + "/admin/users");
			return;
		}

		if (path.contains("reset")) {
			resp.sendRedirect(req.getContextPath() + "/admin/users");
			return;
		}

		// B. Xử lý CREATE / UPDATE
		UserEntity user = new UserEntity();
		try {
			// Populate dữ liệu cơ bản
			BeanUtils.populate(user, req.getParameterMap());

			// Xử lý thủ công các trường Boolean/Radio để đảm bảo chính xác
			user.setGender(Boolean.parseBoolean(req.getParameter("gender")));
			user.setAdmin(Boolean.parseBoolean(req.getParameter("admin")));
			user.setIsActive(Boolean.parseBoolean(req.getParameter("isActive")));

			if (path.contains("create")) {
				// Check trùng ID
				if (userService.findById(user.getId()) != null) {
					req.setAttribute("error", "ID " + user.getId() + " đã tồn tại!");
					req.setAttribute("user", user);
					doGet(req, resp); // Reload lại trang kèm lỗi
					return;
				}

				// Mã hóa mật khẩu
				user.setPassword(BCryptUtils.hashPassword(user.getPassword()));

				userService.register(user);
				req.getSession().setAttribute("message", "Thêm User mới thành công!");
				logger.info("ADMIN: " + adminId + " | CREATED User: " + user.getId());

			} else if (path.contains("update")) {
				UserEntity oldUser = userService.findById(user.getId());

				// Logic Password: Nếu bỏ trống thì giữ nguyên pass cũ
				if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
					user.setPassword(oldUser.getPassword());
				} else {
					user.setPassword(BCryptUtils.hashPassword(user.getPassword()));
				}

				userService.update(user);
				req.getSession().setAttribute("message", "Cập nhật User thành công!");
				logger.info("ADMIN: " + adminId + " | UPDATED User: " + user.getId());
			}
			resp.sendRedirect(req.getContextPath() + "/admin/users");

		} catch (Exception e) {
			logger.error("Error Create/Update user", e);
			req.setAttribute("error", "Lỗi: " + e.getMessage());
			req.setAttribute("user", user);
			doGet(req, resp);
		}
	}
}