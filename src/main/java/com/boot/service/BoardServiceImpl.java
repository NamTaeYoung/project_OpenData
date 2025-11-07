package com.boot.service;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.boot.dao.BoardAttachDAO;
import com.boot.dao.BoardDAO;
import com.boot.dao.UserDAO;
import com.boot.dto.BoardAttachDTO;
import com.boot.dto.BoardDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class BoardServiceImpl implements BoardService {

    private final BoardDAO boardDAO;          // ← 필드명/타입 정확히
    private final BoardAttachDAO attachDAO;
    @Autowired
    private UserDAO userDAO;
    
    @Value("${file.upload-dir:${user.home}/uploads}")
    private String uploadDir;

    @Override
    public void write(BoardDTO dto) {
        boardDAO.insert(dto);
    }

    @Override
    @Transactional
    public Long writeWithAttachments(BoardDTO dto, List<MultipartFile> files) throws IOException {
        // 첨부 없으면 글만 저장
        if (files == null || files.isEmpty() || files.get(0).isEmpty()) {
            boardDAO.insert(dto);
            return dto.getBoardNo(); // selectKey로 세팅됨
        }

        // 날짜별 폴더
        String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        File uploadFolder = new File(uploadDir, datePath);
        if (!uploadFolder.exists()) uploadFolder.mkdirs();

        // 글 저장 (boardNo 생성)
        boardDAO.insert(dto);
        Long boardNo = dto.getBoardNo();

        // 첨부 저장
        int sortOrder = 0;
        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;

            String originalName = StringUtils.cleanPath(file.getOriginalFilename());
            String uuid = UUID.randomUUID().toString();
            String savedName = uuid + "_" + originalName;

            File saveFile = new File(uploadFolder, savedName);
            file.transferTo(saveFile);

            String webPath = "/upload/" + datePath + "/" + savedName;

            BoardAttachDTO attachDTO = new BoardAttachDTO();
            attachDTO.setBoardNo(boardNo);
            attachDTO.setFileName(originalName);
            attachDTO.setFilePath(webPath);
            attachDTO.setUuid(uuid);
            attachDTO.setIsImage(file.getContentType() != null
                                 && file.getContentType().startsWith("image") ? "Y" : "N");
            attachDTO.setSortOrder(sortOrder++); // 대표=0

            attachDAO.insertAttach(attachDTO);
        }

        return boardNo;
    }

    @Override
    public List<BoardAttachDTO> getImages(Long boardNo) {
        return attachDAO.findByBoardNo(boardNo);
    }

    @Override
    public BoardDTO find(Long boardNo) {     // ← 누락되어 있던 메서드 구현
        return boardDAO.find(boardNo);
    }
    @Override
    public String getNicknameByUserId(String userId) {
        return userDAO.findNicknameByUserId(userId);
    }
//    @Override
//    public int getDisplayNo(Long boardNo) {
//        return boardDAO.selectDisplayNo(boardNo);
//    }
    
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
