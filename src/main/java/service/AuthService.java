package service;

import entity.UserEntity;

public interface AuthService {
	UserEntity login(String idOrEmail, String password);
}
