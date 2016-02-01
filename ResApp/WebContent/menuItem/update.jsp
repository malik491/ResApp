<%@page import="edu.depaul.se491.utils.ParamLengths"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns,edu.depaul.se491.utils.ParamValues" %>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import=" edu.depaul.se491.enums.MenuItemCategory" %>

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
	<h3> Update Menu Item </h3>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>
<%
	String msg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	MenuItemBean menuItem = (MenuItemBean) request.getAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN);
	
	if (msg != null) {
%>		<h3><%= msg %></h3> 
<%	}
	
	if (menuItem != null) {
		long id = menuItem.getId();
		String name = menuItem.getName();
		String description = menuItem.getDescription();
		String price = String.format("%.2f", menuItem.getPrice()); //&#36; html for $
		
		MenuItemCategory mItemCatInput = menuItem.getItemCategory();
		MenuItemCategory[] mItemCats = MenuItemCategory.values();				
				
		String namePattern = ParamPatterns.MenuItem.NAME;
		int descriptionMax = ParamLengths.MenuItem.MAX_DESC;
		
		double priceMin = ParamValues.MenuItem.MIN_PRICE;
		double priceMax = ParamValues.MenuItem.MAX_PRICE;
%>
		<form id="updateForm" action="${pageContext.request.contextPath}/menuItem/update" method="POST">
		<table>
			<thead> <tr> <th> Menu Item </th> <th> <input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%= id %>"> </th> </tr> </thead>
			<tbody>
				<tr> <td> ID </td> <td> <%=id%></td></tr>
				<tr> <td> Item Name </td> <td> <input type="text" name="<%=ParamLabels.MenuItem.NAME%>" value="<%= name %>" pattern="<%=namePattern%>" title="menu item name" required> </td></tr>
				<tr> <td> Description </td> 
					 <td> 
					 	<textarea name="<%=ParamLabels.MenuItem.DESC%>" form="updateForm" maxLength="<%=descriptionMax%>" required> <%= description %> </textarea> 
					 </td>
				</tr>
				<tr> <td> Unit Price ($<%=priceMin%> - $<%=priceMax%>)</td> 
					 <td> 
					 	&#36;<input type="number" min="<%=priceMin%>" max="<%=priceMax%>" step="0.99" name="<%=ParamLabels.MenuItem.PRICE%>" value="<%= price %>" required> 
					 </td>
				</tr>
				<tr> <td> Item Category :</td>
					<td><select form="updateForm" name="<%=ParamLabels.MenuItem.ITEM_CATEGORY%>" required>
<%						for(MenuItemCategory mItemCat: mItemCats) {
%>							<option value="<%=mItemCat.name()%>" <%if (mItemCat == mItemCatInput){%> selected="selected" <%}%>> <%=mItemCat.name().toLowerCase()%> </option>
<%						}
%>						</select>
					</td>	
				</tr>						
			</tbody>
		</table>
			
		<input type="submit" value="Update Menu Item">
		</form>
<%	}	
%>
	</div>

</body>
</html>