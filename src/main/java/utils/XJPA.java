package utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class XJPA {
	private static final Logger logger = LogManager.getLogger(XJPA.class);
	private static EntityManagerFactory factory;

	static {
		try {
			factory = Persistence.createEntityManagerFactory("Marcus_video");
			// Log thông báo (INFO)
			logger.info("Khởi tạo JPA EntityManagerFactory thành công!");
		} catch (Exception e) {
			// Log lỗi ERROR
			logger.error("CRITICAL: Không thể kết nối Database!", e);
			throw new RuntimeException(e);
		}
	}

	public static EntityManager getEntityManager() {
		return factory.createEntityManager();
	}
}