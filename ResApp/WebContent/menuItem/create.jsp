<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="edu.depaul.se491.utils.ParamLengths"%>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import="edu.depaul.se491.enums.MenuItemCategory" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns, edu.depaul.se491.utils.ParamValues" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Create Menu Item</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3> Create Menu Item </h3>
<% 
	String jspMsg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	if (jspMsg != null) {
%>		<div class="message"> <%= jspMsg %>	</div>				
<%	}
	
	MenuItemCategory[] categories = MenuItemCategory.values();
	String  name = ParamPatterns.MenuItem.NAME;
	int descriptionMax = ParamLengths.MenuItem.MAX_DESC;
	
	double priceMin = ParamValues.MenuItem.MIN_PRICE;
	double priceMax = ParamValues.MenuItem.MAX_PRICE;
	String submissionUrl = response.encodeURL(getServletContext().getContextPath() + "/menuItem/create");
%>
	<form class="form" id="addForm" action="<%= submissionUrl %>" method="post">
		<h3> Menu Item Information </h3>
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
</main>
</body>
</html>