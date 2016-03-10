/**
 * 
 */
package edu.depaul.se491.resapp.actions.account;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.AccountServiceClient;

/**
 * @author Malik
 */
@WebServlet("/account/manage")
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
		AccountBean[] accounts = null;
		if (loggedinAccount.getRole() == AccountRole.MANAGER || loggedinAccount.getRole() == AccountRole.ADMIN) {
			AccountServiceClient serviceClient = new AccountServiceClient(loggedinAccount.getCredentials(), ACCOUT_WEB_SERVICE_URL);
			accounts = serviceClient.getAll();
			jspMsg = (accounts == null)? serviceClient.getResponseMessage() : null;	
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (accounts != null)
			request.setAttribute(ParamLabels.Account.ACCOUNT_BEAN_LIST, accounts);
		
		String jspUrl = "/account/manage.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
		
	}
}
