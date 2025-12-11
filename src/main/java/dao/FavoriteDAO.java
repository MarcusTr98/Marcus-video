package dao;

import java.util.List;
import entity.FavoriteEntity;
import entity.VideoEntity;

public interface FavoriteDAO extends DAO<FavoriteEntity, Long> {
	List<FavoriteEntity> findByUserId(String userId);

	FavoriteEntity findByUserAndVideo(String userId, String videoId);

	long countByVideoId(String videoId);

	List<VideoEntity> findAllByUserId(String userId);
}