<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>관리자 로그인 | 대기질 정보</title>

  <!-- 폰트 -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">

  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/login.css">
  
  <!-- 관리자 로그인 박스 크기 조정 -->
  <style>
    .auth-form {
      min-width: 500px;
      max-width: 600px;
      width: 100%;
      padding: 80px 60px;
    }
    
    @media (max-width: 600px) {
      .auth-form {
        min-width: auto;
        padding: 60px 40px;
      }
    }
  </style>
</head>

<body>
  <!-- Header -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/main" class="brand">대기질 정보</a>
      <div class="nav-right">
        <a href="<c:url value='/login'/>">로그인</a>
        <a href="<c:url value='/register'/>">회원가입</a>
        <a href="<c:url value='/admin/login'/>" aria-current="page" style="font-weight:700; color:var(--brand)">관리자정보</a>
      </div>
    </nav>
  </header>

  <!-- Promo Bar -->
  <div class="promo" aria-hidden="true"></div>

  <!-- Login -->
  <main class="auth-wrap">
    <section class="auth-card" aria-label="관리자 로그인">
      <!-- 폼 -->
      <div class="auth-form">
        <h1 class="auth-title">관리자 로그인</h1>
        <p class="auth-desc">관리자 계정으로 로그인해주세요.</p>

        <c:if test="${not empty login_err}"></c:if>
        
        <form id="adminLoginForm" novalidate method="post" action="/admin/login_yn">
          <div class="field">
            <label class="label" for="username">관리자 아이디</label>
            <input class="input" id="username" name="username" type="text" placeholder="관리자 아이디를 입력하세요" required />
          </div>

          <div class="field">
            <label class="label" for="password">비밀번호</label>
            <div class="input-group">
              <input class="input" id="password" name="password" type="password" placeholder="비밀번호를 입력하세요" required />
              <button type="button" class="password-toggle" aria-label="비밀번호 보기/숨기기"></button>
            </div>
          </div>

          <div class="alert alert-danger" style="color:red; margin-bottom:5px; font-size:12px;position:relative; top:5px;">
            ${login_err}
          </div><br>
          
          <c:if test="${not empty message}">
            <div class="alert alert-info" style="color:blue; margin-bottom:5px; font-size:12px;position:relative; top:5px;">
              ${message}
            </div><br>
          </c:if>

          <div class="submit">
            <button type="submit" class="btn btn-primary">로그인</button>
            <button type="button" class="btn btn-ghost" onclick="location.href='<c:url value="/main"/>'">메인으로 돌아가기</button>
          </div>
        </form>
      </div>

    </section>
  </main>

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


  <!-- 외부 JS -->
  <script src="/js/login.js"></script>
</body>
</html>
