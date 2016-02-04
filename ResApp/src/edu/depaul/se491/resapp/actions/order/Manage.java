/**
 * 
 */
package edu.depaul.se491.resapp.actions.order;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.OrderBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.ws.clients.OrderServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/order/manage")
public class Manage extends BaseAction {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AccountBean loggedinAccount = getLoggedinAccount(request);
		if (loggedinAccount == null) {
			// not logged in. go to login page
			getServletContext().getRequestDispatcher(LOGIN_JSP_URL).forward(request, response);
			return;
		}
		
		
		String jspMsg = null;
		OrderBean[] orders = null;
		if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			OrderServiceClient serviceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_SERVICE_URL);
			orders = serviceClient.getAll();
			jspMsg = (orders == null)? serviceClient.getResponseMessage() : null;	
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (orders != null)
			request.setAttribute(ParamLabels.Order.ORDER_BEAN_LIST, orders);
		
		String jspUrl = "/order/manage.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	
	}
}
