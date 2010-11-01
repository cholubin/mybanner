function input_check(string) {
 var txt = string;
 var cnt = 0;
 for(i=0; i<txt.length; i++) {
  if(txt.charCodeAt(i)>=0 && txt.charCodeAt(i)<=127) {
   // ascii
  } else {
   // not ascii
   cnt++;
  }
  if(cnt!=0) return false; 
 } 
}

function member_join(){

	if ($('#user-id').val() == "") {
		alert('아이디를 입력하세요!');
		$('#user-id').focus();
		return false; 
	}else{ 
		if (input_check($('#user-id').val()) == false){
			alert('아이디는 영문만 가능합니다!');
			$('#user-id').val("");
			$('#user-id').focus();
			return false;
		}
			
	}
	
	if ($('#user-name').val() == ""){
		alert("성함을 입력해주세요!");
		$('#user-name').focus();
		return false;
	}
	
	if ($('#user-password').val() == "" || $('#user-repassword').val() == "" ){
		alert('비밀번호를 입력해주세요!');
		
		return false;
	}else{
		if( $('#user-password').val() != $('#user-repassword').val()) {
			alert('비밀번호를 확인해주세요!');
			$('#user-password').focus();
			return false;
		}
	}
	
	if ($('#user-name').val() == ""){
		alert("성함을 입력해주세요!");
		$('#user-name').focus();
		return false;
	}
	
	if ($('#user-email').val() == ""){
		alert("메일주소를 입력해주세요!");
		$('#user-email').focus();
		return false;
	}
	


	if (window.confirm("입력하신 정보로 회원가입을 하시겠습니까?")){
		loadingView();
		
						
		$.ajax({
			data:'userid='+$('#user-id').val()+'&name='+$('#user-name').val()+'&password='+$('#user-password').val()+'&email='+$('#user-email').val(), 
			dataType:'script', 
			type:'post', 
			url:'/users/create',
			success: function(request){
				loadingView();
				document.location.replace('/');
			}
		});	
	};
	

}

function member_modify(){

	
	if ($('#user-password').val() == "" ){
		alert('정보수정을 위해서는 비밀번호가 필요합니다!');
		$('#user-password').focus();
		return false;
	}

	
	if ($('#user-email').val() == ""){
		alert("메일주소를 입력해주세요!");
		$('#user-email').focus();
		return false;
	}
	


	if (window.confirm("입력하신 정보로 수정 하시겠습니까?")){
		loadingView();
		
						
		$.ajax({
			data:'id='+$('#user_id').val()+'&current_password='+$('#user-password').val()+'&new_password='+$('#user-new-password').val()+'&email='+$('#user-email').val(), 
			dataType:'script', 
			type:'post', 
			url:'/users/update',
			success: function(request){
				loadingView();
				if(request == "비밀번호 오류"){
					alert("비밀번호가 틀립니다!");	
				}else if(request == "수정완료"){
					alert("정상적으로 수정이 완료되었습니다!");
					$('#popup-closeButton').click();
				}
			}
		});	
	};
}

$('#user-id').live("change",function(){
	$.ajax({
		data:'user_id='+$('#user-id').val(), 
		dataType:'script', 
		type:'post', 
		url:'/users/check_id',
		success: function(request){
			if (request == "dup"){
				$('#id_check').html("이미 사용중!");
				$('#user-id').val("");
				$('#user-id').focus();
			}else{
				$('#id_check').html("사용가능!");
			}
			
		}
	});
});
