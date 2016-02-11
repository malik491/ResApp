<%@page import="edu.depaul.se491.utils.ParamLengths"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.AccountBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Create Account</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>

<body>
	<div class="component">
	<h3> Create Account </h3>
	<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>
<% 

	// get msg (set by servlet)
	String jspMsg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);

	if (jspMsg != null) {
%>		<h3> <%= jspMsg %>	</h3>				
<%	}

	String username = ParamPatterns.Credentials.USERNAME;
	String password = ParamPatterns.Credentials.PASSWORD;
	
	String fName = ParamPatterns.User.F_NAME;
	String lName = ParamPatterns.User.L_NAME;
	String email = ParamPatterns.User.EMAIL;
	String phone = ParamPatterns.User.PHONE;
	
	String line1 = ParamPatterns.Address.LINE_1;
	String city  = ParamPatterns.Address.CITY;
	String zipcode = ParamPatterns.Address.ZIPCODE;
	AddressState[] states = AddressState.values();
%>

	<form id="createForm" action="${pageContext.request.contextPath}/account/create" method="POST">
		
		<h3>Account Information </h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> Username </td> <td> <input type="text" name="<%=ParamLabels.Credentials.USERNAME%>" pattern="<%=username%>" title="account username" required="required"> </td> </tr>
				<tr> <td> Password </td> <td> <input type="text" name="<%=ParamLabels.Credentials.PASSWORD%>" pattern="<%=password%>" title="account password" required="required"> </td> </tr>
				<tr> <td> Role </td> <td> <%=AccountRole.EMPLOYEE.name().toLowerCase()%></td></tr>
			</tbody> 
		</table>

		<h3>User Information </h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> First name </td> <td> <input type="text" name="<%=ParamLabels.User.F_NAME%>" pattern="<%=fName%>" title="first name" required="required"> </td> </tr>
				<tr> <td> Last name </td> <td> <input type="text" name="<%=ParamLabels.User.L_NAME%>" pattern="<%=lName%>" title="last name" required="required"> </td> </tr>
				<tr> <td> Email </td> <td> <input type="text" name="<%=ParamLabels.User.EMAIL%>" pattern="<%=email%>" title="email" required="required"> </td> </tr>
				<tr> <td> Phone </td> <td> <input type="text" name="<%=ParamLabels.User.PHONE%>" pattern="<%=phone%>" title="phone" required="required"> </td> </tr>
			</tbody>
		</table>
		
		<h3>User Address Information </h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> Line 1 </td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_1%>" pattern="<%=line1%>" title="street address" required="required"> </td> </tr>
				<tr> <td> Line 2 </td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_2%>" maxLength="<%=ParamLengths.Address.MAX_LINE2%>"> </td> </tr>
				<tr> <td> City </td> <td> <input type="text" name="<%=ParamLabels.Address.CITY%>" pattern="<%=city%>" title="city" required="required"> </td> </tr>
				<tr> <td> State </td> 
					 <td><select form="createForm" name="<%=ParamLabels.Address.STATE%>" required="required">
<%						for(AddressState state: states) {
%>							<option value="<%=state.name()%>"> <%=state.name()%> </option>
<%						}
%>					</select></td>				
				</tr>					
				<tr> <td> Zipcode </td> <td> <input type="text" name="<%=ParamLabels.Address.ZIP_CODE%>" pattern="<%=zipcode%>" title="zipcode" required="required"> </td> </tr>
			</tbody>
		</table>
		<input type="submit" value ="Create Account">
	</form>
	
	</div>
</body>
</html>