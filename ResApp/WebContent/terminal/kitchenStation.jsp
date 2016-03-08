<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.OrderBean,edu.depaul.se491.beans.OrderItemBean,edu.depaul.se491.beans.MenuItemBean"%>
<%@ page import="edu.depaul.se491.enums.*"%>
<%@ page import="edu.depaul.se491.utils.ParamLabels"%>
<%@ page import="java.util.List"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Kitchen Terminal</title>
	 	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.12.0.min.js"></script>
	 	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-ui.min.js"></script>
	 	
	 	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery/jquery-ui.css">
	 	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery/jquery-ui.structure.css">
	 	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery/jquery-ui.theme.css">
	 	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css">

	 	<script type="text/javascript" src="${pageContext.request.contextPath}/js/kitchenStation.js"></script>
	</head>
<body>

<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
<%
	String ajaxUpdateURL = response.encodeURL(getServletContext().getContextPath() + "/terminal/station/ajax/update");
	String ajaxFetchURL = response.encodeURL(getServletContext().getContextPath() + "/terminal/station/ajax/fetch");
	
	String msg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	OrderBean[] orders = (OrderBean[]) request.getAttribute(ParamLabels.Order.ORDER_BEAN_LIST);
	MenuItemCategory stationCategory = (MenuItemCategory) request.getAttribute(ParamLabels.MenuItem.ITEM_CATEGORY);
	
	String jsonOrderList = (String) request.getAttribute("jsonOrderList");
	

	if (msg != null) {
%> 		<div class="message"><%=msg%></div> 
<%	} 
	if (orders != null && jsonOrderList != null && stationCategory != null) {
%>
		<h3> Active Orders (<%=stationCategory.name().toLowerCase()%> food station) </h3>
		<div class="message"> Hit the space bar to clear the top order</div>
		<div id="accordion-outer-div">
			<div id="accordion">
<%			for (OrderBean order: orders) {
				long id = order.getId();
				String[] timestamp = order.getTimestamp().toLocalDateTime().toString().split("T");
				String dateTime = String.format("%s &nbsp;&nbsp; %s", timestamp[0], timestamp[1]);
				String type = order.getType().toString().toLowerCase();
				OrderItemBean[] orderItems = order.getOrderItems();
%>				<h3> Order( ID = <%=id%>, <%=dateTime%> ) </h3>
				<div>
					<input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=id%>">
					<table>
<%						for (OrderItemBean oItem: orderItems) {
							MenuItemBean menuItem = oItem.getMenuItem();
							if (menuItem.getItemCategory() == stationCategory && oItem.getStatus() == OrderItemStatus.NOT_READY) {
%>								<tr>
									<td> <%= oItem.getQuantity() %> </td>
									<td> <%= oItem.getMenuItem().getName()%></td>
									<td> <input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItem.getId()%>"> </td>
								</tr>
<%							}
						}
%>					</table>
				</div> 
<%			}
%>			</div>
	 	</div>
		
		<script>
			var currentStation = "<%=stationCategory.name()%>";
			var orders = <%=jsonOrderList%> ;
			var ajaxUpdateURL = "<%=ajaxUpdateURL%>";
			var ajaxFetchURL = "<%=ajaxFetchURL%>";	
		</script>
<%	}
%>
</main>
</body>
</html>