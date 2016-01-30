<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import="edu.depaul.se491.enums.MenuItemCategory" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Manage Menu Items</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">

	<h3>Manage Menu Items</h3>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home </a> <br> <br>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	MenuItemBean[] menuItems = (MenuItemBean[]) request.getAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN_LIST);
	
	if (message != null) {
%>		
		<h3> <%= message %> </h3>	
<%	
	} else if (menuItems != null) {
		if (menuItems.length == 0) {
%>		
			<h3> There Are No Menu Items You Can Manage </h3>
<%		
		} else {
%>
		<table>
			<thead><tr><th> Item ID </th><th> Name </th> <th> View </th><th> Update </th><th> Delete </th></tr></thead>
			<tbody>	
<%			for (MenuItemBean mItem: menuItems) {
				long menuItemId = mItem.getId();
				String name = mItem.getName();
%>				<!--  print row for this menu item -->
				<tr>
					<td><%=menuItemId%></td>
					<td><%=name%></td>	
					<td>
						<form action="${pageContext.request.contextPath}/menuItem/view" method="POST">
						<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItemId%>">
						<input type="submit" value="View">
						</form>
					</td>
					<td>
						<form action="${pageContext.request.contextPath}/menuItem/update" method="POST">
						<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItemId%>">
						<input type="submit" value="Update">
						</form>
					</td>
					<td>
						<form action="${pageContext.request.contextPath}/menuItem/delete" method="POST">
						<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%=menuItemId%>">
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