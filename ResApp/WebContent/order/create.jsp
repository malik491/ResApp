<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.sql.Timestamp" %>
<%@page import="edu.depaul.se491.utils.ParamLengths"%>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns, edu.depaul.se491.utils.ParamValues" %>
<%@ page import="edu.depaul.se491.enums.OrderStatus,edu.depaul.se491.enums.OrderItemStatus, edu.depaul.se491.enums.OrderType,edu.depaul.se491.enums.AddressState, edu.depaul.se491.enums.PaymentType" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Create Order</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>
<body>
	<div class="component">
	<h1>Create Order </h1>
		<a href="${pageContext.request.contextPath}/home.jsp"> Home Page </a> <br> <br>
	<%
	String msg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	if (msg != null) 
	{
	%>
		<h3><%=msg%></h3> 
<% 	}
		
	List<MenuItemBean> menuItems = (List<MenuItemBean>) request.getAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN_LIST); 
	
	if (menuItems == null || (menuItems.size() == 0)) {
%>
		<h3>There are no menu items (empty menu)</h3>
<%
	} else {
		int line1LenMax = ParamLengths.Address.MAX_LINE1;
		int line2LenMax = ParamLengths.Address.MAX_LINE2;
		int cityLenMax =  ParamLengths.Address.MAX_CITY;
		int zipcodeLenMax = ParamLengths.Address.MAX_ZIPCODE;
		String addrLine1 = ParamLabels.Address.LINE_1;
		String addrLine2 = ParamLabels.Address.LINE_2;
		String addrCity = ParamLabels.Address.CITY;
		String addrState = ParamLabels.Address.STATE;
		String addrZipcode = ParamLabels.Address.ZIP_CODE;
		OrderItemStatus [] status = OrderItemStatus.values();
		String confirmParamName = ParamLabels.Order.CONFIRMATION;
		String confirm = "conf#" + Integer.toString(Long.toString(System.currentTimeMillis() + new Random().nextInt()).hashCode() );
		Timestamp time = new Timestamp(System.currentTimeMillis());
		Timestamp  timestamp = Timestamp.valueOf(time.toString());
		String quantityParamName;
		String statusParamName;
		String creditCardParamName = ParamLabels.CreditCard.CC_NUMBER;
		String ccHolderNameParamName = ParamLabels.CreditCard.CC_HOLDER_NAME;
		String ccExpMonthParamName = ParamLabels.CreditCard.CC_EXP_MONTH;
		String ccExpYearParamName = ParamLabels.CreditCard.CC_EXP_YEAR;
		String ccConfirmParamName = ParamLabels.Payment.CC_TRANSACTION_CONFIRMATION;
		String timeParamName = ParamLabels.Order.TIMESTAMP;
		String ccConfirm = "conf#" + Integer.toString(Long.toString(System.currentTimeMillis() + new Random().nextInt()).hashCode() );
		int ccNumMax = ParamLengths.CreditCard.MAX_CC_NUMBER;
		int ccNumMin = ParamLengths.CreditCard.MIN_CC_NUMBER;
		int ccHolderMax = ParamLengths.CreditCard.MAX_CC_HOLDER_NAME;
		int ccExpMthMax = ParamValues.CreditCard.MAX_CC_EXP_MONTH;
		int ccExpYrMax = ParamValues.CreditCard.MAX_CC_EXP_YEAR;
		String paymentTypeParam = ParamLabels.Payment.TYPE;
		
		%>
		
		<Form id="addForm" action="${pageContext.request.contextPath}/order/create" method="post">
		<table>
			<thead> <tr> <th> Order Data</th> <th> </th> </tr> </thead>			
			<tbody>
			<tr> <td> Status </td>
				<td> <select name="<%=ParamLabels.Order.STATUS%>" form="addForm" required>
	<% 			for(OrderStatus s: OrderStatus.values()) {
	%>			 	<option value="<%=s.toString()%>" > <%=s.toString().toLowerCase()%></option>
	<%			}
	%>			</select></td>
			</tr>
			
			<tr> <td> Type </td>
				 <td> <select name=<%=ParamLabels.Order.TYPE%> form="addForm" required>
	<% 			 for(OrderType t: OrderType.values()) {
	%>			 	<option value="<%=t.toString()%>" > <%=t.toString().toLowerCase()%></option>
	<%			}
	%>			</select></td>									
			</tr>	
			<tr> <td> Delivery Address Information </td> <td></td></tr>
			<tr> <td> Address 1	</td> <td> <input type="text" name="<%=addrLine1%>" value="" maxlength="<%=line1LenMax%>" title="Address Line 1"></td> </tr>
			<tr> <td> Address 2 (optional)	</td> <td> <input type="text" name="<%=addrLine2%>" value="" maxlength="<%=line2LenMax%>" title="Address Line 2" >	</td> </tr>
			<tr> <td> City	</td> <td>	<input type="text" name="<%=addrCity%>" value="" maxlength="<%=cityLenMax%>" title="City" > </td> </tr>
			<tr> <td> State	</td> 
				 <td> <select name="<%=addrState%>" form="addForm" required>
	<% 					for(AddressState st: AddressState.values()) {
	%>					 	<option value="<%=st.toString()%>"> <%=st.toString()%></option>
	<%					}
	%>				 </select></td> 
			</tr>
			<tr> <td> Zipcode </td> <td> <input type="text" name="<%=addrZipcode%>" value="" maxlength="<%=zipcodeLenMax%>" title="ZipCode"> </td></tr>
			</tbody>
		</table>
		
		<table>
			<tr> <td> Payment Information </td> <td></td></tr>
			<tr> 
			<td> Payment Type</td> 
			<td>
			<select name="<%=paymentTypeParam%>" form="addForm" required>
	<% 					for(PaymentType pt: PaymentType.values()) {
	%>					 	<option value="<%=pt.toString()%>"> <%=pt.toString()%></option>
	<%					}
	%>				 


			</select>
			</td>
			</tr>
			<tr> <td> Credit Card Number  </td> <td> <input type="text" name="<%=creditCardParamName%>" value=""  maxlength="<%=ccNumMax%>" title="Credit Card Number"> </td></tr> 
			<tr> <td> Credit Card Holder Name  </td> <td> <input type="text" name="<%=ccHolderNameParamName%>" value=""  maxlength="<%=ccHolderMax%>" title="Credit Card Holder"> </td></tr>
			<tr> 
				<td> Expiration date </td>
				<td> Expiration Month  </td> <td> <input type="text" name="<%=ccExpMonthParamName%>" value=""  maxlength="<%=ccExpMthMax%>" title="Expiration Month"> </td>
				<td> Expiration Year  </td> <td> <input type="text" name="<%=ccExpYearParamName%>" value=""  maxlength="<%=ccExpYrMax%>" title="Expiration Year"> </td>
			


			</tr>

		</table>

		<table>
			<thead> <tr> <th> Menu Item </th> <th> Quantity </th> <th> Status </th></tr> </thead>
			<tbody>
	<% 		for (MenuItemBean menuItem: menuItems) {
				long menuItemId = menuItem.getId();
				String mItemName = menuItem.getName();
				quantityParamName = String.format("%s-%d",ParamLabels.OrderItem.QUANTITY,menuItemId);
				statusParamName = String.format("%s-%d",ParamLabels.OrderItem.STATUS,menuItemId);
	%>			
				<tr> <td> <%=mItemName%> </td>
				     <td> <input type="number" min="0" max="1000" step="1" name="<%=quantityParamName%>" value="0" required> </td> 
				   	 <td><select form="addForm" name="<%=statusParamName%>" required>
<%						 	for(OrderItemStatus s: status) {
%>								<option value="<%=s.name() %>" ><%=s.name().toLowerCase()%> </option>
<%							}
%>						 </select> 
					</td>

				</tr>
	<%		}
	%>		

	
	</tbody>
			</table>
			<input type="submit" value="Create Order">
		</Form>				
<%	}
%>	
	
	
	
	
	
	</div>
</body>
</html>