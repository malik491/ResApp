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

		MenuItemBean updatedMenuItem = null;
		long menuItemId = getIdFromRequest(request, ParamLabels.MenuItem.ID, 0);
		
		if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			// validate menu item id
			boolean isValid = new MenuItemValidator().validateId(menuItemId, false);
			
			if (isValid) {
				// we have a valid id, so either update menu item or load a menu item to be updated 
				MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENU_WEB_SERVICE_URL);
				
				updatedMenuItem = getMenuItemFromRequest(request);
				
				if (isValidMenuItemBean(updatedMenuItem, false)) {
					// update menu item
					Boolean updated = serviceClient.update(updatedMenuItem);
					jspMsg = (updated == null)? serviceClient.getResponseMessage() : "Successfully updated menu item";					
				} else {
					if (updatedMenuItem.getItemCategory() != null)
						jspMsg = "Invalid New Menu Item Data (reloaded old valid data)";
					
					// load menu item to update
					updatedMenuItem = serviceClient.get(menuItemId);
					if (updatedMenuItem == null) {
						String serviceClientMsg = serviceClient.getResponseMessage();
						jspMsg = (jspMsg == null)? serviceClientMsg : jspMsg + "<br>" + serviceClientMsg;					
					}			
				}
			}
			
		}

		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (updatedMenuItem != null)
			request.setAttribute(ParamLabels.MenuItem.MENU_ITEM_BEAN, updatedMenuItem);
		
		String jspUrl = "/menuItem/update.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}	
	
}