<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="edu.depaul.se491.utils.ParamLengths"%>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns,edu.depaul.se491.utils.ParamValues" %>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import=" edu.depaul.se491.enums.MenuItemCategory" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Update Menu Item</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3> Update Menu Item </h3>
<%
	String msg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	MenuItemBean menuItem = (MenuItemBean) request.getAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN);
	
	if (msg != null) {
%>		<div class="message"><%= msg %></div> 
<%	}
	
	if (menuItem != null) {
		long id = menuItem.getId();
		String name = menuItem.getName();
		String description = menuItem.getDescription().trim();
		String price = String.format("%.2f", menuItem.getPrice()); //&#36; html for $
		
		MenuItemCategory mItemCatInput = menuItem.getItemCategory();
		MenuItemCategory[] mItemCats = MenuItemCategory.values();				
				
		String namePattern = ParamPatterns.MenuItem.NAME;
		int descriptionMax = ParamLengths.MenuItem.MAX_DESC;
		
		double priceMin = ParamValues.MenuItem.MIN_PRICE;
		double priceMax = ParamValues.MenuItem.MAX_PRICE;
		
		String submissionUrl = response.encodeURL(getServletContext().getContextPath() + "/menuItem/update");
%>
		<h3>Menu Item Information</h3>
		
		<form class="form" id="updateForm" action="<%= submissionUrl %>" method="POST">
		<input type="hidden" name="<%=ParamLabels.MenuItem.ID%>" value="<%= id %>">
		
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> ID </td> <td> <%=id%></td></tr>
				<tr> <td> Item Name </td> 
					<td> <input type="text" name="<%=ParamLabels.MenuItem.NAME%>" value="<%=name%>" pattern="<%=namePattern%>" 
							title="length <%=ParamLengths.MenuItem.MIN_NAME%>-<%=ParamLengths.MenuItem.MAX_NAME%>" required="required"> 
					</td>
				</tr>
				<tr> <td> Description </td> 
					 <td> 
					 	<textarea name="<%=ParamLabels.MenuItem.DESC%>" form="updateForm"
					 		rows="10" cols="50" maxLength="<%=descriptionMax%>" required="required"><%=description%></textarea> 
					 </td>
				</tr>
				<tr> <td> Unit Price (&#36;<%=priceMin%> - &#36;<%=priceMax%>)</td> 
					 <td> 
					 	&#36;<input type="number" min="<%=priceMin%>" max="<%=priceMax%>" step="any" name="<%=ParamLabels.MenuItem.PRICE%>" 
					 	value="<%=price%>" required="required">
					 </td>
				</tr>
				<tr> <td> Item Category </td>
					<td><select form="updateForm" name="<%=ParamLabels.MenuItem.ITEM_CATEGORY%>" required="required">
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
		
		<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/manage") %>"> Manage Menu Items </a>
<%	}	
%>
</main>
</body>
</html>