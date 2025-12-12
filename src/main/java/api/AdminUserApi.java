package api;

import com.google.gson.JsonObject;
import entity.UserEntity;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.UserService;
import service.UserServiceImpl;
import java.io.IOException;

@WebServlet("/api/admin/user/status")
public class AdminUserApi extends HttpServlet {
    
    private UserService userService = new UserServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        JsonObject json = new JsonObject();

        try {
            // 1. Kiểm tra quyền Admin (Bảo mật)
            UserEntity currentUser = (UserEntity) req.getSession().getAttribute("user");
            if (currentUser == null || !currentUser.getAdmin()) {
                resp.setStatus(403);
                json.addProperty("status", "error");
                json.addProperty("message", "Bạn không có quyền thực hiện hành động này.");
                resp.getWriter().write(json.toString());
                return;
            }

            // 2. Lấy tham số
            String userId = req.getParameter("userId");
            // action: 'block' hoặc 'unblock'
            String action = req.getParameter("action"); 

            UserEntity targetUser = userService.findById(userId);
            if (targetUser == null) {
                json.addProperty("status", "error");
                json.addProperty("message", "User không tồn tại.");
            } else {
                // 3. Xử lý Logic
                boolean newStatus = "unblock".equals(action); // unblock -> true (active), block -> false
                
                // Không cho phép tự khóa chính mình
                if (targetUser.getId().equals(currentUser.getId())) {
                    throw new Exception("Không thể tự khóa tài khoản Admin của chính mình!");
                }

                targetUser.setIsActive(newStatus);
                userService.update(targetUser);

                json.addProperty("status", "success");
                json.addProperty("message", newStatus ? "Đã mở khóa tài khoản!" : "Đã khóa tài khoản!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("status", "error");
            json.addProperty("message", "Lỗi: " + e.getMessage());
        }

        resp.getWriter().write(json.toString());
    }
}