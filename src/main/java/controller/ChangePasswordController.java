package controller;

import java.io.IOException;
import constant.SessionAttr;
import entity.UserEntity;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.UserService;
import service.UserServiceImpl;
import utils.BCryptUtils;

@WebServlet("/account/change-password")
public class ChangePasswordController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService = new UserServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session != null && session.getAttribute(SessionAttr.CURRENT_USER) != null) {
			req.getRequestDispatcher("/views/change-password.jsp").forward(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/login");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute(SessionAttr.CURRENT_USER) == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}

		UserEntity currentUser = (UserEntity) session.getAttribute(SessionAttr.CURRENT_USER);
		String currentPass = req.getParameter("currentPass");
		String newPass = req.getParameter("newPass");
		String confirmPass = req.getParameter("confirmPass");
		String message = "";
		String error = "";

		try {
			UserEntity userInDb = userService.findById(currentUser.getId());

			if (!BCryptUtils.checkPassword(currentPass, userInDb.getPassword())) {
				error = "Mật khẩu hiện tại không đúng!";
			} else if (!newPass.equals(confirmPass)) {
				error = "Mật khẩu xác nhận không trùng khớp!";
			} else {
				userService.changePassword(currentUser.getId(), newPass);
				session.invalidate();
				resp.sendRedirect(req.getContextPath() + "/login?message=PassChanged");
				return;
			}
		} catch (Exception e) {
			e.printStackTrace();
			error = "Có lỗi xảy ra: " + e.getMessage();
		}

		req.setAttribute("message", message);
		req.setAttribute("error", error);
		req.getRequestDispatcher("/views/change-password.jsp").forward(req, resp);
	}
}