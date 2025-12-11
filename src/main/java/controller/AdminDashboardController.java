package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import dto.VideoLikedInfo;
import service.StatsService;
import service.StatsServiceImpl;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private StatsService statsService = new StatsServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 1. Thống kê tổng quan (Summary Cards)
		req.setAttribute("totalUsers", statsService.countUsers());
		req.setAttribute("totalVideos", statsService.countVideos());
		req.setAttribute("totalLikes", statsService.countTotalLikes());

		// 2. Báo cáo Yêu thích (Top Video Liked)
		List<VideoLikedInfo> videoStats = statsService.findVideoLikedInfo();
		req.setAttribute("videoStats", videoStats);

		// 3. Báo cáo Chia sẻ
		// req.setAttribute("shareStats", statsService.findShareReport());

		// 4. Forward về giao diện Dashboard
		req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
	}
}