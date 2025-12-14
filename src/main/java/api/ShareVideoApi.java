package api;

import com.google.gson.JsonObject;
import utils.EmailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/video/share")
public class ShareVideoApi extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Cấu hình Tiếng Việt và JSON
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();

        try {
            // 2. Lấy tham số từ client gửi lên
            String emailTo = req.getParameter("email");
            String videoId = req.getParameter("videoId");

            // Validate backend (Chặn trường hợp client tắt JS)
            if (emailTo == null || emailTo.trim().isEmpty() || videoId == null) {
                jsonResponse.addProperty("status", "error");
                jsonResponse.addProperty("message", "Thông tin không hợp lệ.");
                resp.getWriter().write(jsonResponse.toString());
                return;
            }

            // 3. Tạo nội dung Email
            String videoLink = "http://localhost:8080/MarcusVideo/video?id=" + videoId;
            
            String subject = "MarcusVideo: Bạn đã nhận được một chia sẻ video thú vị!";
            String content = "<h3>Xin chào,</h3>"
                    + "<p>Một người bạn đã chia sẻ video này với bạn trên hệ thống MarcusVideo.</p>"
                    + "<p>Hãy click vào link bên dưới để xem ngay:</p>"
                    + "<a href='" + videoLink + "' style='background:blue; color:white; padding:10px; text-decoration:none;'>Xem Video Ngay</a>"
                    + "<p>Hoặc truy cập: " + videoLink + "</p>"
                    + "<br><p>Trân trọng,<br>MarcusVideo Team.</p>";

            // 4. Gọi hàm gửi Email
            EmailUtils.sendEmail(emailTo, subject, content);

            // 5. Trả về Success
            jsonResponse.addProperty("status", "success");
            
        } catch (Exception e) {
            e.printStackTrace();
            // Trả về Error nếu gửi mail thất bại
            jsonResponse.addProperty("status", "error");
            jsonResponse.addProperty("message", "Lỗi hệ thống gửi mail: " + e.getMessage());
        }

        // Ghi phản hồi về Client
        resp.getWriter().write(jsonResponse.toString());
    }
}