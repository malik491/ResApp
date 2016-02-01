<%@page import="edu.depaul.se491.utils.ParamLengths"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.AccountBean,edu.depaul.se491.beans.CredentialsBean,edu.depaul.se491.beans.UserBean,edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns,edu.depaul.se491.utils.ParamValues" %>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import=" edu.depaul.se491.enums.MenuItemCategory" %>



<%
int MIN = 1;
int MAX = 300;
%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Update Menu Item</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>

	<div class="component">
	<h1> Update Menu Item </h1>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>
<%
	String msg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	MenuItemBean menuItem = (MenuItemBean) request.getAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN);
	
		if (msg != null) {
%>	 		<h3><%= msg %></h3> 
<%		}
		
		Long id = menuItem.getId();
		String name = menuItem.getName();
		String description = menuItem.getDescription();
		String price = String.format("%.2f", menuItem.getPrice()); //&#36; html for $
		
		MenuItemCategory mItemCatInput = menuItem.getItemCategory();
		MenuItemCategory[] mItemCats = MenuItemCategory.values();				
				
		int nameLenMax = ParamLengths.MenuItem.MAX_NAME;
		int descLenMax = ParamLengths.MenuItem.MAX_DESC;
		double priceMax = ParamValues.MenuItem.MAX_PRICE;
%>
		<form id="updateForm" action="${pageContext.request.contextPath}/menuItem/update" method="POST">
		<table>
			<thead> <tr> <th> Menu Item </th> <th> <input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%= id %>"> </th> </tr> </thead>
			<tbody>
				<tr> <td> ID </td> <td> <%=id%></td></tr>
				<tr> <td> Item Name </td> <td> <input type="text" name="<%=ParamLabels.MenuItem.NAME%>" value="<%= name %>" maxlength="<%=nameLenMax%>" required> </td></tr>
				<tr> <td> Description </td> <td><textarea name="<%=ParamLabels.MenuItem.DESC%>" form="updateForm" maxlength="<%=descLenMax%>" required> <%= description %> </textarea> </td></tr>
				<tr> <td> Unit Price ($0.0 - $1000.00)</td> <td> &#36;<input type="number" min="0" max="<%=priceMax%>" step="0.50" name="<%=ParamLabels.MenuItem.PRICE%>" value="<%= price %>" required> </td></tr>
				<tr>
						<td><select form="updateForm" name="<%=ParamLabels.MenuItem.ITEM_CATEGORY%>" required>
<%						for(MenuItemCategory mItemCat: mItemCats) {
%>							<option value="<%=mItemCat.name()%>" <%if (mItemCat == mItemCatInput){%> selected="selected" <%}%>> <%=mItemCat.name()%> </option>
<%						}
%>					</select></td>	
				</tr>
				
								
			</tbody>
		</table>
		
		<input type="submit" value="Update Menu Item">
		</form>
<%	
%>
	</div>

</body>
</html>