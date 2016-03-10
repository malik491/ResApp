package edu.depaul.se491.resapp.actions.menuItem;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.MenuItemBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.MenuServiceClient;

/**
 * @author Malik, Lamont
 *
 */
@WebServlet("/menuItem/create")
public class Create extends BaseAction {
	private static final long serialVersionUID = 1L; // ignore this

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AccountBean loggedinAccount = getLoggedinAccount(request);
		if (loggedinAccount == null) {
			// not logged in. go to login page
			getServletContext().getRequestDispatcher(LOGIN_JSP_URL).forward(request, response);
			return;
		}

		String jspMsg = null;
		
		if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			MenuItemBean menuItem = getMenuItemFromRequest(request); 
			if (menuItem.getItemCategory() != null) {
				if (isValidMenuItemBean(menuItem, true)) {
					MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENU_WEB_SERVICE_URL);
					MenuItemBean createdItem = serviceClient.post(menuItem);
					jspMsg =(createdItem == null) ? serviceClient.getResponseMessage() : "Successfully created new menu item";	
				} else {
					jspMsg = "Invalid New Menu Item Data";
				}
			}
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);

		
		String jspUrl = "/menuItem/create.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
	
}
