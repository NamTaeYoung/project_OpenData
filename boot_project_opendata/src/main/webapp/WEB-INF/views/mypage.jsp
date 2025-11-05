<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>마이페이지 - 대기질 정보</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/mypage.css">
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
        <a href="/board" class="nav-board">게시판</a>
        <a href="/notice" class="nav-notice">공지사항</a>
        <a href="/qna" class="nav-qna">QnA</a>
      </div>
    </div>
  </div>

  <!-- 마이페이지 섹션 -->
  <section class="mypage-section">
    <div class="mypage-container">
      <div class="mypage-header">
        <h1 class="mypage-title">마이페이지</h1>
        <p class="mypage-subtitle">회원 정보를 관리하고 내 활동을 확인하세요</p>
      </div>

      <!-- 회원 정보 조회/수정/삭제 섹션 -->
      <div class="mypage-card">
        <div class="card-header">
          <h2 class="card-title">
            <span class="card-title-icon">👤</span>
            회원 정보 조회/수정/삭제
          </h2>
          <div class="card-action">
            <a href="<c:url value='/mypage/edit'/>" class="btn btn-primary">수정</a>
            <a href="<c:url value='/mypage/delete'/>" class="btn btn-danger" onclick="return confirm('정말 탈퇴하시겠습니까?');">탈퇴</a>
          </div>
        </div>
        <div class="info-grid">
          <div class="info-item">
            <span class="info-label">아이디</span>
            <span class="info-value">${sessionScope.loginId}</span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.id}</span> --%>
          </div>
          <div class="info-item">
            <span class="info-label">이름</span>
            <span class="info-value">${sessionScope.loginDisplayName}</span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.name}</span> --%>
          </div>
          <div class="info-item">
            <span class="info-label">이메일</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${not empty sessionScope.userEmail}">${sessionScope.userEmail}</c:when>
                <c:otherwise><span class="empty">등록된 이메일이 없습니다</span></c:otherwise>
              </c:choose>
            </span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.email}</span> --%>
          </div>
          <div class="info-item">
            <span class="info-label">전화번호</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${not empty sessionScope.userPhone}">${sessionScope.userPhone}</c:when>
                <c:otherwise><span class="empty">등록된 전화번호가 없습니다</span></c:otherwise>
              </c:choose>
            </span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.phone}</span> --%>
          </div>
          <div class="info-item">
            <span class="info-label">가입일</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${not empty sessionScope.userRegDate}">${sessionScope.userRegDate}</c:when>
                <c:otherwise><span class="empty">-</span></c:otherwise>
              </c:choose>
            </span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.regDate}</span> --%>
          </div>
          <div class="info-item">
            <span class="info-label">최근 로그인</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${not empty sessionScope.userLastLogin}">${sessionScope.userLastLogin}</c:when>
                <c:otherwise><span class="empty">-</span></c:otherwise>
              </c:choose>
            </span>
            <%-- 백엔드 연동 시: <span class="info-value">${user.lastLogin}</span> --%>
          </div>
        </div>
      </div>

      <!-- 게시판 목록 조회 섹션 -->
      <div class="mypage-card">
        <div class="card-header">
          <h2 class="card-title">
            <span class="card-title-icon">📝</span>
            게시판 목록 조회
          </h2>
          <div class="card-action">
            <a href="/board" class="btn btn-secondary">전체 목록 보기</a>
          </div>
        </div>
        <div class="board-list">
          <%-- 백엔드 연동 시: <c:forEach> 태그로 내 게시글 표시
          <c:forEach var="board" items="${myBoardList}">
            <div class="board-list-item">
              <div class="board-list-info">
                <h3 class="board-list-title">${board.title}</h3>
                <div class="board-list-meta">
                  <span>작성일: ${board.regDate}</span>
                  <span>조회수: ${board.viewCount}</span>
                </div>
              </div>
              <div class="board-list-actions">
                <a href="/board/${board.id}" class="btn btn-secondary">보기</a>
                <a href="/board/${board.id}/edit" class="btn btn-primary">수정</a>
              </div>
            </div>
          </c:forEach>
          --%>
          <!-- 데이터가 없을 때 -->
          <div class="empty-message">
            작성한 게시글이 없습니다.
          </div>
        </div>
      </div>

      <!-- 관심 지역 조회 섹션 -->
      <div class="mypage-card">
        <div class="card-header">
          <h2 class="card-title">
            <span class="card-title-icon">📍</span>
            관심 지역 조회
          </h2>
          <div class="card-action">
            <a href="<c:url value='/mypage/region/add'/>" class="btn btn-primary">지역 추가</a>
          </div>
        </div>
        <div class="region-grid">
          <%-- 백엔드 연동 시: <c:forEach> 태그로 관심 지역 표시
          <c:forEach var="region" items="${favoriteRegions}">
            <div class="region-card">
              <h3 class="region-name">${region.name}</h3>
              <span class="region-grade ${region.grade}">
                <c:choose>
                  <c:when test="${region.grade == 'good'}">좋음</c:when>
                  <c:when test="${region.grade == 'normal'}">보통</c:when>
                  <c:when test="${region.grade == 'bad'}">나쁨</c:when>
                  <c:when test="${region.grade == 'very-bad'}">매우 나쁨</c:when>
                </c:choose>
              </span>
              <div style="margin-top: 12px; font-size: 14px; color: var(--muted);">
                미세먼지: ${region.pm10} ㎍/㎥
              </div>
              <button class="region-remove" onclick="removeRegion('${region.id}')">삭제</button>
            </div>
          </c:forEach>
          --%>
          <!-- 데이터가 없을 때 -->
          <div class="empty-message" style="grid-column: 1 / -1;">
            등록된 관심 지역이 없습니다. 지역을 추가해보세요.
          </div>
        </div>
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

  <script>
    // 관심 지역 삭제 함수
    function removeRegion(regionId) {
      if (confirm('이 관심 지역을 삭제하시겠습니까?')) {
        // 백엔드 연동 시: fetch로 삭제 요청
        // fetch('/mypage/region/' + regionId, {
        //   method: 'DELETE'
        // }).then(response => {
        //   if (response.ok) {
        //     location.reload();
        //   }
        // });
        alert('백엔드 연동 후 사용 가능합니다.');
      }
    }
  </script>
</body>
</html>
