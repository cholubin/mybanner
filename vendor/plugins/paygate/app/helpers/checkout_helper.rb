module CheckoutHelper              
  def insert_paymethod_hidden_input(params)
    payment = params[:payment]
    mid = params[:mid]
    # hosting_url = params[:hosting_url]
    pay_method = payment.pay_method    
    hidden_form = ""
    hidden_form << "<form class='paygate' name='PGIOForm' method='post' action='https://service.paygate.net/payment/payform.jsp'> "
    hidden_form << "<input type='hidden' name='mid' value='#{mid}' />"    
    hidden_form << "<input type='hidden' name='MoveURL' value='/pay_result''/>"   
    hidden_form << "<input type = 'hidden' name='replycode' value='' />"
    hidden_form << "<input type = 'hidden' name='replyMsg' value='' />"      
    
   
    case pay_method
    when 'mobile'             
      hidden_form << "<input type = 'hidden' class='paymethod' name='paymethod' value='801' />"      
      hidden_form << "<input type = 'hidden'name='goodname' value='#{payment.name}' />"
      hidden_form << "<input type = 'hidden' name='unitprice' value='#{payment.total_price} ' />  #{payment.total_price} won"
      hidden_form << "<input type = 'hidden' name='goodcurrency' value='WON' />"        

      hidden_form << "<br>social number <input name='socialnumber' /> "
      hidden_form << "<br><select name='carrier'><option value='016'>KT</option><option value='019'>LG</option><option value='011'>SK</option></select> "
      hidden_form << "<br>phone number <input  name='receipttotel' /> "    
      # hidden_form << "<input type='hidden' name='MoveURL' value='/pay_result''/>"   
      # hidden_form << "<input type = 'hidden' name='replycode' value='' />"
      # hidden_form << "<input type = 'hidden' name='replyMsg' value='' />"      
      hidden_form << "<br><input type='button' value='PAY NOW' class='start_processing' onclick='startPayment();'/>"
      hidden_form << "</form>"
      hidden_form         
            
    when 'card'           
      hidden_form << "<input type = 'hidden' class='paymethod' name='paymethod' value='card' />"
      hidden_form << "<input type = 'hidden' name='goodname' value='#{payment.name}' />"
      hidden_form << "<input type = 'hidden' name='unitprice' value='#{payment.total_price}' />  #{payment.total_price} won"
      hidden_form << "<input type = 'hidden' name='goodcurrency' value='WON' />"  
      # hidden_form << "<input type='hidden' name='MoveURL' value='/pay_result''>"     
      # hidden_form << "<input type = 'hidden' name='replycode' value='' />"
      # hidden_form << "<input type = 'hidden' name='replyMsg' value='' />"      
      hidden_form << "<br><input type='button' value='PAY NOW' class='start_processing' onclick='startPayment();'/>"
      hidden_form << "</form>"
      hidden_form
    when '4'           
      hidden_form << "<input type = 'hidden' class='paymethod' name='paymethod' value='4' />"
      hidden_form << "<input type = 'hidden' name='goodname' value='#{payment.name}' />"
      hidden_form << "<input type = 'hidden' name='unitprice' value='#{payment.total_price}' />  #{payment.total_price} won"
      hidden_form << "<input type = 'hidden' name='goodcurrency' value='WON' />"  
      hidden_form << "<br> social number<input name='socialnumber'/>"  
      hidden_form << "<br>Customer name<input name='receipttoname' />"              
      hidden_form << "<input type='hidden' name='MoveURL' value='/pay_result''>"     
      hidden_form << "<input type = 'hidden' name='replycode' value='' />"
      hidden_form << "<input type = 'hidden' name='replyMsg' value='' />"      
      hidden_form << "<br><input type='button' value='PAY NOW' class='start_processing' onclick='startPayment();'/>"
      hidden_form << "</form>"
      hidden_form
    else
      hidden_form 
    end   
    return hidden_form
  end
end

     
      
   
                 
                   
  
     
  
    
  
       


