package dao;

import java.util.List;
import entity.UserEntity;

public interface UserDAO extends DAO<UserEntity, String> {
	UserEntity findByEmail(String email);

	UserEntity findByIdOrEmail(String idOrEmail);

	long count();

	List<UserEntity> findAll(int page, int pageSize);
}