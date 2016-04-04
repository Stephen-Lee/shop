$(document).on('page:load',function(){
    $('.product-type input').each(function() {
    var self = $(this),
        label = self.next(),
        label_text = label.text();
    label.remove();
    self.iCheck({
        checkboxClass: 'icheckbox_sm-blue',
        radioClass: 'radio_sm-blue',
        insert: label_text
    });
});



$(".plus").click(function() {
    var quantity_field = $("#items__quantity"),
        quantity = parseInt(quantity_field.val());
    quantity_field.val(quantity + 1);
})

$(".minus").click(function() {
    var quantity_field = $("#items__quantity"),
        quantity = parseInt(quantity_field.val());

    if (quantity > 1) {
        quantity_field.val(quantity - 1);
    };
});


})