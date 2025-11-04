// 더보기 버튼
document.addEventListener('DOMContentLoaded', function() {
  const loadMoreBtn = document.getElementById('loadMoreBtn');
  const additionalProducts = document.getElementById('additionalProducts');
  if(!loadMoreBtn || !additionalProducts) return;
  let isExpanded = false;

  loadMoreBtn.addEventListener('click', function() {
    if (!isExpanded) {
      additionalProducts.classList.remove('hidden');
      loadMoreBtn.textContent = '접기';
      isExpanded = true;
      additionalProducts.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else {
      additionalProducts.classList.add('hidden');
      loadMoreBtn.textContent = '더보기';
      isExpanded = false;
    }
  });
});

// 책 속 한 줄: 좌우 스크롤
(function(){
  const track = document.getElementById('quotesTrack');
  if(!track) return;
  const prev = document.getElementById('quotesPrev');
  const next = document.getElementById('quotesNext');

  const cardWidth = () => {
    const first = track.querySelector('.q-card');
    if(!first) return 320;
    return first.getBoundingClientRect().width + 16;
  };

  prev.addEventListener('click', ()=> track.scrollBy({left:-cardWidth(), behavior:'smooth'}));
  next.addEventListener('click', ()=> track.scrollBy({left: cardWidth(), behavior:'smooth'}));
})();

// FAQ 토글
(function(){
  const items = document.querySelectorAll('.faq-item');
  if(!items.length) return;
  items.forEach(item => {
    const q = item.querySelector('.faq-question');
    const a = item.querySelector('.faq-answer');
    const icon = item.querySelector('.faq-icon');
    if(a){
      a.style.maxHeight = '0px';
      a.style.overflow = 'hidden';
      a.style.boxSizing = 'border-box';
      a.style.willChange = 'max-height';
      a.style.transition = 'max-height 300ms cubic-bezier(.2,.6,.2,1), padding 300ms cubic-bezier(.2,.6,.2,1)';
      a.style.paddingTop = '0px';
      a.style.paddingBottom = '0px';
    }
    q.addEventListener('click', () => {
      const open = a && a.style.maxHeight !== '0px';
      if(open){
        a.style.maxHeight = '0px';
        a.style.paddingTop = '0px';
        a.style.paddingBottom = '0px';
        if(icon){ icon.style.transform = 'rotate(0deg)'; }
        item.classList.remove('active');
      } else {
        a.style.maxHeight = (a.scrollHeight + 24) + 'px';
        a.style.paddingTop = '8px';
        a.style.paddingBottom = '12px';
        if(icon){ icon.style.transform = 'rotate(180deg)'; }
        item.classList.add('active');
      }
    });
  });
})();