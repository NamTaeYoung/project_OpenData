function check_ok(){
	
	//비밀번호 정규식
	var passwordRegex = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,16}$/;
	//전화번호 정규식
	var phonRegex = /^0\d{1,2}-\d{3,4}-\d{4}$/;
	
	
	// 폼 이름에 name 값으로 찾아감
	if(reg_frm.user_id.value==""){
		alert("아이디를 써주세요.");
		reg_frm.user_id.focus();//입력안할때 깜빡임
		return;
	}
	if(reg_frm.user_id.value.length< 4){
			alert("아이디는 4글자이상이어야 합니다.");
			reg_frm.user_id.focus();
			return;
		}
	if(reg_frm.user_pw.value.length==0){
			alert("패스워드는 반드시 입력해야 합니다.");
			reg_frm.user_pw.focus();
			return;
		}
	if(reg_frm.user_pw.value.length==0){
			alert("패스워드는 반드시 입력해야 합니다.");
			reg_frm.user_pw.focus();
			return;
		}
	if (!passwordRegex.test(reg_frm.user_pw.value)) {
        alert("비밀번호는 8~16자, 영문자, 숫자, 특수문자를 모두 포함해야 합니다.");
        reg_frm.user_pw.focus();
        return;
    }

    // 비밀번호 일치 검사
    if (reg_frm.user_pw.value !== reg_frm.pwd_check.value) {
        alert("패스워드가 일치하지 않습니다.");
        reg_frm.pwd_check.focus();
        return;
    }
	
	if(reg_frm.user_name.value.length==0){
			alert("이름을 써주세요.");
			reg_frm.user_name.focus();
			return;
		}
	if(reg_frm.user_email.value.length==0){
			alert("Email을 써주세요.");
			reg_frm.user_email.focus();
			return;
		}
	
	if(reg_frm.user_phone_num.value.length==0){
			alert("전화번호를 써주세요.");
			reg_frm.user_phone_num.focus();
			return;
		}
		
 	//전화번호가 000-0000-0000형식인지 확인
	if (!phonRegex.test(reg_frm.user_phone_num.value)) {
        alert("000-0000-0000형식으로 입력해주세요.");
        reg_frm.user_pw.focus();
        return;
    }
	
    if (!checkIdOk) {
        alert("아이디 중복 검사를 먼저 해주세요!");
        return;
    }
    
    if (!emailOk) {
        alert("이메일 인증을 완료해야 회원가입이 가능합니다!");
        return;
    }
	// 폼이 reg_frm에서 action 속성의 파일을 호출
	document.reg_frm.submit();
	alert("회원가입이 완료되었습니다!");
}

//우편번호 검색
function chk_post(){
	new daum.Postcode(
		{
			oncomplete : function(data) {
			   // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	 
	           // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	           // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	           var fullAddr = ''; // 최종 주소 변수
	           var extraAddr = ''; // 조합형 주소 변수

	           // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	           if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	               fullAddr = data.roadAddress;
	            } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                fullAddr = data.jibunAddress;
	            }

	            // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
	            if (data.userSelectedType === 'R') {
	                //법정동명이 있을 경우 추가한다.
	                if (data.bname !== '') {
	                     extraAddr += data.bname;
	                }
	                // 건물명이 있을 경우 추가한다.
	                if (data.buildingName !== '') {
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
	            }

	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
	            document.getElementById('user_post_num').value = data.zonecode; //5자리 새우편번호 사용
	            document.getElementById('user_address').value = fullAddr;

	 
	            // 커서를 상세주소 필드로 이동한다.
	            document.getElementById('user_detail_address').focus();
	        }
	    }).open();
	}
function sendAuthCode() {
	var emailRegex = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-za-z0-9\-]+/;
    const email = document.getElementById("user_email").value;

    if(reg_frm.user_email.value.length==0){
			alert("Email을 써주세요.");
			reg_frm.user_email.focus();
			return;
		}
	if (!emailRegex.test(reg_frm.user_email.value)) {
        alert("메일형식으로 입력해주세요.");
        reg_frm.user_email.focus();
        return;
    }
    
    fetch("mail/send?email=" + email, { method: "POST" })
        .then(response => response.text())
        .then(result => {
        	if (result === "duplicate") {
                alert("이미 등록된 이메일입니다. 다른 이메일을 사용해주세요.");
                document.getElementById("user_email").focus();
                return;
            } else if (!isNaN(result)) {
            //} else if (result === "success") {
                alert("인증번호가 전송되었습니다. (테스트용: " + result + ")");
                document.getElementById("user_email_chk").disabled = false;
                document.querySelector('[onclick="verifyAuthCode()"]').disabled = false;
            } else {
                alert("메일 전송 중 오류가 발생했습니다. (응답값: " + result + ")");
            }
        })
        .catch(error => {
            console.error("에러:", error);
            alert("메일 전송 중 오류가 발생했습니다.");
        });
}

function verifyAuthCode(){
	const authCode = document.getElementById("user_email_chk").value;
	
    if (reg_frm.user_email_chk.value.length == 0) {
        alert("인증번호를 써주세요.");
        reg_frm.user_email_chk.focus();
        return;
    }

    fetch("mail/verify?code=" + authCode, { method: "POST" })
        .then(response => response.text())
        .then(result => {
            if (result.trim() === "success") {
                alert("이메일 인증에 성공했습니다!");
                emailOk = true;
                document.getElementById("user_email_chk").disabled = true;
                document.querySelector('[onclick="sendAuthCode()"]').disabled = true;
                document.querySelector('[onclick="verifyAuthCode()"]').disabled = true;
                document.getElementById("register_btn").disabled = false;
            } else {
                alert("인증번호가 올바르지 않습니다.");
            }
        })
        .catch(error => {
            console.error("에러:", error);
            alert("서버 오류로 인증에 실패했습니다.");
        });
}
