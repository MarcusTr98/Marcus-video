package service;

import java.util.List;

import dto.VideoLikedInfo;
import dto.VideoStats;

public interface StatsService {

	long countUsers();

	long countVideos();

	long countTotalLikes();

	List<VideoLikedInfo> findVideoLikedInfo();

	List<VideoStats> findTopViews();

	List<VideoStats> findNewUsersStats();

	List<VideoStats> findVideoStatusStats();
}
