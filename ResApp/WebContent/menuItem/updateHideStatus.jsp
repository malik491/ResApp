<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Delete Menu Item</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">
	<h3> Update Menu Item Status</h3>
	<br>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> 
	<br>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	if (message != null) {
%>		<h3> <%= message %> </h3>
<%	}
%>	
	</div>
</body>
</html>