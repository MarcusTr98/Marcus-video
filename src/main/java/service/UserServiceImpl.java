package service;

import java.util.List;
import dao.UserDAO;
import dao.UserDAOImpl;
import entity.UserEntity;
import utils.BCryptUtils;

public class UserServiceImpl implements UserService {

	private UserDAO userDAO;

	public UserServiceImpl() {
		this.userDAO = new UserDAOImpl();
	}
	
	public void setUserDAO(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

	@Override
	public UserEntity login(String idOrEmail, String password) {
		UserEntity user = userDAO.findByIdOrEmail(idOrEmail);
		if (user == null) {
			return null;
		}
		System.out.println("User Input Pass: " + password);
		System.out.println("DB Hash Pass: " + user.getPassword());
		if (BCryptUtils.checkPassword(password, user.getPassword())) {
			return user;
		}
		return null;
	}

	@Override
	public UserEntity register(UserEntity user) {
		if (userDAO.findById(user.getId()) != null)
			return null;
		if (userDAO.findByEmail(user.getEmail()) != null)
			return null;
		user.setPassword(BCryptUtils.hashPassword(user.getPassword()));
		user.setAdmin(false);
		return userDAO.create(user);
	}

	@Override
	public UserEntity findByEmail(String email) {
		return userDAO.findByEmail(email);
	}

	// --- ADMIN & CRUD ---

	@Override
	public List<UserEntity> findAll(int page, int pageSize) {
		return userDAO.findAll(page, pageSize);
	}

	@Override
	public int getTotalPage(int pageSize) {
		long count = userDAO.count();
		int totalPage = (int) Math.ceil((double) count / pageSize);
		return totalPage;
	}

	@Override
	public UserEntity findById(String id) {
		return userDAO.findById(id);
	}

	@Override
	public UserEntity create(UserEntity user) {
		if (userDAO.findById(user.getId()) != null) {
			throw new RuntimeException("ID người dùng đã tồn tại!");
		}
		user.setPassword(BCryptUtils.hashPassword(user.getPassword()));
		return userDAO.create(user);
	}

	@Override
	public UserEntity update(UserEntity entity) {
		if (!entity.getPassword().startsWith("$2a$")) {
			entity.setPassword(BCryptUtils.hashPassword(entity.getPassword()));
		}
		return userDAO.update(entity);
	}

	@Override
	public void deleteById(String id) {
		userDAO.deleteById(id);
	}

	@Override
	public void changePassword(String userId, String newPassword) {
		UserEntity user = userDAO.findById(userId);
		if (user != null) {
			String hash = BCryptUtils.hashPassword(newPassword);
			user.setPassword(hash);
			userDAO.update(user);
			System.out.println("Đã đổi mật khẩu DB thành công cho user: " + userId);
		}
	}
}