// 사용자 로그인 상태 렌더링
function renderByAuth() {
  const userName = localStorage.getItem('userName');
  const guestLinks = document.getElementById('guestLinks');
  const userGreeting = document.getElementById('userGreeting');
  const userNameText = document.getElementById('userNameText');

  if (userName) {
    if (userNameText) userNameText.textContent = userName;
    if (guestLinks) guestLinks.style.display = 'none';
    if (userGreeting) userGreeting.style.display = 'flex';
  } else {
    if (userGreeting) userGreeting.style.display = 'none';
    if (guestLinks) guestLinks.style.display = 'flex';
  }
}

function logout() {
  if (confirm('정말 로그아웃 하시겠습니까?')) {
    localStorage.removeItem('userName');
    localStorage.removeItem('isLoggedIn');
    // 메인으로 이동
    window.location.href = getCtxUrl('/main');
  }
}

// 탭 전환
function switchTabByName(tabName) {
  document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
  document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

  const targetBtn = document.querySelector(`.tab-button[data-tab="${tabName}"]`);
  const targetContent = document.getElementById(`${tabName}Content`);
  if (targetBtn) targetBtn.classList.add('active');
  if (targetContent) targetContent.classList.add('active');
}

// 장바구니 담기
function addToCart() {
  const titleEl = document.querySelector('.product-title');
  const productTitle = titleEl ? titleEl.textContent.trim() : '이 상품';
  if (confirm(`"${productTitle}"을(를) 장바구니에 추가하시겠습니까?`)) {
    // TODO: 실제 서버 요청으로 교체 (예: fetch('/cart/add', {method:'POST', body:...}))
    alert('장바구니에 추가되었습니다!');
  }
}

// 바로 구매
function buyNow() {
  const titleEl = document.querySelector('.product-title');
  const productTitle = titleEl ? titleEl.textContent.trim() : '이 상품';
  if (confirm(`"${productTitle}"을(를) 바로 구매하시겠습니까?`)) {
    // TODO: 결제 페이지로 이동 (서버 경로에 맞게 수정)
    alert('결제 페이지로 이동합니다.');
    // window.location.href = getCtxUrl('/checkout');
  }
}

// 리뷰 제출
function submitReview() {
  const rating = document.querySelector('input[name="rating"]:checked');
  const reviewText = (document.getElementById('reviewText') || {}).value || '';
  const text = reviewText.trim();

  if (!rating) { alert('평점을 선택해주세요.'); return; }
  if (!text) { alert('리뷰 내용을 입력해주세요.'); return; }

  if (confirm('리뷰를 등록하시겠습니까?')) {
    // TODO: 실제 서버 요청으로 교체
    alert('리뷰가 등록되었습니다!');
    document.getElementById('reviewText').value = '';
    document.querySelectorAll('input[name="rating"]').forEach(i => i.checked = false);
  }
}

// 컨텍스트 경로가 있으면 붙여주는 헬퍼 (스프링에서 필요시)
function getCtxUrl(path) {
  // JSP에서 <base> 태그나 c:url을 쓰는 것이 이상적이지만,
  // JS 내에서 동적으로 경로가 필요하면 아래를 사용하세요.
  return path; // 필요 시 커스텀 로직 추가
}

// 초기 바인딩
document.addEventListener('DOMContentLoaded', () => {
  // 로그인 상태 처리
  renderByAuth();

  // 로그아웃 버튼 동작
  const logoutBtn = document.getElementById('logoutBtn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', (e) => {
      e.preventDefault();
      logout();
    });
  }

  // 탭 버튼들 이벤트
  document.querySelectorAll('.tab-button').forEach(btn => {
    btn.addEventListener('click', () => {
      const tab = btn.getAttribute('data-tab');
      switchTabByName(tab);
    });
  });

  // 액션 버튼
  const btnAddToCart = document.getElementById('btnAddToCart');
  const btnBuyNow = document.getElementById('btnBuyNow');
  const btnSubmitReview = document.getElementById('btnSubmitReview');

  btnAddToCart && btnAddToCart.addEventListener('click', addToCart);
  btnBuyNow && btnBuyNow.addEventListener('click', buyNow);
  btnSubmitReview && btnSubmitReview.addEventListener('click', submitReview);

  // 이미지가 있으면 배경 이모지 제거 클래스는 JSP에서 이미 처리했지만,
  // 혹시 동적으로 이미지가 주입되는 경우를 대비한 보정:
  const imgWrap = document.querySelector('.product-image');
  if (imgWrap && imgWrap.querySelector('img')) {
    imgWrap.classList.add('has-image');
  }
});