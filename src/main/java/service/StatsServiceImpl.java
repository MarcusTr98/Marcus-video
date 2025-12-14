package service;

import java.util.List;
import dao.StatsDAO;
import dto.VideoLikedInfo;
import dto.VideoStats;

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

	@Override
	public List<VideoStats> findTopViews() {
		return statsDAO.findTopViews();
	}

	@Override
	public List<VideoStats> findNewUsersStats() {
		return statsDAO.findNewUsersStats();
	}

	@Override
	public List<VideoStats> findVideoStatusStats() {
		return statsDAO.findVideoStatusStats();
	}

}