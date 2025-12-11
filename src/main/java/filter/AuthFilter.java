package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.UserService;
import service.UserServiceImpl;
import utils.CookieUtils;

import java.io.IOException;

import entity.UserEntity;

@WebFilter({ "/admin/*", "/api/video/like", "/api/video/share", "/account/*" })
public class AuthFilter extends HttpFilter implements Filter {
	private UserService userService = new UserServiceImpl();

	public AuthFilter() {
		super();
	}

	public void destroy() {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse resp = (HttpServletResponse) response;
		HttpSession session = req.getSession();
		String uri = req.getRequestURI();

		// 1. Lấy User từ Session
		UserEntity user = (UserEntity) session.getAttribute("user");

		// 2. AUTO LOGIN
		if (user == null) {
			String usernameInCookie = CookieUtils.get("username", req);
			if (usernameInCookie != null && !usernameInCookie.isEmpty()) {
				// Tìm user trong DB dựa vào cookie
				UserEntity userFromCookie = userService.findById(usernameInCookie);
				if (userFromCookie != null) {
					user = userFromCookie;
					session.setAttribute("user", user);
				}
			}
		}

		// 3. Kiểm tra đăng nhập (Sau khi đã check cả Session lẫn Cookie)
		if (user == null) {
			session.setAttribute("securityUri", uri);
			resp.sendRedirect(req.getContextPath() + "/login?message=PleaseLogin");
			return;
		}

		// 4. Phân quyền Admin
		if (uri.contains("/admin/") && !user.getAdmin()) {
			resp.sendRedirect(req.getContextPath() + "/home");
			return;
		}

		// 5. Hợp lệ -> Cho đi tiếp
		chain.doFilter(request, response);
	}

	public void init(FilterConfig fConfig) throws ServletException {
	}
}