package edu.depaul.se491.resapp.actions;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.utils.ParamLabels;

@WebServlet("/logoff")
public class LogOff extends BaseAction {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String jspUrl = "/login.jsp";
		String jspMsg = null;
		
		HttpSession session = request.getSession();
		AccountBean account = (AccountBean) session.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
		
		if (account != null) {
			// user is logged in. log off/clear session
			synchronized(session) {
				session.removeAttribute(ParamLabels.Account.ACCOUNT_BEAN);
				session.invalidate();
			}
			jspMsg = "Successfuly logged off";
		} else {
			jspMsg = "Not logged in";
		}
		
		request.setAttribute(ParamLabels.JspMsg.MSG, jspMsg);
		
		getServletContext().getRequestDispatcher(jspUrl).forward(request, response);
	}
}
