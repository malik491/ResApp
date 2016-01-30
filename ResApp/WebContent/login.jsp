<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns" %>

<!DOCTYPE html>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login page</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">
	
	<h3>Log in</h3>
	<br>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	if (message != null) {
%>		<h3> <%= message %> </h3>
<%	}
%>	
	
	<form action="${pageContext.request.contextPath}/login" method="POST">
		<label> Username:</label> <input type="text" name="<%=ParamLabels.Credentials.USERNAME%>" pattern="<%=ParamPatterns.Credentials.USERNAME%>" title="account username" required>
		<br>
		<label> Password:</label> <input type="password" name="<%=ParamLabels.Credentials.PASSWORD%>" pattern="<%=ParamPatterns.Credentials.PASSWORD%>" title="account password" required>
		<br>
		<input type="submit" value="Log in">
	</form>
	
	<br><br>
	<h3> Account data for testing </h3>
	<table> 
		<thead> <tr> <th> Account Username </th> <th> Account Password </th> </tr> </thead>
		<tbody>
			<tr> <td> manager </td> <td> password </td> </tr>
			<tr> <td> employee </td> <td> password </td> </tr>
		</tbody>
	</table>
	</div>
<body>

</body>
</html>