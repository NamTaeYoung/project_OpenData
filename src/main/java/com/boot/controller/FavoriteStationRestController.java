package com.boot.controller;

import com.boot.dto.FavoriteStationDTO;
import com.boot.service.FavoriteStationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteStationRestController {

    private final FavoriteStationService favoriteService;

    /** 단건 조회: 존재 여부 확인용 */
    @GetMapping("/one")
    public ResponseEntity<?> getOne(
            @RequestParam String stationName,
            HttpSession session
    ) {
        String userId = (String) session.getAttribute("loginId");
        
        // ✅ 로그인 안 되어 있으면 exists=false 반환
        if (userId == null || userId.isBlank()) {
            return ResponseEntity.ok(Map.of(
                "success", true,
                "exists", false
            ));
        }

        FavoriteStationDTO dto = favoriteService.get(userId, stationName);
        boolean exists = (dto != null);

        return ResponseEntity.ok(Map.of(
                "success", true,
                "exists", exists
        ));
    }

    /** 토글(하트 클릭) */
    @PostMapping("/toggle")
    public ResponseEntity<?> toggle(
            @RequestBody FavoriteStationDTO payload,
            HttpSession session
    ) {
        String userId = (String) session.getAttribute("loginId");
        
        // ✅ 로그인 체크 - 로그인 안 되어 있으면 401 에러
        if (userId == null || userId.isBlank()) {
            return ResponseEntity.status(401).body(Map.of(
                "success", false,
                "error", "로그인이 필요합니다"
            ));
        }

        payload.setUserId(userId);
        boolean nowOn = favoriteService.toggle(payload);

        return ResponseEntity.ok(Map.of(
                "success", true,
                "favorited", nowOn
        ));
    }

    /** 유저별 목록 */
    @GetMapping
    public ResponseEntity<?> list(HttpSession session) {
        String userId = (String) session.getAttribute("loginId");
        
        if (userId == null || userId.isBlank()) {
            return ResponseEntity.status(401).body(Map.of(
                "success", false,
                "error", "로그인이 필요합니다"
            ));
        }
        
        return ResponseEntity.ok(Map.of(
                "success", true,
                "items", favoriteService.list(userId)
        ));
    }

    /** 삭제 (옵션) */
    @DeleteMapping
    public ResponseEntity<?> delete(
            @RequestParam String stationName,
            HttpSession session
    ) {
        String userId = (String) session.getAttribute("loginId");
        
        if (userId == null || userId.isBlank()) {
            return ResponseEntity.status(401).body(Map.of(
                "success", false,
                "error", "로그인이 필요합니다"
            ));
        }
        
        int cnt = favoriteService.remove(userId, stationName);
        return ResponseEntity.ok(Map.of("success", cnt > 0));
    }
}
