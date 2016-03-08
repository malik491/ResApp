<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<%@ page import="edu.depaul.se491.enums.OrderItemStatus" %>
<%@ page import="edu.depaul.se491.enums.PaymentType" %>

<%@ page import="edu.depaul.se491.enums.OrderType" %>
		

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>View Order</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>

<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3>View Order </h3>
<%
	OrderBean order = (OrderBean) request.getAttribute(ParamLabels.Order.ORDER_BEAN);
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	
	if (message != null) {
%> 		<div class="message"><%= message %></div> 
<%	} 
	else if (order != null) {
		long orderId = order.getId();
		String status = order.getStatus().name().toLowerCase();
		String type = order.getType().name().toLowerCase();
		String confirmation = order.getConfirmation();
		
		String[] timestamp = order.getTimestamp().toLocalDateTime().toString().split("T");
		String orderDateTime = String.format("%s &nbsp;&nbsp; %s", timestamp[0], timestamp[1]);

		PaymentBean payment = order.getPayment();
		String paymentType = (payment.getType() == PaymentType.CREDIT_CARD)? "credit card" : "cash";
		String total = String.format("&#36;%.2f", payment.getTotal());
		
		AddressBean orderAddress = order.getAddress();
		String address = orderAddress == null? null : String.format("%s<br>%s%s, %s %s", 
				orderAddress.getLine1(), orderAddress.getLine2() == null? "" : orderAddress.getLine2() + "<br>",
						orderAddress.getCity(), orderAddress.getState().toString(), orderAddress.getZipcode());
%>
		<table> 
			<thead> <tr> <th> Order </th> <th> </th> </tr> </thead>
			<tbody>
			<tr> <td> ID </td> <td> <%= orderId %> </td></tr>
			<tr> <td> Status </td> <td> <%= status %> </td></tr>
			<tr> <td> Type </td> <td> <%= type %> </td></tr>
			<tr> <td> Confirmation </td> <td> <%= confirmation %> </td></tr>
			<tr> <td> date/time </td> <td> <%= orderDateTime %> </td></tr>
			<tr> <td> Payment Type </td> <td> <%= paymentType %> </td></tr>
			<tr> <td> Payment Total </td> <td><%= total %> </td></tr>
<%			if (payment.getType() == PaymentType.CREDIT_CARD) {
%>				<tr> <td> Transaction Confirmation </td> <td> <%= payment.getTransactionConfirmation() %></td></tr>
<%			}
			if (order.getType() == OrderType.DELIVERY) {
%>				<tr> <td> Delivery Address </td> <td> <%= address %></td></tr>
<%			} 
%>
		</tbody> </table>

		<h3> Order Items </h3>
		<table>
			<thead><tr>	<th> Menu Item </th><th> Quantity </th><th> Unit Price </th><th> Status </tr></thead>
			<tbody>
<%
			OrderItemBean[] orderItems = order.getOrderItems();
			for (OrderItemBean oItem: orderItems) {
				MenuItemBean menuItem = oItem.getMenuItem();
				String name = menuItem.getName();
				String price = String.format("&#36;%.2f", menuItem.getPrice()); //&#36; html for $
				int quantity = oItem.getQuantity();
					
				String itemStatus = oItem.getStatus().toString();
%>				<tr>
					<td><%=name%></td><td><%=quantity%></td><td><%=price%></td><td><%=itemStatus%></td>
				</tr>
<%			}
%>
			</tbody>
		</table>
		
		<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/order/manage") %>"> Manage Orders </a>
<%	}
%>
</main>
</body>

</html>