package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import entity.HistoryEntity;
import entity.UserEntity;
import service.HistoryService;
import service.HistoryServiceImpl;

@WebServlet("/account/history")
public class HistoryController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HistoryService historyService = new HistoryServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		UserEntity user = (UserEntity) req.getSession().getAttribute("user");
		if (user != null) {
			List<HistoryEntity> historyList = historyService.findByUser(user.getId());
			req.setAttribute("histories", historyList);
			req.getRequestDispatcher("/views/history.jsp").forward(req, resp);
		} else {
			resp.sendRedirect(req.getContextPath() + "/login");
		}
	}
}