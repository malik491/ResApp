<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.AccountBean,edu.depaul.se491.beans.CredentialsBean,edu.depaul.se491.beans.UserBean,edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>View Account</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">
	<h3> Account </h3>
	
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>

<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	AccountBean account = (AccountBean) request.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
	
	if (message != null) {
%>		<h3> <%= message %></h3>		
<%	} else  if (account != null){
		CredentialsBean credentials = account.getCredentials();
		AccountRole role = account.getRole();
		UserBean user = account.getUser();
		AddressBean address = user.getAddress();
		
		String line2 = address.getLine2() == null? "" : address.getLine2() + "<br>";
		String formatedAddr = String.format("%s<br>%s%s, %s %s",
				address.getLine1(), line2, address.getCity(), address.getState().toString(), address.getZipcode());
%>
		<h3>Account Information</h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> Username </td> <td> <%= credentials.getUsername() %></td></tr>
				<tr> <td> Password </td> <td> <%= credentials.getPassword() %> </td></tr>
				<tr> <td> Role </td> <td> <%= role.name().toLowerCase() %> </td></tr>
			</tbody>
		</table>
		
		<h3>User Information</h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>				
				<tr> <td> First Name </td> <td> <%= user.getFirstName() %></td></tr>
				<tr> <td> Last Name </td> <td> <%= user.getLastName() %> </td></tr>
				<tr> <td> Email </td> <td> <%= user.getEmail() %> </td></tr>
				<tr> <td> Phone </td> <td> <%= user.getPhone() %> </td></tr>
				<tr> <td> Address </td> <td> <%= formatedAddr %> </td> </tr>
			</tbody>
		</table>
<%	} 
%>	
	</div>
</body>
</html>