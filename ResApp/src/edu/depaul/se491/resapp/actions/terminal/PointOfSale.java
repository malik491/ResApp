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

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.MenuItemBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.MenuServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/terminal/pos")
public class PointOfSale extends BaseAction {
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
		if (loggedinAccount.getRole() == AccountRole.EMPLOYEE) {
			MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENU_WEB_SERVICE_URL);
			menuItems = serviceClient.getAllVisible();
			jspMsg = (menuItems == null)? serviceClient.getResponseMessage() : null;	
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (menuItems != null) {
			request.setAttribute(ParamLabels.MenuItem.VISIBLE_MENU_ITEM_BEAN_LIST, menuItems);
			request.setAttribute("jsonMenuItemList", new Gson().toJson(menuItems));
		}
		
		String jspUrl = "/terminal/pos.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}

}
