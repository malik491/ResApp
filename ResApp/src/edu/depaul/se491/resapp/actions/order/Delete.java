package edu.depaul.se491.resapp.actions.order;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.validators.OrderValidator;
import edu.depaul.se491.ws.clients.OrderServiceClient;

/**
 * 
 * @author Malik
 *
 */
@WebServlet("/order/delete")
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

			long OrderID = getIdFromRequest(request, ParamLabels.Order.ID, 0); 
			if (OrderID == 0)
				jspMsg = "Invalid Order Id.";
			
			boolean isNewOrder = false;
			boolean isValid = new OrderValidator().validateId(new Long(OrderID), isNewOrder);

			if(isValid)
			{
				OrderServiceClient serviceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_SERVICE_URL);
				Boolean deleted = serviceClient.delete(OrderID);
				jspMsg =(deleted == null) ? serviceClient.getResponseMessage() : (deleted ? "Successfully deleted the order." : "The order can not be deleted.") ;
			}
		}
	
		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);

	
		String jspUrl = "/order/delete.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
	
}