package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import org.apache.commons.beanutils.BeanUtils;
import entity.VideoEntity;
import service.VideoService;
import service.VideoServiceImpl;
import utils.VideoUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@WebServlet({ "/admin/video", "/admin/video/create", "/admin/video/update", "/admin/video/delete",
		"/admin/video/edit/*", "/admin/video/reset" })
public class AdminVideoController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LogManager.getLogger(AdminVideoController.class);
	private VideoService videoService = new VideoServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String path = req.getServletPath();
		VideoEntity formVideo = new VideoEntity();
		formVideo.setPoster("https://placehold.co/600x400?text=Poster");
		formVideo.setViews(0);
		formVideo.setActive(true);

		if (path.contains("edit")) {
			String id = req.getPathInfo().substring(1);
			formVideo = videoService.findById(id);
		}
		// Reset
		else if (path.contains("reset")) {
		}

		// Phân trang
		int page = 1;
		int pageSize = 7;
		if (req.getParameter("page") != null) {
			try {
				page = Integer.parseInt(req.getParameter("page"));
			} catch (Exception e) {
				page = 1;
			}
		}
		List<VideoEntity> list = videoService.findAll(page, pageSize);
		int totalPage = videoService.getTotalPage(pageSize);
		req.setAttribute("video", formVideo);
		req.setAttribute("videos", list);
		req.setAttribute("currentPage", page);
		req.setAttribute("totalPage", totalPage);
		req.getRequestDispatcher("/views/admin/video.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String path = req.getServletPath();
		if (path.contains("delete")) {
			String id = req.getParameter("id");
			try {
				videoService.deleteById(id);
				req.getSession().setAttribute("message", "Xóa video thành công!");
			} catch (Exception e) {
				req.getSession().setAttribute("error", "Không thể xóa video (Có thể do ràng buộc dữ liệu)!");
			}
			resp.sendRedirect(req.getContextPath() + "/admin/video");
			return;
		}

		VideoEntity video = new VideoEntity();
		try {
			BeanUtils.populate(video, req.getParameterMap());

			// 1. Xử lý Active
			video.setActive(req.getParameter("active") != null);

			// 2. Xử lý Views tránh lỗi NullPointerException
			if (video.getViews() == null) {
				video.setViews(0);
			}

			// 3. Xử lý ID Youtube
			String rawId = req.getParameter("id");
			String realId = VideoUtils.extractVideoId(rawId);
			video.setId(realId);

			if (path.contains("create")) {
				VideoEntity existingVideo = videoService.findById(realId);
				if (existingVideo != null) {
					req.setAttribute("error", "Video ID " + realId + " đã tồn tại!");
					req.setAttribute("video", video);
					doGet(req, resp);
					return;
				}
				videoService.create(video);
				req.getSession().setAttribute("message", "Thêm mới thành công!");
			} else if (path.contains("update")) {
				videoService.update(video);
				req.getSession().setAttribute("message", "Cập nhật thành công!");
			}
			resp.sendRedirect(req.getContextPath() + "/admin/video");

		} catch (Exception e) {
			// e.printStackTrace();
			// ghi log lỗi
			logger.error("Error in AdminVideoController path: " + path, e);
			req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
			doGet(req, resp);
		}
	}
}