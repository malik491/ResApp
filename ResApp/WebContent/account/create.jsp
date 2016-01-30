<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="edu.depaul.se491.beans.AccountBean" %>
<%@ page import="edu.depaul.se491.enums.AccountRole" %>
<%@ page import="edu.depaul.se491.enums.AddressState" %>
<%@ page import="edu.depaul.se491.utils.ParamLengths" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Menu Item </title>
</head>
<body>
<% 

	// get msg (set by servlet)
	String jspMsg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);

	if (jspMsg != null) {
		// show it
%>		<h3> <%= jspMsg %>	</h3>				<%		
	}
	
	// lengths (min max) for the form
	int usernameMax = ParamLengths.Account.MAX_USERNAME;

	int passwordMax = ParamLengths.Account.MAX_PASSWORD;

	int userFnMax = ParamLengths.User.MAX_F_NAME;
	
	int userLnnMax = ParamLengths.User.MAX_L_NAME;
	
	int userEmailMax = ParamLengths.User.MAX_EMAIL;
	
	int userPhoneMax = ParamLengths.User.MAX_PHONE;
	
	int addrLine1Max = ParamLengths.Address.MAX_LINE1;
	
	int addrLine2Max = ParamLengths.Address.MAX_LINE2;

	int addrCityMax = ParamLengths.Address.MAX_CITY;
	
	int addrZipcodeMax = ParamLengths.Address.MAX_ZIPCODE;
	
	// role and state
	AccountRole[] roles = new AccountRole[] {AccountRole.EMPLOYEE, AccountRole.VENDOR};
	AddressState[] states = AddressState.values();
	
%>
	<form id="createForm" action="${pageContext.request.contextPath}/account/create" method="POST">
		<table>
			<thead> <tr> <th> Field </th> <th> Value </th> </tr> </thead>
			<tbody>
				<tr> <td> Account </td> <td> </td> </tr>
				<tr> <td> Username </td> <td> <input type="text" name="<%ParamLabels.Credentials.USERNAME%>" value="" maxlength="<%=usernameMax%>" required> </td> </tr>
				<tr> <td> Password </td> <td> <input type="text" name="<%ParamLabels.Credentials.PASSWORD%>" value="" maxlength="<%=passwordMax%>" required> </td></tr>
				<tr> <td> Role </td> 
					<td><select name="<%=ParamLabels.Account.ROLE%>" form="createForm" required>
<%						for (AccountRole role: roles) {%>
							<option value="<%=role.name()%>"> <%=role.toString().toLowerCase()%></option>
<%						}
%>					</select></td>
				</tr>
				
				<tr> <td> User Information </td> <td> </td> </tr>
				<tr> <td> First Name </td> <td> <input type="text" name="<%=ParamLabels.User.F_NAME%>" value="" maxlength="<%=userFnMax%>" required> </td></tr>
				<tr> <td> Last Name  </td> <td> <input type="text" name="<%=ParamLabels.User.L_NAME%>" value="" maxlength="<%=userLnMax%>" required> </td></tr>
				<tr> <td> Email	</td> <td> <input type="text" name="<%=ParamLabels.User.EMAIL%>" value="" maxlength="<%=userEmailMax%>" required> </td></tr>
				<tr> <td> Phone </td> <td> <input type="text" name="<%=ParamLabels.User.PHONE%>" value="" maxlength="<%= userPhoneMax%>" required> </td></tr>
				
				<tr> <td> Address Information </td> <td> </td> </tr>
				<tr> <td> Address 1	</td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_1%>" value="" maxlength="<%= addrLine1Max%>" required> </td> </tr>
				<tr> <td> Address 2 (optional)	</td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_2%>" value="" maxlength="<%=addrLine2Max%>"> </td> </tr>
				<tr> <td> City	</td> <td> <input type="text" name="<%=ParamLabels.Address.CITY%>" value="" maxlength="<%=addrCityMax%>" required> </td> </tr>
				<tr> <td> State	</td> 
					 <td> <select name="<%=ParamLabels.Address.STATE%>" form="createForm" required>
<% 						for(AddressState s: states) {
%>						 	<option value="<%=s.name()%>"> <%=s.name()%></option>
<%						}
%>						</select>
					</td>
 				</tr>
 				<tr> <td> Zipcode </td> <td> <input type="text" name="<%=ParamLabels.Address.ZIP_CODE%>" value="" maxlength="<%=addrZipcodeMax%>" required> </td> </tr>
			</tbody>
		</table>
		<input type="submit" value="Create Account">
	</form>
</body>
</html>