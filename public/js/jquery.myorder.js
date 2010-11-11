var total_price = 0;
var prevOption;


function popup(doc_name) {
       // var url = '/mlayout?doc_name='+doc_name;
	   var url = "/MClientBox/index.html?spread_list=NO&user_path=/user_files/<%= current_user.userid %>&doc_path=/article_templates/"+ doc_name+".mlayoutP"
	   width = screen.width;
	   height = screen.height;
      window.open(url ,'webtop_print','width='+width+', height='+height);
}
$('.option_save').live("click", function(event){
	$id = $(this).attr("id").replace("option_save_","");
	$opt1 = $('#select_main_'+$id + ' option:selected').val();
	$opt2 = $('#select_sub_'+$id + ' option:selected').val();
	
	$.ajax({
		data:'opt1='+$opt1+'&opt2='+$opt2+'&id='+ $id, 
		dataType:'script', 
		type:'post', 
		url:'/mytemplates/update_option'
	});
});

$('.piece').change(function(event) {
	id_temp = $(event.target).attr("id").split("_");
	id = id_temp[1];

	$chkbox = $('#chk_'+id);
	if($chkbox.attr("checked") == false){
		if( parseInt($('#peice_'+id).val()) < 1 ){
			$('#peice_'+id).val("1");
		}
		current_unit = $('#peice_'+id).val();
		unit_price = $('#unit_price_'+id).val();
		tmp_total_price = parseInt(current_unit) * parseInt(unit_price);
		$(event.target).parents("tr").find("td.price").html(to_comma(tmp_total_price) + "원");
		
		$.ajax({
			data:'quantity='+current_unit+'&id='+ id, 
			dataType:'script', 
			type:'post', 
			url:'/mytemplates/update_quantity'
		});
	}else{
		alert("품목이 선택되어진 상태에서는 수량을 변동할 수 없습니다! \n체크박스의 체크를 해제하시고 시도해주세요!");
		return false;
	}
});

$('.chkbox').live("click", function(event){
	id = $(this).val();
	var price = parseInt($(event.target).parents("tr").find("td.price").html().replace("원","").replace(",",""));
 	tmp_total_price = parseInt($('#total_price').html().replace("원","").replace(",",""));
	
	if($(this).attr("checked") == true){
		tmp_total_price += price;
		$('#peice_'+id).attr("disabled", true);
	}else{
		tmp_total_price -= price;
		$('#peice_'+id).attr("disabled", false);
	}

	$('#tmp_total_price').val(tmp_total_price);
	$('#total_price').html(to_comma(tmp_total_price) + "원");
	
});
$('#address-search').live("keydown", function(event){
	if(event.keyCode == 13){
		$('#zip_search').click();
		return false;
	}	
})
$('#zip_search').live("click", function(){
	if ($('#address-search').val() == ""){
		alert("검색어를 입력해주세요!");
	}else{
		$.ajax({
			data:'dong='+ $('#address-search').val(), 
			dataType:'script', 
			type:'post', 
			url:'/address/search_ajax',
			success: function(request){
				$("#search-address-form").fadeOut("fast");
				$('#addr_result').html(request).change(function(){
					// $('#zip_code').val()
					var temp_zip = $('#address-selector option:selected').val()
					var zip_code = temp_zip.substr(0,3) + "-" + temp_zip.substr(3,3)
					$('#zip_code').val(zip_code);
				});
			}
		});
		$('#address-search').val("검색중입니다.");
	}
});

$('#order').click(function(){
	var temp_array = jQuery.makeArray($('.chkbox:checked'));

	var order_ids = "";
	jQuery.each(temp_array, function(){
		order_ids += $(this).val() + ",";
	});

	if (order_ids == ""){
		alert("주문할 항목을 선택해주세요!");
	}else{
		popupView(696,390,"/mytemplates/mytemplate_order", { total_price: $('#total_price').text().replace(",",""), ids: order_ids}, function(){
			$type_val = $('#receive-type1 option:selected').val();
			if($type_val != ""){
				$('#receive-type2 option').each(function(){
					if($(this).val() == $type_val){
						$(this).attr("selected", true);
					}
				});
			}
		} );
	}

});

function to_comma(price){
	char_price = price;
	// 콤마찍기
	var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
	char_price += '';                // 숫자를 문자열로 변환

	while (reg.test(char_price))
	char_price = char_price.replace(reg, '$1' + ',' + '$2');
	
	return char_price;
}

$('#receive-type1').live("change",function(){
	if($('#receive-type1 option:selected').val() != ""){
		delivery_price = parseInt($('#receive-type1 option:selected').attr("price"));
	}else{
		delivery_price = 0;
	}
	$('#delivery_price').html(to_comma(delivery_price) + "원");
	current_total_price = parseInt($('#tmp_total_price').val());
	$('#total_price').html(to_comma(current_total_price + delivery_price) + "원");

});

$('#receive-type2').live("change",function(){
	$type_val = $('#receive-type2 option:selected').val();
	$('#receive-type1 option').each(function(){
		if($(this).val() == $type_val){
			$(this).attr("selected", true);
		}
	});
	
	if($('#receive-type2 option:selected').val() != ""){
		delivery_price = parseInt($('#receive-type2 option:selected').attr("price"));
	}else{
		delivery_price = 0;
	}
	$('#delivery_price').html(to_comma(delivery_price) + "원");
	current_total_price = parseInt($('#tmp_total_price').val());
	$('#total_price').html(to_comma(current_total_price + delivery_price) + "원");
	$('#order_total_price').html(to_comma(current_total_price + delivery_price) + "원");
	$('#left_order_total_price').html(to_comma(current_total_price + delivery_price) + "원");
	
});

// 최종 주문하기 버튼 클릭시 프로세스 ==========================================
$('#order_basic').live("click", function(){
	var temp_array = jQuery.makeArray($('.chkbox:checked'));
	var order_item = "";
	var item_unit = "";
	jQuery.each(temp_array, function(){
		order_item += $(this).val() + ",";
		item_unit += $('#peice_'+order_item).val() + ",";
	})
	
	if (order_item == ""){
		alert("주문할 항목을 선택해주세요!");
	}else{
		if($('#receive-type1 option:selected').val() == ""){
			alert('배송방법을 선택해주세요!');
			return false;
		}
		
		if($('#receive-name').val() == ""){
			alert("받으실분의 성함을 입력해주세요!");
			$('#receive-name').focus();
			return false;
		}
		
		if($('#receive-tel').val() == ""){
			alert("일반 전화번호를 입력해주세요!");
			$('#receive-tel').focus();
			return false;
		}

		if($('#receive-mobile').val() == ""){
			alert("모바일(핸드폰) 번호를 입력해주세요!");
			$('#receive-mobile').focus();
			return false;
		}
		
		if($('#zip_code').val() == "" || $('#address2').val() == ""){
			alert("배송주소를 입력해주세요!");
			if($('#zip_code').val() == ""){
				$('#address-search').focus();
			}else{
				$('#address2').focus();
			}
			return false;
		}
		
		loadingView();
		$.ajax({
			data:'item_unit='+item_unit+'&pay_m='+$('input:radio:checked').val()+'&total_price='+$('#order_total_price').val()+'&receive-note='+$('#receive-note').val()+'&address2='+$('#address2').val()+'&address1='+$('#address-selector option:selected').text()+'&zip_code='+$('#zip_code').val()+'&receive_mobile='+$('#receive-mobile').val()+'&receive_tel='+$('#receive-tel').val()+'&receive_name='+$('#receive-name').val()+'&receive_type='+$('#receive-type1 option:selected').val()+'&ids='+ order_item, 
			dataType:'script', 
			type:'post', 
			url:'/mytemplates/create_order',
			success: function(request){
				loadingView();
				if(request != "주문에러!"){
					alert("주문시 표시된 결제금액은 기본금액입니다! 옵션 선택에 따른 추가 금액에 대해선 관리자와 상담해주시기 바랍니다!");
					alert("주문번호: "+request+" \n주문절차가 정상적으로 처리되었습니다!");	
					$('#popup-closeButton').click();
					$('.chkbox:checked').parents("tr").remove();
					
				}else{
					alert("주문진행시 문제가 발생하였습니다! 관리자에게 문의하여 주시기 바랍니다.");	
				}
			}
		});

	}
});

$('#chk_all').click(function(){
	
	$('.chkbox:enabled').each(function(){
		id = $(this).val();
		
		var price = parseInt($(this).parents("tr").find("td.price").html());
	 	tmp_total_price = parseInt($('#total_price').html().replace("원","").replace(",",""));

		if($(this).attr("checked") == true){
			tmp_total_price -= price;
			$('#peice_'+id).attr("disabled", false);
			$(this).attr("checked", false)
		}else{
			tmp_total_price += price;
			$('#peice_'+id).attr("disabled", true);
			$(this).attr("checked", true)
		}

		$('#tmp_total_price').val(tmp_total_price);
		$('#total_price').html(to_comma(tmp_total_price) + "원");
		
	})
	// $('.chkbox').click();
});

$('.delete').click(function(){
	if (event.target.id == ""){
		var temp_array = jQuery.makeArray($('.chkbox:checked'));
		var del_ids = "";
		jQuery.each(temp_array, function(){
			del_ids += $(this).val() + ",";
		})
		
		if (del_ids == ""){
			alert("삭제할 항목을 선택해주세요!");
		}else{
			if (window.confirm("정말 삭제하시겠습니까?")){
				loadingView();
				$.ajax({
					data:'ids='+ del_ids, 
					dataType:'script', 
					type:'post', 
					url:'/mytemplates/destroy_selection',
					success: function(request){
						jQuery.each(temp_array, function(){
							$('#'+$(this).val()).remove();
						})
						loadingView();
					}
				});	
			}
			
		}

			
	}else{
		var temp_id = event.target.id.split("_");
		var id = temp_id[1];
		if (window.confirm("정말 삭제하시겠습니까?")){
			loadingView();
			$.ajax({
				data:'id='+ id, 
				dataType:'script', 
				type:'post', 
				url:'/mytemplates/destroy',
				success: function(request){
					$('#'+id).remove();
					loadingView();

				}
			});	
		};	
	}
	
});

// 품목별 수량 증가 감소 by fooleaf
$("a.minus")
	.live("click",
	function() {
		$id = $(this).parents("tr").attr("id");
		$chkbox = $('#chk_'+$id);
		if($chkbox.attr("checked") == false){
			now = parseInt($(this).parents("tr").find("input.piece").val());
			if(now <= 1){
				$(this).parents("tr").find("input.piece").val(1);
			}
			else{
				$(this).parents("tr").find("input.piece").val(now-1);
			}

			current_unit = $(this).parents("tr").find("input.piece").val();
			unit_price = $('#unit_price_'+$id).val()
			total_price = parseInt(current_unit) * parseInt(unit_price);
			$(this).parents("tr").find("td.price").html(to_comma(total_price) + "원");
			
			$.ajax({
				data:'quantity='+current_unit+'&id='+ $id, 
				dataType:'script', 
				type:'post', 
				url:'/mytemplates/update_quantity'
			});
			
		}else{
			alert("품목이 선택되어진 상태에서는 수량을 변동할 수 없습니다! \n체크박스의 체크를 해제하시고 시도해주세요!")
		}
			
	}
);

$("a.plus")
	.live("click",
	function() {
		$id = $(this).parents("tr").attr("id");
		$chkbox = $('#chk_'+$id);
		if($chkbox.attr("checked") == false){
			now = parseInt($(this).parents("tr").find("input.piece").val());
			$(this).parents("tr").find("input.piece").val(now+1);
			current_unit = $(this).parents("tr").find("input.piece").val();
			unit_price = $('#unit_price_'+$id).val()
			total_price = parseInt(current_unit) * parseInt(unit_price);
			$(this).parents("tr").find("td.price").html(to_comma(total_price) + "원");
			
			$.ajax({
				data:'quantity='+current_unit+'&id='+ $id, 
				dataType:'script', 
				type:'post', 
				url:'/mytemplates/update_quantity'
			});
		}else{
			alert("품목이 선택되어진 상태에서는 수량을 변동할 수 없습니다! \n체크박스의 체크를 해제하시고 시도해주세요!");
		}
	}
);


// 디자인바구니 액션 by fooleaf
$("#designcart-list a.item")
	.live("click",
	function (){
		$(this).parents("td.design").find(".action-select ul").slideDown("fast");
		return false;
	}
);

$(".action-select ul")
	.mouseleave(
	function() {
		$(this).slideUp("fast");
	}
);

$("#designcart-list td")
	.hover(
	function (){
		$(this).parents("tr").find("td.design").css("background-color","#eee");
		$(this).parent().css("background-color","#eee");
	},
	function (){
		$(this).parents("tr").find("td.design").css("background-color","#fff");
		$(this).parent().css("background-color","#fff");
		$(".action-select ul",$(this)).slideUp("fast");
	}
);

// 디자인 바구니 옵션 관련 액션 by fooleaf
$("#designcart-list td.option h5")
	.live("click",
	function (){
		if($(this).parents("td.option").find(".option-select ul").css("display") == "none") {
			if(prevOption != null)
				prevOption.slideUp("fast");
			$(this).parents("td.option").find(".option-select ul").slideDown("fast")
			prevOption = $(this).parents("td.option").find(".option-select ul");
		}
		else {
			$(this).parents("td.option").find(".option-select ul").slideUp("fast");
			prevOption = null;
		}
	}
);
$(".option-select ul")
	.mouseleave(
	function() {
		/*$(this).fadeOut("fast")*/
	}
);
$(".option-select").delegate("select","change",function() { if($(this).parents("ul").find("select:eq(0)").val() == "" || $(this).parents("ul").find("select:eq(1)").val() == "") { $(this).parents("td.option").find("h5").html("<a class=\"select\">옵션을 선택해주세요.</a>")} else { $(this).parents("td.option").find("h5").html("<a class=\"selected\">옵션 선택 완료.</a>")}});
$(".option-select .submit-button").live("click",function() { $(this).parents("ul").slideUp("fast"); prevOption = null;});
