package service;

import java.util.List;

import entity.VideoEntity;

public interface VideoService {
	VideoEntity findById(String id);

	List<VideoEntity> findAll(int page, int pageSize);

	void increaseView(String id);

	boolean toggleLike(String userId, String videoId);

	int countLikes(String videoId);

	List<VideoEntity> findByKeyword(String keyword);

	VideoEntity create(VideoEntity video);

	VideoEntity update(VideoEntity video);

	void deleteById(String id);

	int getTotalPage(int pageSize);

	List<VideoEntity> findByKeyword(String keyword, int page, int pageSize);

	int getTotalPageByKeyword(String keyword, int pageSize);
}