package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.BoardDTO;

@Mapper
public interface BoardDAO {

    // 목록 페이징
    List<BoardDTO> selectPage(@Param("offset") int offset,
                              @Param("size") int size);

    // 총 건수
    int countAll();

    // 단건 조회
    BoardDTO selectOne(@Param("boardNo") Long boardNo);

    // 등록
    int insert(BoardDTO dto);

    // 수정
    int update(BoardDTO dto);

    // 삭제
    int delete(@Param("boardNo") Long boardNo);

    // 조회수 +1
    int increaseHit(@Param("boardNo") Long boardNo);
    
    // 검색 + 페이징
    List<BoardDTO> searchPage(@Param("type") String type,
                              @Param("keyword") String keyword,
                              @Param("offset") int offset,
                              @Param("size") int size);

    // 검색 총건수
    int countSearch(@Param("type") String type,
                    @Param("keyword") String keyword);
    
    
}
