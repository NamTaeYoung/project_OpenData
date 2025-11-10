package com.boot.service;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.boot.dto.NoticeBoardAttachDTO;
import com.boot.dto.NoticeBoardDTO;

public interface NoticeBoardService {

    /** ✅ 공지 작성 (첨부파일 없이) */
    void write(NoticeBoardDTO dto);

    /** ✅ 공지 작성 (첨부파일 포함) */
    Long writeWithAttachments(NoticeBoardDTO dto, List<MultipartFile> files) throws IOException;

    /** ✅ 첨부파일 조회 */
    List<NoticeBoardAttachDTO> getAttachments(Long noticeNo);

    /** ✅ 단건 조회 (조회수 증가 여부 X) */
    NoticeBoardDTO find(Long noticeNo);

    /** ✅ 작성자 닉네임 조회 */
    String getNicknameByUserId(String userId);

    /** ✅ 페이지 목록 조회 */
    List<NoticeBoardDTO> getPage(int page, int size);

    /** ✅ 전체 공지 수 */
    int getTotalCount();

    /** ✅ 검색 + 페이징 */
    List<NoticeBoardDTO> getSearchPage(String type, String keyword, int page, int size);

    /** ✅ 검색 총 건수 */
    int getSearchTotalCount(String type, String keyword);

    /** ✅ 단건 조회 (조회수 증가 선택적) */
    NoticeBoardDTO getById(Long noticeNo, boolean increaseHit);

    /** ✅ 등록 */
    void create(NoticeBoardDTO dto);

    /** ✅ 수정 */
    void update(NoticeBoardDTO dto);

    /** ✅ 삭제 */
    void delete(Long noticeNo);

    /** ✅ 첨부 삭제 */
    void deleteAttachments(List<Long> attachNos);

    /** ✅ 첨부 추가 */
    void addAttachments(Long noticeNo, List<MultipartFile> files) throws IOException;
}
