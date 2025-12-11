package service;

import java.util.Date;
import java.util.List;
import dao.HistoryDAO;
import dao.HistoryDAOImpl;
import entity.HistoryEntity;
import entity.UserEntity;
import entity.VideoEntity;

public class HistoryServiceImpl implements HistoryService {

	private HistoryDAO dao = new HistoryDAOImpl();

	@Override
	public List<HistoryEntity> findByUser(String userId) {
		return dao.findByUser(userId);
	}

	@Override
	public boolean create(UserEntity user, VideoEntity video) {
		// Kiểm tra xem user đã từng xem video này chưa
		HistoryEntity existHistory = dao.findByUserAndVideo(user.getId(), video.getId());

		if (existHistory == null) {
			// Chưa xem -> Tạo mới
			existHistory = new HistoryEntity();
			existHistory.setUser(user);
			existHistory.setVideo(video);
			existHistory.setViewDate(new Date());
			existHistory.setIsLiked(false);
			dao.create(existHistory);
			return true;
		} else {
			// Đã xem
			existHistory.setViewDate(new Date());
			dao.update(existHistory);
			return false;
		}
	}
}