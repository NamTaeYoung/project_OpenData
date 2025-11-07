<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 | 책갈피</title>
	<!-- 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">

	<!-- 외부 CSS -->
  	<link rel="stylesheet" href="/css/register.css">
    <!-- 회원가입 외부 js -->
	<script src="/js/register.js"></script>
	<!-- 다음 api -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	
	<!-- 제이쿼리 -->
	<script src="/js/jquery.js"></script>
<script>
let checkIdOk = false;
let emailOk = false;
$(function(){
    $("#checkId").click(function(){
        const user_id = $("#user_id").val().trim();

    	if(reg_frm.user_id.value==""){
    		alert("아이디를 써주세요.");
    		reg_frm.user_id.focus();//입력안할때 깜빡임
    		return;
    	}

        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/checkId", // contextPath 자동 반영
            data: { "user_id": user_id },
            dataType: "text", // text로 받기
            success: function(result){
                if (result.trim() === "N") {
                    $("#result_checkId").text("사용 가능한 아이디입니다.")
                        .css("color", "green");
                    	checkIdOk = true; //통과 
                    $("#user_pw").focus();
                } else {
                    $("#result_checkId").text("이미 사용 중인 아이디입니다.")
                        .css("color", "red");
                    $("#user_id").val("").focus();
                    checkIdOk = false; //실패 
                }
            },
            error: function(xhr, status, error){
                alert("서버 오류: " + error);
            }
        });
    });
});
</script>
</head>
<body>
    <!-- Header -->
    <header>
        <nav class="nav" aria-label="주요 메뉴">
            <a href="/main" class="brand">대기질 정보</a>
            <div class="nav-right">
                <a href="<c:url value='/login'/>">로그인</a>
                <a href="<c:url value='/register'/>" aria-current="page" style="font-weight:700; color:var(--brand)">회원가입</a>
				<a href="<c:url value='/admin/login'/>">관리자정보</a>            </div>
        </nav>
    </header>

    <!-- 얇은 갈색 줄 -->
    <div class="promo" aria-hidden="true"></div>

    <!-- Signup -->
    <main class="auth-wrap">
            <!-- 폼 -->
            <div class="auth-form">
                <h1 class="auth-title">회원가입</h1>
                <p class="auth-desc">간단한 정보만 입력하면 도서 관리 서비스를 바로 이용할 수 있어요.</p>

                <form id="signupForm" novalidate name="reg_frm" method="post" action="register_ok">
                    <!-- 이름 / 닉네임 -->
                    <div class="grid-2">
                        <div class="field">
                            <label class="label" for="user_name">이름</label>
                            <input class="input" id="user_name" name="user_name" type="text" placeholder="홍길동" minlength="2"
                                required />
                        </div>
                        <div class="field">
                            <label class="label" for="user_nickname">닉네임</label>
                            <input class="input" id="user_nickname" name="user_nickname" type="text" placeholder="매니저" />
                        </div>
                    </div>

                    <!-- 아이디 -->
                    <div class="field">
                        <label class="label" for="user_id">아이디</label>
                        <div class="row-inline">
	                        <input class="input" id="user_id" name="user_id" type="text" inputmode="text" placeholder="영문/숫자 4~20자"
	                        	   required/>
	                       	<input type="button" class="btn-auth" id="checkId" value="중복검사">
	                    </div>
							<span id="result_checkId" style="font-size:12px; position:relative; top:-15px;""></span>
                    </div>

                    <!-- 비밀번호 / 확인 -->
                    <div class="grid-2">
                        <div class="field">
                            <label class="label" for="user_pw">비밀번호</label>
                            <input class="input" id="user_pw" name="user_pw" type="password"
                                placeholder="8자 이상, 영문/숫자 조합" minlength="8" required />
                        </div>
                        <div class="field">
                            <label class="label" for="pwd_check">비밀번호 확인</label>
                            <input class="input" id="pwd_check" name="pwd_check" type="password" placeholder="비밀번호 재입력"
                                minlength="8" required />
                        </div>
                    </div>

                    <!-- 이메일 + 인증번호 보내기 -->
                    <div class="field">
                        <label class="label" for="user_email">이메일</label>
                        <div class="row-inline">
                            <input class="input" id="user_email" name="user_email" type="email" inputmode="email"
                                placeholder="you@example.com" required />
                            <button type="button" class="btn-auth" id="btnSend" onclick="sendAuthCode()">인증번호 보내기</button>
                        </div>
                    </div>

                    <!-- 인증번호 + 확인 -->
                    <div class="field">
                        <label class="label" for="user_email_chk">인증번호</label>
                        <div class="row-inline">
                            <input class="input" id="user_email_chk" name="user_email_chk" type="text" placeholder="인증번호" />
                            <button type="button" class="btn-auth" id="btnVerify" onclick="verifyAuthCode()"disabled>인증번호 확인</button>
                        </div>
                    </div>

                    <!-- 전화번호 -->
                    <div class="field">
                        <label class="label" for="user_phone_num">휴대폰 번호</label>
                        <input class="input" id="user_phone_num" name="user_phone_num" type="tel" inputmode="tel"
                            placeholder="010-1234-5678" />
                    </div>

                    <!-- 우편번호/주소 -->
                    <div class="field">
                        <label class="label" for="user_post_num">우편번호</label>
                        <div class="row-inline">
                            <input class="input" id="user_post_num" name="user_post_num" type="text" inputmode="numeric"
                                placeholder="예) 47212" maxlength="10" />
                            <button type="button" class="btn-auth" id="btnZip" onclick="chk_post()">우편번호검색</button>
                        </div>
                    </div>

                    <div class="field">
                        <label class="label" for="user_address">주소</label>
                        <input class="input" id="user_address" name="user_address" type="text" placeholder="도로명 주소" />
                    </div>

                    <div class="field">
                        <label class="label" for="user_detail_address">상세주소</label>
                        <input class="input" id="user_detail_address" name="user_detail_address" type="text" placeholder="동/호수 등" />
                    </div>

                    <!-- 제출 -->
                    <div class="submit">
                        <button type="button" class="btn btn-primary" onclick="check_ok()" id="register_btn">회원가입 완료</button>
                        <button type="button" class="btn btn-ghost" onclick="location.href='login'">이미 계정이 있으신가요?
                            로그인</button>
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
  	<script src="/js/register.js"></script>
</body>
</html>
