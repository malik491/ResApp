<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.AccountBean,edu.depaul.se491.beans.CredentialsBean,edu.depaul.se491.beans.UserBean,edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>View Account</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3> Account </h3>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	AccountBean account = (AccountBean) request.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
	AccountRole loggedInRole = (AccountRole) request.getAttribute(ParamLabels.Account.ROLE);
	
	if (message != null) {
%>		<div class="message"> <%= message %></div>		
<%	} else  if (account != null && loggedInRole != null){
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
		
<%		if (loggedInRole == AccountRole.MANAGER) {
%>			<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/account/manage") %>"> Manage Accounts </a>
<%		}
%>
<%	} 
%>	
</main>
</body>
</html>