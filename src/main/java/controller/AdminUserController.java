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

		// 1. Logic Edit
		if (path.contains("edit")) {
			String id = req.getPathInfo().substring(1);
			formUser = userService.findById(id);
		}

		// 2. Logic Phân trang (Pagination)
		int page = 1;
		int pageSize = 8;
		if (req.getParameter("page") != null) {
			page = Integer.parseInt(req.getParameter("page"));
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

		// Xử lý riêng cho Delete (Vì delete thường chỉ gửi ID, không gửi cả form)
		if (path.contains("delete")) {
			String id = req.getParameter("id");
			userService.deleteById(id);
			req.getSession().setAttribute("message", "Xóa thành công!");
			resp.sendRedirect(req.getContextPath() + "/admin/users");
			return;
		}

		// Xử lý Create/Update
		UserEntity user = new UserEntity();
		try {
			BeanUtils.populate(user, req.getParameterMap());
			boolean isAdmin = Boolean.parseBoolean(req.getParameter("admin"));
			user.setAdmin(isAdmin);

			if (path.contains("create")) {
				userService.register(user); // Đã có hash password
			} else if (path.contains("update")) {
				// Lưu ý: UserServiceImpl.update cần check nếu pass rỗng thì giữ pass cũ
				userService.update(user);
			}
			resp.sendRedirect(req.getContextPath() + "/admin/users");
		} catch (Exception e) {
			e.printStackTrace();
			req.setAttribute("error", "Lỗi: " + e.getMessage());
			doGet(req, resp);
		}
	}
}