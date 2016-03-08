<nav class="nav-container">
	<div class="nav-content"> 
		<div id="appname">
			Restaurant App
		</div>
		
		<div id="home">
			<img class="icon" alt="icon" src="${pageContext.request.contextPath}/icons/ic_home_white_36px.svg"
				onclick="location.href = '<%=response.encodeURL(getServletContext().getContextPath() + "/login") %>'"
			>
		</div>
		
		<div class="nav-dropdown">
			<img alt="account icon" src="${pageContext.request.contextPath}/icons/ic_account_circle_white_36px.svg">
			<div class="nav-dropdown-content">
				<div class="nav-dropdown-option">
					<img class="icon" alt="icon" src="${pageContext.request.contextPath}/icons/ic_autorenew_black_18px.svg">
					<a href="<%= response.encodeURL(getServletContext().getContextPath() + "/account/update") %>"> Edit Account </a>
				</div>

				<div class="nav-dropdown-option">
					<img class="icon" alt="icon" src="${pageContext.request.contextPath}/icons/ic_exit_to_app_black_18px.svg">
					<a href="<%= response.encodeURL(getServletContext().getContextPath() + "/logout") %>"> Logout </a>
				</div>
			</div>
		</div>
	</div>
</nav>