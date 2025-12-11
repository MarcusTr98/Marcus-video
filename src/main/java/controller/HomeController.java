package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import entity.VideoEntity;
import service.VideoService;
import service.VideoServiceImpl;

@WebServlet("/home")
public class HomeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private VideoService videoService = new VideoServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 1. Xác định trang hiện tại (Mặc định là 1)
		int page = 1;
		int pageSize = 6; // Hiển thị 6 video mỗi trang

		if (req.getParameter("page") != null) {
			try {
				page = Integer.parseInt(req.getParameter("page"));
			} catch (NumberFormatException e) {
				page = 1; // Nếu user nhập bậy (?page=abc) thì về trang 1
			}
		}

		// 2. Gọi Service lấy list và tổng số trang
		List<VideoEntity> list = videoService.findAll(page, pageSize);
		int totalPage = videoService.getTotalPage(pageSize);

		// 3. Đẩy ra JSP
		req.setAttribute("videos", list);
		req.setAttribute("currentPage", page);
		req.setAttribute("totalPage", totalPage);

		req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
	}
}