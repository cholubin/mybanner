function to_comma(price){
	char_price = price;
	// 콤마찍기
	var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
	char_price += '';                // 숫자를 문자열로 변환

	while (reg.test(char_price))
	char_price = char_price.replace(reg, '$1' + ',' + '$2');
	
	return char_price;
}
