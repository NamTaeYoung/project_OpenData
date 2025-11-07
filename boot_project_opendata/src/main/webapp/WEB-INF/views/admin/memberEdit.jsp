<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 수정 | 관리자</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/main.css">
    <style>
        .edit-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .edit-card {
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .edit-title {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 30px;
            color: #2b2b2b;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            font-weight: 700;
            margin-bottom: 8px;
            color: #333;
        }
        .form-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-input:focus {
            outline: none;
            border-color: #2c5f8d;
        }
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 700;
        }
        .btn-primary {
            background: #2c5f8d;
            color: white;
        }
        .btn-primary:hover {
            background: #1e4261;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
    </style>
</head>
<body>
    <!-- 헤더 & 네비 -->
    <header>
        <nav class="nav" aria-label="주요 메뉴">
           <a href="/adminMain" class="brand">대기질 정보</a>
            <div class="nav-right">
                <a href="<c:url value='/adminMain'/>">관리자메인</a>
                <a href="<c:url value='/logout'/>">로그아웃</a>
            </div>
        </nav>
    </header>

    <!-- Promo Bar -->
    <div class="promo" aria-hidden="true"></div>

    <main>
        <div class="edit-container">
            <div class="edit-card">
                <h1 class="edit-title">회원 정보 수정</h1>
                
                <form method="post" action="/memberManagement/update">
                    <input type="hidden" name="user_id" value="${member.user_id}">
                    
                    <div class="form-group">
                        <label class="form-label">아이디</label>
                        <input type="text" class="form-input" value="${member.user_id}" disabled>
                        <small style="color: #666;">아이디는 수정할 수 없습니다.</small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input type="text" name="user_name" class="form-input" value="${member.user_name}" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">닉네임</label>
                        <input type="text" name="user_nickname" class="form-input" value="${member.user_nickname}">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">이메일</label>
                        <input type="email" name="user_email" class="form-input" value="${member.user_email}" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">전화번호</label>
                        <input type="tel" name="user_phone_num" class="form-input" value="${member.user_phone_num}">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">우편번호</label>
                        <input type="text" name="user_post_num" class="form-input" value="${member.user_post_num}">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">주소</label>
                        <input type="text" name="user_address" class="form-input" value="${member.user_address}">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">상세주소</label>
                        <input type="text" name="user_detail_address" class="form-input" value="${member.user_detail_address}">
                    </div>
                    
                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">수정 완료</button>
                        <a href="/memberManagement" class="btn btn-secondary">취소</a>
                    </div>
                </form>
            </div>
        </div>
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
</body>
</html>
