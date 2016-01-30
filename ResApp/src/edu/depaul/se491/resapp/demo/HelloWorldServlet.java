package edu.depaul.se491.resapp.demo;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.depaul.se491.beans.CredentialsBean;
import edu.depaul.se491.beans.MenuItemBean;
import edu.depaul.se491.ws.clients.MenuServiceClient;

@WebServlet("/helloworld")
public class HelloWorldServlet extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String baseUrl = "http://localhost/CoreApp/menuItem";
		CredentialsBean credentials = new CredentialsBean("manager", "password");
				
		MenuServiceClient serviceClient = new MenuServiceClient(credentials, baseUrl);
		
		MenuItemBean[] items = serviceClient.getAll();
		
		request.setAttribute("items", items);
		
		String jspUrl = "/manageItems.jsp";
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);	
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
}
