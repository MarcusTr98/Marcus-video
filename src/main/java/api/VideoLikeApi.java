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

@WebServlet("/api/video/like")
public class VideoLikeApi extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private VideoService videoService = new VideoServiceImpl();
	private ObjectMapper mapper = new ObjectMapper(); // Dùng để convert Object -> JSON

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public VideoLikeApi() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		// 1. Kiểm tra đăng nhập
		UserEntity user = (UserEntity) request.getSession().getAttribute("user");
		if (user == null) {
			response.setStatus(401); // Unauthorized
			return;
		}

		// 2. Lấy videoId từ tham số (Form Data hoặc JSON Body)
		String videoId = request.getParameter("id");

		if (videoId == null) {
			response.setStatus(400); // Bad Request
			return;
		}

		try {
			// 3. Gọi Service xử lý Like
			boolean isLiked = videoService.toggleLike(user.getId(), videoId);
			int totalLikes = videoService.countLikes(videoId);

			// 4. Trả về JSON
			VideoLikeDTO result = new VideoLikeDTO("success", totalLikes, isLiked);
			mapper.writeValue(response.getOutputStream(), result);

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(500);
		}
	}

}
