<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원관리 | 관리자</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/main.css">
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
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            color: var(--text);
            background: var(--bg);
            line-height: 1.5;
        }
        /* 회원관리 섹션 */
        .member-management-section {
            padding: 60px 0;
            background: var(--section-bg);
            min-height: calc(100vh - 200px);
            width: 100%;
        }
        .member-management-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
        }
        .member-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .member-title {
            font-size: clamp(24px, 3vw, 32px);
            font-weight: 700;
            color: var(--text);
            margin: 0;
        }
        .table-wrapper {
            overflow-x: auto;
            background: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        .member-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            min-width: 1200px;
        }
        .member-table thead {
            background: var(--brand);
            color: white;
        }
        .member-table th {
            padding: 15px 12px;
            text-align: left;
            font-weight: 700;
            font-size: 14px;
        }
        .member-table td {
            padding: 16px 12px;
            font-size: 14px;
            color: var(--text);
            word-wrap: break-word;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .member-table tbody tr {
            border-bottom: 1px solid #eee;
            transition: background .2s ease;
        }
        .member-table tbody tr:hover {
            background: #f8f9fa;
        }
        /* 컬럼 너비 조정 */
        .member-table th:nth-child(1),  /* 아이디 */
        .member-table td:nth-child(1) {
            width: 10%;
            min-width: 100px;
        }
        .member-table th:nth-child(2),  /* 이름 */
        .member-table td:nth-child(2) {
            width: 8%;
            min-width: 80px;
        }
        .member-table th:nth-child(3),  /* 닉네임 */
        .member-table td:nth-child(3) {
            width: 8%;
            min-width: 80px;
        }
        .member-table th:nth-child(4),  /* 이메일 */
        .member-table td:nth-child(4) {
            width: 18%;
            min-width: 180px;
        }
        .member-table th:nth-child(5),  /* 전화번호 */
        .member-table td:nth-child(5) {
            width: 12%;
            min-width: 120px;
        }
        .member-table th:nth-child(6),  /* 로그인 타입 */
        .member-table td:nth-child(6) {
            width: 10%;
            min-width: 100px;
            text-align: center;
        }
        .member-table th:nth-child(7),  /* 가입일 */
        .member-table td:nth-child(7) {
            width: 18%;
            min-width: 180px;
        }
        .member-table th:nth-child(8),  /* 관리 */
        .member-table td:nth-child(8) {
            width: 16%;
            min-width: 150px;
            text-align: center;
        }
        .btn-edit, .btn-delete {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            margin: 0 3px;
            white-space: nowrap;
        }
        .btn-edit {
            background: var(--brand);
            color: white;
        }
        .btn-edit:hover {
            background: var(--brand-dark);
        }
        .btn-delete {
            background: #c62828;
            color: white;
        }
        .btn-delete:hover {
            background: #9e1f1f;
        }
        .alert {
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        @media (max-width: 1400px) {
            .table-wrapper {
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <!-- 헤더 & 네비 -->
    <header>
        <nav class="nav" aria-label="주요 메뉴">
            <a href="/adminMain" class="brand">대기질 정보</a>
            <div class="nav-right">
                <c:choose>
                    <c:when test="${empty sessionScope.loginDisplayName}">
                        <a href="<c:url value='/login'/>">로그인</a>
                        <a href="<c:url value='/register'/>">회원가입</a>
                    </c:when>
                    <c:otherwise>
                        <a href="<c:url value='/adminMain'/>">관리자메인</a>
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
          <a href="/adminMain" class="nav-category">상세정보</a>
          <a href="/memberManagement" class="nav-board active">회원관리</a>
          <a href="/boardManagement" class="nav-notice">게시판관리</a>
          <a href="/qna" class="nav-qna">지역관리</a>
        </div>
      </div>
    </div>

    <main>
        <!-- 회원관리 섹션 -->
        <section class="member-management-section">
            <div class="member-management-container">
                <div class="member-header">
                    <h1 class="member-title">회원 관리</h1>
                </div>

                <c:if test="${param.success == 'update'}">
                    <div class="alert alert-success">회원 정보가 수정되었습니다.</div>
                </c:if>
                <c:if test="${param.success == 'delete'}">
                    <div class="alert alert-success">회원이 삭제되었습니다.</div>
                </c:if>
                <c:if test="${param.error == 'update'}">
                    <div class="alert alert-error">회원 정보 수정에 실패했습니다.</div>
                </c:if>
                <c:if test="${param.error == 'delete'}">
                    <div class="alert alert-error">회원 삭제에 실패했습니다.</div>
                </c:if>

                <div class="table-wrapper">
                    <table class="member-table">
                        <thead>
                            <tr>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>닉네임</th>
                                <th>이메일</th>
                                <th>전화번호</th>
                                <th>로그인 타입</th>
                                <th>가입일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty memberList}">
                                    <tr>
                                        <td colspan="8" style="text-align: center; padding: 40px;">
                                            등록된 회원이 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="member" items="${memberList}">
                                        <tr>
                                            <td>${member.user_id}</td>
                                            <td>${member.user_name}</td>
                                            <td>${member.user_nickname}</td>
                                            <td>${member.user_email}</td>
                                            <td>${member.user_phone_num}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty member.login_type}">일반</c:when>
                                                    <c:otherwise>${member.login_type}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${member.reg_date}</td>
                                            <td>
                                                <a href="/memberManagement/edit?user_id=${member.user_id}" class="btn-edit">수정</a>
                                                <button onclick="deleteMember('${member.user_id}')" class="btn-delete">삭제</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
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
        function deleteMember(userId) {
            if (confirm('정말로 이 회원을 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/memberManagement/delete';
                
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'user_id';
                input.value = userId;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>