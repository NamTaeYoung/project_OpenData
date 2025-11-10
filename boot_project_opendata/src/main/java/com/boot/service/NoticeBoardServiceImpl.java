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

import com.boot.dao.NoticeBoardAttachDAO;
import com.boot.dao.NoticeBoardDAO;
import com.boot.dao.UserDAO;
import com.boot.dto.NoticeBoardAttachDTO;
import com.boot.dto.NoticeBoardDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class NoticeBoardServiceImpl implements NoticeBoardService {

    private final NoticeBoardDAO noticeDAO;
    private final NoticeBoardAttachDAO attachDAO;
    @Autowired
    private UserDAO userDAO;

    @Value("${file.upload-dir:${user.home}/uploads}")
    private String uploadDir;

    @Override
    public void write(NoticeBoardDTO dto) {
        noticeDAO.insert(dto);
    }

    @Override
    @Transactional
    public Long writeWithAttachments(NoticeBoardDTO dto, List<MultipartFile> files) throws IOException {
        // 첨부 없음 → 본문만 등록
        if (files == null || files.isEmpty() || files.get(0).isEmpty()) {
            noticeDAO.insert(dto);
            return dto.getNoticeNo();
        }

        // 날짜별 폴더 생성
        String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        File uploadFolder = new File(uploadDir, datePath);
        if (!uploadFolder.exists()) uploadFolder.mkdirs();

        // 공지 등록
        noticeDAO.insert(dto);
        Long noticeNo = dto.getNoticeNo();

        // 첨부 등록
        int sortOrder = 0;
        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;

            String originalName = StringUtils.cleanPath(file.getOriginalFilename());
            String uuid = UUID.randomUUID().toString();
            String savedName = uuid + "_" + originalName;

            File saveFile = new File(uploadFolder, savedName);
            file.transferTo(saveFile);

            String webPath = "/upload/" + datePath + "/" + savedName;

            NoticeBoardAttachDTO attachDTO = new NoticeBoardAttachDTO();
            attachDTO.setNoticeNo(noticeNo);
            attachDTO.setFileName(originalName);
            attachDTO.setFilePath(webPath);
            attachDTO.setUuid(uuid);
            attachDTO.setIsImage(file.getContentType() != null && file.getContentType().startsWith("image") ? "Y" : "N");
            attachDTO.setSortOrder(sortOrder++);

            attachDAO.insertAttach(attachDTO);
        }

        return noticeNo;
    }

    @Override
    public List<NoticeBoardAttachDTO> getAttachments(Long noticeNo) {
        return attachDAO.findByNoticeNo(noticeNo);
    }

    @Override
    public NoticeBoardDTO find(Long noticeNo) {
        return noticeDAO.find(noticeNo);
    }

    @Override
    public String getNicknameByUserId(String userId) {
        return userDAO.findNicknameByUserId(userId);
    }

    @Override
    public List<NoticeBoardDTO> getPage(int page, int size) {
        int safeSize = size <= 0 ? 10 : size;
        int safePage = page <= 0 ? 1 : page;
        int offset = (safePage - 1) * safeSize;
        return noticeDAO.selectPage(offset, safeSize);
    }

    @Override
    public int getTotalCount() {
        return noticeDAO.countAll();
    }

    @Override
    public List<NoticeBoardDTO> getSearchPage(String type, String keyword, int page, int size) {
        int safeSize = size <= 0 ? 10 : size;
        int safePage = page <= 0 ? 1 : page;
        int offset = (safePage - 1) * safeSize;
        return noticeDAO.searchPage(type, keyword, offset, safeSize);
    }

    @Override
    public int getSearchTotalCount(String type, String keyword) {
        return noticeDAO.countSearch(type, keyword);
    }

    @Override
    @Transactional
    public NoticeBoardDTO getById(Long noticeNo, boolean increaseHit) {
        if (noticeNo == null) {
            throw new IllegalArgumentException("noticeNo는 필수입니다.");
        }
        if (increaseHit) {
            noticeDAO.increaseHit(noticeNo);
        }
        return noticeDAO.selectOne(noticeNo);
    }

    @Override
    @Transactional
    public void create(NoticeBoardDTO dto) {
        if (dto == null) throw new IllegalArgumentException("공지 데이터가 비었습니다.");
        if (dto.getUserId() == null || dto.getUserId().isBlank()) {
            throw new IllegalArgumentException("작성자(userId)는 필수입니다.");
        }
        if (dto.getNoticeTitle() == null || dto.getNoticeTitle().isBlank()) {
            throw new IllegalArgumentException("제목(noticeTitle)은 필수입니다.");
        }
        if (dto.getNoticeContent() == null || dto.getNoticeContent().isBlank()) {
            throw new IllegalArgumentException("내용(noticeContent)은 필수입니다.");
        }
        noticeDAO.insert(dto);
    }

    @Override
    @Transactional
    public void update(NoticeBoardDTO dto) {
        if (dto == null || dto.getNoticeNo() == null) {
            throw new IllegalArgumentException("noticeNo는 필수입니다.");
        }
        noticeDAO.update(dto);
    }

    @Override
    @Transactional
    public void delete(Long noticeNo) {
        if (noticeNo == null) {
            throw new IllegalArgumentException("noticeNo는 필수입니다.");
        }
        noticeDAO.delete(noticeNo);
    }

    @Override
    @Transactional
    public void deleteAttachments(List<Long> attachNos) {
        for (Long attachNo : attachNos) {
            NoticeBoardAttachDTO file = attachDAO.findById(attachNo);
            if (file != null) {
                attachDAO.delete(attachNo);

                // 실제 파일 삭제
                File f = new File(file.getFilePath().replace("/upload", uploadDir));
                if (f.exists()) f.delete();

                // 썸네일 삭제
                if ("Y".equals(file.getIsImage()) && file.getThumbPath() != null) {
                    File thumb = new File(file.getThumbPath().replace("/upload", uploadDir));
                    if (thumb.exists()) thumb.delete();
                }
            }
        }
    }

    @Override
    @Transactional
    public void addAttachments(Long noticeNo, List<MultipartFile> files) throws IOException {
        if (files == null || files.isEmpty()) return;

        String datePath = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        File uploadFolder = new File(uploadDir, datePath);
        if (!uploadFolder.exists()) uploadFolder.mkdirs();

        int sortOrder = attachDAO.findByNoticeNo(noticeNo).size();

        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;

            String originalName = file.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String savedName = uuid + "_" + originalName;

            File saveFile = new File(uploadFolder, savedName);
            file.transferTo(saveFile);

            String webPath = "/upload/" + datePath + "/" + savedName;

            NoticeBoardAttachDTO attachDTO = new NoticeBoardAttachDTO();
            attachDTO.setNoticeNo(noticeNo);
            attachDTO.setFileName(originalName);
            attachDTO.setFilePath(webPath);
            attachDTO.setUuid(uuid);
            attachDTO.setIsImage(file.getContentType().startsWith("image") ? "Y" : "N");
            attachDTO.setSortOrder(sortOrder++);

            attachDAO.insertAttach(attachDTO);
        }
    }
}
