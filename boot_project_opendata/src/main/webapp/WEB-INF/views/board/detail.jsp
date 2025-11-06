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

  <section class="write-section">
    <div class="write-container">
      <div class="write-header">
<!--        <h1 class="write-title">✅ 등록 완료 (상세보기)</h1>-->
      </div>
      <form class="write-form readonly">
      <!-- 제목 -->
      <div class="form-group">
           <label class="form-label">제목</label>
           <input type="text" class="form-input" value="${post.boardTitle}" readonly>
      </div>
      
        <!-- 첨부 이미지 -->
        <div class="form-group">
          <label class="form-label"></label>
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
         <label class="form-label"></label>
         <textarea class="form-textarea" readonly>${post.boardContent}</textarea>
      </div>
      
      <table class="info-table">
                <tr>
                  <th>번호</th>
                  <td>${post.boardNo}</td>
                  <th>작성자</th>
                  <td>${nickname}</td>
                </tr>
                <tr>
                  <th>작성일</th>
               <td>
                 <c:choose>
                   <c:when test="${not empty post.formattedDate}">
                     ${post.formattedDate}
                   </c:when>
                   <c:otherwise>
                     <spring:eval expression="post.boardDate != null ? post.boardDate.format(T(java.time.format.DateTimeFormatter).ofPattern('yyyy-MM-dd HH:mm')) : ''" />
                   </c:otherwise>
                 </c:choose>
               </td>

                  <th>조회수</th>
                  <td>${post.boardHit}</td>
                </tr>
              </table>

        <!-- 완료/목록 버튼 -->
        <div class="form-actions">
       <%-- 작성자이거나 관리자일 때만 수정/삭제 버튼 노출 --%>
       <c:if test="${sessionScope.loginId == post.userId || sessionScope.isAdmin == true || sessionScope.userRole == 'ADMIN'}">
         <div class="form-actions">
           <button type="button" class="btn btn-write"
                   onclick="location.href='${pageContext.request.contextPath}/board/edit/${post.boardNo}'">수정</button>

           <button type="button" class="btn btn-delete"
                   onclick="if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/board/delete/${post.boardNo}'">삭제</button>
         </div>
       </c:if>
       <%-- 목록 버튼은 항상 보이게 --%>
       <div class="form-actions">
         <button type="button" class="btn btn-list"
                 onclick="location.href='${pageContext.request.contextPath}/board/list'">목록</button>
       </div>
        </div>
      </form>
    </div>
  </section>

  <!-- 푸터(생략 가능) -->
</body>
</html>
