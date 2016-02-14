/**
 * 
 */
package edu.depaul.se491.resapp.actions.terminal;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonParseException;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.OrderBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.enums.MenuItemCategory;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.OrderServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/terminal/station/ajax/update")
public class KSAjaxUpdate extends BaseAction {
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
			String orderInJson = request.getParameter("order");
			MenuItemCategory selectedStation = getSelectedStation(request);
			
			if (orderInJson == null || selectedStation == null) {
				jsonResponse = getInvalidResponse("Missing 'order' or 'mItemCategory' request parameters");
			} else {
				OrderBean order = getOrderBean(orderInJson);
				if (order == null) {
					jsonResponse = getInvalidResponse("failed to parse json order");
				} else if (isValidOrderBean(order, false) == false){
					jsonResponse = getInvalidResponse("Invalid order data");
				} else {
					OrderServiceClient serviceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_SERVICE_URL);
					Boolean updated = null;
					
					if (selectedStation == MenuItemCategory.MAIN) {
						updated = serviceClient.mainStationUpdate(order);
					} else if (selectedStation == MenuItemCategory.BEVERAGE) {
						updated = serviceClient.beverageStationupdate(order);
					} else {
						updated = serviceClient.sideStationUpdate(order);
					}
				
					if (updated == null) {
						jsonResponse = getInvalidResponse(serviceClient.getResponseMessage());
					} else if (updated == false) {
						jsonResponse = getInvalidResponse("falied to updated order");
					} else {
						jsonResponse = "{\"updated\": true}";
					}
				}
			}
		}
		
		response.setContentType("application/json");
		response.getWriter().print(jsonResponse);
		response.flushBuffer();
	}

	private OrderBean getOrderBean(String orderInJson) {
		OrderBean order = null;
		try {
			order = new Gson().fromJson(orderInJson, OrderBean.class);
		} catch (JsonParseException e) {
			e.printStackTrace();
		}
		return order;
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
		String response = "{\"updated\": false, \"message\": \"" +message+ "\"}";
		return response;
	}
}
