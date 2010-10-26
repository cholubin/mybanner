	//파일전송 후 콜백 함수
function FileuploadCallback(data,state){
	if (data=="error"){
		alert("파일전송중 오류가 발생하였습니다.\n다시한번 시도해주세요.");
		//location.reload();
		return false;
	}
	alert('신청이 완료되었습니다.\n디자인바구니에서 확인하실 수 있습니다.');
	$('#popup-closeButton').click();
}
		

$(function(){
	//비동기 파일 전송
	var frm=$('#frmFile'); 
	frm.ajaxForm(FileuploadCallback); 
	frm.submit(function(){return false; }); 
});


// 파일업로드 이벤트
function FileUpload(){
		var frm;
		frm = $('#frmFile');
		frm.attr("action","/temps/create_mytemp");
		frm.ajaxForm(FileuploadCallback); 
		frm.submit();
}

function req_submit(){
	
	var frm;
	frm = $('#frmFile');
	frm.ajaxForm({ 
        dataType:  'script', 
		url: '/mytemplates/jobboard_create',
        success:   Callback_req_submit 
	  });
	
	 frm.submit();
}

function Callback_req_submit(request,state){
	if (state == "success"){
		loadingView();
		$('#feedback_memo').val("");
		request = request.replace("<table>","").replace("</table>","").replace("<tbody>","").replace("</tbody>","")
		$('#jbbs_body').html(request);


	}
}

				
