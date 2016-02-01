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
import edu.depaul.se491.validators.CredentialsValidator;
import edu.depaul.se491.validators.MenuItemValidator;
import edu.depaul.se491.ws.clients.AccountServiceClient;
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
		
		// set to view own account by default
		MenuItemBean menuItem = null;
		
		String menuItemIDPar = request.getParameter(ParamLabels.MenuItem.ID);
		Long menuItemId = Long.parseLong(menuItemIDPar, 10);
		
		String jspMsg = null;
		
		if (loggedinAccount.getRole() == AccountRole.MANAGER && menuItemId != null) {
			// validate menuItemID and then look up account (clicked 'view' from manage.jsp)
			boolean isValid = new MenuItemValidator().validateId(menuItemId, false);
			if (isValid) {
				MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENUITEM_SERVICE_URL);
				menuItem = serviceClient.get(menuItemId);
				jspMsg = (menuItem == null)? serviceClient.getResponseMessage() : null;
			}
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (menuItem != null)
			request.setAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN, menuItem);
		
		String jspUrl = "/menuItem/view.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
}