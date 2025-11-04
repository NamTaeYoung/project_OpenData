<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>대기질 정보 – 지역별 미세먼지 농도</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_APP_KEY&autoload=false&libraries=services"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root{
      --brand: #2c5f8d;         /* 대기질 테마 색상 */
      --brand-dark: #1e4261;
      --text: #1c1c1c;
      --muted: #686868;
      --bg: #ffffff;
      --card: #f7f7f7;
      --radius: 18px;
      --shadow: 0 10px 30px rgba(0,0,0,.08);
      --section-bg: #f8f9fa;
      --good: #52c41a;
      --normal: #1890ff;
      --bad: #faad14;
      --very-bad: #ff4d4f;
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

    /* 메인 검색 */
    .main-search { display:flex; justify-content:center; margin-bottom:40px; }
    .search-box { position:relative; max-width:700px; width:100%; }
    .search-input {
      width:100%; padding:20px 60px 20px 20px; font-size:18px; border:none; border-radius:50px; outline:none; transition:all .3s ease;
      background:rgba(255,255,255,.95); box-shadow:0 8px 32px rgba(0,0,0,.2); backdrop-filter:blur(10px);
    }
    .search-input:focus { background:#fff; box-shadow:0 12px 40px rgba(0,0,0,.3); }
    .search-input::placeholder{ color:#666; }
    .search-button{
      position:absolute; right:8px; top:50%; transform:translateY(-50%);
      background:var(--brand); border:none; border-radius:50%; width:44px; height:44px;
      display:flex; align-items:center; justify-content:center; cursor:pointer; transition:all .3s ease;
    }
    .search-button:hover{ background:var(--brand-dark); transform:translateY(-50%) scale(1.05); }
    .search-button svg{ width:20px; height:20px; color:#fff; }

    /* 히어로 */
    .hero{
      background: url("https://images.unsplash.com/photo-1556912172-45b7abe8b7e4?ixlib=rb-4.1.0&auto=format&fit=crop&q=80&w=1170")
        center/cover no-repeat;
      padding: 0 20px; min-height: 50vh; display:flex; align-items:center; justify-content:center; position:relative; overflow:hidden;
    }
    .hero::after{ content:''; position:absolute; inset:0; background:rgba(0,0,0,.3); z-index:1; }
    .hero-content{ text-align:center; color:#fff; z-index:3; position:relative; max-width:800px; padding:0 20px; }
    .hero h1{ font-size: clamp(28px, 4.5vw, 42px); line-height:1.2; margin:0 0 20px; font-weight:700; text-shadow:0 2px 4px rgba(0,0,0,.3); }
    .hero p{ font-size: clamp(18px, 3vw, 24px); margin:0 0 40px; opacity:.9; text-shadow:0 1px 2px rgba(0,0,0,.3); }

    /* 지역별 대기질 카드 섹션 */
    .products-section { background: var(--section-bg); padding: 80px 0; }
    .products-container { max-width: 1100px; margin: 0 auto; padding: 0 20px; }
    .section-title { text-align:center; font-size:clamp(24px, 3vw, 32px); font-weight:700; margin-bottom:50px; color:var(--text); }
    .products-grid { display:grid; grid-template-columns: repeat(3, 1fr); gap:30px; align-items:stretch; }
    .products-grid > * { height:360px; }
    .product-card { background:#fff; border-radius:var(--radius); box-shadow:var(--shadow); overflow:hidden; transition:transform .2s, box-shadow .2s; display:flex; flex-direction:column; width:100%; cursor:pointer; }
    .product-card:hover{ transform:translateY(-5px); box-shadow:0 15px 40px rgba(0,0,0,.12); }
    .product-image{ width:100%; height:200px; background:linear-gradient(135deg,#f5f5f5,#e8e8e8); display:flex; align-items:center; justify-content:center; position:relative; flex-shrink:0; }
    .product-image.good{ background:linear-gradient(135deg,#f6ffed,#d9f7be); }
    .product-image.normal{ background:linear-gradient(135deg,#e6f7ff,#bae7ff); }
    .product-image.bad{ background:linear-gradient(135deg,#fffbe6,#ffe58f); }
    .product-image.very-bad{ background:linear-gradient(135deg,#fff1f0,#ffccc7); }
    .product-image::before{ content:"🌬️"; font-size:48px; opacity:.5; }
    .product-info{ padding:20px; display:flex; flex-direction:column; flex-grow:1; height:120px; }
    .product-title{ font-size:18px; font-weight:600; color:var(--text); line-height:1.3; height:46px; display:flex; align-items:center; margin:0; }
    .product-price{ font-size:16px; font-weight:700; color:var(--brand); height:24px; display:flex; align-items:center; margin:0; }
    .product-rating{ display:flex; align-items:center; gap:4px; height:24px; margin:0; }
    .grade-badge{
      display:inline-block; padding:4px 12px; border-radius:12px; font-size:13px; font-weight:600;
    }
    .grade-badge.good{ background:#f6ffed; color:#52c41a; }
    .grade-badge.normal{ background:#e6f7ff; color:#1890ff; }
    .grade-badge.bad{ background:#fffbe6; color:#faad14; }
    .grade-badge.very-bad{ background:#fff1f0; color:#ff4d4f; }
    .products-grid.hidden{ display:none; }
    .load-more-btn{
      display:block; margin:40px auto 0; background:var(--brand); color:#fff; border:none; padding:12px 30px; border-radius:25px; font-size:16px; font-weight:600;
      cursor:pointer; transition:all .3s ease; box-shadow:0 4px 15px rgba(44,95,141,.2);
    }
    .load-more-btn:hover{ background:var(--brand-dark); transform:translateY(-2px); box-shadow:0 6px 20px rgba(44,95,141,.3); }

    /* 대기질 정보 팁 섹션 */
    .quotes-section{font-family: 'Noto Serif KR', 'Inter', serif;font-optical-sizing: auto;font-weight: 400;font-style: normal;letter-spacing: 0.02em;background:#fff; padding:72px 0}
    .quotes-container{max-width:1100px; margin:0 auto; padding:0 20px}
    .quotes-header{display:flex; align-items:end; justify-content:space-between; gap:16px; margin-bottom:18px}
    .quotes-title{margin:0; font-weight:800; font-size:clamp(22px,3vw,28px); letter-spacing:.01em; color:var(--text)}
    .quotes-sub{margin:0; font-size:14px; color:var(--muted)}
    .q-wrap{position:relative}
    .q-track{
      display:flex; gap:16px; overflow-x:auto; padding:6px 2px 6px 2px;
      scroll-snap-type:x mandatory; -webkit-overflow-scrolling:touch; scrollbar-width:none;
    }
    .q-track::-webkit-scrollbar{display:none}
    .q-card{
      scroll-snap-align:start;
      flex:0 0 calc((100% - 32px) / 3); max-width:calc((100% - 32px) / 3);
      min-width:300px; background:#fff; border-radius:14px; border:1px solid #eee; box-shadow:var(--shadow);
      overflow:hidden; display:flex; flex-direction:column; transition:transform .15s ease, box-shadow .2s ease;
    }
    .q-card:hover{ transform:translateY(-4px); box-shadow:0 18px 40px rgba(0,0,0,.10) }
    .q-bar{ height:6px; background:linear-gradient(90deg, var(--brand), var(--brand-dark)); }
    .q-body{ padding:18px 18px 14px }
    .q-quote{ position:relative; font-size:15px; line-height:1.7; color:#222; margin:0; }
    .q-quote::before{ content:"💡"; position:absolute; left:-8px; top:-10px; font-size:20px; }
    .q-meta{ display:flex; align-items:center; justify-content:space-between; gap:10px; margin-top:14px; font-size:13px; color:var(--muted); }
    .q-book{ display:flex; align-items:center; gap:10px }
    .q-thumb{ width:40px; height:40px; border-radius:6px; background:linear-gradient(135deg,#f3f3f3,#e9e9e9); box-shadow:inset 0 0 0 1px #ededed; flex:0 0 40px; display:flex; align-items:center; justify-content:center; font-size:20px; }
    .q-info{ display:flex; flex-direction:column }
    .q-title{ font-weight:700; color:#333; line-height:1.2 }
    .q-author{ opacity:.8 }
    .q-pub{ padding:6px 10px; border-radius:999px; border:1px solid #eee; background:#fafafa; color:#555; font-weight:600 }
    .q-nav{ position:absolute; inset:0; display:flex; justify-content:space-between; align-items:center; pointer-events:none }
    .q-btn{
      pointer-events:auto; border:none; width:40px; height:40px; border-radius:50%; background:rgba(0,0,0,.45); color:#fff; display:flex; align-items:center; justify-content:center; cursor:pointer
    }
    .q-btn:hover{ background:rgba(0,0,0,.6) }
    @media (max-width:920px){
      .q-card{ flex:0 0 calc((100% - 16px) / 2); max-width:calc((100% - 16px) / 2) }
    }
    @media (max-width:560px){
      .q-card{ flex:0 0 100%; max-width:100% }
    }

    /* 검색 섹션 */
    .testimonials-section { background: var(--brand); padding: 80px 0; color: #fff; }
    .testimonials-container { max-width:1100px; margin:0 auto; padding:0 20px; }
    .testimonials-title { text-align:center; font-size:clamp(24px,3vw,32px); font-weight:700; margin-bottom:50px; }
    .region-search-box {
      max-width: 600px;
      margin: 0 auto;
      display: flex;
      gap: 12px;
      align-items: center;
    }
    .region-search-select {
      flex: 1;
      padding: 16px 20px;
      font-size: 16px;
      border: 2px solid rgba(255,255,255,.3);
      border-radius: 12px;
      outline: none;
      transition: all .3s ease;
      font-family: 'Noto Sans KR', sans-serif;
      background: rgba(255,255,255,.95);
      color: var(--text);
    }
    .region-search-select:focus {
      border-color: #fff;
      background: #fff;
      box-shadow: 0 0 0 3px rgba(255,255,255,.3);
    }
    .region-search-btn {
      padding: 16px 32px;
      background: rgba(255,255,255,.95);
      color: var(--brand);
      border: none;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all .3s ease;
      white-space: nowrap;
    }
    .region-search-btn:hover {
      background: #fff;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,.2);
    }

    /* 카카오 지도 섹션 */
    .map-section {
      padding: 40px 0 80px 0;
      background: #fff;
    }
    .map-section .section-title {
      margin-bottom: 40px;
    }
    .map-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 20px;
    }
    .map-wrapper {
      width: 100%;
      height: 500px;
      border-radius: var(--radius);
      overflow: hidden;
      box-shadow: 0 4px 20px rgba(0,0,0,.15), 0 0 0 1px rgba(0,0,0,.1);
      border: 3px solid #2c5f8d;
      margin-bottom: 50px;
      position: relative;
      background: #fff;
    }
    #kakao-map {
      width: 100%;
      height: 100%;
    }
    .map-controls {
      display: flex;
      gap: 12px;
      justify-content: center;
      margin-top: 20px;
    }
    .map-btn {
      padding: 12px 24px;
      background: var(--brand);
      color: #fff;
      border: none;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all .3s ease;
    }
    .map-btn:hover {
      background: var(--brand-dark);
      transform: translateY(-2px);
    }
    .location-info {
      text-align: center;
      margin-top: 20px;
      padding: 16px;
      background: var(--section-bg);
      border-radius: 12px;
      font-size: 14px;
      color: var(--muted);
    }

    /* 대기질 등급 안내 섹션 */
    .grade-guide-section {
      background: #fff;
      padding: 20px 0;
    }
    .grade-guide-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 20px;
    }
    .grade-guide-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20px;
      margin-top: 40px;
    }
    .grade-guide-card {
      background: #fff;
      border-radius: 16px;
      padding: 24px;
      border: 2px solid #eee;
      transition: all .3s ease;
      text-align: center;
    }
    .grade-guide-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 24px rgba(0,0,0,.1);
    }
    .grade-guide-icon {
      width: 64px;
      height: 64px;
      border-radius: 50%;
      margin: 0 auto 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 32px;
    }
    .grade-guide-icon.good { background: #f6ffed; }
    .grade-guide-icon.normal { background: #e6f7ff; }
    .grade-guide-icon.bad { background: #fffbe6; }
    .grade-guide-icon.very-bad { background: #fff1f0; }
    .grade-guide-title {
      font-size: 18px;
      font-weight: 700;
      margin: 0 0 8px;
    }
    .grade-guide-title.good { color: #52c41a; }
    .grade-guide-title.normal { color: #1890ff; }
    .grade-guide-title.bad { color: #faad14; }
    .grade-guide-title.very-bad { color: #ff4d4f; }
    .grade-guide-desc {
      font-size: 14px;
      color: var(--muted);
      line-height: 1.6;
      margin: 0;
    }

    /* 주요 도시 대기질 섹션 */
    .cities-section {
      background: var(--section-bg);
      padding: 60px 0;
    }
    .cities-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 20px;
    }
    .cities-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-top: 40px;
    }
    .city-card {
      background: #fff;
      border-radius: 16px;
      padding: 24px;
      box-shadow: var(--shadow);
      transition: all .3s ease;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .city-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 32px rgba(0,0,0,.12);
    }
    .city-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .city-name {
      font-size: 20px;
      font-weight: 700;
      color: var(--text);
      margin: 0;
    }
    .city-grade {
      padding: 6px 12px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
    }
    .city-grade.good { background: #f6ffed; color: #52c41a; }
    .city-grade.normal { background: #e6f7ff; color: #1890ff; }
    .city-grade.bad { background: #fffbe6; color: #faad14; }
    .city-grade.very-bad { background: #fff1f0; color: #ff4d4f; }
    .city-info {
      display: flex;
      justify-content: space-between;
      font-size: 14px;
      color: var(--muted);
    }
    .city-info-item {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .city-info-label {
      font-size: 12px;
    }
    .city-info-value {
      font-size: 16px;
      font-weight: 600;
      color: var(--text);
    }

    /* 대기질 개선 팁 섹션 */
    .tips-section {
      background: #fff;
      padding: 60px 0;
    }
    .tips-container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 20px;
    }
    .tips-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 24px;
      margin-top: 40px;
    }
    .tip-card {
      background: linear-gradient(135deg, #f8f9fa, #fff);
      border-radius: 16px;
      padding: 28px;
      border: 1px solid #eee;
      transition: all .3s ease;
    }
    .tip-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 32px rgba(0,0,0,.08);
    }
    .tip-icon {
      font-size: 40px;
      margin-bottom: 16px;
    }
    .tip-title {
      font-size: 18px;
      font-weight: 700;
      color: var(--text);
      margin: 0 0 12px;
    }
    .tip-desc {
      font-size: 15px;
      color: var(--muted);
      line-height: 1.7;
      margin: 0;
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
    @media (max-width: 920px){
      .hero{min-height: 80vh}
      .products-grid{grid-template-columns: repeat(2, 1fr)}
      .search-input{font-size: 16px; padding: 16px 50px 16px 16px}
      .search-button{width: 40px; height: 40px}
      .search-button svg{width: 18px; height: 18px}
      .hero h1{font-size: clamp(28px, 4vw, 40px)}
      .hero p{font-size: clamp(16px, 2.5vw, 20px)}
    }
    @media (max-width: 600px){
      .products-grid{grid-template-columns: 1fr}
      .grade-guide-grid{grid-template-columns: repeat(2, 1fr)}
      .cities-grid{grid-template-columns: 1fr}
      .tips-grid{grid-template-columns: 1fr}
    }
    @media (max-width: 480px){
      .nav-right{gap:12px; font-size:.92rem}
      .promo{font-size:.8rem}
      .footer-links{flex-direction: column; gap: 15px}
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
        <a href="/board" class="nav-board">게시판</a>
        <a href="/notice" class="nav-notice">공지사항</a>
        <a href="/qna" class="nav-qna">QnA</a>
      </div>
    </div>
  </div>

    <main>

    <!-- 카카오 지도 섹션 -->
    <section class="map-section">
      <div class="map-container">
        <h2 class="section-title">실시간 대기질 정보</h2>
        <div class="map-wrapper">
          <div id="kakao-map" style="width:100%;height:100%;"></div>
        </div>
        <div class="map-controls">
          <button class="map-btn" id="getLocationBtn">현재 위치 확인</button>
          <button class="map-btn" id="resetMapBtn">지도 초기화</button>
        </div>
        <div class="location-info" id="locationInfo">지도를 클릭하거나 현재 위치 확인 버튼을 눌러주세요</div>
      </div>
    </section>

    <!-- 대기질 등급 안내 섹션 -->
    <section class="grade-guide-section">
      <div class="grade-guide-container">
        <h2 class="section-title">대기질 등급 안내</h2>
        <div class="grade-guide-grid">
          <div class="grade-guide-card">
            <div class="grade-guide-icon good">✅</div>
            <h3 class="grade-guide-title good">좋음</h3>
            <p class="grade-guide-desc">대기질이 양호하여 모든 활동에 적합합니다.</p>
          </div>
          <div class="grade-guide-card">
            <div class="grade-guide-icon normal">⚠️</div>
            <h3 class="grade-guide-title normal">보통</h3>
            <p class="grade-guide-desc">일반적으로 양호하나 민감한 사람은 주의가 필요합니다.</p>
          </div>
          <div class="grade-guide-card">
            <div class="grade-guide-icon bad">😷</div>
            <h3 class="grade-guide-title bad">나쁨</h3>
            <p class="grade-guide-desc">장시간 실외 활동 시 주의가 필요합니다.</p>
          </div>
          <div class="grade-guide-card">
            <div class="grade-guide-icon very-bad">🚫</div>
            <h3 class="grade-guide-title very-bad">매우 나쁨</h3>
            <p class="grade-guide-desc">실외 활동을 자제하고 외출 시 마스크를 착용하세요.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 주요 도시 대기질 섹션 -->
    <section class="cities-section">
      <div class="cities-container">
        <h2 class="section-title">주요 도시 대기질 현황</h2>
        <div class="cities-grid">
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">서울</h3>
              <span class="city-grade normal">보통</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">45 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">25 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">부산</h3>
              <span class="city-grade good">좋음</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">28 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">15 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">대구</h3>
              <span class="city-grade bad">나쁨</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">78 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">42 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">인천</h3>
              <span class="city-grade normal">보통</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">52 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">28 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">광주</h3>
              <span class="city-grade good">좋음</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">32 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">18 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">대전</h3>
              <span class="city-grade normal">보통</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">48 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">26 ㎍/㎥</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 대기질 개선 팁 섹션 -->
    <section class="tips-section">
      <div class="tips-container">
        <h2 class="section-title">대기질 개선을 위한 팁</h2>
        <div class="tips-grid">
          <div class="tip-card">
            <div class="tip-icon">🚗</div>
            <h3 class="tip-title">대중교통 이용하기</h3>
            <p class="tip-desc">개인 차량 대신 대중교통을 이용하면 대기 오염을 줄일 수 있습니다.</p>
          </div>
          <div class="tip-card">
            <div class="tip-icon">🌳</div>
            <h3 class="tip-title">공기 정화 식물 키우기</h3>
            <p class="tip-desc">실내에 공기 정화 식물을 두면 실내 공기질을 개선하는데 도움이 됩니다.</p>
          </div>
          <div class="tip-card">
            <div class="tip-icon">🏠</div>
            <h3 class="tip-title">환기 습관 개선</h3>
            <p class="tip-desc">대기질이 좋은 시간대에 환기를 하면 실내 공기질을 유지할 수 있습니다.</p>
          </div>
        </div>
      </div>
    </section>

    

    

    <!-- 지역 검색 섹션 -->
    <section class="testimonials-section">
      <div class="testimonials-container">
        <h2 class="testimonials-title">지역별 대기질 조회</h2>
        <div class="region-search-box">
          <select id="regionSearchSelect" class="region-search-select">
            <option value="">지역을 선택하세요</option>
            <option value="서울">서울특별시</option>
            <option value="부산">부산광역시</option>
            <option value="대구">대구광역시</option>
            <option value="인천">인천광역시</option>
            <option value="광주">광주광역시</option>
            <option value="대전">대전광역시</option>
            <option value="울산">울산광역시</option>
            <option value="세종">세종특별자치시</option>
            <option value="경기">경기도</option>
            <option value="강원">강원도</option>
            <option value="충북">충청북도</option>
            <option value="충남">충청남도</option>
            <option value="전북">전라북도</option>
            <option value="전남">전라남도</option>
            <option value="경북">경상북도</option>
            <option value="경남">경상남도</option>
            <option value="제주">제주특별자치도</option>
          </select>
          <button class="region-search-btn" id="regionSearchBtn">조회</button>
        </div>
      </div>
    </section>
    

  </main>

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

    

    // 카카오 지도 초기화
    let map = null;
    let marker = null;
    
    document.addEventListener('DOMContentLoaded', function() {
      // 카카오 지도 스크립트가 로드되었는지 확인
      if (typeof kakao !== 'undefined' && kakao.maps) {
        initMap();
      } else {
        // 카카오 지도 스크립트 로드 대기
        const checkKakao = setInterval(() => {
          if (typeof kakao !== 'undefined' && kakao.maps) {
            clearInterval(checkKakao);
            initMap();
          }
        }, 100);
        
        // 10초 후 타임아웃
        setTimeout(() => {
          clearInterval(checkKakao);
          if (!map) {
            document.getElementById('kakao-map').innerHTML = 
              '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:#999;">카카오 지도 API 키를 설정해주세요.<br>(YOUR_KAKAO_APP_KEY를 교체하세요)</div>';
          }
        }, 10000);
      }
    });

    function initMap() {
      kakao.maps.load(() => {
        const container = document.getElementById('kakao-map');
        const options = {
          center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울 기본 위치
          level: 3
        };
        map = new kakao.maps.Map(container, options);
        
        // 지도 클릭 이벤트
        kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
          const latlng = mouseEvent.latLng;
          setMarkerPosition(latlng);
        });
      });
    }

    // 마커 위치 설정
    function setMarkerPosition(latlng) {
      if (!marker) {
        marker = new kakao.maps.Marker({
          position: latlng
        });
        marker.setMap(map);
      } else {
        marker.setPosition(latlng);
      }
      map.setCenter(latlng);
      
      // 위치 정보 표시
      getAddressFromCoords(latlng.getLng(), latlng.getLat());
    }

    // 좌표를 주소로 변환
    function getAddressFromCoords(lng, lat) {
      const geocoder = new kakao.maps.services.Geocoder();
      geocoder.coord2Address(lng, lat, (result, status) => {
        if (status === kakao.maps.services.Status.OK) {
          const address = result[0].address.address_name;
          document.getElementById('locationInfo').textContent = `위치: ${address}`;
        }
      });
    }

    // 현재 위치 확인 버튼
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('getLocationBtn').addEventListener('click', function() {
        if (!map) {
          alert('지도가 아직 로드되지 않았습니다. 잠시 후 다시 시도해주세요.');
          return;
        }
        
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(
            function(position) {
              const lat = position.coords.latitude;
              const lng = position.coords.longitude;
              const latlng = new kakao.maps.LatLng(lat, lng);
              setMarkerPosition(latlng);
            },
            function(error) {
              alert('위치 정보를 가져올 수 없습니다.');
            }
          );
        } else {
          alert('브라우저가 위치 정보를 지원하지 않습니다.');
        }
      });
    });

    // 지도 초기화 버튼
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('resetMapBtn').addEventListener('click', function() {
        if (map) {
          map.setCenter(new kakao.maps.LatLng(37.5665, 126.9780));
          map.setLevel(3);
          if (marker) {
            marker.setMap(null);
            marker = null;
          }
          document.getElementById('locationInfo').textContent = '지도를 클릭하거나 현재 위치 확인 버튼을 눌러주세요';
        }
      });

      // 지역 검색 기능: 선택한 지역으로 지도 이동 (지오코딩)
      document.getElementById('regionSearchBtn').addEventListener('click', function() {
        const region = document.getElementById('regionSearchSelect').value;
        if (!region) {
          alert('지역을 선택해주세요.');
          return;
        }
        if (!map) {
          alert('지도가 아직 로드되지 않았습니다. 잠시 후 다시 시도해주세요.');
          return;
        }
        const geocoder = new kakao.maps.services.Geocoder();
        geocoder.addressSearch(region, function(result, status) {
          if (status === kakao.maps.services.Status.OK && result[0]) {
            const y = parseFloat(result[0].y);
            const x = parseFloat(result[0].x);
            const latlng = new kakao.maps.LatLng(y, x);
            setMarkerPosition(latlng);
          } else {
            alert('해당 지역을 찾을 수 없습니다.');
          }
        });
      });
    });
  </script>
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=975872f5b9b87199e7b4e5d8a371f318"></script>
  <script>
    // 카카오 지도는 위의 DOMContentLoaded 이벤트에서 이미 초기화됨
  </script>
</body>
</html>