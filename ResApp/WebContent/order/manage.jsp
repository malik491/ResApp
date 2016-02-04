<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.OrderBean"%>
<%@ page import="edu.depaul.se491.enums.OrderType,edu.depaul.se491.enums.OrderStatus" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Manage Orders</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">

	<h3>Manage Orders</h3>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home </a> <br> <br>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	OrderBean[] orders = (OrderBean[]) request.getAttribute(ParamLabels.Order.ORDER_BEAN_LIST);
	
	if (message != null) {
%>		
		<h3> <%= message %> </h3>	
<%	
	} else if (orders != null) {
		if (orders.length == 0) {
%>		
			<h3> There Are No Orders You Can Manage </h3>
<%		
		} else {
%>
		<table>
			<thead><tr><th> Order ID </th><th> Type </th> <th> Status </th> <th> View </th><th> Update </th><th> Delete </th></tr></thead>
			<tbody>	
<%			for (OrderBean order: orders) {
				long orderId = order.getId();
				String type = order.getType().name().toLowerCase();
				String status = order.getStatus().name().toLowerCase();
%>
				<!--  print row for this order -->
				
				<tr>
					<td><%=orderId%></td>
					<td><%=type%></td>
					<td><%=status%></td>
					
					<td>
						<form action="${pageContext.request.contextPath}/order/view" method="POST">
						<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=orderId%>">
						<input type="submit" value="View">
						</form>
					</td>
					<td>
						<form action="${pageContext.request.contextPath}/order/update" method="POST">
						<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=orderId%>">
						<input type="submit" value="Update">
						</form>
					</td>
					<td>
						<form action="${pageContext.request.contextPath}/order/delete" method="POST">
						<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=orderId%>">
						<input type="submit" value="Delete">
						</form>
					</td>								
				</tr>
<% 			}
%>			</tbody>
		</table>
<%		}
	}
%>
	</div>
</body>
</html>