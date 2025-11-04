// 탭 전환 (현재 페이지는 '내정보 수정'만 활성)
function switchTab(tab, event) {
  if (tab === 'edit') {
    document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
    if (event && event.target) event.target.classList.add('active');
    // 필요 시 다른 영역 show/hide 로직 추가
  }
}

// 로그아웃 (서버 라우팅 사용하는 경우에는 a[href="/logout"]로 이동)
function logout() {
  if (confirm('정말 로그아웃 하시겠습니까?')) {
    window.location.href = '/logout';
  }
}

// 폼 검증 & 제출 전 체크
(function () {
  const form = document.getElementById('formEdit');
  if (!form) return;

  form.addEventListener('submit', (e) => {
    const pw = form.newPw.value.trim();
    const pw2 = form.newPwConfirm.value.trim();

    if (pw || pw2) {
      if (pw.length < 8) {
        e.preventDefault();
        alert('비밀번호는 8자 이상으로 설정하세요.');
        return;
      }
      if (pw !== pw2) {
        e.preventDefault();
        alert('비밀번호 확인이 일치하지 않습니다.');
        return;
      }
    }
    // 서버로 POST (action="/mypage/edit")
    // 서버에서 성공 처리 후 /mypage#info 등으로 redirect
  });
})();
