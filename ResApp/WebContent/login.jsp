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
		
		<div>
		<h3> Account data for testing </h3>
		<table> 
			<thead> <tr> <th> Account Username </th> <th> Account Password </th> </tr> </thead>
			<tbody>
				<tr> <td> manager </td> <td> password </td> </tr>
				<tr> <td> employee1 </td> <td> password </td> </tr>
			</tbody>
		</table>
		</div>		
	</section>
</main>
<body>

</body>
</html>