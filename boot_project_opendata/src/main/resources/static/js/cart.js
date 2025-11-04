document.addEventListener("DOMContentLoaded", () => {
  const selectAllCheckbox = document.getElementById("selectAll");
  const selectedCountElem = document.getElementById("selectedCount");
  const removeSelectedBtn = document.getElementById("removeSelectedBtn");
  const clearCartBtn = document.getElementById("clearCartBtn");
  const checkoutBtn = document.getElementById("checkoutBtn");
  const form = document.getElementById("orderForm");
  
  // JSP meta 태그의 context path를 JS 변수로 할당
  const context = document.querySelector('meta[name="ctx"]').getAttribute('content');

  function updateSelectedCount() {
    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    selectedCountElem.textContent = `(${checkedBoxes.length}개 선택)`;
  }

  function updateSummary() {
    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    let total = 0;

    checkedBoxes.forEach(cb => {
      const row = cb.closest("tr");
      const quantity = parseInt(row.querySelector(".quantity-input").value, 10);
      const unitPriceText = row.querySelector(".price").textContent;
      const totalPrice = parseInt(unitPriceText.replace(/[^0-9]/g, ""), 10);
      const unitPrice = totalPrice / quantity;
      total += unitPrice * quantity;
    });

    const delivery = total >= 30000 ? 0 : 3000;

    document.getElementById("subtotalText").textContent = `₩${total.toLocaleString()}`;
    document.getElementById("shippingText").textContent = delivery === 0 ? "무료" : `₩${delivery.toLocaleString()}`;
    document.getElementById("grandTotalText").textContent = `₩${(total + delivery).toLocaleString()}`;
  }

  selectAllCheckbox.addEventListener("change", () => {
    document.querySelectorAll(".cart-checkbox").forEach(cb => (cb.checked = selectAllCheckbox.checked));
    updateSelectedCount();
    updateSummary();
  });

  document.querySelectorAll(".cart-checkbox").forEach(cb => {
    cb.addEventListener("change", () => {
      const allCheckboxes = document.querySelectorAll(".cart-checkbox");
      const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
      selectAllCheckbox.checked = allCheckboxes.length === checkedBoxes.length;
      updateSelectedCount();
      updateSummary();
    });
  });

  document.querySelectorAll(".quantity-input").forEach(input => {
    input.addEventListener("change", e => {
      let qty = parseInt(e.target.value, 10);
      if (isNaN(qty) || qty < 1) qty = 1;
      else if (qty > 99) qty = 99;
      e.target.value = qty;

      const row = e.target.closest("tr");
      const priceElem = row.querySelector(".price");
      const unitPrice = parseInt(priceElem.textContent.replace(/[^0-9]/g, ""), 10) / (row.dataset.lastQty || qty);
      const newPrice = unitPrice * qty;
      priceElem.textContent = `₩${newPrice.toLocaleString()}`;
      row.dataset.lastQty = qty;

      updateSummary();
    });
  });

  removeSelectedBtn.addEventListener("click", e => {
    e.preventDefault();
    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    if (checkedBoxes.length === 0) {
      alert("삭제할 상품을 선택해주세요.");
      return;
    }
    if (!confirm("선택한 상품을 삭제하시겠습니까?")) return;

    const cartIds = Array.from(checkedBoxes).map(cb => cb.closest("tr").dataset.cartId);

    fetch(`${context}/deleteCartItems`, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({cartIds: cartIds})
    })
    .then(res => {
      if (res.ok) {
        checkedBoxes.forEach(cb => cb.closest("tr").remove());
        updateSelectedCount();
        updateSummary();
      } else {
        alert("삭제 실패. 다시 시도해주세요.");
      }
    })
    .catch(() => alert("네트워크 오류가 발생했습니다."));
  });

  clearCartBtn.addEventListener("click", e => {
    e.preventDefault();
    if (!confirm("장바구니를 모두 비우시겠습니까?")) return;

    fetch(`${context}/clearCart`, {method: 'POST'})
      .then(res => {
        if (res.ok) {
          document.querySelectorAll("#cartRows tr").forEach(row => row.remove());
          updateSelectedCount();
          updateSummary();
        } else {
          alert("전체 비우기 실패. 다시 시도해주세요.");
        }
      })
      .catch(() => alert("네트워크 오류가 발생했습니다."));
  });

  checkoutBtn.addEventListener("click", e => {
    e.preventDefault();
    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    if (checkedBoxes.length === 0) {
      alert("주문할 상품을 선택해주세요.");
      return;
    }
    form.querySelectorAll(".dynamic-input").forEach(el => el.remove());

    checkedBoxes.forEach(cb => {
      const row = cb.closest("tr");
      const bookId = cb.value;
      const quantity = row.querySelector(".quantity-input").value;

      const inputBook = document.createElement("input");
      inputBook.type = "hidden";
      inputBook.name = "book_id";
      inputBook.value = bookId;
      inputBook.classList.add("dynamic-input");

      const inputQty = document.createElement("input");
      inputQty.type = "hidden";
      inputQty.name = "quantity";
      inputQty.value = quantity;
      inputQty.classList.add("dynamic-input");

      form.appendChild(inputBook);
      form.appendChild(inputQty);
    });

    form.submit();
  });

  updateSelectedCount();
  updateSummary();
});
