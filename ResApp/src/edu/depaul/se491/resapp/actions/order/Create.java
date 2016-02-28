package edu.depaul.se491.resapp.actions.order;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.depaul.se491.beans.MenuItemBean;
import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.OrderBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.MenuServiceClient;
import edu.depaul.se491.ws.clients.OrderServiceClient;

/**
 * @author Malik, Lamont
 *
 */
@WebServlet("/order/create")
public class Create extends BaseAction {
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
		MenuItemBean[] menuItems = null;
		if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			
			//get the menu items.			
			MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENU_WEB_SERVICE_URL);
			menuItems = serviceClient.getAllVisible() ;
			jspMsg =(menuItems == null) ? serviceClient.getResponseMessage() : null;
			
			if(menuItems != null)
			{	
				long orderId = getIdFromRequest(request, ParamLabels.Order.ID, -1);
				
				if (orderId != -1) {
					//create an order
					OrderBean order = getOrderFromRequest(request);
					if(isValidOrderBean(order, true)){
						//add the order
						OrderServiceClient orderServiceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_WEB_SERVICE_URL);
						OrderBean createdOrder = orderServiceClient.post(order);
						jspMsg =(createdOrder == null) ? orderServiceClient.getResponseMessage() : "Successfully Created Order";
					} else {
						jspMsg = "Invalid order data";
					}

				}			
			}

		}

		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (menuItems != null)
			request.setAttribute(ParamLabels.MenuItem.VISIBLE_MENU_ITEM_BEAN_LIST, menuItems);
		
		String jspURL = "/order/create.jsp";
		getServletContext().getRequestDispatcher(jspURL).forward(request, response);
	}

}