/**
 * Malik
 */
$(document).ready(function(){
	setOrderType();
	$('#orderItemsMessage').hide();
	$('#addressMessage').hide();
	
	$('#updateForm').submit(function(event) {
		var isValid = true;
		
		if ($("#orderType").val() === 'DELIVERY') {
			isValid = isValidAddressData();
			if (isValid === false) {
				$('#addressMessage').show();
			} else {
				$('#addressMessage').hide();
			}
		}
		
		var isAllZero = isAllZeroQuantity();
		if (isAllZero === true) {
			isValid = false;
			$('#orderItemsMessage').show();
		} else {
			$('#orderItemsMessage').hide();
		}
		
		if (isValid === false) {
			event.preventDefault();
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
	$('#addressMessage').hide();
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

function isValidAddressData() {
	var line2Val = $("input[name='addrLine2']").val().trim();
	line2Val = line2Val.length > 0? line2Val : null;
	
	var address = {
			line1 : $("input[name='addrLine1']").val().trim(),
			line2: line2Val,
			city  : $("input[name='addrCity']").val().trim(),
			state : $($("select[name='addrState'] option:selected")[0]).text().trim(),
			zipcode : $("input[name='addrZipCode']").val().trim()
	};
	
	return isValidAddress(address);
}

function isValidAddress(address) {
	 if (address === null)
		 return false;
	 if (address.line1 === null || address.line1.length < 1 || address.line1.length > 100)
		 return false;
	 if (address.line2 !== null && address.line2.length > 100)
		 return false;
	 if (address.city === null || address.city.length < 1 || address.city.length > 100)
		 return false;
	 if (address.zipcode === null || address.zipcode.length < 5 || address.zipcode.length > 10)
		 return false;
	 if (isAllDigits(address.zipcode) === false)
		 return false;
	 if (address.state === null || address.state.length !== 2)
		 return false;
	 
	 return true;
}