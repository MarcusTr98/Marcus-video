package dao;

import java.util.List;
import dto.VideoLikedInfo;
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

	// 4. Lấy dữ liệu chi tiết cho biểu đồ (Top Like)
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
}