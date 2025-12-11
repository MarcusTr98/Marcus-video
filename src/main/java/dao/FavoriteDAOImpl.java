package dao;

import java.util.List;
import entity.FavoriteEntity;
import entity.VideoEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.XJPA;

public class FavoriteDAOImpl extends AbstractDAO<FavoriteEntity, Long> implements FavoriteDAO {

	public FavoriteDAOImpl() {
		super(FavoriteEntity.class);
	}

	@Override
	public List<FavoriteEntity> findAll() {
		EntityManager em = XJPA.getEntityManager();
		try {
			// Dùng JOIN FETCH để tránh N+1 query
			String jpql = "SELECT f FROM FavoriteEntity f JOIN FETCH f.user JOIN FETCH f.video";
			TypedQuery<FavoriteEntity> query = em.createQuery(jpql, FavoriteEntity.class);
			return query.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public List<FavoriteEntity> findByUserId(String userId) {
		EntityManager em = XJPA.getEntityManager();
		try {
			// Dùng JOIN FETCH f.video để tránh N+1 khi lặp
			String jpql = "SELECT f FROM FavoriteEntity f JOIN FETCH f.video WHERE f.user.id = :userId";
			TypedQuery<FavoriteEntity> query = em.createQuery(jpql, FavoriteEntity.class);
			query.setParameter("userId", userId);
			return query.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public FavoriteEntity findByUserAndVideo(String userId, String videoId) {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT o FROM FavoriteEntity o WHERE o.user.id = :uid AND o.video.id = :vid";
			TypedQuery<FavoriteEntity> query = em.createQuery(jpql, FavoriteEntity.class);
			query.setParameter("uid", userId);
			query.setParameter("vid", videoId);
			return query.getSingleResult();
		} catch (Exception e) {
			return null;
		} finally {
			em.close();
		}
	}

	@Override
	public long countByVideoId(String videoId) {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT COUNT(f) FROM FavoriteEntity f WHERE f.video.id = :videoId";
			TypedQuery<Long> query = em.createQuery(jpql, Long.class);
			query.setParameter("videoId", videoId);
			return query.getSingleResult();
		} finally {
			em.close();
		}
	}

	@Override
	public List<VideoEntity> findAllByUserId(String userId) {
		EntityManager em = XJPA.getEntityManager();
		try {
			// Join bảng Favorite sang Video để lấy VideoEntity
			String jpql = "SELECT f.video FROM FavoriteEntity f WHERE f.user.id = :userId";
			TypedQuery<VideoEntity> query = em.createQuery(jpql, VideoEntity.class);
			query.setParameter("userId", userId);
			return query.getResultList();
		} finally {
			em.close();
		}
	}
}