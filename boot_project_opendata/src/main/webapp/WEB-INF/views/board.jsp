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
  <style>
    :root{
      --brand: #2c5f8d;
      --brand-dark: #1e4261;
      --text: #1c1c1c;
      --muted: #686868;
      --bg: #ffffff;
      --card: #f7f7f7;
      --radius: 18px;
      --shadow: 0 10px 30px rgba(0,0,0,.08);
      --section-bg: #f8f9fa;
    }
    *{box-sizing:border-box}
    html,body{height:100%}
    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      color: var(--text);
      background: var(--bg);
      line-height: 1.5;
    }
    /* 헤더 */
    header{ position:sticky; top:0; z-index:50; background:#fff; border-bottom:1px solid #eee; }
    .nav{
      max-width:1100px; margin:0 auto;
      padding:14px 20px;
      display:flex; align-items:center; justify-content:space-between; gap:12px;
    }
    .brand{
      font-weight:800; letter-spacing:.08em;
      color:var(--brand); text-decoration:none;
      display:flex; align-items:center; gap:.6rem;
    }
    .brand::before{
      content:""; width:22px; height:22px; border-radius:6px;
      background: linear-gradient(135deg, var(--brand), var(--brand-dark));
      box-shadow: 0 6px 14px rgba(44,95,141,.35) inset;
      display:inline-block;
    }
    .nav-right{ display:flex; align-items:center; gap:18px; font-size:.95rem; }
    .nav-right a{ color:#333; text-decoration:none; }
    .nav-right a:hover{ color:var(--brand-dark) }
    .nav-right .user-name{ color:#666; font-weight:700; }

    /* 상단 프로모션 바 */
    .promo{
      background: var(--brand);
      padding: 0;
      position: relative;
      z-index: 6;
    }
    .promo-content{
      max-width: 1100px;
      margin: 0 auto;
      height: 50px;
      display: flex;
      justify-content: center;
      align-items: center;
      position: relative;
    }
    .promo-nav{
      display: flex;
      align-items: center;
      gap: 80px;
    }
    .promo-nav a{
      display: inline-flex;
      align-items: center;
      padding: 0;
      border-radius: 0;
      color: #fff;
      text-decoration: none;
      font-family: 'Noto Sans KR', sans-serif;
      font-weight: 400;
      font-size: clamp(18px, 2.2vw, 20px);
      letter-spacing: .02em;
      position: relative;
      transition: color .2s ease;
    }
    .promo-nav a::after{
      content: "";
      position: absolute;
      left: 0; right: 0; bottom: -10px;
      height: 3px;
      background: #fff;
      border-radius: 3px;
      transform: scaleX(0);
      transform-origin: 50% 100%;
      transition: transform .25s ease;
      opacity: .95;
    }
    .promo-nav a:hover::after{ transform: scaleX(1); }
    .promo-nav a.active::after{ transform: scaleX(1); }
    .promo-nav a + a::before{
      content: "";
      position: absolute;
      left: -40px;
      top: 50%;
      width: 2px;
      height: 26px;
      background: rgba(255,255,255,.65);
      transform: translateY(-50%);
      border-radius: 2px;
    }
    @media (max-width: 720px){
      .promo-content{ height: 56px; }
      .promo-nav{ gap: 48px; }
      .promo-nav a{ font-weight: 700; font-size: 18px; }
      .promo-nav a + a::before{ left: -24px; height: 20px; }
    }
    .promo-nav a:hover { background: rgba(255,255,255,0.1); }

    /* 게시판 메인 */
    .board-section {
      padding: 60px 0;
      background: var(--section-bg);
      min-height: calc(100vh - 200px);
    }
    .board-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 20px;
    }
    .board-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
    }
    .board-title {
      font-size: clamp(24px, 3vw, 32px);
      font-weight: 700;
      color: var(--text);
      margin: 0;
    }
    .write-btn {
      padding: 12px 24px;
      background: var(--brand);
      color: #fff;
      border: none;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: all .3s ease;
    }
    .write-btn:hover {
      background: var(--brand-dark);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(44,95,141,.3);
    }

    /* 게시판 테이블 */
    .board-table-wrapper {
      background: #fff;
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow: hidden;
    }
    .board-table {
      width: 100%;
      border-collapse: collapse;
    }
    .board-table thead {
      background: var(--brand);
      color: #fff;
    }
    .board-table th {
      padding: 18px 16px;
      text-align: left;
      font-weight: 600;
      font-size: 15px;
    }
    .board-table th:nth-child(1) { width: 10%; }
    .board-table th:nth-child(2) { width: 50%; }
    .board-table th:nth-child(3) { width: 15%; }
    .board-table th:nth-child(4) { width: 15%; }
    .board-table th:nth-child(5) { width: 10%; }
    .board-table tbody tr {
      border-bottom: 1px solid #eee;
      transition: background .2s ease;
    }
    .board-table tbody tr:hover {
      background: #f8f9fa;
    }
    .board-table td {
      padding: 16px;
      font-size: 14px;
      color: var(--text);
    }
    .board-table td a {
      color: var(--text);
      text-decoration: none;
      display: block;
      transition: color .2s ease;
    }
    .board-table td a:hover {
      color: var(--brand);
    }
    .file-icon {
      display: inline-block;
      margin-left: 8px;
      color: var(--muted);
      font-size: 12px;
    }
    .empty-row {
      text-align: center;
      padding: 60px 20px;
      color: var(--muted);
    }

    /* 검색 영역 */
    .board-search {
      display: flex;
      gap: 12px;
      margin-top: 30px;
      justify-content: center;
    }
    .search-input {
      padding: 12px 20px;
      border: 2px solid #eee;
      border-radius: 12px;
      font-size: 14px;
      outline: none;
      transition: all .3s ease;
      width: 300px;
    }
    .search-input:focus {
      border-color: var(--brand);
      box-shadow: 0 0 0 3px rgba(44,95,141,.1);
    }
    .search-btn {
      padding: 12px 24px;
      background: var(--brand);
      color: #fff;
      border: none;
      border-radius: 12px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all .3s ease;
    }
    .search-btn:hover {
      background: var(--brand-dark);
      transform: translateY(-2px);
    }

    /* 페이지네이션 */
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      margin-top: 40px;
    }
    .pagination a,
    .pagination span {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 40px;
      height: 40px;
      border-radius: 8px;
      text-decoration: none;
      color: var(--text);
      font-size: 14px;
      transition: all .2s ease;
    }
    .pagination a:hover {
      background: var(--section-bg);
      color: var(--brand);
    }
    .pagination .active {
      background: var(--brand);
      color: #fff;
    }

    /* 푸터 */
    .footer { background:#000; color:#fff; padding:60px 0 30px; }
    .footer-container { max-width:1100px; margin:0 auto; padding:0 20px; }
    .footer-brand { font-size:32px; font-weight:800; margin-bottom:20px; color:var(--brand); }
    .footer-info { font-size:14px; line-height:1.8; margin-bottom:30px; opacity:.8; }
    .footer-links { display:flex; gap:30px; margin-top:20px; }
    .footer-links a { color:#fff; text-decoration:none; opacity:.8; }
    .footer-links a:hover { opacity:1; }

    /* 반응형 */
    @media (max-width: 768px){
      .board-header {
        flex-direction: column;
        gap: 20px;
        align-items: flex-start;
      }
      .board-table {
        font-size: 12px;
      }
      .board-table th,
      .board-table td {
        padding: 12px 8px;
      }
      .board-table th:nth-child(3),
      .board-table th:nth-child(4),
      .board-table td:nth-child(3),
      .board-table td:nth-child(4) {
        display: none;
      }
      .board-table th:nth-child(1) { width: 15%; }
      .board-table th:nth-child(2) { width: 70%; }
      .board-table th:nth-child(5) { width: 15%; }
      .search-input {
        width: 100%;
      }
      .board-search {
        flex-direction: column;
      }
    }
  </style>
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
        <a href="/board" class="nav-board active">게시판</a>
        <a href="/notice" class="nav-notice">공지사항</a>
        <a href="/qna" class="nav-qna">QnA</a>
      </div>
    </div>
  </div>

  <!-- 게시판 섹션 -->
  <section class="board-section">
    <div class="board-container">
      <div class="board-header">
        <h1 class="board-title">게시판</h1>
        <a href="/board/write" class="write-btn">글쓰기</a>
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

