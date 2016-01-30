<%@page import="edu.depaul.se491.utils.ParamLengths"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.AccountBean,edu.depaul.se491.beans.CredentialsBean,edu.depaul.se491.beans.UserBean,edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Update Account</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>

<body>
	<div class="component">
	<h3> Update Account </h3>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>
<% 

	// get msg (set by servlet)
	String jspMsg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	AccountBean account = (AccountBean) request.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
	
	if (jspMsg != null) {
%>
		<h3> <%= jspMsg %>	</h3>	
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
	
	if (account != null){
		AccountRole role = account.getRole();
		CredentialsBean credentials = account.getCredentials();
		UserBean user = account.getUser();
		AddressBean address = user.getAddress();
%>
	<form id="updateForm" action="${pageContext.request.contextPath}/account/update" method="POST">
		<table>
			<thead> <tr> <th> Account Information </th> <th> </th> </tr> </thead>
			<tbody>
				<tr> <td>  </td> <td> </td> </tr>
				<tr> <td> Username </td> <td> <%=credentials.getUsername()%> </td> </tr>
				<tr> <td> Password </td> <td> <input type="text" name="<%=ParamLabels.Credentials.PASSWORD%>" value="<%=credentials.getPassword()%>" pattern="<%=password%>" title="account password" required> </td> </tr>
				<tr> <td> Role </td> <td> <%= role.name().toLowerCase()%></td> </tr>
				
				<tr> <td> User Information :</td>  <td> </td> </tr>
				<tr> <td> First name </td> <td> <input type="text" name="<%=ParamLabels.User.F_NAME%>" value="<%=user.getFirstName()%>" pattern="<%=fName%>" title="first name" required> </td> </tr>
				<tr> <td> Last name </td> <td> 	<input type="text" name="<%=ParamLabels.User.L_NAME%>" value="<%=user.getLastName()%>" 	pattern="<%=lName%>" title="last name" required> </td> </tr>
				<tr> <td> Email </td> <td> 		<input type="text" name="<%=ParamLabels.User.EMAIL%>"  value="<%=user.getEmail()%>" 	pattern="<%=email%>" title="email" required> </td> </tr>
				<tr> <td> Phone </td> <td> 		<input type="text" name="<%=ParamLabels.User.PHONE%>"  value="<%=user.getPhone()%>" 	pattern="<%=phone%>" title="phone" required> </td> </tr>
			
				<tr> <td> Address Information : </td>  <td> </td> </tr>			
				
				<tr> <td> Line 1 </td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_1%>" value="<%=address.getLine1()%>" 	pattern="<%=line1%>" title="street address" required> </td> </tr>
				<tr> <td> Line 2 </td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_2%>" value="<%=address.getLine2()%>" 	maxLength="<%=ParamLengths.Address.MAX_LINE2%>"> </td> </tr>
				<tr> <td> City </td> <td> 	<input type="text" name="<%=ParamLabels.Address.CITY%>"   value="<%=address.getCity()%>"	pattern="<%=city%>" title="city" required> </td> </tr>
				<tr> <td> State </td> 
					 <td><select form="updateForm" name="<%=ParamLabels.Address.STATE%>" required>
<%						for(AddressState state: states) {
%>							<option value="<%=state.name()%>" <%if (state == address.getState()){%> selected="selected" <%}%>> <%=state.name()%> </option>
<%						}
%>					</select></td>				
				</tr>					
				<tr> <td> Zipcode </td> <td> <input type="text" name="<%=ParamLabels.Address.ZIP_CODE%>" value="<%=address.getZipcode()%>"	pattern="<%=zipcode%>" title="zipcode" required> </td> </tr>
				<tr> <td> </td> <td> <input type="submit" value ="Update Account"> </td>
				
				<tr> <td> </td> <td> <input type="hidden" name="<%=ParamLabels.Credentials.USERNAME%>" value="<%=credentials.getUsername()%>"> </td> </tr>
				<tr> <td> </td> <td> <input type="hidden" name="<%=ParamLabels.Account.ROLE%>" value="<%=role.name()%>"> </td> </tr>
				<tr> <td> </td> <td> <input type="hidden" name="<%=ParamLabels.User.ID%>" value="<%=user.getId()%>"> </td> </tr>	
				<tr> <td> </td> <td> <input type="hidden" name="<%=ParamLabels.Address.ID%>" value="<%=address.getId()%>"> </td> </tr>	
			</tbody>
		</table>
	</form>
	
<%	}
%>
	</div>
</body>
</html>