package dao;

import java.util.List;

import entity.VideoEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.XJPA;

public class VideoDAOImpl extends AbstractDAO<VideoEntity, String> implements VideoDAO {

	public VideoDAOImpl() {
		super(VideoEntity.class);
	}

	@Override
	public List<VideoEntity> findByKeyword(String keyword) {
		EntityManager em = XJPA.getEntityManager();
		// SỬA ĐỔI: Sử dụng LEFT JOIN FETCH để tải favorite cùng với video
		String jpql = "SELECT o FROM VideoEntity o LEFT JOIN FETCH o.favorites f WHERE o.title LIKE :keyword";
		TypedQuery<VideoEntity> query = em.createQuery(jpql, VideoEntity.class);
		String search = "%" + keyword + "%";
		query.setParameter("keyword", search);
		List<VideoEntity> list = query.getResultList();
		try {
			return list;
		} finally {
			em.close();
		}
	}

	@Override
	public List<VideoEntity> findTop10Favorite() {
		EntityManager em = XJPA.getEntityManager();
		String jpql = "SELECT o.video FROM FavoriteEntity o GROUP BY o.video ORDER BY COUNT(o) DESC";
		TypedQuery<VideoEntity> query = em.createQuery(jpql, VideoEntity.class);
		query.setMaxResults(10);
		List<VideoEntity> list = query.getResultList();
		try {
			return list;
		} finally {
			em.close();
		}
	}

	@Override
	public List<VideoEntity> findListDontLike() {
		EntityManager em = XJPA.getEntityManager();
		String jpql = "SELECT o FROM VideoEntity o WHERE o.favorites IS EMPTY";
		TypedQuery<VideoEntity> query = em.createQuery(jpql, VideoEntity.class);
		List<VideoEntity> list = query.getResultList();
		try {
			return list;
		} finally {
			em.close();
		}
	}

	@Override
	public List<VideoEntity> findAll() {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT DISTINCT o FROM VideoEntity o LEFT JOIN FETCH o.favorites";

			TypedQuery<VideoEntity> query = em.createQuery(jpql, VideoEntity.class);
			return query.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public VideoEntity findById(String id) {
		EntityManager em = XJPA.getEntityManager();
		try {
			// Tìm video và nạp luôn danh sách người đã like (để hiển thị số like)
			String jpql = "SELECT o FROM VideoEntity o LEFT JOIN FETCH o.favorites WHERE o.id = :id";
			TypedQuery<VideoEntity> query = em.createQuery(jpql, VideoEntity.class);
			query.setParameter("id", id);
			return query.getSingleResult();
		} catch (Exception e) {
			return null;
		} finally {
			em.close();
		}
	}

	// phân trang
	@Override
	public List<VideoEntity> findAll(int page, int pageSize) {
		EntityManager em = XJPA.getEntityManager();
		try {
			TypedQuery<VideoEntity> query = em.createQuery("SELECT v FROM VideoEntity v", VideoEntity.class);
			query.setFirstResult((page - 1) * pageSize);
			query.setMaxResults(pageSize);
			return query.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public long count() {
		EntityManager em = XJPA.getEntityManager();
		try {
			return em.createQuery("SELECT COUNT(v) FROM VideoEntity v", Long.class).getSingleResult();
		} finally {
			em.close();
		}
	}

	@Override
	public List<VideoEntity> findByKeyword(String keyword, int page, int pageSize) {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT v FROM VideoEntity v WHERE v.title LIKE :keyword";
			TypedQuery<VideoEntity> query = em.createQuery(jpql, VideoEntity.class);
			query.setParameter("keyword", "%" + keyword + "%");
			query.setFirstResult((page - 1) * pageSize);
			query.setMaxResults(pageSize);
			return query.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public long countByKeyword(String keyword) {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT COUNT(v) FROM VideoEntity v WHERE v.title LIKE :keyword";
			TypedQuery<Long> query = em.createQuery(jpql, Long.class);
			query.setParameter("keyword", "%" + keyword + "%");
			return query.getSingleResult();
		} finally {
			em.close();
		}
	}

}