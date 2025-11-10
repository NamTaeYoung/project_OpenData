package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.NoticeBoardAttachDTO;

@Mapper
public interface NoticeBoardAttachDAO {

    /** ✅ 첨부파일 등록 */
    int insertAttach(NoticeBoardAttachDTO dto);

    /** ✅ 해당 공지글의 첨부파일 전체 조회 */
    List<NoticeBoardAttachDTO> findByNoticeNo(@Param("noticeNo") Long noticeNo);

    /** ✅ 단일 첨부파일 조회 */
    NoticeBoardAttachDTO findById(@Param("attachNo") Long attachNo);

    /** ✅ 첨부파일 삭제 */
    int delete(@Param("attachNo") Long attachNo);
}
