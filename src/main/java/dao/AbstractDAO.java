package dao;

import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.XJPA;

public abstract class AbstractDAO<T, ID> implements DAO<T, ID> {

	private Class<T> entityClass;

	public AbstractDAO(Class<T> entityClass) {
		this.entityClass = entityClass;
	}

	@Override
	public T create(T entity) {
		EntityManager em = XJPA.getEntityManager();
		try {
			em.getTransaction().begin();
			em.persist(entity);
			em.getTransaction().commit();
			return entity;
		} catch (Exception e) {
			em.getTransaction().rollback();
			throw new RuntimeException("Create error for " + entityClass.getSimpleName(), e);
		} finally {
			em.close();
		}
	}

	@Override
	public T update(T entity) {
		EntityManager em = XJPA.getEntityManager();
		try {
			em.getTransaction().begin();
			T managedEntity = em.merge(entity);
			em.getTransaction().commit();
			return managedEntity;
		} catch (Exception e) {
			em.getTransaction().rollback();
			throw new RuntimeException("Update error for " + entityClass.getSimpleName(), e);
		} finally {
			em.close();
		}
	}

	@Override
	public void deleteById(ID id) {
		EntityManager em = XJPA.getEntityManager();
		try {
			T entity = em.find(entityClass, id);
			if (entity != null) {
				em.getTransaction().begin();
				em.remove(entity);
				em.getTransaction().commit();
			}
		} catch (Exception e) {
			em.getTransaction().rollback();
			throw new RuntimeException("Delete error for " + entityClass.getSimpleName() + " with id=" + id, e);
		} finally {
			em.close();
		}
	}

	@Override
	public T findById(ID id) {
		EntityManager em = XJPA.getEntityManager();
		try {
			return em.find(entityClass, id);
		} finally {
			em.close();
		}
	}

	@Override
	public List<T> findAll() {
		EntityManager em = XJPA.getEntityManager();
		try {
			String jpql = "SELECT o FROM " + entityClass.getSimpleName() + " o";
			TypedQuery<T> query = em.createQuery(jpql, entityClass);
			return query.getResultList();
		} finally {
			em.close();
		}
	}
}