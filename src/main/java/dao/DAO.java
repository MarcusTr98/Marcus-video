package dao;

import java.util.List;

public interface DAO<T, ID> {

	T create(T entity);

	T update(T entity);

	void deleteById(ID id);

	T findById(ID id);

	List<T> findAll();
}