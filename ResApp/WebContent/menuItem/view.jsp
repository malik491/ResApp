<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.AccountBean,edu.depaul.se491.beans.CredentialsBean,edu.depaul.se491.beans.UserBean,edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>View Menu Item</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3> View Menu Item </h3>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	MenuItemBean menuItem = (MenuItemBean) request.getAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN);
	
	if (message != null) {
%>		<div class="message"> <%= message %> </div>	
<%	
	} else if (menuItem != null) {
		
		Long id = menuItem.getId();
		String name = menuItem.getName();
		String description = menuItem.getDescription();
		String price = String.format("&#36;%.2f", menuItem.getPrice()); //&#36; html for $
		String category = menuItem.getItemCategory().name().toLowerCase();
%>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> Item ID </td> <td> <%=id%></td></tr>
				<tr> <td> Item Name </td> <td> <%=name %> </td></tr>
				<tr> <td> Description </td> <td> <%=description %> </td></tr>
				<tr> <td> Unit Price</td> <td> <%=price%> </td></tr>
				<tr> <td> Category </td> <td> <%=category%> </td></tr>
			</tbody>
		</table>
		
		<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/manage") %>"> Manage Menu Items </a>
<%		}	
%>
</main>
</body>
</html>