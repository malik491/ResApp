/**
 * 
 */

$(document).ready(function() {
	$("#accordion").accordion();
	$(window).on({
		keyup : function(e){
			if (e.keyCode === 32) {
				var hiddenInput = $('#accordion > div > input').first();
				if (hiddenInput && hiddenInput.length > 0) {
					var orderId = parseInt(hiddenInput.val());
					var topOrder = getOrder(orderId);
					if (topOrder !== null) {
						updateOrderItemStatus(topOrder);
						ajaxUpdateOrder(topOrder);
					}
				}
			}
		}
	});
	
	setTimeout(ajaxFetchOrders, 5000);
});


function getOrder(id) {
	if (orders === null)
		return null;
	
	if (id === undefined || id === 0 || id === NaN)
		return null;
	
	var result = null;
	for (var i=0; i < orders.length; i++) {
		var order = orders[i];
		if (order.id === id) {
			result = order;
			break;
		}
	}
	
	return result;
}

function updateOrderItemStatus(order) {
	if (order === null)
		return;
	
	var orderItems = order.orderItems;
	for (var i=0; i < orderItems.length; i++) {
		var oItem = orderItems[i];
		if (oItem.menuItem.itemCategory === currentStation) {
			oItem.status = 'READY';
		}
	}
	return;
}

function ajaxFetchOrders() {
	var ids = [];
	for (var i=0; i < orders.length; i++) {
		ids.push(orders[i].id);
	}
	
	$.ajax({
		   type: 'POST',
		   url: ajaxFetchURL,
		   dataType: 'JSON',
		   data: { excludeIds: JSON.stringify(ids), mItemCategory: currentStation},
		   success: 
			   	function(data, textStatus, jqXHR) {
		   			console.log(data);
			   		if (data.valid === true) {
			   			var newOrdersStart = orders.length;
			   			if (data.orders.length > 0) {
			   				orders = orders.concat(data.orders);
			   				appendNewOrders(newOrdersStart);
			   			}
			   			setTimeout(ajaxFetchOrders, 5000);
			   		} else if (data.valid === false) {
			   			alert(data.message);
			   		} else {
			   			alert('malformed server ajax response');
			   		}
		    	},
		    error: 
		    	function(data) {
		        	alert('Error: AJAX in ajaxFetchOrders() Check if the server is running');
		    	}
	});
}

function ajaxUpdateOrder(updatedOrder) {
	var copiedOrder = $.extend(true, {}, updatedOrder);
	
	$.ajax({
		   type: 'POST',
		   url: ajaxUpdateURL,
		   dataType: 'JSON',
		   data: { order: JSON.stringify(copiedOrder)},
		   success: 
			   	function(data, textStatus, jqXHR) {
		   			console.log(data);
			   		if (data) {
			   			if (data.updated === false) {
			   				alert('failed to update order: ' + data.message);
			   			}
						orders.splice(0, 1);
						
						$('#accordion > h3').first().remove();
						$('#accordion > div').first().remove();
						$("#accordion").accordion('refresh');
			   		} else {
			   			alert('malformed server ajax response');
			   		}
		    	},
		    error: 
		    	function(data) {
		        	alert('Error: AJAX in ajaxUpdateOrder(). Check if the server is running');
		    	}
	});
}


function appendNewOrders(index) {
	var accordion = $("#accordion");
	var refresh = false;
	for (var i=index; i < orders.length; i++) {
		refresh = true;
		
		var order = orders[i];
		var items = order.orderItems;
		console.log(order);
		
		var table = $('<table />');
		for (var j=0; j < items.length; j++) {
			var oItem = items[j];
			var menuItem = oItem.menuItem;
			
			if (menuItem.itemCategory === currentStation && oItem.status === 'NOT_READY') {
				var mItemInput = $('<input />', {type:"hidden", name:'mItemId', value:"" + menuItem.id });

				var td1 = $('<td />').text('' + oItem.quantity);
				var td2 = $('<td />').text('' + oItem.menuItem.name);
				var td3 = $('<td />').append(mItemInput);
				
				var tr = $('<tr />');
				tr.append(td1);
				tr.append(td2);
				tr.append(td3);
				
				table.append(tr);
			}
		}

		var h3 = $('<h3 />').text('Order( ID = ' + order.id+ ', ' + order.timestamp);
		
		var div = $('<div />');
		div.append($('<input />', {type:"hidden", name:'orderId', value:"" + order.id }));
		div.append(table);
		
		accordion.append(h3);
		accordion.append(div);
	}
	
	if (refresh === true) {
		$("#accordion").accordion('refresh');
	}
}
