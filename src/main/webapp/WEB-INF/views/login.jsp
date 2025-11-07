<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>로그인 | 책갈피</title>

  <!-- 폰트 -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">

  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/login.css">
</head>

<body>
  <!-- Header -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/main" class="brand">대기질 정보</a>
      <div class="nav-right">
        <a href="<c:url value='/login'/>" aria-current="page" style="font-weight:700; color:var(--brand)">로그인</a>
        <a href="<c:url value='/register'/>">회원가입</a>
        <a href="<c:url value='/admin/login'/>">관리자정보</a>
      </div>
    </nav>
  </header>

  <!-- Promo Bar -->
  <div class="promo" aria-hidden="true"></div>

  <!-- Login -->
  <main class="auth-wrap">
    <section class="auth-card" aria-label="로그인">
      <!-- 폼 -->
      <div class="auth-form">
        <h1 class="auth-title">로그인</h1>
        <p class="auth-desc">대기질 정보에 오신 것을 환영합니다. 계정으로 로그인해주세요.</p>


		
        <c:if test="${not empty login_err}"></c:if>
        
        <form id="loginForm" novalidate method="post" action="login_yn">
          <div class="field">
            <label class="label" for="user_id">로그인</label>
            <input class="input" id="user_id" name="user_id" type="email" inputmode="email" placeholder="아이디를 입력하세요" required />
          </div>

          <div class="field">
            <label class="label" for="user_pw">비밀번호</label>
            <div class="input-group">
              <input class="input" id="user_pw" name="user_pw" type="password" placeholder="비밀번호를 입력하세요" required />
              <button type="button" class="password-toggle" aria-label="비밀번호 보기/숨기기"></button>
            </div>
          </div>

		  <div class="alert alert-danger" style="color:red; margin-bottom:5px; font-size:12px;position:relative; top:5px;">
		  	    ${login_err}
		  </div><br>
		  
		  <!-- 소셜 로그인 버튼 묶음 -->
		  <div style="display:flex; gap:15px; justify-content:center; margin-top:15px;">
		    <!-- 카카오 로그인 -->
		    <a href="/oauth/kakao/login">
		      <img src="/img/kakao_logo.png"
		           alt="카카오 로그인"
		           style="width:50px; height:50px; cursor:pointer; border-radius:50%;">
		    </a>

		    <!-- 네이버 로그인 -->
		    <a href="/oauth/naver/login">
		      <img src="/img/naver_logo.png"
		           alt="네이버 로그인"
		           style="width:50px; height:50px; cursor:pointer; border-radius:50%;">
		    </a>

		    <!-- 구글 로그인 -->
		    <a href="/oauth/google/login">
		      <img src="/img/google_logo.png"
		           alt="구글 로그인"
		           style="width:50px; height:50px; cursor:pointer; border-radius:50%;">
		    </a>
		  </div>
		  
		  <c:if test="${not empty sessionScope.socialLoginError}">
		    <div class="alert alert-danger" style="color:red; font-size:12px; margin-bottom:5px;">
		      ${sessionScope.socialLoginError}
		    </div>
		    <c:remove var="socialLoginError" scope="session"/>
		  </c:if>
		  
          <div class="forgot-links">
            <a href="#" class="forgot" onclick="showAccountFindModal()">계정을 잊으셨나요?</a>
          </div>

          <div class="submit">
            <button type="submit" class="btn btn-primary">로그인</button>
            <button type="button" class="btn btn-ghost" onclick="location.href='<c:url value="/register"/>'">계정이 없으신가요? 회원가입</button>
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

  <!-- 계정 찾기 모달 -->
  <div id="accountFindModal" class="modal">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title">계정 찾기</h3>
        <span class="close" onclick="closeModal('accountFindModal')">&times;</span>
      </div>
      <p class="modal-description">아이디 또는 비밀번호를 찾으실 수 있습니다.</p>

      <div class="find-tabs">
        <button class="tab-button active" onclick="switchTab('id')">아이디 찾기</button>
        <button class="tab-button" onclick="switchTab('password')">비밀번호 찾기</button>
      </div>

      <!-- 아이디 찾기 -->
      <form id="idFindForm" class="modal-form" onsubmit="findId(event)" style="display: block;">
        <div class="field">
          <label class="label" for="find_email">이메일</label>
          <input class="input" id="find_email" name="user_email" type="email" placeholder="이메일을 입력하세요" required />
        </div>
        <div class="modal-submit">
          <button type="submit" class="btn btn-primary">확인</button>
        </div>
      </form>

     <!-- 비밀번호 찾기 -->
      <form id="passwordFindForm" class="modal-form" onsubmit="findPassword(event)" style="display: none;">
        <div class="field">
          <label class="label" for="find_id">아이디</label>
          <input class="input" id="find_id" name="user_id" type="text" placeholder="아이디를 입력하세요" required />
        </div>
        <div class="field">
          <label class="label" for="find_pwd_email">이메일</label>
          <input class="input" id="find_pwd_email" name="user_email" type="email" placeholder="이메일을 입력하세요" required />
        </div>
        <div class="modal-submit">
          <button type="submit" class="btn btn-primary">확인</button>
        </div>
      </form>
    </div>
  </div>

  <!-- 외부 JS -->
  <script src="/js/login.js"></script>
</body>
</html>
