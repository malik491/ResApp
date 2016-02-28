/**
 * 
 */
package edu.depaul.se491.resapp.actions.terminal;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonParseException;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.OrderBean;
import edu.depaul.se491.beans.OrderItemBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.enums.MenuItemCategory;
import edu.depaul.se491.enums.OrderItemStatus;
import edu.depaul.se491.enums.OrderStatus;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.OrderServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/terminal/station/ajax/fetch")
public class KSAjaxFetch extends BaseAction {
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AccountBean loggedinAccount = getLoggedinAccount(request);
		String jsonResponse = null;
		
		if (loggedinAccount == null) {
			jsonResponse = getInvalidResponse("Access Denied. You are not logged in");
		} else if (loggedinAccount.getRole() != AccountRole.EMPLOYEE){
			jsonResponse = getInvalidResponse("Access Deined. Not allowed based on your role");
		} else {
			long[] excludeIds = getExcludeIds(request);
			MenuItemCategory selectedStation = getSelectedStation(request);
			
			if (excludeIds == null || selectedStation == null) {
				jsonResponse = getInvalidResponse("Missing 'excludeIds' or 'selectedStation' request parameters");
			} else {
				OrderServiceClient serviceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_WEB_SERVICE_URL);
				OrderBean[] submittedOrders = serviceClient.getAllWithStatus(OrderStatus.SUBMITTED);
				if (submittedOrders == null) {
					jsonResponse = getInvalidResponse(serviceClient.getResponseMessage());
				} else {
					OrderBean[] orders = null;
					if (submittedOrders.length == 0)
						orders = submittedOrders;
					else
						orders = getStationOrders(selectedStation, submittedOrders, excludeIds);
					
					jsonResponse = String.format("{\"valid\": true, \"orders\": %s}", new Gson().toJson(orders));
				}
			}
		}
		
		response.setContentType("application/json");
		response.getWriter().print(jsonResponse);
		response.flushBuffer();
	}

	private long[] getExcludeIds(HttpServletRequest request) {
		long[] ids = null;
		try {
			ids = new Gson().fromJson(request.getParameter("excludeIds"), long[].class);
			
		} catch(JsonParseException e) {}
		
		return ids;
	}
	
	private OrderBean[] getStationOrders(MenuItemCategory selectedStation, OrderBean[] submittedOrders, long[] excludeIds) {
		List<OrderBean> orders = new ArrayList<>();
		for (OrderBean order: submittedOrders) {
			if (exclude(excludeIds, order.getId()))
				continue;
			
			OrderItemBean[] items = order.getOrderItems();
			if (items != null && items.length > 0) {
				for (OrderItemBean oItem: items) {
					if (oItem.getMenuItem().getItemCategory() == selectedStation && oItem.getStatus() == OrderItemStatus.NOT_READY) {
						orders.add(order);
						break;
					}
				}
			}
		}
		OrderBean[] ordersArray = new OrderBean[orders.size()];
		ordersArray =  orders.toArray(ordersArray);
		return ordersArray;
	}
	
	private boolean exclude(long[] excludeIds, long id) {
		for (long orderId : excludeIds) {
			if (orderId == id)
				return true;
		}
		return false;
	}

	private MenuItemCategory getSelectedStation(HttpServletRequest request) {
		String category = request.getParameter(ParamLabels.MenuItem.ITEM_CATEGORY);
		MenuItemCategory station = null;
		try {
			station = MenuItemCategory.valueOf(category);
		} catch (Exception e) {}
		
		return station;
	}

	private String getInvalidResponse(String message) {
		String response = "{\"valid\": false, \"message\": \"" +message+ "\"}";
		return response;
	}
}