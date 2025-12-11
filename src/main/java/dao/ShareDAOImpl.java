package dao;

import java.util.List;

import entity.ShareEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.XJPA;

public class ShareDAOImpl extends AbstractDAO<ShareEntity, Long> implements ShareDAO {

	public ShareDAOImpl() {
		super(ShareEntity.class);
	}

	// 5. Tìm video được chia sẻ trong năm 2024 và sắp xếp theo thời gian
	@Override
	public List<ShareEntity> findShareInYear(int year) {
		EntityManager em = XJPA.getEntityManager();
		String jpql = "SELECT o FROM ShareEntity o WHERE YEAR(o.shareDate) = :year ORDER BY o.shareDate DESC";
		TypedQuery<ShareEntity> query = em.createQuery(jpql, ShareEntity.class);
		query.setParameter("year", year);
		List<ShareEntity> list = query.getResultList();
		try {
			return list;
		} finally {
			em.close();
		}
	}

	// 6. Xây dựng báo cáo tổng hợp lượt chia sẻ của từng video
	@Override
	public List<Object[]> findShareReport() {
		EntityManager em = XJPA.getEntityManager();
		String jpql = "SELECT o.video.title, COUNT(o), MIN(o.shareDate), MAX(o.shareDate) FROM ShareEntity o GROUP BY o.video.title";
		TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
		try {
			return query.getResultList();
		} finally {
			em.close();
		}
	}
}