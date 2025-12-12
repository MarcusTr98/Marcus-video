package service;

import java.util.List;
import dao.StatsDAO;
import dto.VideoLikedInfo;

public class StatsServiceImpl implements StatsService {

	private StatsDAO statsDAO;

	public StatsServiceImpl() {
		this.statsDAO = new StatsDAO();
	}

	@Override
	public long countUsers() {
		return statsDAO.countUsers();
	}

	@Override
	public long countVideos() {
		return statsDAO.countVideos();
	}

	@Override
	public long countTotalLikes() {
		return statsDAO.countTotalLikes();
	}

	@Override
	public List<VideoLikedInfo> findVideoLikedInfo() {
		return statsDAO.findVideoLikedInfo();
	}
}