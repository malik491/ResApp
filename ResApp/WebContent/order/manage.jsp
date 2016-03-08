<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.OrderBean"%>
<%@ page import="edu.depaul.se491.enums.OrderType,edu.depaul.se491.enums.OrderStatus" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Manage Orders</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3>Manage Orders</h3>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	OrderBean[] orders = (OrderBean[]) request.getAttribute(ParamLabels.Order.ORDER_BEAN_LIST);
	
	if (message != null) {
%>		<div class="message"> <%= message %> </div>	
<%	
	} else if (orders != null) {
		if (orders.length == 0) {
%>			<div class="message"> There Are No Orders You Can Manage </div>
<%		} else {
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
						<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/order/view") %>" method="POST">
						<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=orderId%>">
						<input type="image" src="${pageContext.request.contextPath}/icons/ic_pageview_black_24px.svg" alt="view">
						</form>
					</td>
					<td>
						<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/order/update") %>" method="POST">
						<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=orderId%>">
						<input type="image" src="${pageContext.request.contextPath}/icons/ic_update_black_24px.svg" alt="update">
						</form>
					</td>
					<td>
						<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/order/delete") %>" method="POST">
						<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=orderId%>">
						<input type="image" src="${pageContext.request.contextPath}/icons/ic_delete_black_24px.svg" alt="delete">
						</form>
					</td>								
				</tr>
<% 			}
%>			</tbody>
		</table>
<%		}
	}
%>
</main>
</body>
</html>