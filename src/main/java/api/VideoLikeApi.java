package api;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.VideoService;
import service.VideoServiceImpl;
import java.io.IOException;
import com.fasterxml.jackson.databind.ObjectMapper;
import dto.VideoLikeDTO;
import entity.UserEntity;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/video/like")
public class VideoLikeApi extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private VideoService videoService = new VideoServiceImpl();
	private ObjectMapper mapper = new ObjectMapper();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		// Tạo biến wrapper để trả lỗi nếu cần
		Map<String, Object> errorResp = new HashMap<>();

		// 1. Kiểm tra đăng nhập
		UserEntity user = (UserEntity) request.getSession().getAttribute("user");
		if (user == null) {
			response.setStatus(401);
			errorResp.put("status", "error");
			errorResp.put("message", "Bạn chưa đăng nhập");
			mapper.writeValue(response.getOutputStream(), errorResp); // GHI JSON RA
			return;
		}

		// 2. Lấy videoId
		String videoId = request.getParameter("id");
		if (videoId == null) {
			response.setStatus(400);
			errorResp.put("status", "error");
			errorResp.put("message", "Thiếu Video ID");
			mapper.writeValue(response.getOutputStream(), errorResp); // GHI JSON RA
			return;
		}

		try {
			// 3. Logic
			boolean isLiked = videoService.toggleLike(user.getId(), videoId);
			int totalLikes = videoService.countLikes(videoId);

			// 4. Success Response
			VideoLikeDTO result = new VideoLikeDTO("success", totalLikes, isLiked);
			mapper.writeValue(response.getOutputStream(), result);

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(500);
			errorResp.put("status", "error");
			errorResp.put("message", e.getMessage());
			mapper.writeValue(response.getOutputStream(), errorResp); // GHI JSON RA
		}
	}
}