package dao;

import java.util.List;

import entity.ShareEntity;

public interface ShareDAO extends DAO<ShareEntity, Long> {
	List<ShareEntity> findShareInYear(int year);

	List<Object[]> findShareReport();
}