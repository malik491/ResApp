<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.AccountBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Manage Accounts</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main">
	<h3>Manage Accounts</h3>
<%
	String message = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	AccountBean[] accounts = (AccountBean[]) request.getAttribute(ParamLabels.Account.ACCOUNT_BEAN_LIST);
	
	if (message != null) {
%>		
		<div class="message"> <%= message %> </div>	
<%	
	} else if (accounts != null) {
		int count = 0;
		for (AccountBean account : accounts) {
			if (account.getRole() != AccountRole.CUSTOMER_APP)
				count++;
		}
		
		if (count == 0) {
%>		
			<div class="message"> There Are No Accounts to Manage </div>
<%		
		} else {
%>
		<table>
			<thead> <tr> <th> Account Username </th> <th> Account Role </th> <th> View </th><th> Update </th><th> Delete </th> </tr></thead>
			<tbody>
<%			for(AccountBean account: accounts){
				if (account.getRole() != AccountRole.CUSTOMER_APP) {
					String username = account.getCredentials().getUsername();
					String role = account.getRole().name().toLowerCase();
%>	
					<tr>
						<td><%=username%></td>
						<td><%=role%></td>	
						<td>
							<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/account/view") %>" method="POST">
							<input type="hidden" name="<%=ParamLabels.Credentials.USERNAME%>" value="<%=username%>">
							<input type="image" src="${pageContext.request.contextPath}/icons/ic_pageview_black_24px.svg" alt="view">
							</form>
						</td>
						<td>
							<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/account/update") %>" method="POST">
							<input type="hidden" name="<%=ParamLabels.Credentials.USERNAME%>" value="<%=username%>">
							<input type="image" src="${pageContext.request.contextPath}/icons/ic_update_black_24px.svg" alt="update">
							</form>
						</td>
						<td>
							<form action="<%= response.encodeURL(getServletContext().getContextPath() + "/account/delete") %>" method="POST">
							<input type="hidden" name="<%=ParamLabels.Credentials.USERNAME%>" value="<%=username%>">
							<input type="image" src="${pageContext.request.contextPath}/icons/ic_delete_black_24px.svg" alt="delete">
							</form>
						</td>								
					</tr>
<%				}
			}
%>		</tbody>
		</table>					
<%		}
	}
%>
</main>
</body>
</html>