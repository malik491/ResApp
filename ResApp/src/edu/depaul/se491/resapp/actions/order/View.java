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
import edu.depaul.se491.validators.OrderValidator;
import edu.depaul.se491.ws.clients.OrderServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/order/view")
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
		
		String jspMsg = null;

		final long orderItemId = getIdFromRequest(request, ParamLabels.Order.ID, 0);
		boolean isValid = new OrderValidator().validateId(orderItemId, false);

		//OrderItemBean orderItem = null;
		OrderBean orderbean = null;
		
		if (isValid && loggedinAccount.getRole() == AccountRole.MANAGER) {
			OrderServiceClient serviceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_SERVICE_URL);
			orderbean = serviceClient.get(orderItemId);
			jspMsg = (orderbean == null)? serviceClient.getResponseMessage() : null;			
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (orderbean != null)
			request.setAttribute(ParamLabels.Order.ORDER_BEAN, orderbean); //not sure here
		
		String jspUrl = "/order/view.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
	
}