<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.AccountBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Manage Accounts</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">
	<h3>Manage Accounts</h3>
	<a href="${pageContext.request.contextPath}/home.jsp">Home</a> <br> <br>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	AccountBean[] accounts = (AccountBean[]) request.getAttribute(ParamLabels.Account.ACCOUNT_BEAN_LIST);
	
	if (message != null) {
%>		
		<h3> <%= message %> </h3>	
<%	
	} else if (accounts != null) {
		if (accounts.length == 0) {
%>		
			<h3> There Are No Accounts You Can Manage </h3>
<%		
		} else {
%>
		<table>
			<thead> <tr> <th> Account Username </th> <th> Account Role </th> <th> View </th><th> Update </th><th> Delete </th> </tr></thead>
			<tbody>
<%			for(AccountBean account: accounts){
				String username = account.getCredentials().getUsername();
				String role = account.getRole().name().toLowerCase();
%>	
				<tr>
					<td><%=username%></td>
					<td><%=role%></td>	
					<td>
						<form action="${pageContext.request.contextPath}/account/view" method="POST">
						<input type="hidden" name="<%=ParamLabels.Credentials.USERNAME%>" value="<%=username%>">
						<input type="submit" value="View">
						</form>
					</td>
					<td>
						<form action="${pageContext.request.contextPath}/account/update" method="POST">
						<input type="hidden" name="<%=ParamLabels.Credentials.USERNAME%>" value="<%=username%>">
						<input type="submit" value="Update" <% if (account.getCredentials().getUsername().equalsIgnoreCase("employee1")){%> disabled="disabled"<%}%>>
						</form>
					</td>
					<td>
						<form action="${pageContext.request.contextPath}/account/delete" method="POST">
						<input type="hidden" name="<%=ParamLabels.Credentials.USERNAME%>" value="<%=username%>">
						<input type="submit" value="Delete" <% if (account.getCredentials().getUsername().equalsIgnoreCase("employee1")){%> disabled="disabled"<%}%>>
						</form>
					</td>								
				</tr>
<%			}
%>		
			</tbody>
		</table>
<%		}
	}
%>
	</div>
</body>
</html>