<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="edu.depaul.se491.beans.AccountBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole,edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns,edu.depaul.se491.utils.ParamLengths" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Create Account</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
	</head>

<body>
<jsp:include page="/nav.jsp"></jsp:include>

<main class="main"> 
	<h3> Create Account </h3>
<% 
	String jspMsg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	if (jspMsg != null) {
%>		<div class="message"> <%= jspMsg %>	</div>				
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
	
	String submissionUrl = response.encodeURL(getServletContext().getContextPath() + "/account/create");
%>

	<form class="form" id="createForm" action="<%=submissionUrl%>" method="POST">
		<h3>Account Information </h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> Username </td> <td> <input type="text" name="<%=ParamLabels.Credentials.USERNAME%>" pattern="<%=username%>" title="account username" required="required" /> </td> </tr>
				<tr> <td> Password </td> <td> <input type="text" name="<%=ParamLabels.Credentials.PASSWORD%>" pattern="<%=password%>" title="account password" required="required" /> </td> </tr>
				<tr> <td> Role </td> <td> <%=AccountRole.EMPLOYEE.name().toLowerCase()%></td></tr>
			</tbody> 
		</table>

		<h3>User Information </h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> First name </td> <td> <input type="text" name="<%=ParamLabels.User.F_NAME%>" pattern="<%=fName%>" title="first name" required="required" /> </td> </tr>
				<tr> <td> Last name </td> <td> <input type="text" name="<%=ParamLabels.User.L_NAME%>" pattern="<%=lName%>" title="last name" required="required" /> </td> </tr>
				<tr> <td> Email </td> <td> <input type="text" name="<%=ParamLabels.User.EMAIL%>" pattern="<%=email%>" title="email" required="required" /> </td> </tr>
				<tr> <td> Phone (10 digits number) </td> <td> <input type="text" name="<%=ParamLabels.User.PHONE%>" pattern="<%=phone%>" title="phone" required="required" /> </td> </tr>
			</tbody>
		</table>
		
		<h3>User Address Information </h3>
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> Line 1 </td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_1%>" pattern="<%=line1%>" title="street address" required="required"> </td> </tr>
				<tr> <td> Line 2 (optional) </td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_2%>" maxLength="<%=ParamLengths.Address.MAX_LINE2%>"> </td> </tr>
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
</main>

</body>
</html>