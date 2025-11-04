document.addEventListener('DOMContentLoaded', () => {

  initializePagination();
  setupSearchAndFilter();
});

function initializePagination() {

  const pagination = document.getElementById('pagination');
  const rows = document.querySelectorAll('#purchaseTableBody tr');
  const pageData = {};

  rows.forEach(row => {
    const page = row.getAttribute('data-page');
    if (!pageData[page]) pageData[page] = [];
    pageData[page].push(row);
  });

  const totalPages = Math.max(Object.keys(pageData).length, 1);
  console.log('totalPages:', totalPages);
  let html = `<button id="prevBtn" class="pagination-btn" onclick="changePage(-1)" disabled>&lt;</button>`;

  for (let i = 1; i <= totalPages; i++) {
    html += `<button class="pagination-btn${i === 1 ? ' active' : ''}" onclick="changePage(${i})" data-page="${i}">${i}</button>`;
  }

  html += `<button id="nextBtn" class="pagination-btn" onclick="changePage(1)">&gt;</button>`;
  pagination.innerHTML = html;
  showPage(1);
}

function showPage(pageNumber) {
  const rows = document.querySelectorAll('#purchaseTableBody tr');
  rows.forEach(row => {
    row.style.display = row.getAttribute('data-page') === String(pageNumber) ? '' : 'none';
  });

  document.querySelectorAll('.pagination-btn[data-page]').forEach(btn => btn.classList.remove('active'));
  const activeBtn = document.querySelector(`.pagination-btn[data-page="${pageNumber}"]`);
  if (activeBtn) activeBtn.classList.add('active');

  document.getElementById('prevBtn').disabled = pageNumber === 1;
  document.getElementById('nextBtn').disabled = pageNumber === document.querySelectorAll('.pagination-btn[data-page]').length;
}

function changePage(page) {
  const currentPage = getCurrentPage();
  const totalPages = document.querySelectorAll('.pagination-btn[data-page]').length;

  if (page === -1 && currentPage > 1) showPage(currentPage - 1);
  else if (page === 1 && currentPage < totalPages) showPage(currentPage + 1);
  else if (typeof page === 'number') showPage(page);
}

function getCurrentPage() {
  const activeBtn = document.querySelector('.pagination-btn.active[data-page]');
  return activeBtn ? parseInt(activeBtn.getAttribute('data-page')) : 1;
}

function setupSearchAndFilter() {
  const searchInput = document.getElementById('searchInput');
  if (searchInput) {
    searchInput.addEventListener('keypress', e => {
      if (e.key === 'Enter') performSearch();
    });
  }

  const statusFilter = document.getElementById('statusFilter');
  if (statusFilter) {
    statusFilter.addEventListener('change', () => {
      filterRows();
    });
  }
}


function performSearch() {
  const searchTerm = document.getElementById('searchInput').value.toLowerCase().trim();
  filterRows(searchTerm);
}

function filterRows(searchTerm = '') {
  const selectedStatus = document.getElementById('statusFilter').value;
  const currentPage = getCurrentPage();
  const rows = document.querySelectorAll('#purchaseTableBody tr');

  rows.forEach(row => {
    if (row.getAttribute('data-page') !== String(currentPage)) {
      row.style.display = 'none';
      return;
    }

    const orderNo = row.cells[0].textContent.toLowerCase();
    const bookTitle = row.cells[2].textContent.toLowerCase();
    const statusSpan = row.querySelector('.status-badge');
    const matchesSearch = searchTerm === '' || orderNo.includes(searchTerm) || bookTitle.includes(searchTerm);
    const matchesStatus = selectedStatus === '' || (statusSpan && statusSpan.classList.contains(`status-${selectedStatus}`));

    row.style.display = matchesSearch && matchesStatus ? '' : 'none';
  });
}

function logout() {
  if (confirm('정말 로그아웃 하시겠습니까?')) {
    localStorage.removeItem('userName');
    localStorage.removeItem('isLoggedIn');
    location.href = 'main.html';
  }
}
