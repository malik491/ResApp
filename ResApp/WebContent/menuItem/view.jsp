<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@ page import="edu.depaul.se491.beans.AccountBean,edu.depaul.se491.beans.CredentialsBean,edu.depaul.se491.beans.UserBean,edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>View Menu Item</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">
	<h3> MenuItem Information </h3>
	
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>

<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	MenuItemBean menuItem = (MenuItemBean) request.getAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN);
	
	if (message != null) {
%>		
		<h3> <%= message %> </h3>	
<%	
	} else if (menuItem != null) {
		
		Long id = menuItem.getId();
		String name = menuItem.getName();
		String description = menuItem.getDescription();
		String price = String.format("&#36;%.2f", menuItem.getPrice()); //&#36; html for $
		String category = menuItem.getItemCategory().name().toLowerCase();
%>

		<table>
			<thead> <tr> <th> Menu Item Information </th> <th> </th> </tr> </thead>
			<tbody>
				<tr> <td> Item ID </td> <td> <%=id%></td></tr>
				<tr> <td> Item Name </td> <td> <%=name %> </td></tr>
				<tr> <td> Description </td> <td> <%=description %> </td></tr>
				<tr> <td> Unit Price</td> <td> <%=price%> </td></tr>
				<tr> <td> Category </td> <td> <%=category%> </td></tr>
			</tbody>
		</table>
<%		}	
%>	
	</div>
</body>
</html>