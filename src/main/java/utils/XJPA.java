package utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class XJPA {
	private static EntityManagerFactory factory;
	static {
		try {
			factory = Persistence.createEntityManagerFactory("Marcus_video");
		} catch (Exception e) {
			throw new RuntimeException("Failed to init JPA: " + e.getMessage(), e);
		}
	}

	public static EntityManager getEntityManager() {
		return factory.createEntityManager();
	}
}
