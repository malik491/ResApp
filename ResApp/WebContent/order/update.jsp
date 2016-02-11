<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns,edu.depaul.se491.utils.ParamValues,edu.depaul.se491.utils.ParamLengths"%>
<%@ page import="edu.depaul.se491.beans.OrderBean"%>
<%@ page import="edu.depaul.se491.beans.OrderItemBean"%>
<%@ page import="edu.depaul.se491.beans.MenuItemBean"%>
<%@ page import="edu.depaul.se491.beans.PaymentBean"%>
<%@ page import="edu.depaul.se491.beans.AddressBean"%>
<%@ page import="edu.depaul.se491.enums.OrderStatus"%>
<%@ page import="edu.depaul.se491.enums.OrderItemStatus"%>
<%@ page import="edu.depaul.se491.enums.OrderType"%>
<%@ page import="edu.depaul.se491.enums.PaymentType"%>
<%@ page import="edu.depaul.se491.enums.AddressState"%>
<%@ page import="java.sql.Timestamp"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Update Order</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css" />
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
		<script src="${pageContext.request.contextPath}/js/updateOrder.js"></script>
	</head>
<body>
	<div class="component">
	
	<h3>Update Order</h3>
		<a href="${pageContext.request.contextPath}/home.jsp"> Home </a> <br><br>
<%
		String msg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
		OrderBean order = (OrderBean) request.getAttribute(ParamLabels.Order.ORDER_BEAN);
		if (msg != null) {
%>			<h3><%=msg%></h3>
<%		}
		if (order != null) {
			long orderId = order.getId();
			OrderType orderType = order.getType();
			OrderStatus orderStatus = order.getStatus();
			String confirmation = order.getConfirmation();
			
			String[] timestamp = order.getTimestamp().toLocalDateTime().toString().split("T");
			String orderDateTime = String.format("%s &nbsp;&nbsp; %s", timestamp[0], timestamp[1]);
			
			
			PaymentBean payment = order.getPayment();
			String total = String.format("&#36;%.2f", payment.getTotal());
			
			AddressBean orderAddress = order.getAddress();
			
			int line1LenMax = ParamLengths.Address.MAX_LINE1;
			int line2LenMax = ParamLengths.Address.MAX_LINE2;
			int cityLenMax = ParamLengths.Address.MAX_CITY;
			int zipcodeLenMax = ParamLengths.Address.MAX_ZIPCODE;
%>
			<form id="updateForm" action="${pageContext.request.contextPath}/order/update" method="POST">
				<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=orderId%>">
				<input type="hidden" name="<%=ParamLabels.Order.CONFIRMATION%>" value="<%=confirmation%>">
				<input type="hidden" name="<%=ParamLabels.Payment.ID%>" value="<%=payment.getId()%>">
				<input type="hidden" name="<%=ParamLabels.Payment.TYPE%>" value="<%=payment.getType().name()%>">
				<input type="hidden" name="<%=ParamLabels.Payment.TOTAL%>" value="<%=payment.getTotal()%>">
<%				if (payment.getType() == PaymentType.CREDIT_CARD) {
%>					<input type="hidden" name="<%=ParamLabels.Payment.CC_TRANSACTION_CONFIRMATION%>" value="<%=payment.getTransactionConfirmation()%>">
<%				}
				if (orderType == OrderType.DELIVERY) {
%>					<input type="hidden" name="<%=ParamLabels.Address.ID%>" value="<%=orderAddress.getId()%>">
<%				}
%>				
				<div>
				<h3>Order</h3>
				<table>
					<thead> <tr> <th> Field </th> <th> Value </th> </tr></thead>
					<tbody>
					<tr> <td> ID </td> <td> <%=orderId%> </td></tr>
					<tr> <td>Status</td> 
						 <td> <select name="<%=ParamLabels.Order.STATUS%>" form="updateForm" required="required">
<%							for (OrderStatus status : OrderStatus.values()) {
%>								<option value="<%=status.name()%>" <%if (status == orderStatus){%> selected<%}%>> <%=status.name().toLowerCase()%></option>
<%							}
%>							</select>
						</td>
					</tr>
					<tr> <td>Type</td> 
						 <td> <select id="<%=ParamLabels.Order.TYPE%>" name="<%=ParamLabels.Order.TYPE%>" form="updateForm" required="required">
<%							for (OrderType type : OrderType.values()) {
%>								<option value="<%=type.name()%>" <%if (type == orderType){%> selected<%}%>><%=type.name().toLowerCase()%></option>
<%							}
%>							</select>
						</td>
					</tr>
					
					<tr> <td> Confirmation </td> <td> <%= confirmation %> </td></tr>
					<tr> <td> Date/Time </td> <td> <%= orderDateTime %> </td></tr>
					
					<tr> <td> Payment Type </td> <td> <%= payment.getType() == PaymentType.CREDIT_CARD? "credit card" : "cash" %> </td></tr>
					<tr> <td> Payment Total </td> <td><%= total %> </td></tr>
<%					if (payment.getType() == PaymentType.CREDIT_CARD) {
%>						<tr><td>Transaction Confirmation</td> <td> <%=payment.getTransactionConfirmation()%> </td></tr>
<%					}
%>					</tbody> 
				</table> 
				</div>
				
				<div id="deliveryaddress">
				<h3> Delivery Address </h3>
				<table>
					<thead> <tr> <th> Field </th> <th> Value </th> </tr></thead>
					<tbody>
					<tr> <td> Line 1 </td> 
						 <td> <input type="text" name="<%=ParamLabels.Address.LINE_1%>" value="<%=orderAddress == null? "" : orderAddress.getLine1()%>" 
						 			 pattern="<%=ParamPatterns.Address.LINE_1%>" 
						 			 title="length <%=ParamLengths.Address.MIN_LINE1%>-<%=ParamLengths.Address.MAX_LINE1%>" required="required"> 
						 </td> 
					</tr>
					<tr> <td> Line 2 (Optional) </td> 
						 <td> <input type="text" name="<%=ParamLabels.Address.LINE_2%>" value="<%=orderAddress == null? "" : orderAddress.getLine2() == null? "" : orderAddress.getLine2()%>" 
						 			 maxLength="<%=ParamLengths.Address.MAX_LINE2%>" 
						 			 title="length <%=ParamLengths.Address.MIN_LINE2%>-<%=ParamLengths.Address.MAX_LINE2%>"> 
						 </td> 
					</tr>
					<tr> <td> City </td> 
						 <td> <input type="text" name="<%=ParamLabels.Address.CITY%>" value="<%=orderAddress == null? "" : orderAddress.getCity()%>" 
						 			 pattern="<%=ParamPatterns.Address.CITY%>" 
						 			 title="length <%=ParamLengths.Address.MIN_CITY%>-<%=ParamLengths.Address.MAX_CITY%>" required="required"> 
						 </td> 
					</tr>
					<tr> <td> State </td> 
						 <td> <select name="<%=ParamLabels.Address.STATE%>" form="updateForm" required="required">
<% 							for (AddressState state : AddressState.values()) {
%>								<option value="<%=state.name()%>" <%if (orderAddress != null && state == orderAddress.getState()){%> selected="selected" <%}%>> <%=state.name()%> </option>
<%							}
%>						  	</select>
						 </td> 
					</tr>
					<tr> <td> Zipcode </td> 
						 <td> <input type="text" name="<%=ParamLabels.Address.ZIP_CODE%>" value="<%=orderAddress == null? "" : orderAddress.getZipcode()%>" 
						 			 pattern="<%=ParamPatterns.Address.ZIPCODE%>" 
						 			 title="digit string. length <%=ParamLengths.Address.MIN_ZIPCODE%>-<%=ParamLengths.Address.MAX_ZIPCODE%>" required="required"> 
						 </td> 
					</tr>
					</tbody>
				</table>
				</div>
			
				<div id="orderItemsMessage" style="color:red;font-weight:bold;"> One item must have quantity > 0 </div>
				
				<div>
				<h3> Order Items </h3>
				<table id="orderItems">
					<thead> <tr><th>Menu Item</th> <th>Quantity</th> <th>Status</th> </tr> </thead>
					<tbody>
<%					for (OrderItemBean orderItem: order.getOrderItems()) {
						long menuItemId = orderItem.getMenuItem().getId();
						OrderItemStatus orderItemStatus = orderItem.getStatus();
						String quantityParamName = String.format("%s-%d", ParamLabels.OrderItem.QUANTITY, menuItemId);
						String statusParamName = String.format("%s-%d", ParamLabels.OrderItem.STATUS, menuItemId);
%>						
						<tr> 
							<td> <%=orderItem.getMenuItem().getName()%> </td> 
							<td> <input type="number" name="<%=quantityParamName%>" min="<%=ParamValues.OrderItem.MIN_QTY%>" 
										max="<%=ParamValues.OrderItem.MAX_QTY%>" value="<%=orderItem.getQuantity()%>" required="required">
							</td> 
							<td> <select name="<%=statusParamName%>" form="updateForm" required>
<%								for (OrderItemStatus status: OrderItemStatus.values()) { 
%>									<option value="<%=status.name()%>" <%if (status == orderItem.getStatus()){%> selected="selected"<%}%>>
										<%= (status == OrderItemStatus.NOT_READY)? "not ready" : "ready" %> </option>
<%								}
%>								</select>
							</td>
						</tr>
<%					}
%>					</tbody>
				</table>
				</div>
				
			<input type="submit" value="Update Order">
		</form>
<%
		} // end if (order != null)
%>

	</div>
</body>
</html>