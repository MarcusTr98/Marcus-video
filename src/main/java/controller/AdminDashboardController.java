package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import service.StatsService;
import service.StatsServiceImpl;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private StatsService statsService = new StatsServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 1. Cards Tổng quan
		req.setAttribute("totalUsers", statsService.countUsers());
		req.setAttribute("totalVideos", statsService.countVideos());
		req.setAttribute("totalLikes", statsService.countTotalLikes());

		// 2. Dữ liệu Biểu đồ
		req.setAttribute("videoStats", statsService.findVideoLikedInfo()); // Top Like
		req.setAttribute("videoViews", statsService.findTopViews()); // Top View
		req.setAttribute("userStats", statsService.findNewUsersStats()); // New Users
		req.setAttribute("videoStatus", statsService.findVideoStatusStats()); // Status Pie Chart

		req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
	}
}