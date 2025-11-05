package com.boot.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.dao.BoardDAO;
import com.boot.dto.BoardDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final BoardDAO boardDAO;

    @Override
    public List<BoardDTO> getPage(int page, int size) {
        int safeSize = size <= 0 ? 10 : size;
        int safePage = page <= 0 ? 1 : page;
        int offset = (safePage - 1) * safeSize;
        return boardDAO.selectPage(offset, safeSize);
    }

    @Override
    public int getTotalCount() {
        return boardDAO.countAll();
    }

    /** 🔍 검색 + 페이징 */
    @Override
    public List<BoardDTO> getSearchPage(String type, String keyword, int page, int size) {
        // Default size and page checks
        int safeSize = size <= 0 ? 10 : size;
        int safePage = page <= 0 ? 1 : page;
        int offset = (safePage - 1) * safeSize;

        // Ensure type and keyword are validated, if not null/empty
        return boardDAO.searchPage(type, keyword, offset, safeSize);
    }

    /** 🔍 검색 결과 전체 건수 */
    @Override
    public int getSearchTotalCount(String type, String keyword) {
        return boardDAO.countSearch(type, keyword);
    }

    @Override
    @Transactional // 조회수 증가와 조회를 하나의 트랜잭션으로
    public BoardDTO getById(Long boardNo, boolean increaseHit) {
        if (boardNo == null) {
            throw new IllegalArgumentException("boardNo는 필수입니다.");
        }
        if (increaseHit) {
            boardDAO.increaseHit(boardNo);
        }
        return boardDAO.selectOne(boardNo);
    }

    @Override
    @Transactional
    public void create(BoardDTO dto) {
        if (dto == null) throw new IllegalArgumentException("요청 본문이 비었습니다.");
        if (dto.getUserId() == null || dto.getUserId().isBlank()) {
            throw new IllegalArgumentException("작성자(userId)는 필수입니다.");
        }
        if (dto.getBoardTitle() == null || dto.getBoardTitle().isBlank()) {
            throw new IllegalArgumentException("제목(boardTitle)은 필수입니다.");
        }
        if (dto.getBoardContent() == null || dto.getBoardContent().isBlank()) {
            throw new IllegalArgumentException("내용(boardContent)은 필수입니다.");
        }
        boardDAO.insert(dto);
    }

    @Override
    @Transactional
    public void update(BoardDTO dto) {
        if (dto == null || dto.getBoardNo() == null) {
            throw new IllegalArgumentException("boardNo는 필수입니다.");
        }
        boardDAO.update(dto);
    }

    @Override
    @Transactional
    public void delete(Long boardNo) {
        if (boardNo == null) {
            throw new IllegalArgumentException("boardNo는 필수입니다.");
        }
        boardDAO.delete(boardNo);
    }
    

}
