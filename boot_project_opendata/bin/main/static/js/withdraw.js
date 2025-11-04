// 탭 전환 (회원탈퇴만 현재 페이지에서 처리)
function switchTab(tab, event) {
  if (tab === 'withdraw') {
    document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
    if (event && event.target) event.target.classList.add('active');
  }
}

// 회원탈퇴 폼 처리
document.addEventListener("DOMContentLoaded", function () {
  // 탭 활성화
  const tabs = document.querySelectorAll(".tab-button");
  tabs.forEach(btn => btn.classList.remove("active"));
  const withdrawTab = Array.from(tabs).find(btn =>
    btn.textContent.replace(/\s/g, "") === "회원탈퇴"
  );
  if (withdrawTab) withdrawTab.classList.add("active");

  // 입력 필드 디자인 효과
  const inputs = document.querySelectorAll(".form-input");
  inputs.forEach(input => {
    input.addEventListener("focus", () => input.classList.add("focus"));
    input.addEventListener("blur", () => input.classList.remove("focus"));
  });

  // 탈퇴 확인
  const form = document.getElementById("withdrawForm");
  if (form) {
    form.addEventListener("submit", function (e) {
      const ok = confirm("정말 탈퇴하시겠습니까?");
      if (!ok) e.preventDefault(); // 취소하면 전송 안 함
    });
  }
});


