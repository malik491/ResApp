package edu.depaul.se491.resapp.actions;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.AddressBean;
import edu.depaul.se491.beans.CredentialsBean;
import edu.depaul.se491.beans.MenuItemBean;
import edu.depaul.se491.beans.UserBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.enums.AddressState;
import edu.depaul.se491.enums.MenuItemCategory;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.validators.AccountValidator;
import edu.depaul.se491.validators.AddressValidator;
import edu.depaul.se491.validators.MenuItemValidator;
import edu.depaul.se491.validators.UserValidator;

public class BaseAction extends HttpServlet {
	private static final long serialVersionUID = 1L; // ignore this

	
	protected static final String CORE_APP_URL = "http://localhost/CoreApp";
	protected static final String ACCOUNT_SERVICE_URL = CORE_APP_URL + "/account";
	protected static final String MENUITEM_SERVICE_URL = CORE_APP_URL + "/menuItem";
	
	protected static final String LOGIN_JSP_URL = "/login.jsp";

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected AccountBean getLoggedinAccount(HttpServletRequest request) throws ServletException, IOException{
		AccountBean loggedinAccount = null;
		
		// httpSession (think cookie on the server) is used to store object shared by multiple sevelets and/or jsps
		// we are using it to store current logged in user
		HttpSession session = request.getSession(false);
		if (session != null) {
			synchronized(session) {
				// thread safety
				// don't confuse this with request.setAttribute(). read api or ask me
				loggedinAccount = (AccountBean) session.getAttribute(ParamLabels.Account.ACCOUNT_BEAN);
			}		
		}
		return loggedinAccount;
	}
	
	protected boolean isValidMenuItemBean(MenuItemBean menuItem, boolean isNewMenuItem) {
		return new MenuItemValidator().validate(menuItem, isNewMenuItem);
	}
	
	protected boolean isValidAccountBean(AccountBean account, boolean isNewAccount) {
		boolean isValid = false;
		
		isValid  = new AccountValidator().validate(account);
		isValid &= isValid? new UserValidator().validate(account.getUser(), isNewAccount) : false;
		isValid &= isValid? new AddressValidator().validate(account.getUser().getAddress(), isNewAccount) : false;
		
		return isValid;
	}
	
	protected MenuItemBean getMenuItemFromRequest(HttpServletRequest request) {
		long id =  getIdParam(request, ParamLabels.MenuItem.ID, 0);
		String name = (String) request.getParameter(ParamLabels.MenuItem.NAME);
		String description = (String) request.getParameter(ParamLabels.MenuItem.DESC);
		double price = getDoubleParam(request, ParamLabels.MenuItem.PRICE, 0);
		MenuItemCategory itemCategory = getCategoryParam(request);
		
		MenuItemBean menuItem = new MenuItemBean(id, name, description, price, itemCategory);		
		return menuItem;
	}
	

	protected AccountBean getAccountFromRequest(HttpServletRequest request) {
		AccountBean account = new AccountBean(getCredentialsBean(request), getUserBean(request), getAccountRoleParam(request));		
		return account;
	}
	
	protected CredentialsBean getCredentialsBean(HttpServletRequest request) {
		String username = (String) request.getParameter(ParamLabels.Credentials.USERNAME);
		String password = (String) request.getParameter(ParamLabels.Credentials.PASSWORD);
		
		CredentialsBean credentials = new CredentialsBean(username, password);
		return credentials;
	}

	protected UserBean getUserBean(HttpServletRequest request) {
		long id = getIdParam(request, ParamLabels.User.ID, 0);
		String firstName = (String) request.getParameter(ParamLabels.User.F_NAME);
		String lastName = (String) request.getParameter(ParamLabels.User.L_NAME);
		String email = (String) request.getParameter(ParamLabels.User.EMAIL);
		String phone = (String) request.getParameter(ParamLabels.User.PHONE);
		
		UserBean user = new UserBean(id, firstName, lastName, email, phone, getAddressBean(request));
		
		return user;
	}

	protected AddressBean getAddressBean(HttpServletRequest request) {
		long id = getIdParam(request, ParamLabels.Address.ID, 0);
		String line1 = (String) request.getParameter(ParamLabels.Address.LINE_1);
		String line2 = (String) request.getParameter(ParamLabels.Address.LINE_2);
		String city = (String) request.getParameter(ParamLabels.Address.CITY);
		AddressState state = getAddressStateParam(request);
		String zipcode = (String) request.getParameter(ParamLabels.Address.ZIP_CODE);
		
		AddressBean address = new AddressBean(id, line1, line2, city, state, zipcode);
		
		return address;
	}

	/**
	 * return id parameter from request or default value if
	 * (id param is missing or it's not numeric)
	 * @param request
	 * @param paramName
	 * @param defaultValue
	 * @return
	 */
	protected long getIdParam(HttpServletRequest request, String paramName, long defaultValue) {
		long id = defaultValue;
		try {
			String stringId = (String) request.getParameter(paramName);
			id = Long.parseLong(stringId);
		} catch (NumberFormatException e) {
			
		}
		return id;
	}

	/**
	 * wrapper around exceptions. return role or null
	 * @param request
	 * @return
	 */
	protected AccountRole getAccountRoleParam(HttpServletRequest request) {
		AccountRole role = null;
		try {
			role = AccountRole.valueOf((String) request.getParameter(ParamLabels.Account.ROLE));
		} catch (IllegalArgumentException | NullPointerException e){
			
		}
		return role;
	}
	
	/**
	 * wrapper around exception
	 * @param request
	 * @return
	 */
	protected AddressState getAddressStateParam(HttpServletRequest request) {
		AddressState state = null;
		try {
			state = AddressState.valueOf((String) request.getParameter(ParamLabels.Address.STATE));
		} catch (IllegalArgumentException | NullPointerException e){
			
		}
		return state;
	}

	/**
	 * wrapper around exception
	 * @param request
	 * @return
	 */
	protected MenuItemCategory getCategoryParam(HttpServletRequest request) {
		MenuItemCategory category = null;
		try {
			category = MenuItemCategory.valueOf((String) request.getParameter(ParamLabels.MenuItem.ITEM_CATEGORY));
		} catch (IllegalArgumentException | NullPointerException e) {
		}
		return category;
	}
	
	
	/**
	 * wrapper around exception.
	 * @param request
	 * @param doubleValue
	 * @param defaultValue
	 * @return
	 */
	protected double getDoubleParam(HttpServletRequest request, String paramName, double defaultValue) {
		double value = defaultValue;
		try {
			value = Double.parseDouble((String) request.getParameter(paramName));
		} catch (NumberFormatException | NullPointerException e) {
			
		}
		return value;
	}
}
