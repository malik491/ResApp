<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List" %>

<%@ page import="edu.depaul.se491.beans.AccountBean,edu.depaul.se491.beans.CredentialsBean,edu.depaul.se491.beans.UserBean,edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<%@ page import="edu.depaul.se491.beans.OrderBean" %>
<%@ page import="edu.depaul.se491.beans.OrderItemBean" %>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import="edu.depaul.se491.beans.PaymentBean" %>
<%@ page import="edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.OrderStatus" %>
<%@ page import="edu.depaul.se491.enums.OrderType" %>
		

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>View Order</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>

<body>
	<div class="component">
	<h1>View Order </h1>
<%
	OrderBean order = (OrderBean) request.getAttribute(ParamLabels.Order.ORDER_BEAN);
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	
	if (message != null) {
			%> <h3><%= message %></h3> <%
	} 
	else if (order != null) {
		long orderId = order.getId();
		String status = "";
		String type = "";
		OrderStatus oStatus = order.getStatus();
		OrderType oType = order.getType();
		
		if(oStatus != null)
		status = oStatus.toString().toLowerCase();
		
		if(oType != null)
		type = oType.toString().toLowerCase();
		PaymentBean payment = order.getPayment();
		AddressBean addressOrder = order.getAddress();
		
		String total = String.format("&#36;%.2f", payment.getTotal()); //&#36; html for $
		String confirmation = order.getConfirmation();
		String[] timestamp = order.getTimestamp().toLocalDateTime().toString().split("T");
		String dateTime = String.format("%s &nbsp;&nbsp; %s", timestamp[0], timestamp[1]);
		
		String address = addressOrder == null? "None" : String.format("%s,<br> %s.<br> %s, %s %s", 
				addressOrder.getLine1(), addressOrder.getLine2(), addressOrder.getCity(), addressOrder.getState().toString(), addressOrder.getZipcode());
%>
		<table> 
			<thead> <tr> <th> Order </th> <th> </th> </tr> </thead>
			<tbody>
			<tr> <td> ID : </td> <td> <%= orderId %> </td></tr>
			<tr> <td> Status : </td> <td> <%= status %> </td></tr>
			<tr> <td> Type : </td> <td> <%= type %> </td></tr>
			<tr> <td> Total : </td> <td><%= total %> </td></tr>
			<tr> <td> Confirmation : </td> <td> <%= confirmation %> </td></tr>
			<tr> <td> DateTime </td> <td> <%= dateTime %> </td></tr>
			<tr> <td> Delivery Address </td> <td> <%= address %></td></tr>
		</tbody> </table>
		
		<h2> Items</h2>
		<table>
			<thead><tr>	<th> Menu Item Name </th><th> Quantity </th><th> Unit Price </th></tr></thead>
			<tbody>
<%
		List<OrderItemBean> orderItems = order.getItems();
		for (OrderItemBean oItem: orderItems) {
			MenuItemBean menuItem = oItem.getMenuItem();
			String name = menuItem.getName();
			String price = String.format("&#36;%.2f", menuItem.getPrice()); //&#36; html for $
			int qunatity = oItem.getQuantity();
%>			<!--  print MENU ITEMS for this order -->
			<tr>
				<td><%=name%></td><td><%=qunatity%></td><td><%=price%></td>
			</tr>
<%		}
%>
		</tbody></table>
<%	}
%>
	</div>

</body>

</html>