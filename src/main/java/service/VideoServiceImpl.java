package service;

import java.util.List;
import dao.FavoriteDAO;
import dao.FavoriteDAOImpl;
import dao.UserDAOImpl;
import dao.VideoDAO;
import dao.VideoDAOImpl;
import entity.FavoriteEntity;
import entity.UserEntity;
import entity.VideoEntity;

public class VideoServiceImpl implements VideoService {

	private VideoDAO videoDAO;
	private FavoriteDAO favoriteDAO;

	public VideoServiceImpl() {
		this.videoDAO = new VideoDAOImpl();
		this.favoriteDAO = new FavoriteDAOImpl();
	}

	@Override
	public VideoEntity findById(String id) {
		return videoDAO.findById(id);
	}

	@Override
	public List<VideoEntity> findAll(int page, int pageSize) {
		return videoDAO.findAll(page, pageSize);
	}

	@Override
	public int getTotalPage(int pageSize) {
		long count = videoDAO.count();
		return (int) Math.ceil((double) count / pageSize);
	}

	@Override
	public void increaseView(String id) {
		VideoEntity video = videoDAO.findById(id);
		if (video != null) {
			int currentViews = (video.getViews() == null) ? 0 : video.getViews();
			video.setViews(currentViews + 1);
			videoDAO.update(video);
		}
	}

	@Override
	public boolean toggleLike(String userId, String videoId) {
		FavoriteEntity existFav = favoriteDAO.findByUserAndVideo(userId, videoId);
		if (existFav == null) {
			VideoEntity video = videoDAO.findById(videoId);
			UserEntity user = new UserDAOImpl().findById(userId);
			if (user != null && video != null) {
				FavoriteEntity newFav = new FavoriteEntity();
				newFav.setVideo(video);
				newFav.setUser(user);
				newFav.setLikeDate(new java.util.Date());
				favoriteDAO.create(newFav);
				return true;
			}
			return false;
		} else {
			favoriteDAO.deleteById(existFav.getId());
			return false;
		}
	}

	@Override
	public int countLikes(String videoId) {
		return (int) favoriteDAO.countByVideoId(videoId);
	}

	@Override
	public List<VideoEntity> findByKeyword(String keyword) {
		return videoDAO.findByKeyword(keyword);
	}

	@Override
	public VideoEntity create(VideoEntity video) {
		return videoDAO.create(video);
	}

	@Override
	public VideoEntity update(VideoEntity video) {
		return videoDAO.update(video);
	}

	@Override
	public void deleteById(String id) {
		videoDAO.deleteById(id);

	}

	@Override
	public List<VideoEntity> findByKeyword(String keyword, int page, int pageSize) {
		return videoDAO.findByKeyword(keyword, page, pageSize);
	}

	@Override
	public int getTotalPageByKeyword(String keyword, int pageSize) {
		long count = videoDAO.countByKeyword(keyword);
		return (int) Math.ceil((double) count / pageSize);
	}

}