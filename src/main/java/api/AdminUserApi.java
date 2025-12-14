package api;

import com.google.gson.JsonObject;
import entity.UserEntity;
import service.UserService;
import service.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/admin/user/status")
public class AdminUserApi extends HttpServlet {

	// Điểm yếu: Nên dùng Dependency Injection nếu có thể.
	private UserService userService = new UserServiceImpl();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("application/json");
		resp.setCharacterEncoding("UTF-8");
		JsonObject json = new JsonObject();

		try {
			// 1. Lấy user hiện tại từ session
			UserEntity currentUser = (UserEntity) req.getSession().getAttribute("user");

			// Refactor #3: Nếu Filter chưa chặn, thì check null ở đây để tránh
			// NullPointerException
			// Nếu đã có Filter, dòng này là chốt chặn cuối cùng.
			if (currentUser == null) {
				resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
				json.addProperty("status", "error");
				json.addProperty("message", "Phiên đăng nhập đã hết hạn.");
				resp.getWriter().write(json.toString());
				return;
			}

			// 2. Lấy và Validate tham số
			String userIdRaw = req.getParameter("userId");
			String action = req.getParameter("action");

			if (userIdRaw == null || action == null) {
				throw new IllegalArgumentException("Thiếu tham số userId hoặc action.");
			}

			String targetUserId = userIdRaw;
			UserEntity targetUser = userService.findById(targetUserId);

			if (targetUser == null) {
				json.addProperty("status", "error");
				json.addProperty("message", "Người dùng không tồn tại.");
			} else {
				// 3. Logic nghiệp vụ: Không được tự khóa chính mình
				// So sánh ID (nên dùng equals cho Object)
				if (targetUser.getId().equals(currentUser.getId())) {
					json.addProperty("status", "error");
					json.addProperty("message", "Không thể tự khóa tài khoản Admin của chính mình!");
				} else {
					boolean newStatus = "unblock".equals(action); // unblock -> true (active), block -> false
					targetUser.setIsActive(newStatus);
					userService.update(targetUser);

					json.addProperty("status", "success");
					json.addProperty("message", newStatus ? "Đã mở khóa tài khoản!" : "Đã khóa tài khoản!");
				}
			}

		} catch (NumberFormatException e) {
			json.addProperty("status", "error");
			json.addProperty("message", "ID người dùng không hợp lệ.");
		} catch (Exception e) {
			e.printStackTrace(); // Log lỗi server
			json.addProperty("status", "error");
			json.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
		}

		resp.getWriter().write(json.toString());
	}
}