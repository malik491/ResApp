/**
 * 
 */
package edu.depaul.se491.resapp.actions.menuItem;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.MenuItemBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.enums.MenuItemCategory;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.utils.ParamValues;
import edu.depaul.se491.validators.MenuItemValidator;
import edu.depaul.se491.ws.clients.AccountServiceClient;
import edu.depaul.se491.ws.clients.MenuServiceClient;

/**
 * @author 
 */
@WebServlet("/menuItem/update")
public class Update extends BaseAction {
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

		MenuItemBean updatedMenuItem = getMenuItemFromRequest(request);
		
		String menuItemIDPar = request.getParameter(ParamLabels.MenuItem.ID);
		Long menuItemId = Long.parseLong(menuItemIDPar, 10);
		
		if (	loggedinAccount.getRole() == AccountRole.ADMIN || 
				loggedinAccount.getRole() == AccountRole.MANAGER ||
				loggedinAccount.getRole() == AccountRole.EMPLOYEE ) {
			
				MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENUITEM_SERVICE_URL);
				
				if (isValidMenuItemBean(updatedMenuItem, false)) 
				{	
					Boolean updated = serviceClient.update(updatedMenuItem);
					jspMsg = (updated == null)? serviceClient.getResponseMessage() : "Successfully updated menu item";
				} else {
					// load menu item to update
					updatedMenuItem = serviceClient.get(menuItemId);
					jspMsg = (updatedMenuItem == null)? serviceClient.getResponseMessage() : null;
				}
			
		}
		else
		{
			jspMsg = "You dont have the right to update the menu item";
		}

		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (updatedMenuItem != null)
			request.setAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN, updatedMenuItem);
		
		String jspUrl = "/menuItem/update.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}	
	
}