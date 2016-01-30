package edu.depaul.se491.resapp.demo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.CredentialsBean;
import edu.depaul.se491.ws.clients.AccountServiceClient;

@WebServlet("/accounts")
public class AccountServlet extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String baseUrl = "http://localhost/CoreApp/account";
		CredentialsBean credentials = new CredentialsBean("manager", "password");
				
		AccountServiceClient serviceClient = new AccountServiceClient(credentials, baseUrl);
		
		AccountBean[] acconuts = serviceClient.getAll();
		
		request.setAttribute("items", acconuts);
		
		String jspUrl = "/manageAccounts.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);	
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}
