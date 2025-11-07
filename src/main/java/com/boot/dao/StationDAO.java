package com.boot.dao;

import java.util.List;

import com.boot.dto.StationDTO;
import com.boot.dto.StationListItem;

public interface StationDAO {
	StationDTO findByName(String stationName);

	void insert(StationDTO station); // 시퀀스 사용

	List<StationListItem> selectInBbox(double south, double west, double north, double east);
}
