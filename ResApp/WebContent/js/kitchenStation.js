/**
 * 
 */
var updatingList = false;

$(document).ready(function() {
	$("#accordion").accordion();
	$(window).on({
		keyup : function(e){
			if (e.keyCode === 32) {
				if (orders.length > 0) {
					var hiddenInput = $('#accordion > div > input').first();
					if (hiddenInput.length > 0) {
						var orderId = parseInt(hiddenInput.val());
						var topOrder = getOrder(orderId);
						if (topOrder !== null) {
							updateOrderItemStatus(topOrder);
							var copiedOrder = $.extend(true, {}, topOrder);
							ajaxUpdateOrder(copiedOrder);
						}
					}					
				}
			}
		}
	});
	
	setTimeout(ajaxFetchOrders, 5000);
});


function getOrder(id) {
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
	while (true) {
		if (updatingList === false) {
			updatingList = true;
			for (var i=0; i < orders.length; i++) {
				ids.push(orders[i].id);
			}
			break;
		}
	}	
	updatingList = false;
	
	$.ajax({
		   type: 'POST',
		   url: ajaxFetchURL,
		   dataType: 'JSON',
		   data: { excludeIds: JSON.stringify(ids), mItemCategory: currentStation},
		   success: 
			   	function(data, textStatus, jqXHR) {
		   			if (data.valid === undefined) {
		   				alert('Malformed Server Response');
		   			} else if (data.valid === false) {
			   			alert('Failed To Fetch New Orders: ' + data.message);
			   		} else if (data.valid === true) {
			   			if (data.orders.length > 0) {
			   				appendNewOrders(data.orders);
			   			}
			   			setTimeout(ajaxFetchOrders, 5000);
			   		}
		    	},
		    error: 
		    	function(xhr, status, error) {
					var msg = xhr.responseText;
					if (msg.length === 0) {
						msg = "Cannot Connect To The Server"
					}
			       	alert('Error: ' + msg);
		    	}
	});
}

function ajaxUpdateOrder(updatedOrder) {
	$.ajax({
		   type: 'POST',
		   url: ajaxUpdateURL,
		   dataType: 'JSON',
		   data: { order: JSON.stringify(updatedOrder), mItemCategory: currentStation},
		   success: 
			   	function(data, textStatus, jqXHR) {
			   		if (data.updated === undefined) {
			   			alert('Malformed Server Response');
			   		} else if (data.updated === false) {
		   				alert('Failed To Update Order: ' + data.message);
			   		} else if (data.updated === true) {
			   			while (true) {
			   				if (updatingList === false) {
					   			updatingList = true;
			   					orders.splice(0, 1);
					   			break;
			   				}
			   			}
			   			updatingList = false;
			   			$('#accordion > h3').first().remove();
						$('#accordion > div').first().remove();
						$("#accordion").accordion('refresh');
			   		}
		    	},
		    error: 
		    	function(xhr, status, error) {
					var msg = xhr.responseText;
					if (msg.length === 0) {
						msg = "Cannot Connect To The Server"
					}
			       	alert('Error: ' + msg);
		    	}
	});
}


function appendNewOrders(newOrders) {
	var accordion = $("#accordion");
	for (var i=0; i < newOrders.length; i++) {
		var order = newOrders[i];
		var items = order.orderItems;
		
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
	while (true) {
		if (updatingList === false) {
			updatingList = true;
			orders = orders.concat(newOrders);
			$("#accordion").accordion('refresh');
			break;
		}
	}
	updatingList = false;
}
