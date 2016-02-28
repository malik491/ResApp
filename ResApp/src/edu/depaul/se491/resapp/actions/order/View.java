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
		OrderBean order = null;

		if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			long orderId = getIdFromRequest(request, ParamLabels.Order.ID, 0);
			boolean isValid = new OrderValidator().validateId(orderId, false);

			if (isValid) {
				OrderServiceClient serviceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_WEB_SERVICE_URL);
				order = serviceClient.get(orderId);
				jspMsg = (order == null)? serviceClient.getResponseMessage() : null;			
			} else {
				jspMsg = "Invalid Order Id";
			}
		}
		
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (order != null)
			request.setAttribute(ParamLabels.Order.ORDER_BEAN, order);
		
		String jspUrl = "/order/view.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
	
}