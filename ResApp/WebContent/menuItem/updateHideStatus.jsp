<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.AccountBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Delete Menu Item</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3> Update Menu Item </h3>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	if (message != null) {
%>		<div class="message"> <%= message %> </div>
<%	}
	
	AccountBean loggedInUser = (AccountBean) session.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
	if (loggedInUser != null && loggedInUser.getRole() == AccountRole.MANAGER) {
%>		<div style="margin-top:2%;"> 
			<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/menuItem/manage") %>"> Manage Menu Items </a>
		</div>
<%	}
%>
</main>
</body>
</html>