/**
 * 
 */
package edu.depaul.se491.resapp.actions.account;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.AccountServiceClient;

/**
 * @author Malik
 */
@WebServlet("/account/update")
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

		AccountBean updatedAccount = getAccountFromRequest(request);
		String username = updatedAccount.getCredentials().getUsername();
		
		if (username == null) {
			// show own account to update
			updatedAccount = loggedinAccount;
			
		} else if (username.equals(loggedinAccount.getCredentials().getUsername())) {
			// update own account
			if (isValidAccountBean(updatedAccount, false)) 
			{	
				// update it
				AccountServiceClient serviceClient = new AccountServiceClient(loggedinAccount.getCredentials(), ACCOUNT_SERVICE_URL);
				Boolean updated = serviceClient.update(updatedAccount);
				
				jspMsg = (updated == null)? serviceClient.getResponseMessage() : "Successfully updated account";
				
				if (updated != null && updated == true) {
					// remove old account bean in the session and save the updated one
					HttpSession session = request.getSession();
					synchronized (session) {
						session.removeAttribute(ParamLabels.Account.ACCOUNT_BEAN);
						session.setAttribute(ParamLabels.Account.ACCOUNT_BEAN, updatedAccount);
					}
					loggedinAccount = updatedAccount;
				}
			} 
			// reload own account
			updatedAccount = loggedinAccount;							

		} else if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			// manager can update other's account
			AccountServiceClient serviceClient = new AccountServiceClient(loggedinAccount.getCredentials(), ACCOUNT_SERVICE_URL);
			
			if (isValidAccountBean(updatedAccount, false)) 
			{	
				Boolean updated = serviceClient.update(updatedAccount);	
				jspMsg = (updated == null)? serviceClient.getResponseMessage() : "Successfully updated account";
				
			} else {
				// load account to update
				updatedAccount = serviceClient.get(updatedAccount.getCredentials().getUsername());
				jspMsg = (updatedAccount == null)? serviceClient.getResponseMessage() : null;
			}
		}

		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (updatedAccount != null)
			request.setAttribute(ParamLabels.Account.ACCOUNT_BEAN, updatedAccount);
		
		String jspUrl = "/account/update.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}	
}
