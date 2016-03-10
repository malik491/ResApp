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
 *
 */
@WebServlet("/account/create")
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
		if (loggedinAccount.getRole() == AccountRole.MANAGER || loggedinAccount.getRole() == AccountRole.ADMIN) {
			AccountBean account = getAccountFromRequest(request);
			if (account.getCredentials().getUsername() != null) {
				if (loggedinAccount.getRole() == AccountRole.MANAGER) {
					account.setRole(AccountRole.EMPLOYEE);

					if (isValidAccountBean(account, true)) {
						AccountServiceClient serviceClient = new AccountServiceClient(loggedinAccount.getCredentials(), ACCOUT_WEB_SERVICE_URL);
						account = serviceClient.post(account);
						jspMsg = (account == null)? serviceClient.getResponseMessage() : "Successfully created new account";
					} else {
						jspMsg = "Invalid New Account Data";
					}		
				}
			}
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		
		String jspUrl = "/account/create.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
}
