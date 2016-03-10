/**
 * 
 */
package edu.depaul.se491.resapp.actions;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.CredentialsBean;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.validators.CredentialsValidator;
import edu.depaul.se491.ws.clients.AccountServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/login")
public class Login extends BaseAction {
	private static final long serialVersionUID = 1L;

	
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String jspUrl = "/login.jsp";
		String jspMsg = null;
		
		HttpSession session = request.getSession();
		AccountBean account = (AccountBean) session.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
		
		if (account == null) {
			// try to log in user
			String username = request.getParameter(ParamLabels.Credentials.USERNAME);
			String password = request.getParameter(ParamLabels.Credentials.PASSWORD);
			if (username != null && password != null) {
				CredentialsBean credentials = new CredentialsBean(username, password);
				boolean isValid = new CredentialsValidator().validate(credentials);

				if (isValid) {
					AccountServiceClient serviceClient = new AccountServiceClient(credentials, ACCOUT_WEB_SERVICE_URL);
					account = serviceClient.get(credentials.getUsername());
					
					if (account == null) {
						jspMsg = serviceClient.getResponseMessage();
					} else {
						synchronized (session) {
							session.setAttribute(ParamLabels.Account.ACCOUNT_BEAN, account);
							jspUrl = "/home.jsp";
						}
					}
				} else {
					jspMsg = "Invalid login Credentials";
				}
			}
		} else {
			jspUrl = "/home.jsp";
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (account != null)
			request.setAttribute(ParamLabels.Account.ACCOUNT_BEAN, account);

		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
		
	}


	
}
