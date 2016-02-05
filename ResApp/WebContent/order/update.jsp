<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@ page import="edu.depaul.se491.utils.ParamLabels,edu.depaul.se491.utils.ParamPatterns,edu.depaul.se491.utils.ParamValues" %>
<%@ page import="edu.depaul.se491.beans.OrderBean" %>
<%@ page import="edu.depaul.se491.beans.OrderItemBean" %>
<%@ page import="edu.depaul.se491.beans.MenuItemBean" %>
<%@ page import="edu.depaul.se491.beans.PaymentBean" %>
<%@ page import="edu.depaul.se491.beans.AddressBean" %>
<%@ page import="edu.depaul.se491.enums.OrderStatus" %>
<%@ page import="edu.depaul.se491.enums.OrderType" %>
<%@ page import="edu.depaul.se491.enums.AddressState" %>
<%@page import="edu.depaul.se491.utils.ParamLengths"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Update Order</title>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/component.css"/>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/demo.css"/>
	</head>


<body>
	<div class="component">
	<h1>Update Order </h1>
<%
	String msg = (String) request.getAttribute(ParamLabels.JspMsg.MSG);
	OrderBean order = (OrderBean) request.getAttribute(ParamLabels.Order.ORDER_BEAN);
	if (msg != null) {
%> 			<h3><%=msg%></h3> 
<%	}	
		
	if(order != null){
		long orderId = order.getId();
		PaymentBean payment = order.getPayment();
		AddressBean addressOrder = order.getAddress();
		String status = order.getStatus().toString().toLowerCase();
		String type = order.getType().toString().toLowerCase();
		
		String total = String.format("&#36;%.2f",payment.getTotal()); //&#36; html for $
		String confirmation = order.getConfirmation();
		String datetime = order.getTimestamp().toLocalDateTime().toString();
		
		
		String addrId = addressOrder == null? "" : Long.toString(addressOrder.getId()); //not sure for ""
		String addrLine1 = addressOrder == null? "" : addressOrder.getLine1();
		String addrLine2 = addressOrder == null? "" : addressOrder.getLine2();
		String addrCity = addressOrder == null? "" : addressOrder.getCity();
		String addrZipcode = addressOrder == null? "" : addressOrder.getZipcode();
		
		int line1LenMax = ParamLengths.Address.MAX_LINE1;
		int line2LenMax = ParamLengths.Address.MAX_LINE2;
		int cityLenMax = ParamLengths.Address.MAX_CITY;
		int zipcodeLenMax = ParamLengths.Address.MAX_ZIPCODE;
		
%>


		<form id="updateForm" action="${pageContext.request.contextPath}/order/update" method="POST">
		<table>
		
		
			<thead> <tr> <th> Order Data</th> <th> <input type="hidden" name="<%=ParamLabels.Order.ID%>" value="<%=orderId%>"> </th> </tr> </thead>			
			<tbody>
			<tr> <td> Status </td>
				 <td> <select name="<%=ParamLabels.Order.STATUS%>" form="updateForm" required>
<% 				 for(OrderStatus s: OrderStatus.values()) {
%>					 	<option value="<%=s.toString()%>" <%if (s == order.getStatus()) { %> selected="selected" <%};%>> <%=s.toString().toLowerCase()%></option>
<%				 }
%>				</select></td>
			</tr>
			
			<tr> <td> Type </td>
				 <td> <select name="<%=ParamLabels.Order.TYPE%>" form="updateForm" required>
<% 					for(OrderType t: OrderType.values()) {
%>					 	<option value="<%=t.toString()%>" <% if (t == order.getType()) { %> selected="selected" <%}%>> <%=t.toString().toLowerCase()%></option>
<%					}
%>					</select></td>									
			</tr>
			
			<tr> <td> Total </td> <td> <%=total%>	</td> </tr>
		
			<tr> <td> Confirmation	</td> <td>  <%=confirmation%>	</td> </tr>
			<tr> <td> Date/Time </td> <td> <%=datetime%> </td> </tr>
			<tr> <td> Delivery Address Information </td> <td> <input type="hidden" name="<%=ParamLabels.Address.ID%>" value="<%=addrId%>"></td></tr>
			<tr> <td> Address 1	</td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_1%>" value="<%=addrLine1%>" manxlength="<%=line1LenMax%>"></td> </tr>
			<tr> <td> Address 2	</td> <td> <input type="text" name="<%=ParamLabels.Address.LINE_2%>" value="<%=addrLine2%>" manxlength="<%=line2LenMax%>"></td> </tr>
			<tr> <td> City	</td> <td>	<input type="text" name="<%=ParamLabels.Address.CITY%>" value="<%=addrCity%>" manxlength="<%=cityLenMax%>"> </td> </tr>
			<tr> <td> State	</td> 
				 <td> <select name="<%=ParamLabels.Address.STATE%>" form="updateForm">
<% 					for(AddressState st: AddressState.values()) {
%>					 	<option value="<%=st.toString()%>" <% if (addressOrder != null && st == addressOrder.getState()) { %> selected="selected" <%}%>> <%=st.toString()%></option>
<%					}
%>				 </select></td> 
			</tr>
			<tr> <td> Zipcdoe </td> <td> <input type="text" name="<%=ParamLabels.Address.ZIP_CODE%>" value="<%=addrZipcode%>" manxlength="<%=zipcodeLenMax%>"> </td></tr>
			</tbody>
		</table>

			<table>
			<thead> <tr> <th> Menu Item </th> <th> Quantity </th> </tr> </thead>
			<tbody>
<% 			for (OrderItemBean oItem: order.getItems()) {
				String id = Long.toString(oItem.getMenuItem().getId());
				String mItemName = oItem.getMenuItem().getName();
				String quantity = Integer.toString(oItem.getQuantity());
%>				
				<tr> <td> <%=mItemName%> </td> <td> <input type="number" min="0" max="1000" step="1" name="mItemQty-<%=id%>" value="<%=quantity%>" required> </td> </tr>
<%			}
	}
%>			</tbody>
			</table>
			<input type="submit" value="Update Order">
			</Form>			
		</div>
</body>


</html>