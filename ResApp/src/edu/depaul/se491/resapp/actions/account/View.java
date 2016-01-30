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
import edu.depaul.se491.validators.CredentialsValidator;
import edu.depaul.se491.ws.clients.AccountServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/account/view")
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
		AccountBean account = loggedinAccount;
				
		String username = (String) request.getParameter(ParamLabels.Credentials.USERNAME);
		String jspMsg = null;
		
		if (loggedinAccount.getRole() == AccountRole.MANAGER && username != null) {
			// validate username and then look up account (clicked 'view' from manage.jsp)
			boolean isValid = new CredentialsValidator().isValidUsername(username);
			if (isValid) {
				AccountServiceClient serviceClient = new AccountServiceClient(loggedinAccount.getCredentials(), ACCOUNT_SERVICE_URL);
				account = serviceClient.get(username);
				jspMsg = (account == null)? serviceClient.getResponseMessage() : null;
			}
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (account != null)
			request.setAttribute(ParamLabels.Account.ACCOUNT_BEAN, account);
		
		String jspUrl = "/account/view.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
}
