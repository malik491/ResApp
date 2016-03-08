<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.AccountBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.MenuItemCategory" %>
<%@page import="edu.depaul.se491.utils.ParamLabels"%>
<%
AccountBean loggedInAccount = (AccountBean) request.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
if (loggedInAccount == null) {
	response.sendRedirect(getServletContext().getContextPath() + "/login.jsp");
} else {
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Home</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>

<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
<%	if (loggedInAccount.getRole() == AccountRole.MANAGER) {
%>
		<h3> Account </h3>
		<div>
			<a class="btn" href="<%=response.encodeURL(getServletContext().getContextPath() + "/account/manage")%>"> Manage Accounts </a>	
			<a class="btn" href="<%=response.encodeURL(getServletContext().getContextPath() + "/account/create")%>"> Create Accounts </a>
		</div>
		
		<h3> Menu </h3>
		<div>
			<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/manage")%>"> Manage Menu </a>
			<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/create")%>"> Create Menu Items </a>
		</div>
		
		<h3> Orders </h3>
		<div>
			<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/order/manage")%>"> Manage Orders </a>
			<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/order/create")%>"> Create Orders </a>
		</div>
		
<%	} else if (loggedInAccount.getRole() == AccountRole.EMPLOYEE) {
		String paramName = ParamLabels.MenuItem.ITEM_CATEGORY;
		String mainStationParam = String.format("?%s=%s", paramName, MenuItemCategory.MAIN.name());
		String bevgStationParam = String.format("?%s=%s", paramName, MenuItemCategory.BEVERAGE.name());
		String sideStationParam = String.format("?%s=%s", paramName, MenuItemCategory.SIDE.name());
%>
		<h3> Work Stations </h3>
		<div class="work-station">
			<img class="icon" alt="cash register" src="${pageContext.request.contextPath}/icons/register-24.png">
			<a href="<%=response.encodeURL(getServletContext().getContextPath() + "/terminal/pos")%>"> Point of Sale </a>
		</div>
		
		<div class="work-station">
			<img class="icon" alt="beverage sation" src="${pageContext.request.contextPath}/icons/beverage-24.png">
			<a href="<%=response.encodeURL(getServletContext().getContextPath() + "/terminal/station" + bevgStationParam)%>"> Beverage Station </a>
		</div>

		<div class="work-station">
			<img class="icon" alt="side station" src="${pageContext.request.contextPath}/icons/fries-24.png">
			<a href="<%=response.encodeURL(getServletContext().getContextPath() + "/terminal/station" + sideStationParam)%>"> Sides Station</a>
		</div>

		<div class="work-station">
			<img class="icon" alt="main station" src="${pageContext.request.contextPath}/icons/burger-24.png">
			<a href="<%=response.encodeURL(getServletContext().getContextPath() + "/terminal/station" + mainStationParam)%>"> Main Station </a>
		</div>
<%	}
%>

</main>
</body>
</html>
<%}
%>

