// 게시글 데이터
     const postsData = [
       { id: 15, title: "도서관 이용 시간 변경 안내", author: "관리자", date: "2024.01.15", views: 245, content: "도서관 이용 시간이 변경되었습니다. 평일 오전 9시부터 오후 10시까지, 주말 오전 10시부터 오후 8시까지 운영됩니다." },
       { id: 14, title: "새로운 도서 추가 소식", author: "김사서", date: "2024.01.14", views: 189, content: "이번 달에 200권의 새로운 도서가 추가되었습니다. 소설, 에세이, 자기계발서 등 다양한 장르의 도서를 만나보세요." },
       { id: 13, title: "독서 모임 참가 신청 안내", author: "이사서", date: "2024.01.13", views: 156, content: "매주 토요일 오후 2시에 진행되는 독서 모임에 참가하실 수 있습니다. 매월 새로운 도서를 선정하여 함께 읽고 토론합니다." },
       { id: 12, title: "도서 대출 연장 방법 안내", author: "박사서", date: "2024.01.12", views: 203, content: "도서 대출 기간을 연장하고 싶으시다면 온라인 시스템이나 도서관 방문을 통해 연장 신청을 하실 수 있습니다." },
       { id: 11, title: "도서관 시스템 점검 안내", author: "관리자", date: "2024.01.11", views: 178, content: "1월 15일 오전 2시부터 6시까지 도서관 시스템 점검으로 인해 온라인 서비스가 일시 중단됩니다." },
       { id: 10, title: "추천 도서 목록 (1월)", author: "김사서", date: "2024.01.10", views: 312, content: "1월 추천 도서로는 '작은 것들의 신', '마음의 평화', '미래의 도시' 등이 선정되었습니다." },
       { id: 9, title: "도서 반납 연체료 안내", author: "이사서", date: "2024.01.09", views: 167, content: "도서 반납이 연체될 경우 하루에 100원의 연체료가 부과됩니다. 연체료는 도서 반납 시 함께 납부해 주세요." },
       { id: 8, title: "도서관 이용 수칙 안내", author: "관리자", date: "2024.01.08", views: 298, content: "도서관 내에서는 조용히 이용해 주시고, 음식물 반입을 금지합니다. 휴대폰은 진동 모드로 설정해 주세요." },
       { id: 7, title: "독서 감상문 공모전 안내", author: "박사서", date: "2024.01.07", views: 234, content: "독서 감상문 공모전을 개최합니다. 참가 대상은 도서관 회원 누구나이며, 우수작은 상금과 상품을 드립니다." },
       { id: 6, title: "도서관 휴관일 안내", author: "관리자", date: "2024.01.06", views: 145, content: "매주 월요일과 공휴일은 도서관 휴관일입니다. 이 점 참고하여 이용해 주시기 바랍니다." },
       { id: 5, title: "도서 대출 연장 서비스 안내", author: "김사서", date: "2024.01.05", views: 198, content: "온라인으로 도서 대출 연장을 신청할 수 있는 서비스를 제공합니다. 홈페이지에서 간편하게 연장 신청하세요." },
       { id: 4, title: "새로운 전자책 도서 추가", author: "이사서", date: "2024.01.04", views: 267, content: "전자책 도서관에 500권의 새로운 전자책이 추가되었습니다. 언제 어디서나 스마트폰이나 태블릿으로 읽을 수 있습니다." },
       { id: 3, title: "독서 클럽 모집 공고", author: "박사서", date: "2024.01.03", views: 189, content: "독서 클럽 회원을 모집합니다. 매주 정기 모임을 통해 책을 읽고 토론하는 시간을 가집니다." },
       { id: 2, title: "도서관 이용 통계 발표", author: "관리자", date: "2024.01.02", views: 156, content: "2023년 도서관 이용 통계를 발표합니다. 총 대출 건수는 15,000건이며, 가장 인기 있는 도서는 소설 장르였습니다." },
       { id: 1, title: "신년 도서관 운영 계획", author: "관리자", date: "2024.01.01", views: 423, content: "2024년 도서관 운영 계획을 발표합니다. 새로운 프로그램과 서비스를 통해 더 나은 도서관을 만들어가겠습니다." }
     ];

     let currentPage = 1;
     const postsPerPage = 10;
     let filteredPosts = [...postsData]; // 검색 결과를 저장할 배열
     let isSearchMode = false; // 검색 모드인지 확인

     document.addEventListener('DOMContentLoaded', function() {
       // 초기 게시글 표시
       displayPosts(1);
       
       // 검색 기능
       const searchInput = document.querySelector('.search-box input');
       const searchButton = document.querySelector('.search-box button');
       
       searchButton.addEventListener('click', function() {
         performSearch();
       });
       
       searchInput.addEventListener('keypress', function(e) {
         if (e.key === 'Enter') {
           performSearch();
         }
       });
       
       // 검색어가 비어있을 때만 전체 게시글 표시
       searchInput.addEventListener('input', function() {
         const searchTerm = this.value.trim();
         if (searchTerm === '') {
           isSearchMode = false;
           filteredPosts = [...postsData];
           displayPosts(1);
         }
       });
       
       // 페이지네이션
       const paginationButtons = document.querySelectorAll('.pagination button');
       paginationButtons.forEach(button => {
         button.addEventListener('click', function() {
           if (!this.disabled) {
             const pageText = this.textContent;
             if (pageText === '이전') {
               if (currentPage > 1) {
                 displayPosts(currentPage - 1);
               }
             } else if (pageText === '다음') {
               const totalPages = Math.ceil(postsData.length / postsPerPage);
               if (currentPage < totalPages) {
                 displayPosts(currentPage + 1);
               }
             } else if (!isNaN(pageText)) {
               displayPosts(parseInt(pageText));
             }
           }
         });
       });
     });

     function performSearch() {
       const searchInput = document.querySelector('.search-box input');
       const searchTerm = searchInput.value.trim().toLowerCase();
       
       if (searchTerm === '') {
         isSearchMode = false;
         filteredPosts = [...postsData];
       } else {
         isSearchMode = true;
         filteredPosts = postsData.filter(post => 
           post.title.toLowerCase().includes(searchTerm) || 
           post.content.toLowerCase().includes(searchTerm) ||
           post.author.toLowerCase().includes(searchTerm)
         );
       }
       
       displayPosts(1);
     }

     function displayPosts(page) {
       currentPage = page;
       const startIndex = (page - 1) * postsPerPage;
       const endIndex = startIndex + postsPerPage;
       const currentPosts = filteredPosts.slice(startIndex, endIndex);
       
       // 기존 게시글 제거 (헤더 제외)
       const tableRows = document.querySelectorAll('.table-row');
       tableRows.forEach(row => row.remove());
       
       // 검색 결과가 없을 때 메시지 표시
       if (filteredPosts.length === 0) {
         const boardTable = document.querySelector('.board-table');
         const noResultsRow = document.createElement('div');
         noResultsRow.className = 'table-row';
         noResultsRow.innerHTML = `
           <div class="table-cell" style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--muted);">
             검색 결과가 없습니다.
           </div>
         `;
         boardTable.appendChild(noResultsRow);
       } else {
         // 새 게시글 추가
         const boardTable = document.querySelector('.board-table');
         currentPosts.forEach(post => {
           const row = document.createElement('div');
           row.className = 'table-row';
           row.innerHTML = `
             <div class="table-cell post-number">${post.id}</div>
             <div class="table-cell">
               <a href="#" class="post-title">${post.title}</a>
             </div>
             <div class="table-cell post-author">${post.author}</div>
             <div class="table-cell post-date">${post.date}</div>
             <div class="table-cell post-views">${post.views}</div>
           `;
           boardTable.appendChild(row);
         });
       }
       
       // 페이지네이션 버튼 업데이트
       updatePagination();
     }

     function updatePagination() {
       const totalPages = Math.ceil(filteredPosts.length / postsPerPage);
       const paginationButtons = document.querySelectorAll('.pagination button');
       
       // 모든 버튼에서 active 클래스 제거
       paginationButtons.forEach(btn => btn.classList.remove('active'));
       
       // 현재 페이지 버튼에 active 클래스 추가
       paginationButtons.forEach(btn => {
         if (btn.textContent == currentPage) {
           btn.classList.add('active');
         }
       });
       
       // 이전/다음 버튼 활성화/비활성화
       const prevBtn = paginationButtons[0];
       const nextBtn = paginationButtons[paginationButtons.length - 1];
       
       prevBtn.disabled = currentPage === 1;
       nextBtn.disabled = currentPage === totalPages || totalPages === 0;
       
       // 페이지 번호 버튼들 숨기기/보이기
       const pageNumberButtons = Array.from(paginationButtons).slice(1, -1);
       pageNumberButtons.forEach((btn, index) => {
         if (index < totalPages) {
           btn.style.display = 'inline-block';
         } else {
           btn.style.display = 'none';
         }
       });
     }