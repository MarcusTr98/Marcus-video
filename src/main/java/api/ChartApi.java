package api;

import com.google.gson.Gson;
import dto.VideoLikedInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.StatsService;
import service.StatsServiceImpl;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/admin/chart/video-likes")
public class ChartApi extends HttpServlet {

	private static final long serialVersionUID = 1L;

	// Sử dụng Service thay vì gọi trực tiếp DAO
	private StatsService statsService = new StatsServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("application/json"); 
		resp.setCharacterEncoding("UTF-8");
		
		try {
			// 1. Gọi Service lấy list DTO
			List<VideoLikedInfo> data = statsService.findVideoLikedInfo();

			// 2. Convert List -> JSON bằng Gson
			Gson gson = new Gson();
			String jsonString = gson.toJson(data);

			// 3. Trả về Client
			resp.getWriter().write(jsonString);

		} catch (Exception e) {
			e.printStackTrace();
			resp.getWriter().write("{\"status\": " + "\"error\", \"message\": \"" + e.getMessage() + "\"}");
		}
	}
}