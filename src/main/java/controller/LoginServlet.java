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
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import entity.UserEntity;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LogManager.getLogger(LoginServlet.class);
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
			//ghi log info ng đăng nhập thành công
			logger.info("User login success: " + user.getId() + " (" + user.getEmail() + ")");
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
			//ghi log warn đăng nhập sai
			logger.warn("Login failed for: " + idOrEmail);
			request.setAttribute("message", "Sai thông tin đăng nhập!");
			request.getRequestDispatcher("/views/login.jsp").forward(request, response);
		}
	}
}