<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>공지사항 - 대기질 정보</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/css/board.css">
  <script src="/js/banner.js"></script>
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
            <span class="user-name"><c:out value="${sessionScope.loginDisplayName}"/>님</span>
          </c:otherwise>
        </c:choose>
      </div>
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
      </nav>
  </header>

  <!-- 상단 프로모션 -->
  <div class="promo" role="note" aria-label="프로모션">
    <div class="promo-content">
      <div class="promo-nav">
        <a href="/main" class="nav-category">상세정보</a>
        <a href="/board/list" class="nav-board">게시판</a>
        <a href="/notice" class="nav-notice active">공지사항</a>
        <a href="/qna" class="nav-qna">QnA</a>
      </div>
    </div>
  </div>

  <!-- 공지사항 섹션 -->
  <section class="board-section">
    <div class="board-container">
      <div class="board-header">
        <h1 class="board-title">공지사항</h1>
        <c:if test="${sessionScope.isAdmin == true}">
          <a href="/admin/notice/write" class="write-btn">글쓰기</a>
        </c:if>
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
                      <a href="${pageContext.request.contextPath}/notice/detail?noticeNo=${notice.noticeNo}">
                        <c:out value="${notice.noticeTitle}">
                          <span class="file-icon">📎</span>
						</c:out>
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
        <form method="get" action="${pageContext.request.contextPath}/notice" id="searchForm">
          <select name="type" style="padding: 12px; border: 2px solid #eee; border-radius: 12px; font-size: 14px; margin-right: 8px;">
            <option value="tc" ${type == 'tc' ? 'selected' : ''}>제목+내용</option>
            <option value="title" ${type == 'title' ? 'selected' : ''}>제목</option>
            <option value="content" ${type == 'content' ? 'selected' : ''}>내용</option>
            <option value="writer" ${type == 'writer' ? 'selected' : ''}>작성자</option>
          </select>
          <input type="text" name="keyword" class="search-input" placeholder="검색어를 입력하세요" value="${fn:escapeXml(keyword)}">
          <input type="hidden" name="size" value="${size}" />
          <button type="submit" class="search-btn">검색</button>
        </form>
      </div>

      <!-- 페이지네이션 -->
      <div class="pagination">
        <c:if test="${startPage > 1}">
          <c:url var="prevUrl" value="/notice">
            <c:param name="page" value="${startPage-1}" />
            <c:param name="size" value="${size}" />
            <c:if test="${not empty keyword}">
              <c:param name="type" value="${type}" />
              <c:param name="keyword" value="${keyword}" />
            </c:if>
          </c:url>
          <a href="${pageContext.request.contextPath}${prevUrl}"><</a>
        </c:if>

        <c:forEach var="i" begin="${startPage}" end="${endPage}">
          <c:url var="pageUrl" value="/notice">
            <c:param name="page" value="${i}" />
            <c:param name="size" value="${size}" />
            <c:if test="${not empty keyword}">
              <c:param name="type" value="${type}" />
              <c:param name="keyword" value="${keyword}" />
            </c:if>
          </c:url>
          <a href="${pageContext.request.contextPath}${pageUrl}" class="${i == page ? 'active' : ''}">${i}</a>
        </c:forEach>

        <c:if test="${endPage < pageCount}">
          <c:url var="nextUrl" value="/notice">
            <c:param name="page" value="${endPage+1}" />
            <c:param name="size" value="${size}" />
            <c:if test="${not empty keyword}">
              <c:param name="type" value="${type}" />
              <c:param name="keyword" value="${keyword}" />
            </c:if>
          </c:url>
          <a href="${pageContext.request.contextPath}${nextUrl}">></a>
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
</body>
</html>
