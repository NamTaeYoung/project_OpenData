<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>비밀번호 재설정 | 책갈피</title>

  <!-- 폰트 -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">

  <!-- 외부 CSS (로그인과 동일 스타일 사용) -->
  <link rel="stylesheet" href="/css/resetpw.css">
</head>

<body>
  <!-- Header -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
        <a href="/main" class="brand">대기질 정보</a>
    </nav>
  </header>

  <!-- Promo Bar -->
  <div class="promo" aria-hidden="true"></div>

  <!-- Password Reset Form -->
  <main class="auth-wrap">
    <section class="auth-card" aria-label="비밀번호 재설정">
      <div class="auth-form">
        <h1 class="auth-title">비밀번호 재설정</h1>
        <p class="auth-desc">새로운 비밀번호를 입력해주세요.</p>

        <form id="resetForm" novalidate>
          <input type="hidden" id="token" value="${param.token}" />

          <div class="field">
            <label class="label" for="new_pw">새 비밀번호</label>
            <input class="input" id="new_pw" name="new_pw" type="password" placeholder="새 비밀번호를 입력하세요" required />
          </div>

          <div class="field">
            <label class="label" for="confirm_pw">비밀번호 확인</label>
            <input class="input" id="confirm_pw" name="confirm_pw" type="password" placeholder="비밀번호를 다시 입력하세요" required />
          </div>

          <div class="submit">
            <button type="submit" class="btn btn-primary">비밀번호 변경</button>
          </div>
        </form>
      </div>

      <!-- 사이드 -->
      <aside class="auth-side" aria-hidden="true">
        <div class="side-top"></div>
        <span class="side-badge"> · 대기질 정보 · </span>
        <h2 class="side-title">외출시 유의하세요!</h2>
        <p class="side-text">보안을 위해 비밀번호를 주기적으로 변경하세요.</p>
      </aside>
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

  <script>
  document.getElementById("resetForm").addEventListener("submit", function(event) {
    event.preventDefault();

 	//비밀번호 정규식
	var passwordRegex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,16}$/;
    
	const newPw = document.getElementById("new_pw").value.trim();
    const confirmPw = document.getElementById("confirm_pw").value.trim();
    const token = document.getElementById("token").value;

    if (!newPw || !confirmPw) {
      alert("비밀번호를 입력해주세요.");
      return;
    }
    if (newPw !== confirmPw) {
      alert("비밀번호가 일치하지 않습니다.");
      return;
    }
    if (!passwordRegex.test(newPw)) {
        alert("비밀번호는 8~16자, 영문자, 숫자, 특수문자를 모두 포함해야 합니다.");
        return;
    }
    fetch("reset_password?token=" + token + "&newPw=" + newPw, { method: "POST" })
    .then(response => response.text())
    .then(result => {
      if (result.trim() === "success") {
        alert("비밀번호가 성공적으로 변경되었습니다. 로그인 페이지로 이동합니다.");
        window.location.href = "${pageContext.request.contextPath}/login";
      } else {
        alert("비밀번호 변경에 실패했습니다. 다시 시도해주세요.");
      }
    })
    .catch(error => {
      console.error("Error:", error);
      alert("서버 오류가 발생했습니다.");
    });
  });
  </script>
</body>
</html>
