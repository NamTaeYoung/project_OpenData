package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.NoticeBoardDTO;

@Mapper
public interface NoticeBoardDAO {

    /** ✅ 공지 등록 */
    int insert(NoticeBoardDTO dto);

    /** ✅ 공지 단건 조회 */
    NoticeBoardDTO find(@Param("noticeNo") Long noticeNo);

    /** ✅ 방금 등록된 공지 PK 조회 */
    Long selectCurrNoticeNo();

    /** ✅ 목록 페이징 */
    List<NoticeBoardDTO> selectPage(@Param("offset") int offset,
                                    @Param("size") int size);

    /** ✅ 전체 건수 */
    int countAll();

    /** ✅ 단건 조회 (조회수 증가 X) */
    NoticeBoardDTO selectOne(@Param("noticeNo") Long noticeNo);

    /** ✅ 수정 */
    int update(NoticeBoardDTO dto);

    /** ✅ 삭제 */
    int delete(@Param("noticeNo") Long noticeNo);

    /** ✅ 조회수 +1 */
    int increaseHit(@Param("noticeNo") Long noticeNo);

    /** ✅ 검색 + 페이징 */
    List<NoticeBoardDTO> searchPage(@Param("type") String type,
                                    @Param("keyword") String keyword,
                                    @Param("offset") int offset,
                                    @Param("size") int size);

    /** ✅ 검색 총 건수 */
    int countSearch(@Param("type") String type,
                    @Param("keyword") String keyword);

    /** ✅ 특정 작성자(관리자)의 최근 공지 목록 */
    List<NoticeBoardDTO> selectByUserId(@Param("userId") String userId);
}
