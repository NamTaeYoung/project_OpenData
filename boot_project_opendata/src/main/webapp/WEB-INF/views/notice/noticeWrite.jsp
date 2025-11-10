<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>글쓰기 - 게시판</title>
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
      .promo-nav{ gap: 48px; }
      .promo-nav a{ font-weight: 700; font-size: 18px; }
      .promo-nav a + a::before{ left: -24px; height: 20px; }
    }
    .promo-nav a:hover { background: rgba(255,255,255,0.1); }

    /* 글쓰기 섹션 */
    .write-section {
      padding: 60px 0;
      background: var(--section-bg);
      min-height: calc(100vh - 200px);
    }
    .write-container {
      max-width: 900px;
      margin: 0 auto;
      padding: 0 20px;
    }
    .write-header {
      margin-bottom: 30px;
    }
    .write-title {
      font-size: clamp(24px, 3vw, 32px);
      font-weight: 700;
      color: var(--text);
      margin: 0;
    }

    /* 폼 스타일 */
    .write-form {
      background: #fff;
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      padding: 40px;
    }
    .form-group {
      margin-bottom: 24px;
    }
    .form-label {
      display: block;
      font-size: 15px;
      font-weight: 600;
      color: var(--text);
      margin-bottom: 8px;
    }
    .form-label.required::after {
      content: " *";
      color: #ff4d4f;
    }
    .form-input {
      width: 100%;
      padding: 14px 18px;
      border: 2px solid #eee;
      border-radius: 12px;
      font-size: 15px;
      font-family: 'Noto Sans KR', sans-serif;
      outline: none;
      transition: all .3s ease;
    }
    .form-input:focus {
      border-color: var(--brand);
      box-shadow: 0 0 0 3px rgba(44,95,141,.1);
    }
    .form-textarea {
      width: 100%;
      padding: 14px 18px;
      border: 2px solid #eee;
      border-radius: 12px;
      font-size: 15px;
      font-family: 'Noto Sans KR', sans-serif;
      outline: none;
      resize: vertical;
      min-height: 300px;
      transition: all .3s ease;
    }
    .form-textarea:focus {
      border-color: var(--brand);
      box-shadow: 0 0 0 3px rgba(44,95,141,.1);
    }

    /* 파일 업로드 영역 */
    .file-upload-area {
      border: 2px dashed #ddd;
      border-radius: 12px;
      padding: 30px;
      text-align: center;
      background: #fafafa;
      transition: all .3s ease;
      cursor: pointer;
    }
    .file-upload-area:hover {
      border-color: var(--brand);
      background: #f0f7ff;
    }
    .file-upload-area.dragover {
      border-color: var(--brand);
      background: #e6f4ff;
    }
    .file-upload-icon {
      font-size: 48px;
      color: var(--muted);
      margin-bottom: 12px;
    }
    .file-upload-text {
      color: var(--text);
      font-size: 15px;
      margin-bottom: 8px;
    }
    .file-upload-hint {
      color: var(--muted);
      font-size: 13px;
    }
    .file-input {
      display: none;
    }
    .file-list {
      margin-top: 20px;
      display: none;
    }
    .file-list.active {
      display: block;
    }
    .file-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px 16px;
      background: #f8f9fa;
      border-radius: 8px;
      margin-bottom: 8px;
    }
    .file-item-info {
      display: flex;
      align-items: center;
      gap: 12px;
      flex: 1;
    }
    .file-item-name {
      font-size: 14px;
      color: var(--text);
    }
    .file-item-size {
      font-size: 12px;
      color: var(--muted);
    }
    .file-item-remove {
      background: #ff4d4f;
      color: #fff;
      border: none;
      border-radius: 6px;
      padding: 6px 12px;
      font-size: 12px;
      cursor: pointer;
      transition: all .2s ease;
    }
    .file-item-remove:hover {
      background: #ff7875;
    }

    /* 버튼 영역 */
    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      margin-top: 30px;
    }
    .btn {
      padding: 14px 28px;
      border: none;
      border-radius: 12px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      transition: all .3s ease;
      font-family: 'Noto Sans KR', sans-serif;
    }
    .btn-cancel {
      background: #f5f5f5;
      color: var(--text);
    }
    .btn-cancel:hover {
      background: #e8e8e8;
    }
    .btn-submit {
      background: var(--brand);
      color: #fff;
    }
    .btn-submit:hover {
      background: var(--brand-dark);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(44,95,141,.3);
    }
  </style>
</head>
<body>
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
            <a href="<c:url value='/logout'/>">로그아웃</a>
            <span class="user-name">${sessionScope.loginDisplayName}님</span>
          </c:otherwise>
        </c:choose>
      </div>
    </nav>
  </header>

  <!-- 공지사항 등록 섹션 -->
  <section class="write-section">
    <div class="write-container">
      <div class="write-header">
        <h1 class="write-title">공지사항 등록</h1>
      </div>

      <form class="write-form" id="writeForm" method="post" action="/admin/notice/write.do" enctype="multipart/form-data">

        <!-- 제목 -->
        <div class="form-group">
          <label class="form-label required" for="title">제목</label>
          <input type="text" id="title" name="noticeTitle" class="form-input" placeholder="공지 제목을 입력하세요" value="[공지]" required>
        </div>

        <!-- 내용 -->
        <div class="form-group">
          <label class="form-label required" for="content">내용</label>
          <textarea id="content" name="noticeContent" class="form-textarea" placeholder="공지 내용을 입력하세요" required></textarea>
        </div>

        <!-- 파일 업로드 -->
        <div class="form-group">
          <label class="form-label" for="fileUpload">파일 업로드</label>
          <div class="file-upload-area" id="fileUploadArea">
            <div class="file-upload-icon">📎</div>
            <div class="file-upload-text">파일을 드래그하거나 클릭하여 업로드</div>
            <div class="file-upload-hint">최대 10MB까지 업로드 가능</div>
            <input type="file" id="fileUpload" name="images" class="file-input" multiple accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png,.gif,.zip,.txt">
          </div>
          <div class="file-list" id="fileList"></div>
        </div>

        <div class="form-actions">
          <button type="button" class="btn btn-cancel" onclick="location.href='/noticeManagement'">취소</button>
          <button type="submit" class="btn btn-submit">등록</button>
        </div>
      </form>
    </div>
  </section>

  <script>
	// 파일 업로드 관련 스크립트
	const fileUploadArea = document.getElementById('fileUploadArea');
	const fileInput = document.getElementById('fileUpload');
	const fileList = document.getElementById('fileList');
	const selectedFiles = [];

	fileUploadArea.addEventListener('click', () => fileInput.click());
	fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

	fileUploadArea.addEventListener('dragover', (e) => {
	  e.preventDefault();
	  fileUploadArea.classList.add('dragover');
	});
	fileUploadArea.addEventListener('dragleave', () => fileUploadArea.classList.remove('dragover'));
	fileUploadArea.addEventListener('drop', (e) => {
	  e.preventDefault();
	  fileUploadArea.classList.remove('dragover');
	  handleFiles(e.dataTransfer.files);
	});

	function handleFiles(files) {
	  Array.from(files).forEach(file => {
	    if (file.size > 10 * 1024 * 1024) {
	      alert(`${file.name} 파일이 10MB를 초과합니다.`);
	      return;
	    }
	    if (selectedFiles.some(f => f.name === file.name && f.size === file.size)) {
	      alert(`${file.name} 파일이 이미 선택되어 있습니다.`);
	      return;
	    }
	    selectedFiles.push(file);
	    addFileToList(file);
	  });
	  if (selectedFiles.length > 0) fileList.classList.add('active');
	}

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

	function removeFile(fileName, fileSize) {
	  const index = selectedFiles.findIndex(f => f.name === fileName && f.size === fileSize);
	  if (index > -1) {
	    selectedFiles.splice(index, 1);
	    updateFileList();
	  }
	}

	function updateFileList() {
	  fileList.innerHTML = '';
	  selectedFiles.forEach(file => addFileToList(file));
	  if (selectedFiles.length === 0) {
	    fileList.classList.remove('active');
	  } else {
	    const dataTransfer = new DataTransfer();
	    selectedFiles.forEach(file => dataTransfer.items.add(file));
	    fileInput.files = dataTransfer.files;
	  }
	}

	function formatFileSize(bytes) {
	  if (bytes === 0) return '0 Bytes';
	  const k = 1024;
	  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
	  const i = Math.floor(Math.log(bytes) / Math.log(k));
	  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
	}

	document.getElementById('writeForm').addEventListener('submit', function(e) {
	  const title = document.getElementById('title').value.trim();
	  const content = document.getElementById('content').value.trim();

	  if (!title) {
	    e.preventDefault();
	    alert('제목을 입력해주세요.');
	    document.getElementById('title').focus();
	    return false;
	  }

	  if (!content) {
	    e.preventDefault();
	    alert('내용을 입력해주세요.');
	    document.getElementById('content').focus();
	    return false;
	  }
	});
  </script>
</body>
</html>