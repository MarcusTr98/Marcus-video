package dao;

import java.util.List;

import entity.VideoEntity;

public interface VideoDAO extends DAO<VideoEntity, String> {
	List<VideoEntity> findByKeyword(String keyword);

	List<VideoEntity> findTop10Favorite();

	List<VideoEntity> findListDontLike();

	List<VideoEntity> findAll(int page, int pageSize);

	long count();

	List<VideoEntity> findByKeyword(String keyword, int page, int pageSize);

	long countByKeyword(String keyword); // Đếm số kết quả tìm được để chia trang
}