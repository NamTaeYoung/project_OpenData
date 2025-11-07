package com.boot.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.dao.FavoriteStationDAO;
import com.boot.dto.FavoriteStationDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FavoriteStationServiceImpl implements FavoriteStationService {

    private final FavoriteStationDAO favoriteDAO;

    @Override
    @Transactional
    public int add(FavoriteStationDTO dto) {
        return favoriteDAO.insertFavorite(dto);
    }

    @Override
    @Transactional
    public int upsert(FavoriteStationDTO dto) {
        return favoriteDAO.upsertFavorite(dto);
    }

    @Override
    @Transactional
    public int remove(String userId, String stationName) {
        return favoriteDAO.deleteFavorite(userId, stationName);
    }

    @Override
    @Transactional(readOnly = true)
    public List<FavoriteStationDTO> list(String userId) {
        return favoriteDAO.selectFavoritesByUser(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public FavoriteStationDTO get(String userId, String stationName) {
        if (stationName == null) return null;
        return favoriteDAO.selectFavoriteOne(userId, stationName);
    }

    @Override
    @Transactional
    public boolean toggle(FavoriteStationDTO dto) {
        // 방어코드: stationName/유저 필수
        if (dto == null || dto.getUserId() == null || dto.getStationName() == null) {
            throw new IllegalArgumentException("userId와 stationName은 필수입니다.");
        }

        FavoriteStationDTO found = favoriteDAO.selectFavoriteOne(dto.getUserId(), dto.getStationName());
        if (found != null) {
            // 이미 있으면 삭제 → 최종상태: 관심 해제
            favoriteDAO.deleteFavorite(dto.getUserId(), dto.getStationName());
            return false;
        } else {
            // 없으면 추가 → 최종상태: 관심 등록
            favoriteDAO.insertFavorite(dto);
            // 또는 최신 대기질 값까지 같이 갱신하고 싶으면 upsert 사용:
            // favoriteDAO.upsertFavorite(dto);
            return true;
        }
    }
}
