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
		
		order.setId(getIdFromRequest(request, ParamLabels.Order.ID, 0));
		order.setType(getOrderTypeFromRequest(request));
		order.setStatus(getOrderStatusFromRequest(request));
		order.setConfirmation(request.getParameter(ParamLabels.Order.CONFIRMATION));
		order.setPayment(getPaymentFromRequest(request));
		if (order.getId() == 0)
			order.setOrderItems(getOrderItemsFromRequest(request, true));
		else
			order.setOrderItems(getOrderItemsFromRequest(request, false));
		
		// set address (if delivery order)
		if (order.getType() != null && order.getType() == OrderType.DELIVERY)
			order.setAddress(getAddressFromRequest(request));
		
		// set order payment total
		OrderItemBean[] items = order.getOrderItems();
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
		return new AccountBean(getCredentialsFromRequest(request), getUserFromRequest(request), getAccountRoleFromRequest(request));		
	}
	
	/**
	 * create a menu item bean for request parameters
	 * use isValidMenuItemBean() to validate the returned bean
	 * @param request
	 * @return
	 */
	protected MenuItemBean getMenuItemFromRequest(HttpServletRequest request) {
		MenuItemBean menuItem = new MenuItemBean();
		
		menuItem.setId(getIdFromRequest(request, ParamLabels.MenuItem.ID, 0));
		menuItem.setName(request.getParameter(ParamLabels.MenuItem.NAME));
		menuItem.setDescription(request.getParameter(ParamLabels.MenuItem.DESC));
		menuItem.setPrice(getDoubleFromRequest(request, ParamLabels.MenuItem.PRICE, 0));
		menuItem.setItemCategory(getCategoryFromRequest(request));
		
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
	protected long getIdFromRequest(HttpServletRequest request, String paramName, long defaultValue) {
		long id = defaultValue;
		try {
			String stringId = request.getParameter(paramName);
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
		isValid  = isValid? isValidPaymentBean(order.getPayment(), isNewOrder) : false;

		if (isValid && order.getType() == OrderType.DELIVERY) {
			boolean isNewAddress = order.getAddress().getId() == 0;
			isValid = isValidAddressBean(order.getAddress(), isNewAddress);			
		}
		
		if (isValid) {
			// validate each order item
			for(OrderItemBean oItem: order.getOrderItems()) {
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
		
		payment.setId(getIdFromRequest(request, ParamLabels.Payment.ID, 0));
		payment.setType(getPaymentTypeFromRequest(request));
	
		if (payment.getType() != null && payment.getType() == PaymentType.CREDIT_CARD) {
			payment.setCreditCard(getCreditCardFromRequest(request));
			payment.setTransactionConfirmation(request.getParameter(ParamLabels.Payment.CC_TRANSACTION_CONFIRMATION));
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
		
		creditCard.setCcNumber(request.getParameter(ParamLabels.CreditCard.NUMBER));
		creditCard.setCcHolderName(request.getParameter(ParamLabels.CreditCard.HOLDER_NAME));
		creditCard.setExpMonth(getIntFromRequest(request, ParamLabels.CreditCard.EXP_MONTH, 0));
		creditCard.setExpYear(getIntFromRequest(request, ParamLabels.CreditCard.EXP_YEAR, 0));
		
		return creditCard;
	}
	
	/**
	 * return orderItem beans from request parameters
	 * @param request
	 * @return
	 */
	private OrderItemBean[] getOrderItemsFromRequest(HttpServletRequest request, boolean isNewOrder) {
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
			
			int quantity = getIntFromRequest(request, quantityParamName, 0);
			OrderItemStatus status = getOrderItemStatusFromRequest(request, statusParamName);
			if (status != null) {
				boolean addToOrder = isNewOrder? (quantity > 0) : true;
				if (addToOrder) {
					orderItems.add(new OrderItemBean(menuItem, quantity, status));
				}					
			}
		}
		
		return orderItems.toArray(new OrderItemBean[orderItems.size()]);
	}
	
	/**
	 * return credentials bean from request parameters
	 * @param request
	 * @return
	 */
	private CredentialsBean getCredentialsFromRequest(HttpServletRequest request) {
		CredentialsBean credentials = new CredentialsBean();
		
		credentials.setUsername(request.getParameter(ParamLabels.Credentials.USERNAME));
		credentials.setPassword(request.getParameter(ParamLabels.Credentials.PASSWORD));
		
		return credentials;
	}
	
	/**
	 * return user bean from request parameters
	 * @param request
	 * @return
	 */
	private UserBean getUserFromRequest(HttpServletRequest request) {
		UserBean user = new UserBean();
		
		user.setId(getIdFromRequest(request, ParamLabels.User.ID, 0));
		user.setFirstName(request.getParameter(ParamLabels.User.F_NAME));
		user.setLastName(request.getParameter(ParamLabels.User.L_NAME));
		user.setEmail(request.getParameter(ParamLabels.User.EMAIL));
		user.setPhone(request.getParameter(ParamLabels.User.PHONE));
		user.setAddress(getAddressFromRequest(request));
		
		return user;
	}

	/**
	 * return address bean from request parameter
	 * @param request
	 * @return
	 */
	private AddressBean getAddressFromRequest(HttpServletRequest request) {
		AddressBean address = new AddressBean();
		
		address.setId(getIdFromRequest(request, ParamLabels.Address.ID, 0));
		address.setLine1(request.getParameter(ParamLabels.Address.LINE_1));
		address.setLine2(request.getParameter(ParamLabels.Address.LINE_2));
		address.setCity(request.getParameter(ParamLabels.Address.CITY));
		address.setState(getAddressStateFromRequest(request));
		address.setZipcode(request.getParameter(ParamLabels.Address.ZIP_CODE));
		
		if (address.getLine2() != null && address.getLine2().length() == 0)
			address.setLine2(null);
		
		return address;
	}
	
	/**
	 * wrapper around exceptions.
	 * @param request
	 * @param doubleValue
	 * @param defaultValue
	 * @return
	 */
	private double getDoubleFromRequest(HttpServletRequest request, String paramName, double defaultValue) {
		double value = defaultValue;
		try {
			value = Double.parseDouble(request.getParameter(paramName));
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
	private int getIntFromRequest(HttpServletRequest request, String paramName, int defaultValue) {
		int value = defaultValue;
		try {
			value = Integer.parseInt(request.getParameter(paramName));
		} catch (Exception e) {
			
		}
		return value;
	}
	
	/**
	 * wrapper around exceptions. return role or null
	 * @param request
	 * @return
	 */
	private AccountRole getAccountRoleFromRequest(HttpServletRequest request) {
		AccountRole role = null;
		try {
			role = AccountRole.valueOf(request.getParameter(ParamLabels.Account.ROLE));
		} catch (Exception e){
			
		}
		return role;
	}
	
	/**
	 * wrapper around exception
	 * @param request
	 * @return
	 */
	private AddressState getAddressStateFromRequest(HttpServletRequest request) {
		AddressState state = null;
		try {
			state = AddressState.valueOf(request.getParameter(ParamLabels.Address.STATE));
		} catch (Exception e){
			
		}
		return state;
	}

	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private MenuItemCategory getCategoryFromRequest(HttpServletRequest request) {
		MenuItemCategory category = null;
		try {
			category = MenuItemCategory.valueOf(request.getParameter(ParamLabels.MenuItem.ITEM_CATEGORY));
		} catch (Exception e) {
		}
		return category;
	}
	
	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private OrderStatus getOrderStatusFromRequest(HttpServletRequest request) {
		OrderStatus status = null;
		try {
			status = OrderStatus.valueOf(request.getParameter(ParamLabels.Order.STATUS));
		} catch (Exception e) {
		}
		
		return status;
	}

	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private OrderType getOrderTypeFromRequest(HttpServletRequest request) {
		OrderType type = null;
		try {
			type = OrderType.valueOf(request.getParameter(ParamLabels.Order.TYPE));
		} catch (Exception e) {
		}
		
		return type;
	}
	
	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private OrderItemStatus getOrderItemStatusFromRequest(HttpServletRequest request, String paramName) {
		OrderItemStatus status = null;
		try {
			status = OrderItemStatus.valueOf(request.getParameter(paramName));
		} catch (Exception e) {
		}
		
		return status;
	}
	
	/**
	 * wrapper around exceptions
	 * @param request
	 * @return
	 */
	private PaymentType getPaymentTypeFromRequest(HttpServletRequest request) {
		PaymentType type = null;
		try {
			type = PaymentType.valueOf(request.getParameter(ParamLabels.Payment.TYPE));
		} catch (Exception e) {
		}
		
		return type;
	}

}
