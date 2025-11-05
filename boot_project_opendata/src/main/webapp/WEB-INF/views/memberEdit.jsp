<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>회원 정보 수정 - 대기질 정보</title>
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

    /* 회원정보 수정 섹션 */
    .edit-section {
      padding: 60px 0;
      background: var(--section-bg);
      min-height: calc(100vh - 200px);
    }
    .edit-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 20px;
    }
    .edit-card {
      background: #fff;
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      padding: 50px;
      max-width: 700px;
      margin: 0 auto;
    }
    .edit-title {
      font-size: clamp(28px, 3vw, 36px);
      font-weight: 700;
      color: var(--text);
      margin: 0 0 40px;
      text-align: center;
    }
    .form-group {
      margin-bottom: 24px;
    }
    .form-label {
      display: block;
      font-size: 15px;
      font-weight: 600;
      color: var(--text);
      margin-bottom: 10px;
    }
    .form-input {
      width: 100%;
      padding: 14px 16px;
      border: 1px solid #ddd;
      border-radius: 10px;
      font-size: 15px;
      font-family: 'Noto Sans KR', sans-serif;
      transition: all .2s ease;
      box-sizing: border-box;
    }
    .form-input:focus {
      outline: none;
      border-color: var(--brand);
      box-shadow: 0 0 0 3px rgba(44,95,141,.1);
    }
    .form-input:disabled {
      background: #f5f5f5;
      cursor: not-allowed;
      color: var(--muted);
    }
    .form-hint {
      font-size: 13px;
      color: var(--muted);
      margin-top: 6px;
    }
    .btn-group {
      display: flex;
      justify-content: center;
      gap: 12px;
      margin-top: 40px;
      padding-top: 30px;
      border-top: 1px solid #eee;
    }
    .btn {
      padding: 14px 32px;
      border: none;
      border-radius: 10px;
      font-size: 16px;
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
      .edit-card{ padding: 30px 20px; }
      .btn-group{ flex-direction: column; }
      .btn{ width: 100%; }
    }
  </style>
</head>
<body>
  <!-- 헤더 & 네비 -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/main" class="brand">대기질 정보</a>
      <div class="nav-right">
        <c:choose>
          <c:when test="${empty sessionScope.loginDisplayName}">
            <a href="<c:url value='/login'/>">로그인</a>
            <a href="<c:url value='/register'/>">회원가입</a>
          </c:when>
          <c:otherwise>
            <c:if test="${sessionScope.isAdmin != true}">
              <a href="<c:url value='/mypage'/>">마이페이지</a>
            </c:if>
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

  <!-- 회원정보 수정 섹션 -->
  <section class="edit-section">
    <div class="edit-container">
      <div class="edit-card">
        <h1 class="edit-title">회원 정보 수정</h1>
        
        <form method="post" action="/mypage/edit">
          <div class="form-group">
            <label class="form-label">이름</label>
            <input type="text" name="user_name" class="form-input" value="${user.user_name}" required>
          </div>

          <div class="form-group">
            <label class="form-label">닉네임</label>
            <input type="text" name="user_nickname" class="form-input" value="${user.user_nickname}">
          </div>

          <div class="form-group">
            <label class="form-label">아이디</label>
            <input type="text" class="form-input" value="${user.user_id}" disabled>
            <span class="form-hint">아이디는 수정할 수 없습니다.</span>
          </div>

          <div class="form-group">
            <label class="form-label">비밀번호</label>
            <input type="password" name="user_password" class="form-input" placeholder="변경할 비밀번호를 입력하세요">
            <span class="form-hint">비밀번호를 변경하지 않으려면 비워두세요.</span>
          </div>

          <div class="form-group">
            <label class="form-label">이메일</label>
            <input type="email" name="user_email" class="form-input" value="${user.user_email}" required>
          </div>

          <div class="form-group">
            <label class="form-label">전화번호</label>
            <input type="tel" name="user_phone_num" class="form-input" value="${user.user_phone_num}" placeholder="010-1234-5678">
          </div>

          <div class="form-group">
            <label class="form-label">우편번호</label>
            <input type="text" name="user_post_num" class="form-input" value="${user.user_post_num}" placeholder="12345">
          </div>

          <div class="form-group">
            <label class="form-label">주소</label>
            <input type="text" name="user_address" class="form-input" value="${user.user_address}" placeholder="서울특별시 강남구">
          </div>

          <div class="form-group">
            <label class="form-label">상세주소</label>
            <input type="text" name="user_detail_address" class="form-input" value="${user.user_detail_address}" placeholder="역삼동 123-45">
          </div>

          <div class="btn-group">
            <button type="submit" class="btn btn-primary">정보 수정</button>
            <a href="/mypage" class="btn btn-secondary">취소</a>
          </div>
        </form>
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