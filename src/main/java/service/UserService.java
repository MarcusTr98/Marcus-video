package service;

import java.util.List;
import entity.UserEntity;

public interface UserService {
	UserEntity login(String idOrEmail, String password);

	UserEntity register(UserEntity user);

	UserEntity findByEmail(String email);

	List<UserEntity> findAll(int page, int pageSize);

	UserEntity findById(String id);

	UserEntity create(UserEntity user);

	UserEntity update(UserEntity user);

	void deleteById(String id);

	int getTotalPage(int pageSize);
	
	void changePassword(String userId, String newPassword);
}