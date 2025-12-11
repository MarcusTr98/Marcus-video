package dao;

import java.util.List;
import entity.HistoryEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import utils.XJPA;

public class HistoryDAOImpl extends AbstractDAO<HistoryEntity, Long> implements HistoryDAO {

	public HistoryDAOImpl() {
		super(HistoryEntity.class);
	}

	@Override
	public HistoryEntity findByUserAndVideo(String userId, String videoId) {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT h FROM HistoryEntity h WHERE h.user.id = :uid AND h.video.id = :vid";
			TypedQuery<HistoryEntity> query = em.createQuery(jpql, HistoryEntity.class);
			query.setParameter("uid", userId);
			query.setParameter("vid", videoId);
			return query.getSingleResult();
		} catch (NoResultException e) {
			return null;
		} finally {
			em.close();
		}
	}

	@Override
	public List<HistoryEntity> findByUser(String userId) {
		EntityManager em = XJPA.getEntityManager();
		try {
			// Sắp xếp viewDate DESC để video vừa xem hiện lên đầu
			String jpql = "SELECT h FROM HistoryEntity h WHERE h.user.id = :uid ORDER BY h.viewDate DESC";
			TypedQuery<HistoryEntity> query = em.createQuery(jpql, HistoryEntity.class);
			query.setParameter("uid", userId);
			return query.getResultList();
		} finally {
			em.close();
		}
	}
}