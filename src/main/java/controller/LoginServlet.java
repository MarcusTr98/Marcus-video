package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.UserService;
import service.UserServiceImpl;
import utils.CookieUtils;

import java.io.IOException;

import entity.UserEntity;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();

	public LoginServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/views/login.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String idOrEmail = request.getParameter("idOrEmail");
		String password = request.getParameter("password");
		String remember = request.getParameter("remember");

		UserEntity user = userService.login(idOrEmail, password);

		if (user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("user", user);
			if (remember != null) {
				CookieUtils.add("username", idOrEmail, 24, response);
			} else {
				CookieUtils.add("username", "", 0, response);
			}

			String securityUri = (String) session.getAttribute("securityUri");
			if (securityUri != null) {
				session.removeAttribute("securityUri");
				response.sendRedirect(securityUri);
			} else {
				if (user.getAdmin()) {
					response.sendRedirect(request.getContextPath() + "/admin/dashboard");
				} else {
					response.sendRedirect(request.getContextPath() + "/home");
				}
			}
		} else {
			request.setAttribute("message", "Sai thông tin đăng nhập!");
			request.getRequestDispatcher("/views/login.jsp").forward(request, response);
		}
	}
}