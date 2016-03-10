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
 * @author Malik
 */
@WebServlet("/menuItem/manage")
public class Manage extends BaseAction {
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
		MenuItemBean[] visibleMenuItems = null;
		MenuItemBean[] hiddenMenuItems = null;
		
		if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENU_WEB_SERVICE_URL);
			visibleMenuItems = serviceClient.getAllVisible();
			hiddenMenuItems = serviceClient.getAllHidden();
			
			jspMsg = (visibleMenuItems == null || hiddenMenuItems == null)? serviceClient.getResponseMessage() : null;	
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (visibleMenuItems != null)
			request.setAttribute(ParamLabels.MenuItem.VISIBLE_MENU_ITEM_BEAN_LIST, visibleMenuItems);
		if (hiddenMenuItems != null)
			request.setAttribute(ParamLabels.MenuItem.HIDDEN_MENU_ITEM_BEAN_LIST, hiddenMenuItems);
		
		String jspUrl = "/menuItem/manage.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	
	}
}
