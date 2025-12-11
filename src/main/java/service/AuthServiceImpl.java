package service;

import dao.UserDAO;
import dao.UserDAOImpl;
import entity.UserEntity;

public class AuthServiceImpl implements AuthService {
	private UserDAO userDAO;

	public AuthServiceImpl() {
		this.userDAO = new UserDAOImpl();
	}

	@Override
	public UserEntity login(String idOrEmail, String password) {
		// 1. Tìm user theo ID hoặc Email
		UserEntity user = userDAO.findByIdOrEmail(idOrEmail);

		// 2. Nếu không tìm thấy hoặc sai mật khẩu
		if (user == null || !user.getPassword().equals(password)) {
			return null;
		}

		// 3. Đăng nhập thành công -> Trả về user
		return user;
	}

}
