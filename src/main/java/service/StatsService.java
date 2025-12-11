package service;

import java.util.List;

import dto.VideoLikedInfo;

public interface StatsService {

	long countUsers();

	long countVideos();

	long countTotalLikes();

	List<VideoLikedInfo> findVideoLikedInfo();
}
