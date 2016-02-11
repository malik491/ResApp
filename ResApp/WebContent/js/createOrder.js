/**
 * Malik
 */
$(document).ready(function(){
	selectPickupOrder();
	selectCashPayment();
	$('#orderItemsMessage').hide();
	
	$('#createForm').submit(function(event) {
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
	
	$("#paymentType").change(function(){
		var isCash = $(this).val() === 'CASH';
		if (isCash === true) {
			selectCashPayment();
		} else {
			selectCreditCardPayment();
		}
	});
});


function selectCashPayment() {
	$('#creditcard').hide();
	
	var numberInput = $("input[name='ccNumber']").removeAttr('required');
	var nameInput = $("input[name='ccHolderName']").removeAttr('required');
	var monthInput = $("input[name='ccExpMonth']").removeAttr('required');
	var yearInput = $("input[name='ccExpYear']").removeAttr('required');
	
	$(numberInput).val('');
	$(nameInput).val('');
}

function selectCreditCardPayment() {
	var numberInput = $("input[name='ccNumber']").attr('required', 'required');
	var nameInput = $("input[name='ccHolderName']").attr('required', 'required');
	var monthInput = $("input[name='ccExpMonth']").attr('required', 'required');
	var yearInput = $("input[name='ccExpYear']").attr('required', 'required');
	
	$(numberInput).val('');
	$(nameInput).val('');
	
	$('#creditcard').show();
}

function selectPickupOrder() {
	$('#deliveryaddress').hide();
	
	var line1Input = $("input[name='addrLine1']").removeAttr('required');
	var line2Input = $("input[name='addrLine2']");
	var cityInput = $("input[name='addrCity']").removeAttr('required');
	var stateInput = $("select[name='addrState']").removeAttr('required');
	var zipcodeInput = $("input[name='addrZipCode']").removeAttr('required');

	$(line1Input).val('');
	$(line2Input).val('');
	$(cityInput).val('');
	$(stateInput).val('');
	$(zipcodeInput).val('');
}

function selectDeliveryOrder() {
	var line1Input = $("input[name='addrLine1']").attr('required', 'required');
	var line2Input = $("input[name='addrLine2']");
	var cityInput = $("input[name='addrCity']").attr('required', 'required');
	var stateInput = $("select[name='addrState']").attr('required', 'required');
	var zipcodeInput = $("input[name='addrZipCode']").attr('required', 'required');
	
	$(line1Input).val('');
	$(line2Input).val('');
	$(cityInput).val('');
	$(stateInput).find("option[value='IL']").attr('selected', 'selected');
	$(zipcodeInput).val('');
	
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
