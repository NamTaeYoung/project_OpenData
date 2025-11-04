function findId() {
	var emailRegex = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-za-z0-9\-]+/;
    const email = document.getElementById("find_email").value;

    if(find_id_frm.user_email.value.length==0){
			alert("Email을 써주세요.");
			reg_frm.user_email.focus();
			return;
		}
	if (!emailRegex.test(find_id_frm.user_email.value)) {
        alert("메일형식으로 입력해주세요.");
        reg_frm.user_email.focus();
        return;
    }
    
    fetch("mail/find_id?email=" + email, { method: "POST" })
        .then(response => response.text())
        .then(result => {
            if (result.trim() === "success") {
                alert("입력하신 이메일로 아이디를 보냈습니다.");
            } else {
                alert("해당 이메일이 존재하지 않습니다.");
            }
        })
        .catch(error => {
            console.error("에러:", error);
            alert("서버 오류로 인증에 실패했습니다.");
        });
}
