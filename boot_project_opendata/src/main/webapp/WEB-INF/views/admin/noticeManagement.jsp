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
  <style>
    .board-filter label {
      font-size: 15px;
      font-weight: 500;
      color: #374151;
    }

    .board-select {
      padding: 6px 12px;
      margin-left: 4px;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      background-color: #f9fafb;
      color: #1e3a8a;
      font-weight: 500;
      font-size: 14px;
      outline: none;
      transition: all 0.2s ease;
      cursor: pointer;
      box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    }

    .board-select:hover {
      border-color: #94a3b8;
    }

    .board-select:focus {
      border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.3);
    }
  </style>
  <script src="/js/banner.js"></script>
</head>
<body>
  <!-- 헤더 & 네비 -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/adminMain" class="brand">대기질 정보</a>
      <div class="nav-right">
        <c:choose>
          <c:when test="${empty sessionScope.loginDisplayName}">
            <a href="<c:url value='/login'/>">로그인</a>
            <a href="<c:url value='/register'/>">회원가입</a>
          </c:when>
          <c:otherwise>
            <a href="<c:url value='/adminMain'/>">관리자메인</a>
            <a href="<c:url value='/logout'/>">로그아웃</a>
            <span class="user-name">${sessionScope.loginDisplayName}님</span>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- 도시 대기질 배너 -->
      <div class="city-banner-wrapper">
        <div class="city-slide" id="headerCitySlide">
          <c:forEach var="city" items="${cityAverages}">
            <div class="city-slide-item">
              ${city.stationName}:
              미세먼지(
                <strong class="<c:choose>
                                 <c:when test='${city.pm10Value <= 30}'>good</c:when>
                                 <c:when test='${city.pm10Value <= 80}'>normal</c:when>
                                 <c:when test='${city.pm10Value <= 150}'>bad</c:when>
                                 <c:otherwise>very-bad</c:otherwise>
                               </c:choose>">
                  <c:choose>
                    <c:when test="${city.pm10Value <= 30}">좋음</c:when>
                    <c:when test="${city.pm10Value <= 80}">보통</c:when>
                    <c:when test="${city.pm10Value <= 150}">나쁨</c:when>
                    <c:otherwise>매우나쁨</c:otherwise>
                  </c:choose>
                </strong>
              )
              초미세먼지(
                <strong class="<c:choose>
                                 <c:when test='${city.pm25Value <= 15}'>good</c:when>
                                 <c:when test='${city.pm25Value <= 35}'>normal</c:when>
                                 <c:when test='${city.pm25Value <= 75}'>bad</c:when>
                                 <c:otherwise>very-bad</c:otherwise>
                               </c:choose>">
                  <c:choose>
                    <c:when test="${city.pm25Value <= 15}">좋음</c:when>
                    <c:when test="${city.pm25Value <= 35}">보통</c:when>
                    <c:when test="${city.pm25Value <= 75}">나쁨</c:when>
                    <c:otherwise>매우나쁨</c:otherwise>
                  </c:choose>
                </strong>
              )
            </div>
          </c:forEach>
        </div>
      </div>
    </nav>
  </header>

  <!-- 상단 프로모션 -->
  <div class="promo" role="note" aria-label="관리자 메뉴">
    <div class="promo-content">
      <div class="promo-nav">
        <a href="/adminMain" class="nav-category">상세정보</a>
        <a href="/memberManagement" class="nav-board">회원관리</a>
        <a href="/boardManagement" class="nav-notice">게시판관리</a>
        <a href="/qnaManagement" class="nav-qna">지역관리</a>
      </div>
    </div>
  </div>

  <!-- 공지사항 관리 섹션 -->
  <section class="board-section">
    <div class="board-container">

      <!-- 헤더 -->
      <div class="board-header" style="display: flex; justify-content: space-between; align-items: center;">
        <div style="display: flex; align-items: center; gap: 10px;">
          <h1 class="board-title" style="margin: 0;">공지사항 관리</h1>
          <div class="board-filter">
            <select id="boardType" name="boardType" class="board-select" onchange="moveToBoardPage(this.value)">
              <option value="">선택하세요</option>
              <option value="board">게시판 관리</option>
              <option value="notice" selected>공지사항 관리</option>
              <option value="qna">Q&A 관리</option>
            </select>
          </div>
        </div>

        <!-- 공지사항 글쓰기 버튼 -->
        <a href="/admin/notice/write" class="write-btn">공지 등록</a>
      </div>

      <!-- 공지 목록 테이블 -->
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
            <c:choose>
              <c:when test="${empty noticeList}">
                <tr>
                  <td colspan="5" class="empty-row">등록된 공지사항이 없습니다.</td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="notice" items="${noticeList}">
                  <tr>
                    <td>${notice.noticeNo}</td>
                    <td>
                      <a href="${pageContext.request.contextPath}/admin/notice/detail?noticeNo=${notice.noticeNo}">
                        <c:out value="${notice.noticeTitle}" />
                      </a>
                    </td>
                    <td>관리자</td>
                    <td>${notice.formattedDate}</td>
                    <td>${notice.noticeHit}</td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <!-- 검색 영역 -->
      <div class="board-search">
        <form method="get" action="${pageContext.request.contextPath}/noticeManagement" id="searchForm">
          <select name="type" style="padding: 12px; border: 2px solid #eee; border-radius: 12px; font-size: 14px; margin-right: 8px;">
            <option value="tc" ${type == 'tc' ? 'selected' : ''}>제목+내용</option>
            <option value="title" ${type == 'title' ? 'selected' : ''}>제목</option>
            <option value="content" ${type == 'content' ? 'selected' : ''}>내용</option>
            <option value="writer" ${type == 'writer' ? 'selected' : ''}>작성자</option>
          </select>
          <input type="text" name="keyword" class="search-input" placeholder="검색어를 입력하세요" value="${param.keyword}">
          <button type="submit" class="search-btn">검색</button>
        </form>
      </div>

      <!-- 페이지네이션 -->
      <div class="pagination">
        <c:if test="${startPage > 1}">
          <a href="${pageContext.request.contextPath}/noticeManagement?page=${startPage-1}"><</a>
        </c:if>

        <c:forEach var="i" begin="${startPage}" end="${endPage}">
          <a href="${pageContext.request.contextPath}/noticeManagement?page=${i}" class="${i == page ? 'active' : ''}">${i}</a>
        </c:forEach>

        <c:if test="${endPage < pageCount}">
          <a href="${pageContext.request.contextPath}/noticeManagement?page=${endPage+1}">></a>
        </c:if>
      </div>
    </div>
  </section>

  <!-- 푸터 -->
  <footer class="footer">
    <h2>대기질 정보 시스템</h2>
    <p>대기질 정보 시스템 | 데이터 출처: 공공데이터포털 (data.go.kr)</p>
    <p>환경부 실시간 대기질 정보 제공</p>
    <p>주소: 부산시 부산진구 범내골</p>
    <br>
    <a href="#">이용약관</a>
    <a href="#">개인정보처리방침</a>
  </footer>

  <script>
    // ✅ 선택 시 해당 JSP 페이지로 이동
    function moveToBoardPage(type) {
      if (type === "board") {
        location.href = "/boardManagement";
      } else if (type === "notice") {
        location.href = "/noticeManagement";
      } else if (type === "qna") {
        location.href = "/qnaManagement";
      }
    }
  </script>
</body>
</html>

