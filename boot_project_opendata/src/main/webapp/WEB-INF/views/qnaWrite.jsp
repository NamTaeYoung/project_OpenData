<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>글쓰기 - QnA</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/boardWrite.css">
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
        <a href="/board/list" class="nav-board">게시판</a>
        <a href="/notice" class="nav-notice">공지사항</a>
        <a href="/qna" class="nav-qna active">QnA</a>
      </div>
    </div>
  </div>

  <!-- 글쓰기 섹션 -->
  <section class="write-section">
    <div class="write-container">
      <div class="write-header">
        <h1 class="write-title">QnA 글쓰기</h1>
      </div>

      <form class="write-form" id="writeForm" method="post" action="/qna/write" enctype="multipart/form-data">
        <%-- 백엔드 연동 시: 수정 모드일 경우 id 추가
        <input type="hidden" name="id" value="${qna.id}">
        --%>

        <div class="form-group">
          <label class="form-label required" for="title">제목</label>
          <input type="text" id="title" name="title" class="form-input" placeholder="제목을 입력하세요" required>
        </div>

        <div class="form-group">
          <label class="form-label required" for="writer">작성자</label>
          <input type="text" id="writer" name="writer" class="form-input" placeholder="작성자를 입력하세요" required>
          <%-- 백엔드 연동 시: 로그인한 사용자 정보 자동 입력
          <input type="text" id="writer" name="writer" class="form-input" value="${sessionScope.user.name}" readonly>
          --%>
        </div>

        <div class="form-group">
          <label class="form-label required" for="content">내용</label>
          <textarea id="content" name="content" class="form-textarea" placeholder="내용을 입력하세요" required></textarea>
        </div>

        <div class="form-group">
          <label class="form-label" for="fileUpload">파일 업로드</label>
          <div class="file-upload-area" id="fileUploadArea">
            <div class="file-upload-icon">📎</div>
            <div class="file-upload-text">파일을 드래그하거나 클릭하여 업로드</div>
            <div class="file-upload-hint">최대 10MB까지 업로드 가능</div>
            <input type="file" id="fileUpload" name="files" class="file-input" multiple accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png,.gif,.zip,.txt">
          </div>
          <div class="file-list" id="fileList"></div>
        </div>

        <div class="form-actions">
          <button type="button" class="btn btn-cancel" onclick="location.href='/qna'">취소</button>
          <button type="submit" class="btn btn-submit">등록</button>
        </div>
      </form>
    </div>
  </section>

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
    // 파일 업로드 관련 스크립트
    const fileUploadArea = document.getElementById('fileUploadArea');
    const fileInput = document.getElementById('fileUpload');
    const fileList = document.getElementById('fileList');
    const selectedFiles = [];

    // 파일 선택 클릭
    fileUploadArea.addEventListener('click', () => {
      fileInput.click();
    });

    // 파일 선택 시
    fileInput.addEventListener('change', (e) => {
      handleFiles(e.target.files);
    });

    // 드래그 앤 드롭
    fileUploadArea.addEventListener('dragover', (e) => {
      e.preventDefault();
      fileUploadArea.classList.add('dragover');
    });

    fileUploadArea.addEventListener('dragleave', () => {
      fileUploadArea.classList.remove('dragover');
    });

    fileUploadArea.addEventListener('drop', (e) => {
      e.preventDefault();
      fileUploadArea.classList.remove('dragover');
      handleFiles(e.dataTransfer.files);
    });

    // 파일 처리 함수
    function handleFiles(files) {
      Array.from(files).forEach(file => {
        // 파일 크기 체크 (10MB)
        if (file.size > 10 * 1024 * 1024) {
          alert(`${file.name} 파일이 10MB를 초과합니다.`);
          return;
        }

        // 중복 체크
        if (selectedFiles.some(f => f.name === file.name && f.size === file.size)) {
          alert(`${file.name} 파일이 이미 선택되어 있습니다.`);
          return;
        }

        selectedFiles.push(file);
        addFileToList(file);
      });

      if (selectedFiles.length > 0) {
        fileList.classList.add('active');
      }
    }

    // 파일 목록에 추가
    function addFileToList(file) {
      const fileItem = document.createElement('div');
      fileItem.className = 'file-item';
      const fileName = file.name.replace(/'/g, "\\'");
      const fileSize = formatFileSize(file.size);
      fileItem.innerHTML = 
        '<div class="file-item-info">' +
          '<span class="file-item-name">' + fileName + '</span>' +
          '<span class="file-item-size">(' + fileSize + ')</span>' +
        '</div>' +
        '<button type="button" class="file-item-remove" onclick="removeFile(\'' + fileName + '\', ' + file.size + ')">삭제</button>';
      fileList.appendChild(fileItem);
    }

    // 파일 삭제
    function removeFile(fileName, fileSize) {
      const index = selectedFiles.findIndex(f => f.name === fileName && f.size === fileSize);
      if (index > -1) {
        selectedFiles.splice(index, 1);
        updateFileList();
      }
    }

    // 파일 목록 업데이트
    function updateFileList() {
      fileList.innerHTML = '';
      selectedFiles.forEach(file => {
        addFileToList(file);
      });

      if (selectedFiles.length === 0) {
        fileList.classList.remove('active');
      } else {
        // 파일 input 업데이트 (FormData 사용 시 필요)
        const dataTransfer = new DataTransfer();
        selectedFiles.forEach(file => {
          dataTransfer.items.add(file);
        });
        fileInput.files = dataTransfer.files;
      }
    }

    // 파일 크기 포맷팅
    function formatFileSize(bytes) {
      if (bytes === 0) return '0 Bytes';
      const k = 1024;
      const sizes = ['Bytes', 'KB', 'MB', 'GB'];
      const i = Math.floor(Math.log(bytes) / Math.log(k));
      return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
    }

    // 폼 제출 전 검증
    document.getElementById('writeForm').addEventListener('submit', function(e) {
      const title = document.getElementById('title').value.trim();
      const writer = document.getElementById('writer').value.trim();
      const content = document.getElementById('content').value.trim();

      if (!title) {
        e.preventDefault();
        alert('제목을 입력해주세요.');
        document.getElementById('title').focus();
        return false;
      }

      if (!writer) {
        e.preventDefault();
        alert('작성자를 입력해주세요.');
        document.getElementById('writer').focus();
        return false;
      }

      if (!content) {
        e.preventDefault();
        alert('내용을 입력해주세요.');
        document.getElementById('content').focus();
        return false;
      }

      // 백엔드 연동 시: FormData로 파일 전송
      // const formData = new FormData(this);
      // fetch('/qna/write', {
      //   method: 'POST',
      //   body: formData
      // }).then(response => {
      //   // 처리 로직
      // });
    });
  </script>
</body>
</html>
