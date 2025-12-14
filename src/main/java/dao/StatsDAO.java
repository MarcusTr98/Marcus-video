package dao;

import java.util.ArrayList;
import java.util.List;
import dto.VideoLikedInfo;
import dto.VideoStats;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.XJPA;

public class StatsDAO {

	// 1. Thống kê số lượng User
	public long countUsers() {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT COUNT(u) FROM UserEntity u";
			return em.createQuery(jpql, Long.class).getSingleResult();
		} catch (Exception e) {
			return 0;
		} finally {
			em.close();
		}
	}

	// 2. Thống kê số lượng Video
	public long countVideos() {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT COUNT(v) FROM VideoEntity v";
			return em.createQuery(jpql, Long.class).getSingleResult();
		} catch (Exception e) {
			return 0;
		} finally {
			em.close();
		}
	}

	// 3. Thống kê tổng số lượt Like toàn hệ thống
	public long countTotalLikes() {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT COUNT(f) FROM FavoriteEntity f";
			return em.createQuery(jpql, Long.class).getSingleResult();
		} catch (Exception e) {
			return 0;
		} finally {
			em.close();
		}
	}

	// biểu đồ Top Like
	public List<VideoLikedInfo> findVideoLikedInfo() {
		EntityManager em = XJPA.getEntityManager();
		try {
			// Query khớp với Constructor 4 tham số của DTO
			String jpql = "SELECT new dto.VideoLikedInfo(" + "v.title, " + // videoTitle
					"COUNT(f), " + // totalLikes
					"MAX(f.likeDate), " + // newestDate
					"MIN(f.likeDate)) " + // oldestDate
					"FROM VideoEntity v " + "JOIN v.favorites f " + "GROUP BY v.title " + "ORDER BY COUNT(f) DESC";
			TypedQuery<VideoLikedInfo> query = em.createQuery(jpql, VideoLikedInfo.class);
			return query.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			em.close();
		}
	}

	// biểu đồ top view
	public List<VideoStats> findTopViews() {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT new dto.VideoStats(v.title, CAST(v.views AS long)) " + "FROM VideoEntity v "
					+ "WHERE v.active = true " + "ORDER BY v.views DESC";
			return em.createQuery(jpql, VideoStats.class).setMaxResults(10).getResultList();
		} finally {
			em.close();
		}
	}

	// biểu đồ User đăng ký mới
	public List<VideoStats> findNewUsersStats() {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT new dto.VideoStats(CAST(u.createdDate as string), COUNT(u)) " + "FROM UserEntity u "
					+ "GROUP BY CAST(u.createdDate as string) " + "ORDER BY CAST(u.createdDate as string) ASC";
			return em.createQuery(jpql, VideoStats.class).setMaxResults(7).getResultList();
		} catch (Exception e) {
			return new ArrayList<>();
		} finally {
			em.close();
		}
	}

	// biểu đồ tỷ lệ Video Active/Inactive
	public List<VideoStats> findVideoStatusStats() {
		EntityManager em = XJPA.getEntityManager();
		try {
			// Trả về 'Active' và 'Inactive'
			String jpql = "SELECT new dto.VideoStats(" + "CASE WHEN v.active = true THEN 'Active' ELSE 'Inactive' END, "
					+ "COUNT(v)) " + "FROM VideoEntity v " + "GROUP BY v.active";

			return em.createQuery(jpql, VideoStats.class).getResultList();
		} finally {
			em.close();
		}
	}
}