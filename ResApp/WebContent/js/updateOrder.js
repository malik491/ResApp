/**
 * Malik
 */
$(document).ready(function(){
	setOrderType();
	$('#orderItemsMessage').hide();
	
	$('#updateForm').submit(function(event) {
		var isAllZero = isAllZeroQuantity();
		if (isAllZero === true) {
			$('#orderItemsMessage').show();
			event.preventDefault();
		} else {
			$('#orderItemsMessage').hide();
		}
	});
	
	$("#orderType").change(function(){
		var isPickup = $(this).val() === 'PICKUP';
		if (isPickup === true) {
			selectPickupOrder();
		} else {
			selectDeliveryOrder();
		}
	});
});

function setOrderType() {
	var orderType = $("#orderType").val();
	if (orderType === 'PICKUP') {
		selectPickupOrder();
	} else if (orderType === 'DELIVERY') {
		selectDeliveryOrder();
	}
}

function selectPickupOrder() {
	$('#deliveryaddress').hide();
	
	var line1Input = $("input[name='addrLine1']").removeAttr('required');
	var line2Input = $("input[name='addrLine2']");
	var cityInput = $("input[name='addrCity']").removeAttr('required');
	var stateInput = $("select[name='addrState']").removeAttr('required');
	var zipcodeInput = $("input[name='addrZipCode']").removeAttr('required');
}

function selectDeliveryOrder() {
	var line1Input = $("input[name='addrLine1']").attr('required', 'required');
	var line2Input = $("input[name='addrLine2']");
	var cityInput = $("input[name='addrCity']").attr('required', 'required');
	var stateInput = $("select[name='addrState']").attr('required', 'required');
	var zipcodeInput = $("input[name='addrZipCode']").attr('required', 'required');
	
	$('#deliveryaddress').show();
}

function isAllZeroQuantity() {
	var orderItems = $('#orderItems > tbody > tr');
	if (orderItems.length > 0) {
		var allZero = true;
		for(var i=0; i < orderItems.length; i++) {
			var quantity = $($(orderItems[i]).find('input')[0]).val();
			allZero =  allZero && (quantity === "0");
		}
	}
	return allZero;
}