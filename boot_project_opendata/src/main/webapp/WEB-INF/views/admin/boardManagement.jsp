<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>게시판 - 대기질 정보</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/board.css">
</head>
<body>
  <!-- 헤더 & 네비 -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/adminMain" class="brand">대기질 정보</a>
      <!-- 로그인 전/후 분기 -->
      <div class="nav-right">
        <c:choose>
          <%-- 로그인 전 --%>
          <c:when test="${empty sessionScope.loginDisplayName}">
            <a href="<c:url value='/login'/>">로그인</a>
            <a href="<c:url value='/register'/>">회원가입</a>
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
        <a href="/adminMain" class="nav-category">상세정보</a>
        <a href="/boardManagement" class="nav-board">게시판관리</a>
        <a href="/noticeMangement" class="nav-notice">공지사항관리</a>
        <a href="/qnaMangement" class="nav-qna">QnA관리</a>
      </div>
    </div>
  </div>

  <!-- 게시판 섹션 -->
  <section class="board-section">
    <div class="board-container">
      <div class="board-header">
        <h1 class="board-title">게시판</h1>
      </div>

      <div class="board-table-wrapper">
        <table class="board-table">
          <thead>
            <tr>
              <th>번호</th>
              <th>제목</th>
              <th>작성자</th>
              <th>작성일</th>
              <th>조회수</th>
            </tr>
          </thead>
          <tbody>
            <%-- 백엔드 연동 시: <c:forEach> 태그로 데이터 표시 
            <c:forEach var="board" items="${boardList}">
              <tr>
                <td>${board.id}</td>
                <td>
                  <a href="/board/${board.id}">
                    ${board.title}
                    <c:if test="${not empty board.fileName}">
                      <span class="file-icon">📎</span>
                    </c:if>
                  </a>
                </td>
                <td>${board.writer}</td>
                <td>${board.regDate}</td>
                <td>${board.viewCount}</td>
              </tr>
            </c:forEach>
            --%>
            <!-- 데이터가 없을 때 -->
            <tr>
              <td colspan="5" class="empty-row">
                등록된 게시글이 없습니다.
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 검색 영역 -->
      <div class="board-search">
        <form method="get" action="/board" id="searchForm">
          <select name="searchType" style="padding: 12px; border: 2px solid #eee; border-radius: 12px; font-size: 14px; margin-right: 8px;">
            <option value="title">제목</option>
            <option value="content">내용</option>
            <option value="writer">작성자</option>
          </select>
          <input type="text" name="keyword" class="search-input" placeholder="검색어를 입력하세요" value="${param.keyword}">
          <button type="submit" class="search-btn">검색</button>
        </form>
      </div>

      <!-- 페이지네이션 -->
      <div class="pagination">
        <%-- 백엔드 연동 시: 페이지네이션 데이터 표시
        <c:if test="${pageInfo.hasPrev}">
          <a href="/board?page=${pageInfo.prevPage}">이전</a>
        </c:if>
        <c:forEach var="pageNum" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
          <c:choose>
            <c:when test="${pageNum == pageInfo.currentPage}">
              <span class="active">${pageNum}</span>
            </c:when>
            <c:otherwise>
              <a href="/board?page=${pageNum}">${pageNum}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>
        <c:if test="${pageInfo.hasNext}">
          <a href="/board?page=${pageInfo.nextPage}">다음</a>
        </c:if>
        --%>
        <span class="active">1</span>
      </div>
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

