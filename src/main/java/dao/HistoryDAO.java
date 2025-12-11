package dao;

import java.util.List;
import entity.HistoryEntity;

public interface HistoryDAO extends DAO<HistoryEntity, Long> {
	HistoryEntity findByUserAndVideo(String userId, String videoId);

	List<HistoryEntity> findByUser(String userId);
}