$(document).ready(function(){
	$('#my_file_element').live("click",function(){
		var file_max_num = 5;
		$('#file_max_num').val(file_max_num);
		<!-- Create an instance of the multiSelector class, pass it the output target and the max number of files -->
		var multi_selector = new MultiSelector( document.getElementById( 'files_list' ), file_max_num );
		<!-- Pass in the file element -->
		multi_selector.addElement( document.getElementById( 'my_file_element' ) );
	})

	// 폴더생성 =========================================
	$('#folder_create_btn').live("click", function(){
		if ($('#folder_name').val() == ""){
			alert("폴더명을 입력해 주세요~");
			$('#folder_name').focus();
		}else{
			$.ajax({
				data:'folder_name='+ $('#folder_name').val(), 
				dataType:'html', 
				type:'post', 
				url:'/folders/create_folder',
				success: function(request){
					result_tmp = request.split("/#/");
					result = result_tmp[0]; // success
					message_tmp = result_tmp[1].split("/##/");
					message = message_tmp[0];
					sanitized_folder_name = message_tmp[1];

					if(result == "success"){
						html_str = "<li id='"+message+"'>" +
							"<p class='folder'><a>"+sanitized_folder_name+"</a></p>" +
							"<p class='action'>" +
							"<a class='config'>관리</a>" +
							"</p>" +
							"</li>";

						$('#sortables').append(html_str);
						$('#'+message).hide().fadeIn(500);
						$('#folder_name').val("")
					}else{
						alert(message);
						$('#folder_name').val("").focus();
					}
				}
			});
		}
	});

	//폴더생성: 폴더명 입력 후 엔터를 클릭한 경우 ====================================
	$('#folder_name').live("keydown", function(event){
		if(event.keyCode == 13){
			$('#folder_create_btn').click();
			return false;
		}
	});

	//폴더수정: 폴더명 입력 후 엔터를 클릭한 경우 ====================================
	$('#edit_folder_name').live("keydown", function(event){
		if(event.keyCode == 13){
			$myli = $(event.target).parents("li");
			$edit_btn = $myli.children("p.action").children('a.edit');

			edit_folder($edit_btn, false);
		}
	});

	function edit_folder(event_target, fold){
		myli = event_target.parents("li");
		folder_id = myli.attr("id");
		// folder = $(event.target).parents("li").children("p.folder").children("input");
		folder = myli.children("p.folder").children("input");
		folder_name = folder.val();
		if (folder_name == ""){
			alert("폴더명을 입력해주세요!");
			folder.focus();
			return false;
		}
		parent_action_p = event_target.parents("p.action");
		parent_folder_p = event_target.parents("li").children("p.folder");

		if(fold == false){
			$.ajax({
				data:'folder_name='+folder_name+'&folder_id='+ folder_id, 
				dataType:'html', 
				type:'post', 
				url:'/folders/update_folder',
				success: function(request){
					$.data(myli, "clicked", "");
					html_action_str = "<a class='config'>관리</a>";
					html_folder_str = "<a>"+folder_name+"</a>";
					myli.fadeOut("fast");
					parent_action_p.html(html_action_str);
					parent_folder_p.html(html_folder_str);
					myli.fadeIn("slow");
				}
			});
		}else{
			$.data(myli, "clicked", "");
			html_action_str = "<a class='config'>관리</a>";
			html_folder_str = "<a>"+folder_name+"</a>";
			myli.fadeOut("fast");
			parent_action_p.html(html_action_str);
			parent_folder_p.html(html_folder_str);
			myli.fadeIn("slow");
		}

	}

	// 폴더관리 ==================================================
	$('li').live("click", function(event){
		// 폴더를 선택하는 경우 =====================================
		if($(event.target).is('p.folder') || $(event.target).is('p.folder a')){
			myli = $(event.target).parents("li");
			$('p.folder').removeClass("on");
			// $.data('#folder_list li', "clicked", "");

			if($(event.target).is('p.folder a')){
				$(event.target).parent().addClass("on");
			}else{
				$(event.target).addClass("on");	
			}
			sel_folder = $('p.folder.on');
			$folder_id = myli.attr("id");
			$sel_type = $('#image_search_type option:selected').val();
			$search_val = $('#image_search_val').val();

			if (myli.attr("id") == "shared") {
				$("#imagehard-list").fadeOut("fast",function() {
					$("#imagehard-wrap").load("/sharedimages?cat=all&subcat=all&search="+$search_val+"&ext=all&myimage_folder_id="+ $folder_id +" #imagehard-wrap", function(){
						$("#imagehard-list").hide().fadeIn("fast");	
					});
				});
			}else{
				$("#imagehard-list").fadeOut("fast",function() {
					$("#imagehard-wrap").load("/myimages?search="+$search_val+"&ext="+$sel_type+"&myimage_folder_id="+ $folder_id +" #imagehard-wrap", function(){
						$("#imagehard-list").hide().fadeIn("fast");	
					});
				});
			}
		};
		// 설정버튼을 클릭한 경우 ====================================
		if($(event.target).is('a.config')){
			tmp_finder = $('#sortables').find('a.edit');
			if(tmp_finder.length > 0){
				edit_folder(tmp_finder, true);
			}

			myli = $(event.target).parents("li");
			myli_id = myli.attr("id");
			parent_action_p = $(event.target).parents("p.action");
			parent_folder_p = $(event.target).parents("li").children("p.folder");
			folder_name = $(event.target).parents("li").children("p.folder").children("a").html();

			//이미 클릭한 경우 ========================
			$.data(myli, "clicked", "yes");
			// folder_name = 
			html_action_str = "<a class='edit'>수정</a>" + "<a class='delete folder'>삭제</a>";
			html_folder_str = "<input type='text' id='edit_folder_name' value='"+ folder_name +"'>";
			parent_action_p.html(html_action_str);
			parent_folder_p.html(html_folder_str);

		};


		// 수정버튼을 클릭한 경우 ====================================
		if($(event.target).is('a.edit')){
			edit_folder($(event.target), false);
		};

		// 폴더 삭제버튼을 클릭한 경우 ====================================
		if($(event.target).is('a.delete.folder')){
			myli = $(event.target).parents("li");
			folder_id = myli.attr("id");

			if( window.confirm("선택하신 폴더를 삭제하시겠습니까?") ){
				$.ajax({
					data:'folder_id='+ folder_id, 
					dataType:'html', 
					type:'post', 
					url:'/folders/destroy_folder',
					success: function(request){
						if(request == "success"){
							myli.fadeOut("slow").delay(300).remove();

							$("#imagehard-list").fadeOut("fast",function() {
								$("#imagehard-wrap").load("/myimages?myimage_folder_id=photo" +" #imagehard-wrap", function(){
									$("#imagehard-list").hide().fadeIn("slow");	
								});
							});
						}else{
							alert("폴더삭제 진행중 문제가 발생했습니다! \n다시한번 시도해주시기 바랍니다.");
						};

					}
				});
			}
		};

		// 이미지 삭제버튼을 클릭한 경우 ====================================
		if($(event.target).is('a.delete.img')){
			myimage = $(event.target).parents("ul.article");
			myimage_id = myimage.attr("id");
			$folder_id = $('p.folder.on').parents("li").attr("id");

			if( window.confirm("선택하신 이미지를 삭제하시겠습니까?") ){
				$.ajax({
					data:'myimage_id='+ myimage_id, 
					dataType:'html', 
					type:'post', 
					url:'/myimages/destroy_myimage',
					success: function(request){
						if(request == "success"){
							myimage_count = $('#imagehard-list ul.article').length;
							if (myimage_count == 1){
								if($('li.active').length > 0){
									page_num = parseInt($('li.active').attr("className").replace(" active","").replace("page-",""));
									if(page_num > 1){
										page_num -= 1;
										$("#imagehard-list").fadeOut("fast",function() {
											$("#imagehard-wrap").load("/myimages?page="+page_num+"&myimage_folder_id="+ $folder_id +" #imagehard-wrap", function(){
											$("#imagehard-list").hide().fadeIn("slow");	
											});
										});
									}
								}else{
									myimage.fadeOut("slow", function(){
										$(this).remove();
									});
								}

							}else{
								myimage.fadeOut("slow", function(){
									$(this).remove();
								});
							}
							$('#quick_preview_closeButton').click();
						}else{
							alert("이미지 삭제중 문제가 발생했습니다! \n다시한번 시도해주시기 바랍니다.");
						};

					}
				});
			}else{
				return false;
			}
		};
	});
	// 폴더관리 ==================================================

	//이미지 업로드 ================================================
	$('#imgUpload_btn').live("click", function(){
		$imgFile = $('input:file');
		$file_len = $imgFile.length - 1;
		$i = 1;
		if ($imgFile.length > 0) {
			$imgFile.each(function(){
				val = $(this).val().split("\\");
				if ($(this).val() != ""){
					f_name = val[val.length-1]; //마지막 화일명
					s_name = f_name.substring(f_name.length-4, f_name.length);//확장자빼오기
					ext = s_name.toLowerCase().replace('.','');

					if( $(this).val() == "" ){
						alert("이미지를 선택해 주세요!");
						return false;
					}else{
						if(ext == "eps" || ext == "png" || ext == "jpg" || ext == "pdf" || ext == "jpeg" || ext == "tif" || ext == "gif"){
							imgUpload();	
						}else{
							alert("pdf파일 또는 이미지 파일만 업로드 하실 수 있습니다!");
							$('#files_list div:eq('+ ($file_len - $i) +')').find('input:button').click();
							// return false;
						}
					}
					$i = $i + 1;
				}
			})

		}else{
			alert("이미지를 1개 이상 선택해주세요~");
			return false;
		}


	})
});


function imgUpload(){
	loadingView();
	$folder_id = $('p.folder.on').parents("li").attr("id");
	$('#myimage_folder_id').val($folder_id);

	var frm ;
	frm = $('#imgFile');
	frm.ajaxForm({ 
        dataType:  'script', 
		url: '/myimages/create',
        success:   Callback_imgUpload
	  });
	 frm.submit();

}

function Callback_imgUpload(request,state){
	myimage_count = $('#imagehard-list ul.article').length;
	if (myimage_count == 12){
		//현재 선택된 페이지 (Active)
		if ($('li.active').length > 0){
			page_num = parseInt($('li.active').attr("className").replace(" active","").replace("page-",""));	
		}else{
			page_num = 1;
		}

		$folder_id = $('p.folder.on').parents("li").attr("id");
		$("#imagehard-list").fadeOut("fast",function() {
			$("#imagehard-wrap").load("/myimages?page="+page_num+"&myimage_folder_id="+ $folder_id +" #imagehard-wrap", function(){
				$("#imagehard-list").hide().fadeIn("slow");	
			});
		});
	}

	if (state == "success"){
		loadingView();
		$('#myimage_image_file').val("");
		$("#imagehard-list").hide()
							.prepend(request)
							.fadeIn("slow");

	}
}

//페이징 =======================================================================================
$("#imagehard .pager a").live("click",
	function() {
		$this_list = $(this);
		$("#imagehard-list").fadeOut("slow",function() {
			$("#imagehard-wrap").load($this_list.attr("href")+" #imagehard-wrap", function(){
				$("#imagehard-list").hide().fadeIn("slow");	
			});
	});	

	return false;
})

//Sortable
function update_folder_order(){
	$.ajax({
		data:'folder_id='+result_folder_order(), 
		dataType:'html', 
		type:'post', 
		url:'/folders/update_folder_order',
		success: function(request){
		}
	});
}

function result_folder_order(){
  var result = new Array();
  result = $('#sortables').sortable('toArray');
  return result;
}


//이미지 확장자별 보기 =========================================================
$('#image_search_type').live("click", function(){
	search_myimage();
})

// 검색 =========================================================
$('#image_search_submit_btn').live("click", function(){
	search_myimage();	
	// 	if($('#image_search_val').val() == ""){
	// 	alert("검색어를 입력해 주세요!");
	// 	return false;
	// }else{
	// 	search_myimage();	
	// }

})

function search_myimage(){
	$sel_folder = $('p.folder.on');
	$folder_id = $sel_folder.parents('li').attr("id");
	$sel_type = $('#image_search_type option:selected').val();
	$search_val = $('#image_search_val').val();
	
	if($folder_id == "shared"){
		$("#imagehard-list").fadeOut("fast",function() {
			$("#imagehard-wrap").load("/sharedimages?search="+$search_val+"&ext="+$sel_type+"&myimage_folder_id=" + $folder_id +" #imagehard-wrap", function(){
				$("#imagehard-list").hide().fadeIn("slow");	
			});
		});
		
	}else{
		$("#imagehard-list").fadeOut("fast",function() {
			$("#imagehard-wrap").load("/myimages?search="+$search_val+"&ext="+$sel_type+"&myimage_folder_id=" + $folder_id +" #imagehard-wrap", function(){
				$("#imagehard-list").hide().fadeIn("slow");	
			});
		});
		
	}
	
}

//이미지 상세 페이지 ================================================
$('#imagehard_preview').live("click", function(event){
	$myimage_id = $(this).children("ul").attr("id").replace("myimage_","");
	// 원본받기 ================================================
	if($(event.target).is('li.download') || $(event.target).is('li.download a')){

		location.href = '/myimages/myimage_download?myimage_id='+$myimage_id;
		return false;
	}else if ($(event.target).is('li.download_sharedimage') || $(event.target).is('li.download_sharedimage a')){
		$myimage_id = $(this).children("ul").attr("id").replace("sharedimage_","");
		location.href = '/sharedimages/sharedimage_download?myimage_id='+$myimage_id;
		return false;
	};

	// 이미지 삭제 =================================================================
	if($(event.target).is('li.delete a')){

		$('#'+$myimage_id).children('li.date').children('a.delete.img').click();
	};

	// 이미지 이름 변경  =============================================================
	if($(event.target).is('li.change_file a')){
		$filename = $('#change_file');
		if($filename.val() == ""){
			alert("변경하실 파일명을 입력해 주세요!");
			$filename.focus()
			return false;
		}else{
			$.ajax({
				data:'filename='+$filename.val()+'&myimage_id='+$myimage_id, 
				dataType:'html', 
				type:'post', 
				url:'/myimages/update_name',
				success: function(request){
					$('#imagehard_preview h3').html($filename.val());
					$filename.val("");
					current_page_reload();
				}
			});
			return false;
		}
	};

	// 폴더명 변경 ====================================================
	if($(event.target).is('li.move_file a')){
		$folder_id = $('#move_file option:selected').val();
		$.ajax({
			data:'folder_id='+$folder_id+'&myimage_id='+$myimage_id, 
			dataType:'html', 
			type:'post', 
			url:'/myimages/update_folder',
			success: function(request){
				current_page_reload();
				alert("폴더가 변경되었습니다!");
			}
		});
		return false;
	};
	
	if($(event.target).is('li.move_sharedimage a')){
		$myimage_id = $(this).children("ul").attr("id").replace("sharedimage_","");
		$folder_id = $('#move_file option:selected').val();
		$.ajax({
			data:'folder_id='+$folder_id+'&myimage_id='+$myimage_id, 
			dataType:'html', 
			type:'post', 
			url:'/sharedimages/copy_sharedimage',
			success: function(request){
				if(request == "success"){
					// current_page_reload();
					alert("공개 이미지가 복사완료되었습니다!");
				}else{
					alert("공개 이미지 복사중 오류가 발생하였습니다! 관리자에게 문의하여 주세요!");
				}
				
			}
		});
		return false;
	};
});

function current_page_reload(){
	$sel_type = $('#image_search_type option:selected').val();
	$search_val = $('#image_search_val').val();
	if($('li.active').length > 0){
		$page_num = parseInt($('li.active').attr("className").replace(" active","").replace("page-",""));
	}else{
		$page_num = 1;
	}
	$folder_id = $('p.folder.on').parents("li").attr("id");
	$("#imagehard-list").fadeOut("fast",function() {
		$("#imagehard-wrap").load("/myimages?ext="+$sel_type+"&search="+$search_val+"&page="+$page_num+"&myimage_folder_id="+ $folder_id +" #imagehard-wrap", function(){
			$("#imagehard-list").hide().fadeIn("slow");	
		});
	});
};

$('#change_file').live("keydown", function(event){
	if(event.keyCode == 13){
		$('li.change_file a').click();
		return false;
	}
});

$('#sel_cat').live("change", function(){
	$("#imagehard-list").fadeOut("fast",function() {
		$("#imagehard-wrap").load("/sharedimages?cat="+$('#sel_cat option:selected').val()+"&search=&ext=all&myimage_folder_id=test #imagehard-wrap", function(){
			$("#imagehard-list").hide().fadeIn("fast");	
		});
	});
})

$('#sel_subcat').live("change", function(){
	$("#imagehard-list").fadeOut("fast",function() {
		$("#imagehard-wrap").load("/sharedimages?cat="+$('#sel_cat option:selected').val()+"&subcat="+$('#sel_subcat option:selected').val()+"&search=&ext=all&myimage_folder_id=test #imagehard-wrap", function(){
			$("#imagehard-list").hide().fadeIn("fast");	
		});
	});
})
