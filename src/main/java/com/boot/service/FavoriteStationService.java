package com.boot.service;

import java.util.List;

import com.boot.dto.FavoriteStationDTO;

public interface FavoriteStationService {
    int add(FavoriteStationDTO dto);            // insert
    int upsert(FavoriteStationDTO dto);         // merge
    int remove(String userId, String station);  // delete
    List<FavoriteStationDTO> list(String userId);
    FavoriteStationDTO get(String userId, String station);
    boolean toggle(FavoriteStationDTO dto);
}
