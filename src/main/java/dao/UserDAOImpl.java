package dao;

import java.util.List;

import entity.UserEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import utils.XJPA;

public class UserDAOImpl extends AbstractDAO<UserEntity, String> implements UserDAO {

	public UserDAOImpl() {
		super(UserEntity.class);
	}

	@Override
	public UserEntity findByEmail(String email) {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT o FROM UserEntity o WHERE o.email = :email";
			TypedQuery<UserEntity> query = em.createQuery(jpql, UserEntity.class);
			query.setParameter("email", email);
			return query.getSingleResult();
		} catch (NoResultException e) {
			return null;
		} finally {
			em.close();
		}
	}

	@Override
	public UserEntity findByIdOrEmail(String idOrEmail) {
		EntityManager em = XJPA.getEntityManager();

		try {
			String jpql = "SELECT o FROM UserEntity o WHERE o.id = :idOrEmail OR o.email = :idOrEmail";
			TypedQuery<UserEntity> query = em.createQuery(jpql, UserEntity.class);
			query.setParameter("idOrEmail", idOrEmail);
			return query.getSingleResult();
		} catch (NoResultException e) {
			return null;
		} catch (Exception e) {
			System.out.println("Lỗi DAO find By Id Or Email: " + e);
			return null;
		} finally {
			em.close();
		}
	}
	
	public List<UserEntity> findAll(int page, int pageSize) {
	    EntityManager em = XJPA.getEntityManager();
	    try {
	        String jpql = "SELECT u FROM UserEntity u";
	        TypedQuery<UserEntity> query = em.createQuery(jpql, UserEntity.class);
	        query.setFirstResult((page - 1) * pageSize); // Bỏ qua n dòng đầu
	        query.setMaxResults(pageSize); // Chỉ lấy n dòng tiếp theo
	        return query.getResultList();
	    } finally {
	        em.close();
	    }
	}

	public long count() {
	    EntityManager em = XJPA.getEntityManager();
	    try {
	        String jpql = "SELECT COUNT(u) FROM UserEntity u";
	        return em.createQuery(jpql, Long.class).getSingleResult();
	    } finally {
	        em.close();
	    }
	}

}
