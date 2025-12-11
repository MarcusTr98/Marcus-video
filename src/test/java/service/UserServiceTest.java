package service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import dao.UserDAO;
import entity.UserEntity;
import utils.BCryptUtils;

class UserServiceTest {

	// Service cần test (Object thật)
	private UserServiceImpl userService;

	// DAO giả (Mock Object)
	@Mock
	private UserDAO userDAO;

	@BeforeEach
	void setUp() {
		// Khởi tạo Mockito
		MockitoAnnotations.openMocks(this);

		// Khởi tạo Service và tiêm DAO giả vào
		userService = new UserServiceImpl();
		userService.setUserDAO(userDAO);
	}

	@Test
	void testLogin_Success() {
		// 1. Giả lập dữ liệu
		String email = "test@gmail.com";
		String password = "123";
		String hashedPassword = BCryptUtils.hashPassword(password);

		UserEntity mockUser = new UserEntity();
		mockUser.setEmail(email);
		mockUser.setPassword(hashedPassword);
		mockUser.setAdmin(false);

		// 2. Dạy cho DAO giả: ai tìm email này, trả về mockUser
		when(userDAO.findByIdOrEmail(email)).thenReturn(mockUser);

		// 3. Gọi hàm login thật
		UserEntity result = userService.login(email, password);

		// 4. Kiểm tra kết quả - asser
		assertNotNull(result, "Đăng nhập đúng phải trả về User");
		assertEquals(email, result.getEmail());
	}

	@Test
	void testLogin_Fail_WrongPassword() {
		// 1. Giả lập user trong DB
		String email = "test@gmail.com";
		String realPassword = "123";
		String wrongPassword = "456";

		UserEntity mockUser = new UserEntity();
		mockUser.setEmail(email);
		mockUser.setPassword(BCryptUtils.hashPassword(realPassword));

		// 2. Dạy DAO giả
		when(userDAO.findByIdOrEmail(email)).thenReturn(mockUser);

		// 3. Gọi hàm login với mật khẩu sai
		UserEntity result = userService.login(email, wrongPassword);

		// 4. Kiểm tra: Kết quả phải là null
		assertNull(result, "Mật khẩu sai phải trả về null");
	}

	@Test
	void testLogin_Fail_UserNotFound() {
		String email = "notfound@gmail.com";

		// 2. Dạy DAO giả: Trả về null
		when(userDAO.findByIdOrEmail(email)).thenReturn(null);

		// 3. Gọi hàm
		UserEntity result = userService.login(email, "123");

		// 4. Kiểm tra
		assertNull(result, "Email không tồn tại phải trả về null");
	}
}