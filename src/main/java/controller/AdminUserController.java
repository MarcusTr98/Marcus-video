package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import org.apache.commons.beanutils.BeanUtils;
import entity.UserEntity;
import service.UserService;
import service.UserServiceImpl;

@WebServlet({ "/admin/users", "/admin/user/create", "/admin/user/update", "/admin/user/delete", "/admin/user/edit/*",
		"/admin/user/reset" })
public class AdminUserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
		UserEntity formUser = new UserEntity();
		// Mặc định khi thêm mới là Active
		formUser.setIsActive(true);

		// 1. Logic Edit: Lấy thông tin user đổ lên form
		if (path.contains("edit")) {
			String id = req.getPathInfo(); // Lấy phần sau /edit
			if (id != null && id.length() > 1) {
				id = id.substring(1); // Bỏ dấu /
				formUser = userService.findById(id);
			}
		}

		// 2. Logic Phân trang
		int page = 1;
		int pageSize = 8; // Số lượng user mỗi trang
		try {
			if (req.getParameter("page") != null) {
				page = Integer.parseInt(req.getParameter("page"));
			}
		} catch (Exception e) {
			page = 1;
		}

		List<UserEntity> list = userService.findAll(page, pageSize);
		int totalPage = userService.getTotalPage(pageSize);

		// 3. Đẩy data ra JSP
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

		// A. Xử lý nút RESET (Làm mới form)
		if (path.contains("reset")) {
			resp.sendRedirect(req.getContextPath() + "/admin/users");
			return;
		}

		// B. Xử lý DELETE
		if (path.contains("delete")) {
			String id = req.getParameter("id");
			try {
				userService.deleteById(id);
				req.getSession().setAttribute("message", "Xóa tài khoản thành công!");
			} catch (Exception e) {
				req.getSession().setAttribute("error", "Không thể xóa: " + e.getMessage());
			}
			resp.sendRedirect(req.getContextPath() + "/admin/users");
			return;
		}

		// C. Xử lý CREATE / UPDATE
		UserEntity user = new UserEntity();
		try {
			// BeanUtils tự động map: id, fullname, email, admin, isActive...
			BeanUtils.populate(user, req.getParameterMap());

			if (path.contains("create")) {
				// Create: Bắt buộc hash pass mới
				userService.register(user);
				req.getSession().setAttribute("message", "Thêm mới thành công!");

			} else if (path.contains("update")) {
				// Lấy thông tin cũ từ DB lên để đối chiếu
				UserEntity oldUser = userService.findById(user.getId());
				// Kiểm tra logic password
				if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
					// Nếu admin không nhập pass mới -> Giữ nguyên pass cũ (đã hash)
					user.setPassword(oldUser.getPassword());
				} else {
					// Nếu có nhập pass mới -> Hash pass mới
					user.setPassword(utils.BCryptUtils.hashPassword(user.getPassword()));
				}
				userService.update(user);
				req.getSession().setAttribute("message", "Cập nhật thành công!");
			}
			resp.sendRedirect(req.getContextPath() + "/admin/users");

		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Lỗi: " + e.getMessage());
			req.setAttribute("user", user); // Giữ lại data để không phải nhập lại
			doGet(req, resp);
		}
	}
}