package com.boot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.BoardAttachDTO;

@Mapper
public interface BoardAttachDAO {
    public int insertAttach(BoardAttachDTO dto);
    List<BoardAttachDTO> findByBoardNo(@Param("boardNo") Long boardNo);
}