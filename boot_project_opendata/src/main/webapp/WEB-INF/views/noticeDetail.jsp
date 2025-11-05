<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>글쓰기 - 게시판</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/boardDetail.css">
</head>
<body>
  <!-- 헤더 & 네비 -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/main" class="brand">대기질 정보</a>
      <!-- 로그인 전/후 분기 -->
      <div class="nav-right">
        <c:choose>
          <%-- 로그인 전 --%>
          <c:when test="${empty sessionScope.loginDisplayName}">
            <a href="<c:url value='/login'/>">로그인</a>
            <a href="<c:url value='/register'/>">회원가입</a>
            <a href="<c:url value='/login?admin=true'/>">관리자정보</a>
          </c:when>
          <%-- 로그인 후 --%>
          <c:otherwise>
            <a href="<c:url value='/mypage'/>">마이페이지</a>
            <a href="<c:url value='/logout'/>">로그아웃</a>
            <span class="user-name">${sessionScope.loginDisplayName}님</span>
          </c:otherwise>
        </c:choose>
      </div>
    </nav>
  </header>

  <!-- 상단 프로모션 -->
  <div class="promo" role="note" aria-label="프로모션">
    <div class="promo-content">
      <div class="promo-nav">
        <a href="/main" class="nav-category">상세정보</a>
        <a href="/board/list" class="nav-board">게시판</a>
        <a href="/notice" class="nav-notice">공지사항</a>
        <a href="/qna" class="nav-qna">QnA</a>
      </div>
    </div>
  </div>

  <!-- 게시글 상세보기 -->
  <section class="write-section">
    <div class="write-container">
      <div class="write-header">
        <h1 class="write-title">📄 공지사항 상세보기</h1>
      </div>

      <form class="write-form readonly">
        <!-- 상단 정보 테이블 -->
        <table class="info-table">
          <tr>
            <th>번호</th>
            <td>${board.id}</td>
            <th>작성자</th>
            <td>${board.writer}</td>
          </tr>
          <tr>
            <th>작성일</th>
            <td>${board.regDate}</td>
            <th>조회수</th>
            <td>${board.hit}</td>
          </tr>
        </table>

        <!-- 제목 -->
        <div class="form-group">
          <label class="form-label">제목</label>
          <input type="text" class="form-input" value="${board.title}" readonly>
        </div>

        <!-- 내용 -->
        <div class="form-group">
          <label class="form-label">내용</label>
          <textarea class="form-textarea" readonly>${board.content}</textarea>
        </div>

        <!-- 첨부파일 -->
        <c:if test="${not empty board.fileName}">
          <div class="form-group">
            <label class="form-label">첨부파일</label>
            <a href="/board/download/${board.id}" style="color: var(--brand); text-decoration:none;">📎 ${board.fileName}</a>
          </div>
        </c:if>

        <!-- 버튼 -->
		<div class="form-actions">
		  <!-- 누구나 볼 수 있는 목록 버튼만 -->
		  <button type="button" class="btn btn-list" onclick="location.href='/notice'">목록</button>
		  <!-- 작성자 본인 또는 관리자일 때만 수정/삭제 버튼 표시 -->
		  <c:if test="${sessionScope.isAdmin or sessionScope.loginDisplayName eq board.writer}">
		    <button type="button" class="btn btn-edit" onclick="location.href='/board/edit/${board.id}'">수정</button>
		    <button type="button" class="btn btn-delete"
		            onclick="if(confirm('삭제하시겠습니까?')) location.href='/board/delete/${board.id}'">삭제</button>
		  </c:if>
		</div>
      </form>
    </div>
  </section>


  <!-- 푸터 -->
  <footer class="footer">
    <div class="footer-container">
      <div class="footer-brand">대기질 정보 시스템</div>
      <div class="footer-info">
        대기질 정보 시스템 | 데이터 출처: 공공데이터포털 (data.go.kr)<br>
        환경부 실시간 대기질 정보 제공<br>
        주소 : 부산시 부산진구 범내골
      </div>
      <div class="footer-links">
        <a href="#">이용약관</a>
        <a href="#">개인정보처리방침</a>
      </div>
    </div>
  </footer>
</body>
</html>


