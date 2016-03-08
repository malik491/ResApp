package edu.depaul.se491.resapp.actions.terminal;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.MenuItemBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.resapp.actions.BaseAction;
import edu.depaul.se491.ws.clients.MenuServiceClient;

/**
 * @author Malik
 *
 */

@WebServlet("/terminal/pos/menu/ajax")
public class POSAjaxFetch extends BaseAction {
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		AccountBean loggedinAccount = getLoggedinAccount(request);
		String jsonResponse = null;
		
		if (loggedinAccount == null) {
			jsonResponse = getInvalidResponse("Access Denied. You are not logged in");
		} else if (loggedinAccount.getRole() != AccountRole.EMPLOYEE){
			jsonResponse = getInvalidResponse("Access Deined. Not allowed based on your role");
		} else {
			MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENU_WEB_SERVICE_URL);
			MenuItemBean[] menuItems = serviceClient.getAllVisible();
			if (menuItems == null) {
				jsonResponse = getInvalidResponse(serviceClient.getResponseMessage());
			} else {
				jsonResponse = String.format("{\"valid\": true, \"itemsList\": %s}", new Gson().toJson(menuItems));
			}
		}
		
		response.setContentType("application/json");
		response.getWriter().print(jsonResponse);
		response.flushBuffer();
	}
	
	private String getInvalidResponse(String message) {
		String response = "{\"valid\": false, \"message\": \"" +message+ "\"}";
		return response;
	}
}
