<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>QnA - 대기질 정보</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/qna.css">
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
            <span class="user-name">${sessionScope.loginDisplayName}님</span>
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
        <a href="/notice" class="nav-notice">공지사항</a>
        <a href="/qna" class="nav-qna active">QnA</a>
      </div>
    </div>
  </div>

  <!-- QnA 섹션 -->
  <section class="qna-section">
    <div class="qna-container">
      <div class="qna-header">
        <h1 class="qna-title">QnA</h1>
        <a href="/qna/write" class="write-btn">글쓰기</a>
      </div>

      <div class="qna-table-wrapper">
        <table class="qna-table">
          <thead>
            <tr>
              <th>번호</th>
              <th>제목</th>
              <th>작성자</th>
              <th>작성일</th>
              <th>상태</th>
            </tr>
          </thead>
          <tbody>
            <%-- 백엔드 연동 시: <c:forEach> 태그로 QnA 표시
            <c:forEach var="qna" items="${qnaList}">
              <tr class="${qna.answered ? 'answered' : ''}">
                <td>${qna.id}</td>
                <td>
                  <a href="/qna/${qna.id}">
                    <c:choose>
                      <c:when test="${qna.answered}">
                        <span class="answer-badge">답변완료</span>
                      </c:when>
                      <c:otherwise>
                        <span class="waiting-badge">답변대기</span>
                      </c:otherwise>
                    </c:choose>
                    ${qna.title}
                    <c:if test="${qna.secret}">
                      <span class="lock-icon">🔒</span>
                    </c:if>
                    <c:if test="${not empty qna.fileName}">
                      <span class="file-icon">📎</span>
                    </c:if>
                  </a>
                </td>
                <td>${qna.writer}</td>
                <td>${qna.regDate}</td>
                <td>
                  <c:choose>
                    <c:when test="${qna.answered}">
                      <span style="color: #52c41a; font-weight: 600;">답변완료</span>
                    </c:when>
                    <c:otherwise>
                      <span style="color: #faad14; font-weight: 600;">답변대기</span>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
            --%>
            <!-- 데이터가 없을 때 -->
            <tr>
              <td colspan="5" class="empty-row">
                등록된 QnA가 없습니다.
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 검색 영역 -->
      <div class="qna-search">
        <form method="get" action="/qna" id="searchForm">
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
          <a href="/qna?page=${pageInfo.prevPage}">이전</a>
        </c:if>
        <c:forEach var="pageNum" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
          <c:choose>
            <c:when test="${pageNum == pageInfo.currentPage}">
              <span class="active">${pageNum}</span>
            </c:when>
            <c:otherwise>
              <a href="/qna?page=${pageNum}">${pageNum}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>
        <c:if test="${pageInfo.hasNext}">
          <a href="/qna?page=${pageInfo.nextPage}">다음</a>
        </c:if>
        --%>
        <span class="active">1</span>
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
