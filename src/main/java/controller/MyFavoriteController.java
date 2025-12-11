package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import entity.UserEntity;
import entity.VideoEntity;
import dao.FavoriteDAO;
import dao.FavoriteDAOImpl;
import constant.SessionAttr;

@WebServlet("/account/favorites")
public class MyFavoriteController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private FavoriteDAO favDao = new FavoriteDAOImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		UserEntity user = (UserEntity) session.getAttribute(SessionAttr.CURRENT_USER);

		if (user != null) {
			List<VideoEntity> list = favDao.findAllByUserId(user.getId());
			req.setAttribute("videos", list);
			req.getRequestDispatcher("/views/favorites.jsp").forward(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/login");
		}
	}
}