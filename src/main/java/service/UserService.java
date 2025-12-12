package service;

import java.util.List;
import entity.UserEntity;

public interface UserService {
	UserEntity login(String idOrEmail, String password); // Trả về UserEntity thay vì boolean

	UserEntity register(UserEntity user);

	UserEntity findByEmail(String email);

	UserEntity findById(String id);

	// CRUD
	List<UserEntity> findAll(int page, int pageSize);

	int getTotalPage(int pageSize);

	UserEntity create(UserEntity user);

	UserEntity update(UserEntity entity);

	void deleteById(String id);

	void changePassword(String userId, String newPassword);
}