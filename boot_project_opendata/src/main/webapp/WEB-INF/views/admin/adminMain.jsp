<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>대기질 정보 – 지역별 미세먼지 농도</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_APP_KEY&autoload=false&libraries=services"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/main.css">
</head>
<body>
  <!-- 헤더 & 네비 -->
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="/adminMain" class="brand">대기질 정보</a>
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
        <a href="/adminMain" class="nav-category">상세정보</a>
        <a href="/memberManagement" class="nav-board">회원관리</a>
        <a href="/boardManagement" class="nav-notice">게시판관리</a>
        <a href="/qna" class="nav-qna">지역관리</a>
      </div>
    </div>
  </div>

    <main>

    <!-- 카카오 지도 섹션 -->
    <section class="map-section">
      <div class="map-container">
        <h2 class="section-title">실시간 대기질 정보</h2>
        <div class="map-wrapper">
          <div id="kakao-map" style="width:100%;height:100%;"></div>
        </div>
        <div class="map-controls">
          <button class="map-btn" id="getLocationBtn">현재 위치 확인</button>
          <button class="map-btn" id="resetMapBtn">지도 초기화</button>
        </div>
        <div class="location-info" id="locationInfo">지도를 클릭하거나 현재 위치 확인 버튼을 눌러주세요</div>
      </div>
    </section>

    <!-- 대기질 등급 안내 섹션 -->
    <section class="grade-guide-section">
      <div class="grade-guide-container">
        <h2 class="section-title">대기질 등급 안내</h2>
        <div class="grade-guide-grid">
          <div class="grade-guide-card">
            <div class="grade-guide-icon good">✅</div>
            <h3 class="grade-guide-title good">좋음</h3>
            <p class="grade-guide-desc">대기질이 양호하여 모든 활동에 적합합니다.</p>
          </div>
          <div class="grade-guide-card">
            <div class="grade-guide-icon normal">⚠️</div>
            <h3 class="grade-guide-title normal">보통</h3>
            <p class="grade-guide-desc">일반적으로 양호하나 민감한 사람은 주의가 필요합니다.</p>
          </div>
          <div class="grade-guide-card">
            <div class="grade-guide-icon bad">😷</div>
            <h3 class="grade-guide-title bad">나쁨</h3>
            <p class="grade-guide-desc">장시간 실외 활동 시 주의가 필요합니다.</p>
          </div>
          <div class="grade-guide-card">
            <div class="grade-guide-icon very-bad">🚫</div>
            <h3 class="grade-guide-title very-bad">매우 나쁨</h3>
            <p class="grade-guide-desc">실외 활동을 자제하고 외출 시 마스크를 착용하세요.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 주요 도시 대기질 섹션 -->
    <section class="cities-section">
      <div class="cities-container">
        <h2 class="section-title">주요 도시 대기질 현황</h2>
        <div class="cities-grid">
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">서울</h3>
              <span class="city-grade normal">보통</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">45 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">25 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">부산</h3>
              <span class="city-grade good">좋음</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">28 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">15 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">대구</h3>
              <span class="city-grade bad">나쁨</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">78 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">42 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">인천</h3>
              <span class="city-grade normal">보통</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">52 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">28 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">광주</h3>
              <span class="city-grade good">좋음</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">32 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">18 ㎍/㎥</span>
              </div>
            </div>
          </div>
          <div class="city-card">
            <div class="city-header">
              <h3 class="city-name">대전</h3>
              <span class="city-grade normal">보통</span>
            </div>
            <div class="city-info">
              <div class="city-info-item">
                <span class="city-info-label">미세먼지</span>
                <span class="city-info-value">48 ㎍/㎥</span>
              </div>
              <div class="city-info-item">
                <span class="city-info-label">초미세먼지</span>
                <span class="city-info-value">26 ㎍/㎥</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 대기질 개선 팁 섹션 -->
    <section class="tips-section">
      <div class="tips-container">
        <h2 class="section-title">대기질 개선을 위한 팁</h2>
        <div class="tips-grid">
          <div class="tip-card">
            <div class="tip-icon">🚗</div>
            <h3 class="tip-title">대중교통 이용하기</h3>
            <p class="tip-desc">개인 차량 대신 대중교통을 이용하면 대기 오염을 줄일 수 있습니다.</p>
          </div>
          <div class="tip-card">
            <div class="tip-icon">🌳</div>
            <h3 class="tip-title">공기 정화 식물 키우기</h3>
            <p class="tip-desc">실내에 공기 정화 식물을 두면 실내 공기질을 개선하는데 도움이 됩니다.</p>
          </div>
          <div class="tip-card">
            <div class="tip-icon">🏠</div>
            <h3 class="tip-title">환기 습관 개선</h3>
            <p class="tip-desc">대기질이 좋은 시간대에 환기를 하면 실내 공기질을 유지할 수 있습니다.</p>
          </div>
        </div>
      </div>
    </section>

    

    

    <!-- 지역 검색 섹션 -->
    <section class="testimonials-section">
      <div class="testimonials-container">
        <h2 class="testimonials-title">지역별 대기질 조회</h2>
        <div class="region-search-box">
          <select id="regionSearchSelect" class="region-search-select">
            <option value="">지역을 선택하세요</option>
            <option value="서울">서울특별시</option>
            <option value="부산">부산광역시</option>
            <option value="대구">대구광역시</option>
            <option value="인천">인천광역시</option>
            <option value="광주">광주광역시</option>
            <option value="대전">대전광역시</option>
            <option value="울산">울산광역시</option>
            <option value="세종">세종특별자치시</option>
            <option value="경기">경기도</option>
            <option value="강원">강원도</option>
            <option value="충북">충청북도</option>
            <option value="충남">충청남도</option>
            <option value="전북">전라북도</option>
            <option value="전남">전라남도</option>
            <option value="경북">경상북도</option>
            <option value="경남">경상남도</option>
            <option value="제주">제주특별자치도</option>
          </select>
          <button class="region-search-btn" id="regionSearchBtn">조회</button>
        </div>
      </div>
    </section>
    

  </main>

  <!-- 푸터 -->
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

    

    // 카카오 지도 초기화
    let map = null;
    let marker = null;
    
    document.addEventListener('DOMContentLoaded', function() {
      // 카카오 지도 스크립트가 로드되었는지 확인
      if (typeof kakao !== 'undefined' && kakao.maps) {
        initMap();
      } else {
        // 카카오 지도 스크립트 로드 대기
        const checkKakao = setInterval(() => {
          if (typeof kakao !== 'undefined' && kakao.maps) {
            clearInterval(checkKakao);
            initMap();
          }
        }, 100);
        
        // 10초 후 타임아웃
        setTimeout(() => {
          clearInterval(checkKakao);
          if (!map) {
            document.getElementById('kakao-map').innerHTML = 
              '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:#999;">카카오 지도 API 키를 설정해주세요.<br>(YOUR_KAKAO_APP_KEY를 교체하세요)</div>';
          }
        }, 10000);
      }
    });

    function initMap() {
      kakao.maps.load(() => {
        const container = document.getElementById('kakao-map');
        const options = {
          center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울 기본 위치
          level: 3
        };
        map = new kakao.maps.Map(container, options);
        
        // 지도 클릭 이벤트
        kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
          const latlng = mouseEvent.latLng;
          setMarkerPosition(latlng);
        });
      });
    }

    // 마커 위치 설정
    function setMarkerPosition(latlng) {
      if (!marker) {
        marker = new kakao.maps.Marker({
          position: latlng
        });
        marker.setMap(map);
      } else {
        marker.setPosition(latlng);
      }
      map.setCenter(latlng);
      
      // 위치 정보 표시
      getAddressFromCoords(latlng.getLng(), latlng.getLat());
    }

    // 좌표를 주소로 변환
    function getAddressFromCoords(lng, lat) {
      const geocoder = new kakao.maps.services.Geocoder();
      geocoder.coord2Address(lng, lat, (result, status) => {
        if (status === kakao.maps.services.Status.OK) {
          const address = result[0].address.address_name;
          document.getElementById('locationInfo').textContent = `위치: ${address}`;
        }
      });
    }

    // 현재 위치 확인 버튼
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('getLocationBtn').addEventListener('click', function() {
        if (!map) {
          alert('지도가 아직 로드되지 않았습니다. 잠시 후 다시 시도해주세요.');
          return;
        }
        
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(
            function(position) {
              const lat = position.coords.latitude;
              const lng = position.coords.longitude;
              const latlng = new kakao.maps.LatLng(lat, lng);
              setMarkerPosition(latlng);
            },
            function(error) {
              alert('위치 정보를 가져올 수 없습니다.');
            }
          );
        } else {
          alert('브라우저가 위치 정보를 지원하지 않습니다.');
        }
      });
    });

    // 지도 초기화 버튼
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('resetMapBtn').addEventListener('click', function() {
        if (map) {
          map.setCenter(new kakao.maps.LatLng(37.5665, 126.9780));
          map.setLevel(3);
          if (marker) {
            marker.setMap(null);
            marker = null;
          }
          document.getElementById('locationInfo').textContent = '지도를 클릭하거나 현재 위치 확인 버튼을 눌러주세요';
        }
      });

      // 지역 검색 기능: 선택한 지역으로 지도 이동 (지오코딩)
      document.getElementById('regionSearchBtn').addEventListener('click', function() {
        const region = document.getElementById('regionSearchSelect').value;
        if (!region) {
          alert('지역을 선택해주세요.');
          return;
        }
        if (!map) {
          alert('지도가 아직 로드되지 않았습니다. 잠시 후 다시 시도해주세요.');
          return;
        }
        const geocoder = new kakao.maps.services.Geocoder();
        geocoder.addressSearch(region, function(result, status) {
          if (status === kakao.maps.services.Status.OK && result[0]) {
            const y = parseFloat(result[0].y);
            const x = parseFloat(result[0].x);
            const latlng = new kakao.maps.LatLng(y, x);
            setMarkerPosition(latlng);
          } else {
            alert('해당 지역을 찾을 수 없습니다.');
          }
        });
      });
    });
  </script>
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=975872f5b9b87199e7b4e5d8a371f318"></script>
  <script>
    // 카카오 지도는 위의 DOMContentLoaded 이벤트에서 이미 초기화됨
  </script>
</body>
</html>