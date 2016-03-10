<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Login page</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>

<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<section>
		<h3>Log in</h3>
<%
		String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
		if (message != null) {
%>			<div class="message"> <%= message %> </div>
<%		}
		String submissionURL = response.encodeURL(getServletContext().getContextPath() + "/login");
%>		
		<div class="form">
		<form action="<%=submissionURL%>" method="POST">
			<label> Username:</label> <input type="text" name="<%=ParamLabels.Credentials.USERNAME%>" pattern="<%=ParamPatterns.Credentials.USERNAME%>" title="account username" required>
			<br>
			<label> Password:</label> <input type="password" name="<%=ParamLabels.Credentials.PASSWORD%>" pattern="<%=ParamPatterns.Credentials.PASSWORD%>" title="account password" required>
			<br>
			<input type="submit" value="Log in">
		</form>
		</div>	
	</section>
</main>
<body>

</body>
</html>