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
@WebServlet("/menuItem/delete")
public class Delete extends BaseAction {
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

			long menuItemID = getIdParam(request, ParamLabels.MenuItem.ID, 0); 
			if (menuItemID == 0)
				jspMsg = "Invalid Menu Id.";
			
			boolean isNewMenuItem = false;
			boolean isValid = new MenuItemValidator().validateId(new Long(menuItemID), isNewMenuItem);

			if(isValid)
			{
				MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENUITEM_SERVICE_URL);
				Boolean deleted = serviceClient.delete(menuItemID);
				jspMsg =(deleted == null) ? serviceClient.getResponseMessage() : (deleted ? "Successfully deleted menu item" : "The menu item can not be deleted") ;
			}
		}
	
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);

	
		String jspUrl = "/menuItem/delete.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
	
}
