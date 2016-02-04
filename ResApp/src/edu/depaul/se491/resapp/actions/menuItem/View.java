/**
 * 
 */
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
import edu.depaul.se491.validators.MenuItemValidator;
import edu.depaul.se491.ws.clients.MenuServiceClient;

/**
 * @author Malik
 */
@WebServlet("/menuItem/view")
public class View extends BaseAction {
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

		long menuItemId = getIdFromRequest(request, ParamLabels.MenuItem.ID, 0);
		boolean isValid = new MenuItemValidator().validateId(menuItemId, false);

		MenuItemBean menuItem = null;
		
		if (isValid && loggedinAccount.getRole() == AccountRole.MANAGER) {
			MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENUITEM_SERVICE_URL);
			menuItem = serviceClient.get(menuItemId);
			jspMsg = (menuItem == null)? serviceClient.getResponseMessage() : null;			
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (menuItem != null)
			request.setAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN, menuItem);
		
		String jspUrl = "/menuItem/view.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
}