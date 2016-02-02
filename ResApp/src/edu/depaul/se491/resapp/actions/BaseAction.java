package edu.depaul.se491.resapp.actions;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import edu.depaul.se491.beans.AccountBean;
import edu.depaul.se491.beans.AddressBean;
import edu.depaul.se491.beans.CredentialsBean;
import edu.depaul.se491.beans.CreditCardBean;
import edu.depaul.se491.beans.MenuItemBean;
import edu.depaul.se491.beans.OrderBean;
import edu.depaul.se491.beans.OrderItemBean;
import edu.depaul.se491.beans.PaymentBean;
import edu.depaul.se491.beans.UserBean;
import edu.depaul.se491.enums.AccountRole;
import edu.depaul.se491.enums.AddressState;
import edu.depaul.se491.enums.MenuItemCategory;
import edu.depaul.se491.enums.OrderItemStatus;
import edu.depaul.se491.enums.OrderStatus;
import edu.depaul.se491.enums.OrderType;
import edu.depaul.se491.enums.PaymentType;
import edu.depaul.se491.utils.ParamLabels;
import edu.depaul.se491.validators.AccountValidator;
import edu.depaul.se491.validators.AddressValidator;
import edu.depaul.se491.validators.CreditCardValidator;
import edu.depaul.se491.validators.MenuItemValidator;
import edu.depaul.se491.validators.OrderItemValidator;
import edu.depaul.se491.validators.OrderValidator;
import edu.depaul.se491.validators.PaymentValidator;
import edu.depaul.se491.validators.UserValidator;
import edu.depaul.se491.ws.clients.MenuServiceClient;

public class BaseAction extends HttpServlet {
	private static final long serialVersionUID = 1L; // ignore this

	protected static final String CORE_APP_URL = "http://localhost/CoreApp";
	protected static final String ACCOUNT_SERVICE_URL = CORE_APP_URL + "/account";
	protected static final String MENUITEM_SERVICE_URL = CORE_APP_URL + "/menuItem";
	protected static final String ORDER_SERVICE_URL = CORE_APP_URL + "/order";
	
	protected static final String LOGIN_JSP_URL = "/login.jsp";

	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	/**
	 * return account bean for the logged in user or null
	 * @param request
	 * @return
	 * @throws ServletException
	 * @throws IOException
	 */
	protected AccountBean getLoggedinAccount(HttpServletRequest request) {
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
	
	/**
	 * create an Order bean from request parameters
	 * use isValidOrderBean() to validate the returned bean
	 * @param request
	 * @return
	 */
	protected OrderBean getOrderFromRequest(HttpServletRequest request) {
		OrderBean order = new OrderBean();
		
		order.setId(getIdParam(request, ParamLabels.Order.ID, 0));
		order.setType(getOrderTypeParam(request));
		order.setStatus(getOrderStatusParam(request));
		order.setConfirmation((String) request.getParameter(ParamLabels.Order.CONFIRMATION));
		order.setPayment(getPaymentFromRequest(request));
		order.setItems(getOrderItemsFromRequest(request));
		
		// set address (if delivery order)
		if (order.getType() != null && order.getType() == OrderType.DELIVERY)
			order.setAddress(getAddressBean(request));
		
		// set order payment total
		List<OrderItemBean> items = order.getItems();
		PaymentBean payment = order.getPayment();
		if (items != null && payment != null) {
			double total = 0;
			for (OrderItemBean oItem: items)
				total += (oItem.getQuantity() * oItem.getMenuItem().getPrice());
			payment.setTotal(total);
		}
		
		return order;
	}
	
	
	/**
	 * create an Account bean from request parameters
	 * use isValidAccountBean() to validate the returned bean
	 * @param request
	 * @return
	 */
	protected AccountBean getAccountFromRequest(HttpServletRequest request) {
		return new AccountBean(getCredentialsBean(request), getUserBean(request), getAccountRoleParam(request));		
	}
	
	/**
	 * create a menu item bean for request parameters
	 * use isValidMenuItemBean() to validate the returned bean
	 * @param request
	 * @return
	 */
	protected MenuItemBean getMenuItemFromRequest(HttpServletRequest request) {
		MenuItemBean menuItem = new MenuItemBean();
		
		menuItem.setId(getIdParam(request, ParamLabels.MenuItem.ID, 0));
		menuItem.setName((String) request.getParameter(ParamLabels.MenuItem.NAME));
		menuItem.setDescription((String) request.getParameter(ParamLabels.MenuItem.DESC));
		menuItem.setPrice(getDoubleParam(request, ParamLabels.MenuItem.PRICE, 0));
		menuItem.setItemCategory(getCategoryParam(request));
		
		return menuItem;
	}
	
	/**
	 * return id parameter from request or default value if
	 * (id param is missing or it's not numeric)
	 * the returned id may still be invalid ( < 0 ) so use
	 * specific validator to validate the id if you're only
	 * using the id (example, orderId or menuItemId)
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
		} catch (NumberFormatException | NullPointerException e) {
			
		}
		return id;
	}
	
	/**
	 * validate order bean
	 * @param order
	 * @param isNewOrder
	 * @return
	 */
	protected boolean isValidOrderBean(OrderBean order, boolean isNewOrder) {
		boolean isValid = false;
		
		isValid  = new OrderValidator().validate(order, isNewOrder);
		isValid &= isValid? isValidPaymentBean(order.getPayment(), isNewOrder) : false;

		if (isValid)
			isValid &= order.getType() == OrderType.DELIVERY? isValidAddressBean(order.getAddress(), isNewOrder) : true;			
		
		if (isValid) {
			// validate each order item
			for(OrderItemBean oItem: order.getItems()) {
				isValid &= isValidOrderItemBean(oItem);
			}
		}
		
		return isValid;
	}

	
	/**
	 * validate account bean
	 * @param account
	 * @param isNewAccount
	 * @return
	 */
	protected boolean isValidAccountBean(AccountBean account, boolean isNewAccount) {
		boolean isValid = false;
		isValid  = new AccountValidator().validate(account);
		isValid &= isValid? isValidUserBean(account.getUser(), isNewAccount) : false;
		
		return isValid;
	}
	
	
	/**
	 * validate menu item bean
	 * @param menuItem
	 * @param isNewMenuItem
	 * @return
	 */
	protected boolean isValidMenuItemBean(MenuItemBean menuItem, boolean isNewMenuItem) {
		return new MenuItemValidator().validate(menuItem, isNewMenuItem);
	}
	
	/**
	 * validate user bean
	 * @param user
	 * @param isNewUser
	 * @return
	 */
	private boolean isValidUserBean(UserBean user, boolean isNewUser) {
		boolean isValid = false;
		isValid  = new UserValidator().validate(user, isNewUser);
		isValid &= isValid? isValidAddressBean(user.getAddress(), isNewUser): false;
		
		return isValid;
	}
	
	/**
	 * validate address bean
	 * @param address
	 * @param isNewAddress
	 * @return
	 */
	private boolean isValidAddressBean(AddressBean address, boolean isNewAddress) {
		return new AddressValidator().validate(address, isNewAddress);
	}
	
	/**
	 * validate payment bean
	 * @param paymentBean
	 * @param isNewPayment
	 * @return
	 */
	private boolean isValidPaymentBean(PaymentBean paymentBean, boolean isNewPayment) {
		boolean isValid = false;
		
		isValid = new PaymentValidator().validate(paymentBean, isNewPayment);
		if (isValid && isNewPayment) {
			if (paymentBean.getType() == PaymentType.CREDIT_CARD)
				isValid &= isValidCreditCardBean(paymentBean.getCreditCard());			
		}
		return isValid;
	}
	
	/**
	 * validate a credit card bean
	 * @param creditCard
	 * @return
	 */
	private boolean isValidCreditCardBean(CreditCardBean creditCard) {
		return new CreditCardValidator().validate(creditCard);
	}
	
	/**
	 * validate order item bean
	 * @param orderItem
	 * @return
	 */
	private boolean isValidOrderItemBean(OrderItemBean orderItem) {
		boolean isValid = false;
		isValid = new OrderItemValidator().validate(orderItem);
		isValid &= isValid? isValidMenuItemBean(orderItem.getMenuItem(), false) : false;
		
		return isValid;
	}
	
	/**
	 * return payment bean from request parameters
	 * @param request
	 * @return
	 */
	private PaymentBean getPaymentFromRequest(HttpServletRequest request) {
		PaymentBean payment = new PaymentBean();
		
		payment.setId(getIdParam(request, ParamLabels.Payment.ID, 0));
		payment.setType(getPaymentTypeParam(request));
	
		if (payment.getType() != null && payment.getType() == PaymentType.CREDIT_CARD) {
			payment.setCreditCard(getCreditCardFromRequest(request));
			payment.setTransactionConfirmation((String) request.getParameter(ParamLabels.Payment.CC_TRANSACTION_CONFIRMATION));
		}
		
		return payment;
	}
	
	/**
	 * return credit card bean from request parameters
	 * @param request
	 * @return
	 */
	private CreditCardBean getCreditCardFromRequest(HttpServletRequest request) {
		CreditCardBean creditCard = new CreditCardBean();
		
		creditCard.setCcNumber((String) request.getParameter(ParamLabels.CreditCard.CC_NUMBER));
		creditCard.setCcHolderName((String) request.getParameter(ParamLabels.CreditCard.CC_HOLDER_NAME));
		creditCard.setExpMonth(getIntParam(request, ParamLabels.CreditCard.CC_EXP_MONTH, 0));
		creditCard.setExpYear(getIntParam(request, ParamLabels.CreditCard.CC_EXP_YEAR, 0));
		
		return creditCard;
	}
	
	/**
	 * return orderItem beans from request parameters
	 * @param request
	 * @return
	 */
	private List<OrderItemBean> getOrderItemsFromRequest(HttpServletRequest request) {
		AccountBean loggedinAccount = getLoggedinAccount(request);
		if (loggedinAccount == null)
			return null;
		
		MenuServiceClient serviceClient = new MenuServiceClient(loggedinAccount.getCredentials(), MENUITEM_SERVICE_URL);
		MenuItemBean[] menu = serviceClient.getAll();
		
		List<OrderItemBean> orderItems = new ArrayList<OrderItemBean>();
		
		for (MenuItemBean menuItem: menu) {
			long mItemId = menuItem.getId();
			
			String quantityParamName = String.format("%s-%d", ParamLabels.OrderItem.QUANTITY, mItemId);
			String statusParamName = String.format("%s-%d", ParamLabels.OrderItem.STATUS, mItemId);
			
			int quantity = getIntParam(request, quantityParamName, 0);
			OrderItemStatus status = getOrderItemStatusParam(request, statusParamName);
			if (quantity > 0) {
				orderItems.add(new OrderItemBean(menuItem, quantity, status));
			}	
		}
		
		return orderItems;
	}
	
	/**
	 * return credentials bean from request parameters
	 * @param request
	 * @return
	 */
	private CredentialsBean getCredentialsBean(HttpServletRequest request) {
		CredentialsBean credentials = new CredentialsBean();
		
		credentials.setUsername((String) request.getParameter(ParamLabels.Credentials.USERNAME));
		credentials.setPassword((String) request.getParameter(ParamLabels.Credentials.PASSWORD));
		
		return credentials;
	}
	
	/**
	 * return user bean from request parameters
	 * @param request
	 * @return
	 */
	private UserBean getUserBean(HttpServletRequest request) {
		UserBean user = new UserBean();
		
		user.setId(getIdParam(request, ParamLabels.User.ID, 0));
		user.setFirstName((String) request.getParameter(ParamLabels.User.F_NAME));
		user.setLastName((String) request.getParameter(ParamLabels.User.L_NAME));
		user.setEmail((String) request.getParameter(ParamLabels.User.EMAIL));
		user.setPhone((String) request.getParameter(ParamLabels.User.PHONE));
		user.setAddress(getAddressBean(request));
		
		return user;
	}

	/**
	 * return address bean from request parameter
	 * @param request
	 * @return
	 */
	private AddressBean getAddressBean(HttpServletRequest request) {
		AddressBean address = new AddressBean();
		
		address.setId(getIdParam(request, ParamLabels.Address.ID, 0));
		address.setLine1((String) request.getParameter(ParamLabels.Address.LINE_1));
		address.setLine2((String) request.getParameter(ParamLabels.Address.LINE_2));
		address.setCity((String) request.getParameter(ParamLabels.Address.CITY));
		address.setState(getAddressStateParam(request));
		address.setZipcode((String) request.getParameter(ParamLabels.Address.ZIP_CODE));
		
		return address;
	}
	
	/**
	 * wrapper around exceptions.
	 * @param request
	 * @param doubleValue
	 * @param defaultValue
	 * @return
	 */
	private double getDoubleParam(HttpServletRequest request, String paramName, double defaultValue) {
		double value = defaultValue;
		try {
			value = Double.parseDouble((String) request.getParameter(paramName));
		} catch (Exception e) {	
		}
		return value;
	}
	
	/**
	 * wrapper around exceptions
	 * @param request
	 * @param paramName
	 * @param defaultValue
	 * @return
	 */
	private int getIntParam(HttpServletRequest request, String paramName, int defaultValue) {
		int value = defaultValue;
		try {
			value = Integer.parseInt((String) request.getParameter(paramName));
		} catch (Exception e) {
			
		}
		return value;
	}
	
	/**
	 * wrapper around exceptions. return role or null
	 * @param request
	 * @return
	 */
	private AccountRole getAccountRoleParam(HttpServletRequest request) {
		AccountRole role = null;
		try {
			role = AccountRole.valueOf((String) request.getParameter(ParamLabels.Account.ROLE));
		} catch (Exception e){
			
		}
		return role;
	}
	
	/**
	 * wrapper around exception
	 * @param request
	 * @return
	 */
	private AddressState getAddressStateParam(HttpServletRequest request) {
		AddressState state = null;
		try {
			state = AddressState.valueOf((String) request.getParameter(ParamLabels.Address.STATE));
		} catch (Exception e){
			
		}
		return state;
	}

	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private MenuItemCategory getCategoryParam(HttpServletRequest request) {
		MenuItemCategory category = null;
		try {
			category = MenuItemCategory.valueOf((String) request.getParameter(ParamLabels.MenuItem.ITEM_CATEGORY));
		} catch (Exception e) {
		}
		return category;
	}
	
	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private OrderStatus getOrderStatusParam(HttpServletRequest request) {
		OrderStatus status = null;
		try {
			status = OrderStatus.valueOf((String) request.getParameter(ParamLabels.Order.STATUS));
		} catch (Exception e) {
		}
		
		return status;
	}

	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private OrderType getOrderTypeParam(HttpServletRequest request) {
		OrderType type = null;
		try {
			type = OrderType.valueOf((String) request.getParameter(ParamLabels.Order.TYPE));
		} catch (Exception e) {
		}
		
		return type;
	}
	
	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private OrderItemStatus getOrderItemStatusParam(HttpServletRequest request, String paramName) {
		OrderItemStatus status = null;
		try {
			status = OrderItemStatus.valueOf((String) request.getParameter(paramName));
		} catch (Exception e) {
		}
		
		return status;
	}
	
	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private PaymentType getPaymentTypeParam(HttpServletRequest request) {
		PaymentType type = null;
		try {
			type = PaymentType.valueOf((String) request.getParameter(ParamLabels.Payment.TYPE));
		} catch (Exception e) {
		}
		
		return type;
	}

}
