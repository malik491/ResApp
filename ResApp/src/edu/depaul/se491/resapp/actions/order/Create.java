/**
 * 
 */
package edu.depaul.se491.resapp.actions.order;


import java.io.IOException;
import java.util.Arrays;
import java.util.List;

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
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AccountBean loggedinAccount = getLoggedinAccount(request);
		if (loggedinAccount == null) {
			// not logged in. go to login page
			getServletContext().getRequestDispatcher(LOGIN_JSP_URL).forward(request, response);
			return;
		}
		String jspMsg = null;
		List<MenuItemBean> menuItems = null;
		OrderBean order = null;
		

		if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			
			//get the menu items.			
			MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENUITEM_SERVICE_URL);
			menuItems = Arrays.asList(serviceClient.getAll()) ;
			jspMsg =(menuItems == null) ? serviceClient.getResponseMessage() : null;
			
			if(menuItems != null)
			{	
				//create an order
				order = getOrderFromRequest(request);
				boolean isValid = isValidOrderBean(order, true);
				if(isValid)
				{
					//add the order
					OrderServiceClient orderServiceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_SERVICE_URL);
					order = orderServiceClient.post(order);
					isValid &= isValidOrderBean(order, true);
					jspMsg =(order == null) ? orderServiceClient.getResponseMessage() : (isValid) ? "The order was successfully created" : "The order was successfully created"  ;
				}
			
			}

		}
		
		
		request.setAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN_LIST, menuItems != null? menuItems: null);
		request.setAttribute("msg", jspMsg != null? jspMsg : null);
		String jspURL = "/order/create.jsp";
		getServletContext().getRequestDispatcher(jspURL).forward(request, response);
	}

}