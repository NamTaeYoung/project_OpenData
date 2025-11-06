package com.boot.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boot.dto.BoardDTO;
import com.boot.dao.UserDAO;
import com.boot.dto.BoardAttachDTO;
import com.boot.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/board")
public class BoardController {
	private final UserDAO userDAO;
    private final BoardService boardService;

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @GetMapping("/write")
    public String writeForm(HttpSession session, Model model) {
        String loginUserId = (String) session.getAttribute("loginId");
        String loginNickname = (String) session.getAttribute("loginDisplayNickName");


        model.addAttribute("nickname", loginNickname);
        log.info("@# nickname=>"+loginNickname);
        System.out.println("글쓰기 진입 아이디: " + session.getAttribute("loginId"));
        LocalDateTime now = LocalDateTime.now();
        Date nowDate = Date.from(now.atZone(ZoneId.systemDefault()).toInstant());
        model.addAttribute("now", nowDate);
        
        return "board/write";
    }

    /**
     * 게시글 작성 및 첨부 이미지 저장
     */
    @PostMapping("/write.do")
    public String write(@RequestParam String title,
                        @RequestParam String contents,
                        @RequestParam("images") List<MultipartFile> images,
                        HttpSession session,
                        Model model) throws IOException {

        String userId = (String) session.getAttribute("loginId");
//        if (userId == null) userId = "seowonhii12";

        BoardDTO dto = new BoardDTO();
        dto.setUserId(userId);
        System.out.println("BoardDTO에 저장된 userId: " + dto.getUserId());
        dto.setBoardTitle(title);
        dto.setBoardContent(contents.length() > 300 ? contents.substring(0, 300) : contents);

        // ✅ 서비스에서 게시글 + 첨부 저장
        Long boardNo = boardService.writeWithAttachments(dto, images);

        // ✅ 완료 후 write_done.jsp로 이동 → model 대신 redirect + boardNo 전달
        return "redirect:/board/detail?boardNo=" + boardNo;
    }

    /**
     * 작성완료 화면
     */
    @GetMapping("/detail")
    public String detail(@RequestParam("boardNo") Long boardNo, Model model) {
        BoardDTO post = boardService.find(boardNo);
        BoardDTO dto = boardService.getById(boardNo, true);
//        int displayNo = service.getDisplayNo(boardNo);
        List<BoardAttachDTO> attaches = boardService.getImages(boardNo);

        String nickname = userDAO.findNicknameByUserId(post.getUserId());

        // 날짜 변환: LocalDateTime → java.util.Date
        Date boardDate = null;
        if (post.getBoardDate() != null) {
            boardDate = Date.from(post.getBoardDate().atZone(ZoneId.systemDefault()).toInstant());
        }
        if (boardDate != null) {
            System.out.println(boardDate.getClass());
        }
        
        System.out.println(boardDate.getClass());
        model.addAttribute("post", post);
//        model.addAttribute("displayNo", displayNo);
        model.addAttribute("attaches", attaches);
        model.addAttribute("nickname", nickname != null ? nickname : "워니");
        model.addAttribute("boardDate", boardDate); // JSP에서 fmt:formatDate로 사용

        return "board/detail";
    }
    
    // ✅ 게시판 목록 + 페이징
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size,
                       @RequestParam(defaultValue = "tc") String type, // default search type
                       @RequestParam(defaultValue = "") String keyword, // empty string if no keyword
                       Model model) {
        List<BoardDTO> list;
        int total;

        if (keyword.isEmpty()) {
            // No keyword search
            list = boardService.getPage(page, size); 
            total = boardService.getTotalCount();
        } else {
            // Keyword search
            list = boardService.getSearchPage(type, keyword, page, size);
            total = boardService.getSearchTotalCount(type, keyword);
        }

        // Calculate total pages and start/end pageㅠ
        int pageCount = (int) Math.ceil(total / (double) size);
        int pageGroupSize = 5;
        int startPage = ((page - 1) / pageGroupSize) * pageGroupSize + 1;
        int endPage = Math.min(startPage + pageGroupSize - 1, pageCount);

        model.addAttribute("list", list);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total", total);
        model.addAttribute("pageCount", pageCount);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("type", type);

        return "board/list";
    }
}
