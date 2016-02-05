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
import edu.depaul.se491.beans.OrderItemBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.validators.OrderValidator;
import edu.depaul.se491.ws.clients.OrderServiceClient;

/**
 * @author Malik
 *
 */
@WebServlet("/order/update")
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

		OrderBean updateOrderbean = null;
		long orderItemId = getIdFromRequest(request, ParamLabels.Order.ID, 0);
		
		System.out.println(orderItemId);

		if (loggedinAccount.getRole() == AccountRole.MANAGER) {
			// validate menu item id
			boolean isValid = new OrderValidator().validateId(orderItemId, false);
			
			if (isValid) {
				// we have a valid id, so either update menu item or load a menu item to be updated 
				OrderServiceClient serviceClient = new OrderServiceClient(loggedinAccount.getCredentials(), ORDER_SERVICE_URL);
				updateOrderbean = getOrderFromRequest(request); 
				//updatedMenuItem = getMenuItemFromRequest(request);
				
				System.out.println(updateOrderbean.getId());
				
				
				if (isValidOrderBean(updateOrderbean, false)) {
					// update order
					System.out.println("Second Time");
					Boolean updated = serviceClient.update(updateOrderbean);
					jspMsg = (updated == null)? serviceClient.getResponseMessage() : "Successfully updated order";					
				} else {
					System.out.println("First Time");
					// load menu item to update
					updateOrderbean = serviceClient.get(orderItemId);
					jspMsg = (updateOrderbean == null)? serviceClient.getResponseMessage() : null;					
				}
			}
		}

		if (jspMsg != null)
			request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		if (updateOrderbean != null)
			request.setAttribute(ParamLabels.Order.ORDER_BEAN, updateOrderbean);
		
		String jspUrl = "/order/update.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}	

}