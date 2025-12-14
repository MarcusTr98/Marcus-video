package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import entity.UserEntity;
import entity.VideoEntity;
import service.VideoService;
import service.VideoServiceImpl;
import utils.VideoUtils;

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
		formVideo.setPoster("https://img.youtube.com/vi/ID-ytb/maxresdefault.jpg");
		formVideo.setViews(0);
		formVideo.setActive(true);

		// Nếu là Edit -> Fill dữ liệu cũ vào form
		if (path.contains("edit")) {
			try {
				String id = req.getPathInfo().substring(1); // Lấy ID sau dấu /
				formVideo = videoService.findById(id);
			} catch (Exception e) {
			}
		}

		// Phân trang & Load danh sách
		int page = 1;
		int pageSize = 7;
		try {
			if (req.getParameter("page") != null) {
				page = Integer.parseInt(req.getParameter("page"));
			}
		} catch (NumberFormatException e) {
			page = 1;
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

		// Lấy Admin ID an toàn - ghi log thao tác crud
		UserEntity admin = (UserEntity) req.getSession().getAttribute("user");
		String adminId = (admin != null) ? admin.getId() : "Unknown";

		// Lấy ID video từ form
		String rawId = req.getParameter("id");

		try {
			// --- CASE 1: DELETE ---
			if (path.contains("delete")) {
				videoService.deleteById(rawId);
				req.getSession().setAttribute("message", "Xóa video thành công!");
				logger.info("ACTION: DELETE_VIDEO | Admin: " + adminId + " | Target: " + rawId);
				resp.sendRedirect(req.getContextPath() + "/admin/video");
				return;
			}

			// --- CASE 2: CREATE / UPDATE ---
			VideoEntity video = new VideoEntity();
			BeanUtils.populate(video, req.getParameterMap());

			video.setActive(req.getParameter("active") != null);
			if (video.getViews() == null)
				video.setViews(0);

			// Extract Youtube ID chuẩn
			String realId = VideoUtils.extractVideoId(rawId);
			video.setId(realId);

			if (path.contains("create")) {
				// Check trùng ID
				if (videoService.findById(realId) != null) {
					req.setAttribute("error", "Video ID " + realId + " đã tồn tại!");
					req.setAttribute("video", video);
					doGet(req, resp);
					return;
				}

				videoService.create(video);
				req.getSession().setAttribute("message", "Thêm mới thành công!");
				logger.info("ACTION: CREATE_VIDEO | Admin: " + adminId + " | New ID: " + realId);

			} else if (path.contains("update")) {
				videoService.update(video);
				req.getSession().setAttribute("message", "Cập nhật thành công!");
				logger.info("ACTION: EDIT_VIDEO | Admin: " + adminId + " | Target: " + realId);
			}
			resp.sendRedirect(req.getContextPath() + "/admin/video");

		} catch (Exception e) {
			logger.error("Error in AdminVideoController | Path: " + path, e);
			req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
			doGet(req, resp);
		}
	}
}