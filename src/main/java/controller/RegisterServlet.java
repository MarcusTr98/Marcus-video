package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;
import service.UserServiceImpl;

import java.io.IOException;

import org.apache.commons.beanutils.BeanUtils;

import entity.UserEntity;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RegisterServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.getRequestDispatcher("/views/register.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		UserEntity user = new UserEntity();
		try {
			// 1. Map dữ liệu từ form vào Entity
			BeanUtils.populate(user, request.getParameterMap());

			// 2. Kiểm tra xác nhận mật khẩu (nếu cần xử lý phía server)
			String password = request.getParameter("password");
			String confirm = request.getParameter("confirmPassword");

			if (!password.equals(confirm)) {
				request.setAttribute("message", "Mật khẩu xác nhận không khớp!");
				request.setAttribute("user", user); // Giữ lại thông tin đã nhập
				request.getRequestDispatcher("/views/register.jsp").forward(request, response);
				return;
			}

			// 3. Gọi Service để tạo user
			// (Service cần check xem ID/Email đã tồn tại chưa)
			UserEntity createdUser = userService.register(user);

			if (createdUser != null) {
				// Thành công -> Chuyển sang login để đăng nhập
				request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
				request.getRequestDispatcher("/views/register.jsp").forward(request, response);

			} else {
				// Thất bại (ví dụ: trùng ID)
				request.setAttribute("message", "Đăng ký thất bại! Username hoặc Email đã tồn tại.");
				request.setAttribute("user", user);
				request.getRequestDispatcher("/views/register.jsp").forward(request, response);
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("message", "Lỗi hệ thống!");
			request.getRequestDispatcher("/views/register.jsp").forward(request, response);
		}
	}

}
