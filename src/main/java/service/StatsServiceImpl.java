package service;

import java.util.List;

import dto.VideoLikedInfo;
import jakarta.persistence.EntityManager;
import utils.XJPA;

public class StatsServiceImpl implements StatsService {

	@Override
	public long countUsers() {
		EntityManager em = XJPA.getEntityManager();
		try {
			return em.createQuery("SELECT COUNT(u) FROM UserEntity u", Long.class).getSingleResult();
		} finally {
			em.close();
		}
	}

	@Override
	public long countVideos() {
		EntityManager em = XJPA.getEntityManager();
		try {
			return em.createQuery("SELECT COUNT(v) FROM VideoEntity v", Long.class).getSingleResult();
		} finally {
			em.close();
		}
	}

	@Override
	public long countTotalLikes() {
		EntityManager em = XJPA.getEntityManager();
		try {
			return em.createQuery("SELECT COUNT(f) FROM FavoriteEntity f", Long.class).getSingleResult();
		} finally {
			em.close();
		}
	}

	@Override
	public List<VideoLikedInfo> findVideoLikedInfo() {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT new dto.VideoLikedInfo(f.video.title, COUNT(f), MAX(f.likeDate), MIN(f.likeDate)) "
					+ "FROM FavoriteEntity f " + "GROUP BY f.video.title " + "ORDER BY COUNT(f) DESC";
			return em.createQuery(jpql, VideoLikedInfo.class).getResultList();
		} finally {
			em.close();
		}
	}

}
