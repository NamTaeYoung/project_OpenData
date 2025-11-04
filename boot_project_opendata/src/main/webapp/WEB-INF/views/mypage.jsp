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

    /* 마이페이지 섹션 */
    .mypage-section {
      padding: 60px 0;
      background: var(--section-bg);
      min-height: calc(100vh - 200px);
    }
    .mypage-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 20px;
    }
    .mypage-header {
      margin-bottom: 40px;
    }
    .mypage-title {
      font-size: clamp(28px, 3vw, 36px);
      font-weight: 700;
      color: var(--text);
      margin: 0 0 12px;
    }
    .mypage-subtitle {
      font-size: 16px;
      color: var(--muted);
      margin: 0;
    }

    /* 섹션 카드 */
    .mypage-card {
      background: #fff;
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      padding: 32px;
      margin-bottom: 24px;
      transition: transform .2s, box-shadow .2s;
    }
    .mypage-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 15px 40px rgba(0,0,0,.12);
    }
    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 2px solid #f0f0f0;
    }
    .card-title {
      font-size: 22px;
      font-weight: 700;
      color: var(--text);
      margin: 0;
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .card-title-icon {
      font-size: 24px;
    }
    .card-action {
      display: flex;
      gap: 12px;
    }
    .btn {
      padding: 10px 20px;
      border: none;
      border-radius: 10px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all .3s ease;
      text-decoration: none;
      display: inline-block;
      font-family: 'Noto Sans KR', sans-serif;
    }
    .btn-primary {
      background: var(--brand);
      color: #fff;
    }
    .btn-primary:hover {
      background: var(--brand-dark);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(44,95,141,.3);
    }
    .btn-secondary {
      background: #f5f5f5;
      color: var(--text);
    }
    .btn-secondary:hover {
      background: #e8e8e8;
    }
    .btn-danger {
      background: #ff4d4f;
      color: #fff;
    }
    .btn-danger:hover {
      background: #ff7875;
    }

    /* 회원 정보 섹션 */
    .info-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 20px;
    }
    .info-item {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    .info-label {
      font-size: 14px;
      color: var(--muted);
      font-weight: 500;
    }
    .info-value {
      font-size: 16px;
      color: var(--text);
      font-weight: 600;
    }
    .info-value.empty {
      color: var(--muted);
      font-style: italic;
    }

    /* 게시판 목록 섹션 */
    .board-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .board-list-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px;
      background: #f8f9fa;
      border-radius: 12px;
      transition: all .2s ease;
    }
    .board-list-item:hover {
      background: #e9ecef;
      transform: translateX(4px);
    }
    .board-list-info {
      flex: 1;
    }
    .board-list-title {
      font-size: 16px;
      font-weight: 600;
      color: var(--text);
      margin: 0 0 4px;
    }
    .board-list-meta {
      font-size: 13px;
      color: var(--muted);
      display: flex;
      gap: 12px;
    }
    .board-list-actions {
      display: flex;
      gap: 8px;
    }
    .empty-message {
      text-align: center;
      padding: 40px 20px;
      color: var(--muted);
      font-size: 15px;
    }

    /* 관심 지역 섹션 */
    .region-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 16px;
    }
    .region-card {
      background: linear-gradient(135deg, #f8f9fa, #fff);
      border: 2px solid #e9ecef;
      border-radius: 12px;
      padding: 20px;
      text-align: center;
      transition: all .3s ease;
      cursor: pointer;
    }
    .region-card:hover {
      border-color: var(--brand);
      transform: translateY(-4px);
      box-shadow: 0 8px 20px rgba(44,95,141,.15);
    }
    .region-name {
      font-size: 18px;
      font-weight: 700;
      color: var(--text);
      margin: 0 0 8px;
    }
    .region-grade {
      display: inline-block;
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      margin-top: 8px;
    }
    .region-grade.good { background: #f6ffed; color: #52c41a; }
    .region-grade.normal { background: #e6f7ff; color: #1890ff; }
    .region-grade.bad { background: #fffbe6; color: #faad14; }
    .region-grade.very-bad { background: #fff1f0; color: #ff4d4f; }
    .region-remove {
      margin-top: 12px;
      padding: 6px 12px;
      background: #ff4d4f;
      color: #fff;
      border: none;
      border-radius: 6px;
      font-size: 12px;
      cursor: pointer;
      transition: all .2s ease;
    }
    .region-remove:hover {
      background: #ff7875;
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
      .info-grid{ grid-template-columns: 1fr; }
      .region-grid{ grid-template-columns: repeat(2, 1fr); }
      .card-action{ flex-direction: column; }
      .btn{ width: 100%; text-align: center; }
    }
    @media (max-width: 480px){
      .nav-right{gap:12px; font-size:.92rem}
      .promo{font-size:.8rem}
      .footer-links{flex-direction: column; gap: 15px}
      .mypage-card{ padding: 20px; }
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
