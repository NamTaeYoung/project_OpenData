<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${post.boardTitle}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/css/boardDetail.css">
</head>
<body>
	<header>
	  <nav class="nav" aria-label="주요 메뉴">
	    <a href="/main" class="brand">대기질 정보</a>

	    <div class="nav-right">
	      <c:choose>
	        <c:when test="${empty sessionScope.loginDisplayName}">
	          <a href="<c:url value='/login'/>">로그인</a>
	          <a href="<c:url value='/register'/>">회원가입</a>
	          <a href="<c:url value='/login?admin=true'/>">관리자정보</a>
	        </c:when>

	        <c:otherwise>
	          <c:choose>
	            <%-- 관리자 로그인 시 --%>
	            <c:when test="${sessionScope.isAdmin == true}">
	              <a href="/adminMain">관리자메인</a>
	              <a href="/logout">로그아웃</a>
	              <span class="user-name">${sessionScope.loginDisplayName}님</span>
	            </c:when>

	            <%-- 일반 사용자 로그인 시 --%>
	            <c:otherwise>
	              <a href="/mypage">마이페이지</a>
	              <a href="/logout">로그아웃</a>
	              <span class="user-name">${sessionScope.loginDisplayName}님</span>
	            </c:otherwise>
	          </c:choose>
	        </c:otherwise>
	      </c:choose>
	    </div>
	  </nav>
	</header>

	<!-- 상단 프로모션 (관리자 / 사용자 구분) -->
	<div class="promo" role="note" aria-label="프로모션">
	  <div class="promo-content">
	    <div class="promo-nav">
	      <c:choose>
	        <%-- 관리자 메뉴 --%>
	        <c:when test="${sessionScope.isAdmin == true}">
	          <a href="/adminMain" class="nav-category">상세정보</a>
	          <a href="/memberManagement" class="nav-board">회원관리</a>
	          <a href="/boardManagement" class="nav-notice">게시판관리</a>
	          <a href="/qna" class="nav-qna">지역관리</a>
	        </c:when>
	        <%-- 일반 사용자 메뉴 --%>
	        <c:otherwise>
	          <a href="/main" class="nav-category">상세정보</a>
	          <a href="/board/list" class="nav-board">게시판</a>
	          <a href="/notice" class="nav-notice">공지사항</a>
	          <a href="/qna" class="nav-qna">QnA</a>
	        </c:otherwise>
	      </c:choose>
	    </div>
	  </div>
	</div>

	<section class="write-section">
	  <div class="write-container">
	    <form class="write-form readonly">

	      <!-- 제목 -->
	      <div class="form-group">
	        <label class="form-label">제목</label>
	        <input type="text" class="form-input" value="${post.boardTitle}" readonly>
	      </div>

	      <!-- 첨부 이미지 -->
	      <div class="form-group">
	        <c:choose>
	          <c:when test="${not empty attaches}">
	            <c:forEach var="att" items="${attaches}">
	              <img src="${att.filePath}" alt="${att.fileName}" style="max-width:400px; margin-bottom:10px;">
	            </c:forEach>
	          </c:when>
	          <c:otherwise>
	            <p>첨부된 이미지가 없습니다.</p>
	          </c:otherwise>
	        </c:choose>
	      </div>

	      <!-- 내용 -->
	      <div class="form-group">
	        <textarea class="form-textarea" readonly>${post.boardContent}</textarea>
	      </div>

	      <!-- 게시글 정보 -->
	      <table class="info-table">
	        <tr>
	          <th>번호</th><td>${post.boardNo}</td>
	          <th>작성자</th><td>${nickname}</td>
	        </tr>
	        <tr>
	          <th>작성일</th>
	          <td>
	            <fmt:formatDate value="${boardDate}" pattern="yyyy-MM-dd HH:mm"/>
	          </td>
	          <th>조회수</th><td>${post.boardHit}</td>
	        </tr>
	      </table>

	      <!-- ✅ 버튼 영역 -->
		  <div class="form-actions">
		    <c:choose>
		      <%-- ✅ 관리자일 때: 관리자용 URL 사용 --%>
		      <c:when test="${sessionScope.isAdmin == true}">
		        <button type="button" class="btn btn-write"
		                onclick="location.href='${pageContext.request.contextPath}/admin/board/edit/${post.boardNo}'">수정</button>

		        <button type="button" class="btn btn-delete"
		                onclick="if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/admin/board/delete/${post.boardNo}'">삭제</button>

		        <button type="button" class="btn btn-list"
		                onclick="location.href='${pageContext.request.contextPath}/boardManagement'">목록</button>
		      </c:when>

		      <%-- ✅ 일반 사용자일 때: 기존 URL 유지 --%>
		      <c:otherwise>
		        <c:if test="${sessionScope.loginId == post.userId}">
		          <button type="button" class="btn btn-write"
		                  onclick="location.href='${pageContext.request.contextPath}/board/edit/${post.boardNo}'">수정</button>

		          <button type="button" class="btn btn-delete"
		                  onclick="if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/board/delete/${post.boardNo}'">삭제</button>
		        </c:if>

		        <button type="button" class="btn btn-list"
		                onclick="location.href='${pageContext.request.contextPath}/board/list'">목록</button>
		      </c:otherwise>
		    </c:choose>
		  </div>
	    </form>
	  </div>
	</section>
</body>
</html>
