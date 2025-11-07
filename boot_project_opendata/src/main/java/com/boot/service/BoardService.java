package com.boot.service;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;

public interface BoardService {
    void write(BoardDTO dto);
    Long writeWithAttachments(BoardDTO dto, List<MultipartFile> files) throws IOException;
    List<BoardAttachDTO> getImages(Long boardNo); 
    BoardDTO find(Long boardNo);
    String getNicknameByUserId(String userId);
//    int getDisplayNo(Long boardNo);
    
    /** 페이지 목록 조회 */
    List<BoardDTO> getPage(int page, int size);

    /** 전체 게시글 수 */
    int getTotalCount();
    
    /** 검색 + 페이징 */
    List<BoardDTO> getSearchPage(String type, String keyword, int page, int size);

    /** 검색 총 건수 */
    int getSearchTotalCount(String type, String keyword);

    /** 단건 조회 (increaseHit=true면 조회수 +1) */
    BoardDTO getById(Long boardNo, boolean increaseHit);

    /** 등록 */
    void create(BoardDTO dto);

    /** 수정 */
    void update(BoardDTO dto);

    /** 삭제 */
    void delete(Long boardNo);
    void deleteAttachments(List<Long> attachNos);
    void addAttachments(Long boardNo, List<MultipartFile> files) throws IOException;
    
}
