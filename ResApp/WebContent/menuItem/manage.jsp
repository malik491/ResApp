<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import="edu.depaul.se491.enums.MenuItemCategory" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Manage Menu Items</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3> Manage Menu Items</h3>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	MenuItemBean[] visibleMenuItems = (MenuItemBean[]) request.getAttribute(ParamLabels.MenuItem.VISIBLE_MENU_ITEM_BEAN_LIST);
	MenuItemBean[] hiddenMenuItems = (MenuItemBean[]) request.getAttribute(ParamLabels.MenuItem.HIDDEN_MENU_ITEM_BEAN_LIST);
	
	if (message != null) {
%>		<div class="message"> <%= message %> </div>	
<%	} else if (visibleMenuItems != null && hiddenMenuItems != null) {
		if (visibleMenuItems.length == 0  && hiddenMenuItems.length == 0 ) {
%>			<div class="message"> No Menu Items to Manage (empty menu) </div>
<%		} 
		
		if (visibleMenuItems.length > 0){
%>
		<h4>Visible Menu Items</h4>
		<table>
			<thead><tr><th> Item ID </th><th> Name </th> <th> View </th><th> Update </th><th> Hide Item </th></tr></thead>
			<tbody>	
<%			for (MenuItemBean mItem: visibleMenuItems) {
				long menuItemId = mItem.getId();
				String name = mItem.getName();
%>				<!--  print row for this menu item -->
				<tr>
					<td><%=menuItemId%></td>
					<td><%=name%></td>	
					<td>
						<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/view") %>" method="POST">
						<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItemId%>">
						<input type="image" src="${pageContext.request.contextPath}/icons/ic_pageview_black_24px.svg" alt="view">
						</form>
					</td>
					<td>
						<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/update") %>" method="POST">
						<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItemId%>">
						<input type="image" src="${pageContext.request.contextPath}/icons/ic_update_black_24px.svg" alt="update">
						</form>
					</td>
					<td>
						<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/updateHideStatus") %>" method="POST">
						<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItemId%>">
						<input type="hidden" name="<%=ParamLabels.MenuItem.IS_HIDDEN%>" value="true">
						<input type="image" src="${pageContext.request.contextPath}/icons/ic_visibility_off_black_24px.svg" alt="hide">
						</form>
					</td>
				</tr>
<% 			}
%>			</tbody>
		</table>
<%		}
		// list hidden menu items
		if (hiddenMenuItems.length > 0) {
%>			
		<h4>Hidden Menu Items</h4>
		<table>
			<thead><tr><th> Item ID </th><th> Name </th> <th> View </th><th> Un-hide item </th></tr></thead>
			<tbody>	
<%			for (MenuItemBean mItem: hiddenMenuItems) {
				long menuItemId = mItem.getId();
				String name = mItem.getName();
%>				<!--  print row for this menu item -->
				<tr>
					<td><%=menuItemId%></td>
					<td><%=name%></td>	
					<td>
						<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/view") %>" method="POST">
						<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItemId%>">
						<input type="image" src="${pageContext.request.contextPath}/icons/ic_pageview_black_24px.svg" alt="view">
						</form>
					</td>
					<td>
						<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/updateHideStatus") %>" method="POST">
						<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItemId%>">
						<input type="hidden" name="<%=ParamLabels.MenuItem.IS_HIDDEN%>" value="FALSE">
						<input type="image" src="${pageContext.request.contextPath}/icons/ic_visibility_black_24px.svg" alt="unhide">
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