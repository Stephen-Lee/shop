$(document).ready( function() {


$("#verify_code").hide();
$("#code_trigger").click(function(){
    $("#verify_code").toggle();
});



 var order_total = 0;
 $(".panel-body").each(function(){
    var price = $(this).find(".price").html();
    var price = parseFloat(price);
    var quantity = $(this).find(".quantity").html();
    $(this).find(".total").html(price * quantity);
    order_total += price * quantity;
 });
$("#order_total").html(order_total);


})
