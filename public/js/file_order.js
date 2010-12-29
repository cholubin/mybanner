// 파일업로드 이벤트
function file_order(){
		var frm;
		frm = $('#frmFile');
		frm.attr("action","/temps/create_mytemp");
		frm.ajaxForm(direct_order_Callback); 
		frm.submit();
}

function file_order_Callback(data,state){
	if (data=="fail"){
		alert("파일전송중 오류가 발생하였습니다.\n다시한번 시도해주세요.");
		//location.reload();
		return false;
	}else{
		alert('신청이 완료되었습니다.\n디자인바구니에서 확인하실 수 있습니다.');
		$('#popup-closeButton').click();	
	}
	
}
