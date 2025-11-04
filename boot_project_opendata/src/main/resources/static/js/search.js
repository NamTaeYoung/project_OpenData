const grid  = document.getElementById('grid');
const grid2 = document.getElementById('grid2');
const pager = document.getElementById('pager');
const countText = document.getElementById('countText');

// JSP에서 전달한 컨텍스트 경로
const ctx = document.querySelector('meta[name="ctx"]').content;

function card(b){
  const title = b.title || b.book_title || '';
  const author = b.author || b.writer || '';
  const price = Number(b.price||0);
  const id = b.id || b.book_id;
  const detailUrl = `${ctx}/SearchDetail?book_id=${encodeURIComponent(id)}`;

  return `
    <div class="card">
      <div class="thumb">
        ${b.image ? `<img src="${b.image}" alt="${title}">` : `<div class="placeholder"></div>`}
        ${b.tag ? `<span class="badge">${b.tag}</span>` : ``}
      </div>

      <div class="info">
        <h3 class="title-sm">
          <a href="${detailUrl}" class="title-link" aria-label="${title} 상세보기">${title}</a>
        </h3>
        <p class="author">${author}</p>

        <div class="info-bottom">
          <p class="price">${price.toLocaleString()}원</p>
          <button class="cart-btn" data-book-id="${id}">
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M6 6h15l-1.5 8.5a2 2 0 0 1-2 1.5H9a2 2 0 0 1-2-1.5L5 3H2"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            담기
          </button>
        </div>
      </div>
    </div>
  `;
}

let activeCat = 'all';
let searchQuery = '';

// 장바구니 버튼 이벤트 등록
function bindCartButtons() {
  document.querySelectorAll(".cart-btn").forEach(btn => {
    btn.onclick = null; // 기존 이벤트 제거
    btn.addEventListener("click", function() {
      const bookId = this.dataset.bookId;
      console.log("📌 버튼 클릭됨 -> bookId:", bookId, "loginId:", loginId);

      // 로그인 체크
      if(!loginId || loginId.trim() === "") {
        alert("로그인 후 이용해주세요.");
        console.log("⚠ 로그인 안됨 -> 로그인 페이지로 이동");
        window.location.href = `${ctx}/login`;
        return;
      }

      if(!confirm("장바구니에 담으시겠습니까?")) {
        console.log("❌ 장바구니 담기 취소");
        return;
      }

      fetch(`${ctx}/cartAdd`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
        body: `book_id=${encodeURIComponent(bookId)}`
      })
      .then(res => {
        console.log("🔹 Fetch 응답 상태:", res.status, res.statusText);
        return res.text();
      })
      .then(data => {
        console.log("🔹 Fetch 응답 데이터:", data);
        const msg = data.trim();
        if(msg === "success"){
          alert("✅ 장바구니에 담겼습니다!");
        } else {
          alert("⚠ " + msg);
        }
      })
      .catch(err => {
        console.error("❌ Fetch 에러:", err);
        alert("장바구니 담기 실패");
      });
    });
  });
}


// apply 함수: 리스트 렌더 후 버튼 이벤트 등록
function apply(){
  let list = books.filter(b => {
    const catMatch = activeCat === 'all' ? true : Number(b.cat) === Number(activeCat);
    const searchMatch = searchQuery === '' ? true :
      b.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      b.author.toLowerCase().includes(searchQuery.toLowerCase());
    return catMatch && searchMatch;
  });

  countText.textContent = `총 ${list.length}권`;
  grid.innerHTML = list.map(card).join('');

  bindCartButtons();
}

// 카테고리 버튼 이벤트
document.querySelectorAll('.cat-btn').forEach(btn => {
  btn.addEventListener('click', e => {
    document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active'));
    e.currentTarget.classList.add('active');
    activeCat = e.currentTarget.querySelector('input[name="genre_id"]').value;
    apply();
  });
});

// 검색 폼 이벤트
const searchForm = document.getElementById('searchForm');
searchForm.addEventListener('submit', e => {
  searchQuery = document.getElementById('q').value.trim();
  apply();
});

// 초기 렌더
apply();