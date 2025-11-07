//3~4초마다 상단 베너 교체
document.addEventListener("DOMContentLoaded", function() {
  const slides = document.querySelectorAll(".city-slide-item");
  let currentIndex = 0;

  if (slides.length > 0) {
    slides[currentIndex].classList.add("active");

    setInterval(() => {
      slides[currentIndex].classList.remove("active");
      currentIndex = (currentIndex + 1) % slides.length;
      slides[currentIndex].classList.add("active");
    }, 4000); // ⏱ 4초마다 전환
  }
});