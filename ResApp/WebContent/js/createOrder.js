/**
 * Malik
 */
$(document).ready(function(){
	selectPickupOrder();
	selectCashPayment();
	$('#orderItemsMessage').hide();
	$('#addressMessage').hide();
	$('#creditCardMessage').hide();
	
	$('#createForm').submit(function(event) {
		var isValid = true;
		
		if ($("#paymentType").val() === 'CREDIT_CARD') {
			isValid = isValidCCPaymentData();
			if (isValid === false) {
				$('#creditCardMessage').show();
			} else {
				$('#creditCardMessage').hide();
			}
		}
		
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
	$('#creditCardMessage').hide();
	$('#creditcard').hide();
	
	var numberInput = $("input[name='ccNumber']").removeAttr('required');
	var nameInput = $("input[name='ccHolderName']").removeAttr('required');
	var monthInput = $("input[name='ccExpMonth']").removeAttr('required');
	var yearInput = $("input[name='ccExpYear']").removeAttr('required');
	
	$(numberInput).val('');
	$(nameInput).val('');
	$(monthInput).val('1');
	$(yearInput).val('2016');
}

function selectCreditCardPayment() {
	var numberInput = $("input[name='ccNumber']").attr('required', 'required');
	var nameInput = $("input[name='ccHolderName']").attr('required', 'required');
	var monthInput = $("input[name='ccExpMonth']").attr('required', 'required');
	var yearInput = $("input[name='ccExpYear']").attr('required', 'required');
	
	$(numberInput).val('');
	$(nameInput).val('');
	$(monthInput).val('1');
	$(yearInput).val('2016');
	
	$('#creditcard').show();
}

function selectPickupOrder() {
	$('#addressMessage').hide();
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


function getIntValue(stringValue) {
	 if(/^[0-9]+$/.test(stringValue))
	    return Number(stringValue);
	 return NaN;
}

function isAllDigits(s) {
	if(/^[0-9]+$/.test(s))
	    return true;
	 return false;
}


function isValidCCPaymentData() {
	var ccPayment = {
		ccNumber: $("input[name='ccNumber']").val().trim(),
		ccHolderName : $("input[name='ccHolderName']").val().trim(),
		expMonth : getIntValue($("input[name='ccExpMonth']").val().trim()),
		expYear : getIntValue($("input[name='ccExpYear']").val().trim())
	};
	
	return isValidCCPayment(ccPayment);
}

function isValidCCPayment(ccPayment) {
	 if (ccPayment === null)
		 return false;
	if (ccPayment.ccNumber === null || ccPayment.ccNumber.length < 12 ||ccPayment.ccNumber.length > 19)
		 return false;
	if (isAllDigits(ccPayment.ccNumber) === false)
		return false;
	if (ccPayment.ccHolderName === null || ccPayment.ccHolderName.length < 3 || ccPayment.ccHolderName.length > 100)
		 return false;
	if (isNaN(ccPayment.expMonth) || ccPayment.expMonth < 1 || ccPayment.expMonth > 12)
		 return false;
	
	var currentYear = new Date().getFullYear();
	if (isNaN(ccPayment.expYear) || ccPayment.expYear < currentYear || ccPayment.expYear > currentYear + 20)
		 return false;


	var currentMonth = new Date().getMonth(); // zero based month
	if (ccPayment.expYear === currentYear && ccPayment.expMonth < (currentMonth + 1))
		return false;
	
	return true;
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