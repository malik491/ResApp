<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.AccountBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole" %>
<%@page import="edu.depaul.se491.utils.ParamLabels"%>
<%
	AccountRole loggedInRole = null;
	// session not thread safe
	synchronized (session) {
		AccountBean loggedInAccount = (AccountBean) session.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
		if (loggedInAccount != null)
			loggedInRole = loggedInAccount.getRole();
	}
	
	if (loggedInRole == null) {
		String loginUrl = getServletContext().getContextPath() + "/login.jsp";
		response.sendRedirect(loginUrl);
	} else {
%>			
<!DOCTYPE html>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Home</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">
<%
		if (loggedInRole == AccountRole.MANAGER) {
%>
			<ul>
				<li><a href="${pageContext.request.contextPath}/account/manage"> Manage Accounts </a></li>	
				<li><a href="${pageContext.request.contextPath}/account/create"> Create Accounts </a></li>
				<li> </li>	
				<li><a href="${pageContext.request.contextPath}/menuItem/manage"> Manage Menu Items </a></li>
				<li><a href="${pageContext.request.contextPath}/menuItem/create"> Create Menu Items </a></li>
				<li> </li>	
				<li><a href="${pageContext.request.contextPath}/order/manage"> Manage Orders </a></li>
				<li><a href="${pageContext.request.contextPath}/order/create"> Create Order </a></li>
				<li> </li>	
				<li><a href="${pageContext.request.contextPath}/account/view"> View Your Account </a></li>
				<li><a href="${pageContext.request.contextPath}/account/update"> Update Your Account </a></li>

			</ul>
							
<%		} else if (loggedInRole == AccountRole.EMPLOYEE) {
%>
			<ul>
				<li><a href="${pageContext.request.contextPath}/account/view"> View Account </a></li>	
				<li><a href="${pageContext.request.contextPath}/account/update"> Update Account </a></li>	
			</ul>	
	
<%		} else {
			// not used
		}
%>
		
	<a href="${pageContext.request.contextPath}/logoff"> Log Off </a>	
	</div>
</body>
</html>			

<%	}
%>
