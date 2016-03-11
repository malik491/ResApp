<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.AccountBean,edu.depaul.se491.beans.CredentialsBean,edu.depaul.se491.beans.UserBean,edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns" %>
<%@page import="edu.depaul.se491.utils.ParamLengths"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Update Account</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>
<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main"> 
	<h3> Update Account </h3>
<% 
	String jspMsg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	AccountBean account = (AccountBean) request.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
	AccountBean loggedInUser = (AccountBean) session.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
	
	if (jspMsg != null) {
%>		<div class="message"> <%= jspMsg %>	</div>	
<%	}
	
	String password = ParamPatterns.Credentials.PASSWORD;
	
	String fName = ParamPatterns.User.F_NAME;
	String lName = ParamPatterns.User.L_NAME;
	String email = ParamPatterns.User.EMAIL;
	String phone = ParamPatterns.User.PHONE;
	
	String line1 = ParamPatterns.Address.LINE_1;
	String city  = ParamPatterns.Address.CITY;
	String zipcode = ParamPatterns.Address.ZIPCODE;
	
	AddressState[] states = AddressState.values();
	
	if (account != null && loggedInUser != null){
		AccountRole role = account.getRole();
		CredentialsBean credentials = account.getCredentials();
		UserBean user = account.getUser();
		AddressBean address = user.getAddress();
		String submissionUrl = response.encodeURL(getServletContext().getContextPath() + "/account/update");
		
		boolean hideRoleOptions = loggedInUser.getRole() == role || loggedInUser.getRole() != AccountRole.ADMIN;
%>
		
		<form class="form" id="updateForm" action="<%=submissionUrl%>" method="POST">
			<input type="hidden" name="<%=ParamLabels.Credentials.USERNAME%>" value="<%=credentials.getUsername()%>">
			<input type="hidden" name="<%=ParamLabels.User.ID%>" value="<%=user.getId()%>">	
			<input type="hidden" name="<%=ParamLabels.Address.ID%>" value="<%=address.getId()%>">	
<%			if (hideRoleOptions) {
%>				<input type="hidden" name="<%=ParamLabels.Account.ROLE%>" value="<%=role.name()%>">	
<%			}
%>
			<h3>Account Information </h3>
			<table>
				<thead> <tr> <th> Filed </th> <th> Value </th> </tr> </thead>
				<tbody>
					<tr> <td>  </td> <td> </td> </tr>
					<tr> <td> Username </td> <td> <%=credentials.getUsername()%> </td> </tr>
					<tr> <td> Password </td> <td> <input type="text" name="<%=ParamLabels.Credentials.PASSWORD%>" value="<%=credentials.getPassword()%>" pattern="<%=password%>" title="length <%=ParamLengths.Credentials.MIN_PASSWORD%>-<%=ParamLengths.Credentials.MAX_PASSWORD%>" required="required"> </td> </tr>
					<tr> <td> Role </td>
<%					if (hideRoleOptions) {
%>					 	<td> <%=role.name().toLowerCase()%></td>
<%					} else {
%>						<td><select form="updateForm" name="<%=ParamLabels.Account.ROLE%>" required="required">
								<option value="<%=AccountRole.MANAGER.name()%>" <%if(role == AccountRole.MANAGER){%> selected="selected" <%} %> > <%=AccountRole.MANAGER.name().toLowerCase()%> </option>
								<option value="<%=AccountRole.EMPLOYEE.name()%>" <%if(role == AccountRole.EMPLOYEE){%> selected="selected" <%} %>> <%=AccountRole.EMPLOYEE.name().toLowerCase()%> </option>
							</select>
						</td>
<%					}
%>					</tr>
				</tbody>
			</table>					

			<h3>User Information </h3>
			<table>
				<thead> <tr> <th> Filed </th> <th> Value </th> </tr> </thead>
				<tbody>
					<tr> <td> First name </td> <td> <input type="text" name="<%=ParamLabels.User.F_NAME%>" value="<%=user.getFirstName()%>" pattern="<%=fName%>" title="length <%=ParamLengths.User.MIN_F_NAME%>-<%=ParamLengths.User.MAX_F_NAME%>" required="required"> </td> </tr>
					<tr> <td> Last name </td> <td> 	<input type="text" name="<%=ParamLabels.User.L_NAME%>" value="<%=user.getLastName()%>" 	pattern="<%=lName%>" title="length <%=ParamLengths.User.MIN_L_NAME%>-<%=ParamLengths.User.MAX_L_NAME%>" required="required"> </td> </tr>
					<tr> <td> Email </td> <td> 		<input type="text" name="<%=ParamLabels.User.EMAIL%>"  value="<%=user.getEmail()%>" 	pattern="<%=email%>" title="lengths: 1-35@1-10.2-3" required="required"> </td> </tr>
					<tr> <td> Phone </td> <td> 		<input type="text" name="<%=ParamLabels.User.PHONE%>"  value="<%=user.getPhone()%>" 	pattern="<%=phone%>" title="plain  <%=ParamLengths.User.MIN_PHONE%>-<%=ParamLengths.User.MAX_PHONE%> digits (e.g, 1234567890)" required="required"> </td> </tr>
				</tbody>
			</table>
			
			<h3>User Address Information </h3>
			<table>
				<thead> <tr> <th> Filed </th> <th> Value </th> </tr> </thead>
				<tbody>
					<tr> <td> Line 1 </td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_1%>" value="<%=address.getLine1()%>" 	pattern="<%=line1%>" title="length <%=ParamLengths.Address.MIN_LINE1%>-<%=ParamLengths.Address.MAX_LINE1%>" required="required"> </td> </tr>
					<tr> <td> Line 2 </td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_2%>" value="<%=address.getLine2()== null? "" : address.getLine2()%>" maxLength="<%=ParamLengths.Address.MAX_LINE2%>"> </td> </tr>
					<tr> <td> City </td> <td> 	<input type="text" name="<%=ParamLabels.Address.CITY%>"   value="<%=address.getCity()%>" pattern="<%=city%>" title="length <%=ParamLengths.Address.MIN_CITY%>-<%=ParamLengths.Address.MAX_CITY%>" required="required"> </td> </tr>
					<tr> <td> State </td> 
						 <td><select form="updateForm" name="<%=ParamLabels.Address.STATE%>" required="required">
<%							for(AddressState state: states) {
%>								<option value="<%=state.name()%>" <%if (state == address.getState()){%> selected="selected" <%}%>> <%=state.name()%> </option>
<%							}
%>						</select></td>				
					</tr>					
					<tr> <td> Zipcode </td> <td> <input type="text" name="<%=ParamLabels.Address.ZIP_CODE%>" value="<%=address.getZipcode()%>"	pattern="<%=zipcode%>" title="plain <%=ParamLengths.Address.MIN_ZIPCODE%>-<%=ParamLengths.Address.MAX_ZIPCODE%> digits" required="required"> </td> </tr>
				</tbody>
			</table>
			<input type="submit" value ="Update Account"> 
		</form>
<%	
		if (loggedInUser != null && (loggedInUser.getRole() == AccountRole.MANAGER ||  loggedInUser.getRole() == AccountRole.ADMIN)) {
%>			<a class="btn" href="<%= response.encodeURL(getServletContext().getContextPath() + "/account/manage") %>"> Manage Accounts </a>
<%		}
	}
%>
</main>
</body>
</html>