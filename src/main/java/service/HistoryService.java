package service;

import java.util.List;
import entity.HistoryEntity;
import entity.UserEntity;
import entity.VideoEntity;

public interface HistoryService {
	List<HistoryEntity> findByUser(String userId);

	boolean create(UserEntity user, VideoEntity video);
}