package edu.depaul.se491.resapp.actions.menuItem;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.validators.MenuItemValidator;
import edu.depaul.se491.ws.clients.MenuServiceClient;

/**
 * 
 * @author Malik, Lamont
 *
 */
@WebServlet("/menuItem/updateHideStatus")
public class UpdateHideStatus extends BaseAction {
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

			long menuItemID = getIdFromRequest(request, ParamLabels.MenuItem.ID, 0);
			boolean isValid = new MenuItemValidator().validateId(new Long(menuItemID), false);
			if (!isValid)
				jspMsg = "Invalid Menu Id.";

			Boolean hide = getHideParam(request);
			if (hide == null) {
				jspMsg = (jspMsg == null)? "" : jspMsg;
				jspMsg = jspMsg + " Missing hide parameter.";
				isValid = false;
			}
			
			if(isValid)
			{
				MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENU_WEB_SERVICE_URL);
				Boolean updated = hide? serviceClient.hideMenuItem(menuItemID) : serviceClient.unhideMenuItem(menuItemID);
				if (updated == null) {
					jspMsg = serviceClient.getResponseMessage();
				} else {
					if (updated)
						jspMsg = "Successfully " + ((hide? "hid" : "made visible") + " a menu item.");
					else
						jspMsg = "Failed to" + ((hide? "hide" : "un-hide") + " a menu item.");
				}
			}
		}
	
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);

	
		String jspUrl = "/menuItem/updateHideStatus.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}

	private Boolean getHideParam(HttpServletRequest request) {
		Boolean result = null;
		try {
			String param = request.getParameter(ParamLabels.MenuItem.IS_HIDDEN);
			if (param != null)
				result = Boolean.valueOf(param);
		} catch (Exception e){}
		
		return result;
	}
	
}
