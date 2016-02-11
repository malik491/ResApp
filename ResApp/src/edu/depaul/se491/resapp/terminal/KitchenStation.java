/**
 * 
 */
package edu.depaul.se491.resapp.terminal;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.OrderBean;
import edu.depaul.se491.beans.OrderItemBean;
import edu.depaul.se491.enums.MenuItemCategory;
import edu.depaul.se491.enums.OrderStatus;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.OrderServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/terminal/station")
public class KitchenStation extends BaseAction {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AccountBean loggedinAccount = getLoggedinAccount(request);
		if (loggedinAccount == null) {
			// not logged in. go to login page
			getServletContext().getRequestDispatcher(LOGIN_JSP_URL).forward(request, response);
			return;
		}
		
		String jspMsg = null;
		OrderBean[] orders = null;
		
		MenuItemCategory selectedStation = getSelectedStation(request);
		if (selectedStation != null) {
			OrderServiceClient service = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_SERVICE_URL);
			OrderBean[] submittedOrders = service.getAllWithStatus(OrderStatus.SUBMITTED);
			jspMsg = submittedOrders == null? service.getResponseMessage() : null;
			
			if (submittedOrders != null) {
				if (submittedOrders.length == 0) {
					orders = submittedOrders;
				} else {
					orders = getStationOrders(selectedStation, submittedOrders);
				}
			}
		} else {
			jspMsg = "No Kitchen Station is Selected";
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (orders != null) {
			request.setAttribute(ParamLabels.Order.ORDER_BEAN_LIST, orders);
			request.setAttribute("jsonOrderList", new Gson().toJson(orders));
			request.setAttribute(ParamLabels.MenuItem.ITEM_CATEGORY, selectedStation);
		} 
		
		String jspURL = "/terminal/kitchenStation.jsp";
		getServletContext().getRequestDispatcher(jspURL).forward(request, response);
	}

	private OrderBean[] getStationOrders(MenuItemCategory selectedStation, OrderBean[] submittedOrders) {
		List<OrderBean> orders = new ArrayList<>();
		for (OrderBean order: submittedOrders) {
			OrderItemBean[] items = order.getOrderItems();
			if (items != null && items.length > 0) {
				for (OrderItemBean oItem: items) {
					if (oItem.getMenuItem().getItemCategory() == selectedStation) {
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

	private MenuItemCategory getSelectedStation(HttpServletRequest request) {
		String category = request.getParameter(ParamLabels.MenuItem.ITEM_CATEGORY);
		MenuItemCategory station = null;
		try {
			station = MenuItemCategory.valueOf(category);
		} catch (Exception e) {}
		
		return station;
	}
}
