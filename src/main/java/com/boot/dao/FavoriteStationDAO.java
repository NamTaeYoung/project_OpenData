package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.boot.dto.FavoriteStationDTO;

@Mapper
public interface FavoriteStationDAO {
	int insertFavorite(FavoriteStationDTO dto);
    int upsertFavorite(FavoriteStationDTO dto);   // 선택
    int deleteFavorite(@Param("userId") String userId, @Param("stationName") String stationName);
    List<FavoriteStationDTO> selectFavoritesByUser(@Param("userId") String userId);
    FavoriteStationDTO selectFavoriteOne(@Param("userId") String userId, @Param("stationName") String stationName);

    List<FavoriteStationDTO> getFavoriteList(String user_id);
    
    // 관심지역 삭제
    int deleteFavoriteById(Long favoriteId);
}
