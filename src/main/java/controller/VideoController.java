package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import entity.UserEntity;
import entity.VideoEntity;
import service.HistoryService;
import service.HistoryServiceImpl;
import service.VideoService;
import service.VideoServiceImpl;

@WebServlet({ "/video", "/video/search" })
public class VideoController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private VideoService videoService = new VideoServiceImpl();
	private HistoryService historyService = new HistoryServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
		// 1. TRƯỜNG HỢP: TÌM KIẾM VIDEO (HOẶC XEM TẤT CẢ)
		if (path.contains("search")) {
			String keyword = req.getParameter("keyword");
			int page = 1;
			int pageSize = 6;
			// Xử lý tham số Page an toàn
			if (req.getParameter("page") != null) {
				try {
					page = Integer.parseInt(req.getParameter("page"));
				} catch (NumberFormatException e) {
					page = 1;
				}
			}

			List<VideoEntity> videos;
			int totalPage;
			// Logic: Có từ khóa -> Tìm kiếm. Không có -> Lấy tất cả.
			if (keyword != null && !keyword.trim().isEmpty()) {
				videos = videoService.findByKeyword(keyword, page, pageSize);
				totalPage = videoService.getTotalPageByKeyword(keyword, pageSize);
				req.setAttribute("keyword", keyword); // Gửi lại từ khóa để hiện trên ô input
			} else {
				videos = videoService.findAll(page, pageSize);
				totalPage = videoService.getTotalPage(pageSize);
				req.setAttribute("keyword", "");
			}
			req.setAttribute("videos", videos);
			req.setAttribute("currentPage", page);
			req.setAttribute("totalPage", totalPage);
			req.getRequestDispatcher("/views/find-video.jsp").forward(req, resp);
		}
		// 2. TRƯỜNG HỢP: XEM CHI TIẾT VIDEO
		else {
			String videoId = req.getParameter("id");

			if (videoId != null) {
				videoService.increaseView(videoId);
				VideoEntity video = videoService.findById(videoId);

				HttpSession session = req.getSession();
				UserEntity currentUser = (UserEntity) session.getAttribute("user");
				if (currentUser != null && video != null) {
					// lưu lịch sử nếu user đã đăng nhập
					historyService.create(currentUser, video);
				}
				
				if (video != null) {
					List<VideoEntity> relatedVideos = videoService.findAll(1, 3);
					req.setAttribute("video", video);
					req.setAttribute("relatedVideos", relatedVideos);
					req.getRequestDispatcher("/views/video-detail.jsp").forward(req, resp);
					return;
				}
			}
			resp.sendRedirect(req.getContextPath() + "/home");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}