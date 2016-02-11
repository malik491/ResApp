<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="edu.depaul.se491.utils.ParamLengths"%>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import="edu.depaul.se491.enums.MenuItemCategory" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns, edu.depaul.se491.utils.ParamValues" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Create Menu Item</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">

	<h1> Create Menu Item </h1>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>
<% 

	// get msg (set by servlet)
	String jspMsg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);

	if (jspMsg != null) {
%>		<h3> <%= jspMsg %>	</h3>				
<%	}
	
	MenuItemCategory[] categories = MenuItemCategory.values();
	String  name = ParamPatterns.MenuItem.NAME;
	int descriptionMax = ParamLengths.MenuItem.MAX_DESC;
	
	double priceMin = ParamValues.MenuItem.MIN_PRICE;
	double priceMax = ParamValues.MenuItem.MAX_PRICE;
%>
	<form id="addForm" action="${pageContext.request.contextPath}/menuItem/create" method="post">
		<h3>Menu Item </h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th></tr> </thead>
			<tbody>
				<tr> <td> Item Name </td> 
					 <td> <input type="text" name="<%=ParamLabels.MenuItem.NAME%>" pattern="<%=name%>" 
					 		title="length <%=ParamLengths.MenuItem.MIN_NAME%>-<%=ParamLengths.MenuItem.MAX_NAME%>" required="required">
					 </td>
				</tr>
				<tr> <td> Description </td> 
					 <td>
						<textarea form="addForm" name="<%=ParamLabels.MenuItem.DESC%>"
							rows="10" cols="50" maxLength="<%=ParamLengths.MenuItem.MAX_DESC%>" required="required"></textarea> 
					 </td>
				</tr>
				<tr> <td> Unit Price ($<%=priceMin%> - $<%=priceMax%>)</td> 
					 <td> &#36;<input type="number" min="<%=priceMin%>" max="<%=priceMax%>" step="any" name="<%=ParamLabels.MenuItem.PRICE%>" 
					 		value="0" required="required">
					 </td>
				</tr>
				<tr> <td> Item Category </td> 
					 <td><select form="addForm" name="<%=ParamLabels.MenuItem.ITEM_CATEGORY%>" required="required">
<%						 	for(MenuItemCategory category: categories) {
%>								<option value="<%=category.name() %>" ><%=category.name().toLowerCase()%> </option>
<%							}
%>						 </select>
					</td>
				</tr>	
			</tbody>
		</table>
		<input type="submit" value="Create Menu Item">
	</form>
	</div>
</body>
</html>