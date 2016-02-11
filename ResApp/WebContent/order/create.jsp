<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List" %>
<%@page import="edu.depaul.se491.utils.ParamLengths,edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns,edu.depaul.se491.utils.ParamValues"%>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import="edu.depaul.se491.enums.OrderStatus,edu.depaul.se491.enums.OrderItemStatus, edu.depaul.se491.enums.OrderType,edu.depaul.se491.enums.AddressState, edu.depaul.se491.enums.PaymentType" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Create Order</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
		<script src="${pageContext.request.contextPath}/js/createOrder.js"></script>
	</head>
<body>
	<div class="component">
	<h1>Create Order </h1>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>
<%
	String msg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	MenuItemBean[] menuItems = (MenuItemBean[]) request.getAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN_LIST);
	
	if (msg != null) {
%>		<h3><%=msg%></h3> 
<% 	}
	if (menuItems == null || (menuItems.length == 0)) {
%>		<h3>There are no menu items (empty menu)</h3>
<%	} else {
%>
		<h3>Order</h3>
		<form id="createForm" action="${pageContext.request.contextPath}/order/create" method="POST">
			<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="0">
			
			<div>
			<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td>Status</td> 
			 		 <td> <select name="<%=ParamLabels.Order.STATUS%>" form="createForm" required="required">
<%							for (OrderStatus status : OrderStatus.values()) {
%>								<option value="<%=status.name()%>"> <%=status.name().toLowerCase()%></option>
<%							}
%>						  </select>
					</td>
				</tr>
				<tr> <td>Type</td> 
			 		 <td> <select id="<%=ParamLabels.Order.TYPE%>" name="<%=ParamLabels.Order.TYPE%>" form="createForm" required="required">
<%							for (OrderType type : OrderType.values()) {
%>								<option value="<%=type.name()%>" <%if (type == OrderType.PICKUP){%>selected="selected"<%}%>> <%=type.name().toLowerCase()%></option>
<%							}
%>						  </select>
					</td>
				</tr>
				<tr> <td>Payment</td> 
			 		 <td> <select id="<%=ParamLabels.Payment.TYPE%>" name="<%=ParamLabels.Payment.TYPE %>" form="createForm" required="required">
<%							for (PaymentType type : PaymentType.values()) {
	%>								<option value="<%=type.name()%>" <%if (type == PaymentType.CASH){%>selected="selected"<%}%>> <%= (type == PaymentType.CREDIT_CARD)? "credit card" : "cash" %></option>
<%							}
%>						  </select>
					</td>
				</tr>
			</tbody>
			</table>
			</div>
			
			
			<div id="deliveryaddress">
			<h3> Delivery Address </h3>
			<table>
				<thead> <tr> <th>Field</th> <th>Value </th> </tr> </thead>
				<tbody>
				<tr> <td> Line 1 </td> 
					 <td> <input type="text" name="<%=ParamLabels.Address.LINE_1%>" pattern="<%=ParamPatterns.Address.LINE_1%>" 
					 			 title="length <%=ParamLengths.Address.MIN_LINE1%>-<%=ParamLengths.Address.MAX_LINE1%>" required="required"> 
					 </td> 
				</tr>
				<tr> <td> Line 2 (Optional) </td> 
					 <td> <input type="text" name="<%=ParamLabels.Address.LINE_2%>" value="" maxLength="<%=ParamLengths.Address.MAX_LINE2%>"
					 			 title="length <%=ParamLengths.Address.MIN_LINE2%>-<%=ParamLengths.Address.MAX_LINE2%>"> 
					 </td> 
				</tr>
				<tr> <td> City </td> 
					 <td> <input type="text" name="<%=ParamLabels.Address.CITY%>" pattern="<%=ParamPatterns.Address.CITY%>" 
					 			 title="length <%=ParamLengths.Address.MIN_CITY%>-<%=ParamLengths.Address.MAX_CITY%>" required="required"> 
					 </td> 
				</tr>
				<tr> <td> State </td> 
					 <td> <select name="<%=ParamLabels.Address.STATE%>" form="createForm" required="required">
<% 							for (AddressState state : AddressState.values()) {
%>								<option value="<%=state.name()%>"> <%=state.name()%> </option>
<%							}
%>						  	</select>
					 </td> 
				</tr>
				<tr> <td> Zipcode </td> 
					 <td> <input type="text" name="<%=ParamLabels.Address.ZIP_CODE%>" pattern="<%=ParamPatterns.Address.ZIPCODE%>" 
					 			 title="digit string. length <%=ParamLengths.Address.MIN_ZIPCODE%>-<%=ParamLengths.Address.MAX_ZIPCODE%>" required="required"> 
					 </td> 
				</tr>
			</tbody>
			</table>
			</div>
						
			<div id="creditcard">
			<h3>Credit Card</h3>	
			<table>
				<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
				<tbody>
				<tr> <td> Number </td> 
					 <td> <input type="text" name="<%=ParamLabels.CreditCard.NUMBER%>" 
					 		pattern="<%=ParamPatterns.CreditCard.NUMBER%>" 
					 		title="digit string. length <%=ParamLengths.CreditCard.MIN_NUMBER%>-<%=ParamLengths.CreditCard.MAX_NUMBER%>" required="required"> 
					 </td> 
				</tr>
				<tr> <td> Holder Name </td> 
					 <td> <input type="text" name="<%=ParamLabels.CreditCard.HOLDER_NAME%>" 
					 		pattern="<%=ParamPatterns.CreditCard.HOLDER_NAME%>"
					 		title="length <%=ParamLengths.CreditCard.MIN_HOLDER_NAME%>-<%=ParamLengths.CreditCard.MAX_HOLDER_NAME%>" required="required"> 
					 </td> 
				</tr>
				<tr> <td> Expiration Month </td> 
					 <td> <input type="number" name="<%=ParamLabels.CreditCard.EXP_MONTH%>" value="1"
					 		min="<%=ParamValues.CreditCard.MIN_EXP_MONTH%>" max="<%=ParamValues.CreditCard.MAX_EXP_MONTH%>"
					 		title="number between <%=ParamValues.CreditCard.MIN_EXP_MONTH%>-<%=ParamValues.CreditCard.MAX_EXP_MONTH%>" required="required"> 
					 </td>
				</tr>
				<tr> <td> Expiration Year </td> 
					 <td> <input type="number" name="<%=ParamLabels.CreditCard.EXP_YEAR%>" value="2016"
					  	 min="<%=ParamValues.CreditCard.MIN_EXP_YEAR%>" max="<%=ParamValues.CreditCard.MAX_EXP_YEAR%>"
					 	 title="year <%=ParamValues.CreditCard.MIN_EXP_YEAR%>-<%=ParamValues.CreditCard.MAX_EXP_YEAR%>" required="required"> 
					 </td> 
				</tr>
			</tbody>
			</table>
			</div>
			
			<div id="orderItemsMessage" style="color:red;font-weight:bold;"> All items have zero quantity !!</div>
			
			<div>
			<h3> Order Items </h3>
			<table id="orderItems">
				<thead> <tr><th>Menu Item</th> <th>Quantity</th> <th>Status</th> </tr> </thead>
				<tbody>
<%					for (MenuItemBean menuItem: menuItems) {
					long menuItemId = menuItem.getId();
					String quantityParamName = String.format("%s-%d", ParamLabels.OrderItem.QUANTITY, menuItemId);
					String statusParamName = String.format("%s-%d", ParamLabels.OrderItem.STATUS, menuItemId);
%>						
					<tr> 
						<td> <%=menuItem.getName()%> </td> 
						<td> <input type="number" name="<%=quantityParamName%>" min="<%=ParamValues.OrderItem.MIN_QTY%>" 
								max="<%=ParamValues.OrderItem.MAX_QTY%>" value="<%=ParamValues.OrderItem.MIN_QTY%>" required="required">
						</td> 
						<td> <select name="<%=statusParamName%>" form="createForm" required="required">
<%							for (OrderItemStatus status: OrderItemStatus.values()) { 
%>								<option value="<%=status.name()%>" <%if (status == OrderItemStatus.NOT_READY){%> selected="selected"<%}%>> 
									<%= (status == OrderItemStatus.NOT_READY)? "not ready" : "ready" %>  </option>
<%							}
%>							</select>
						</td>
					</tr>
<%					}
%>				</tbody>
			</table>
			</div>
	
		<input type="submit" value="Create Order">
		</form>		
<%	}
%>
	</div>
</body>
</html>