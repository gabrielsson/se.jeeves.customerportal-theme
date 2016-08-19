<%@ include file="../init.jsp"%>
<%@page import="se.jeeves.customerportal.cart.CartWrapupPreferences"%>
<% portletDisplay.setShowBackIcon(false);

/**
This is how a portlet back url would be set so it is suitable for our portlets 

if (portletDisplay.isShowBackIcon()){
	
	PortletURL portletBackUrl = renderResponse.createRenderURL();
	
	portletBackUrl.setPortletMode(PortletMode.VIEW);
	portletBackUrl.setWindowState(WindowState.NORMAL);
	portletDisplay.setURLBack(portletBackUrl.toString());
}
*/
Boolean orderUnique = (Boolean)renderRequest.getAttribute("orderUnique");
if(orderUnique==null){
	orderUnique=false;
}


String waitMsg = messageSource.getMessage("cart-VIEW-order-process-STRING", null,"***Order is processing", locale);

pageContext.setAttribute("waitMsg", waitMsg);

CartWrapupPreferences prefs = (CartWrapupPreferences) renderRequest.getAttribute("prefs");
Boolean bActivateAcceptConf = prefs.getAcceptCond();
if(bActivateAcceptConf==null){
	bActivateAcceptConf=false;
}
PortletURL renderUrl = renderResponse.createRenderURL();
renderUrl.setWindowState(LiferayWindowState.EXCLUSIVE);
renderUrl.setParameter("action", "popupConfirm");
renderUrl.setParameter("popup","cart/accept-conf");

String sAcceptConfirm = renderResponse.getNamespace()+"popupConfirm('"+renderUrl.toString()+"');return false;";
// boolean bOk2Buy = JeevesSessionUtil.getAllowed2Buy(portletSession);
boolean bOk2Buy = true;
%>

<script language="JavaScript">
jQuery(document).ready(function(){
	<%if(bActivateAcceptConf || !bOk2Buy){%>
		jQuery('input[id="<portlet:namespace/>confirmButton"]').attr("disabled", 'disabled');
	<%}%>
});

function tryAcceptConditionCheck(){
	<%if(!bOk2Buy){%>
		jQuery('input[id="<portlet:namespace/>confirmButton"]').attr("disabled", 'disabled');
	<%}else{%>
		if(jQuery('input[id="<portlet:namespace/>acceptCondition"]').attr('checked')){
			jQuery('input[id="<portlet:namespace/>confirmButton"]').removeAttr('disabled');
		}else{
			jQuery('input[id="<portlet:namespace/>confirmButton"]').attr('disabled', 'disabled');
		}
	<%}%>
}

function <portlet:namespace />popupConfirm(url){
	var popup = Liferay.Popup(
			{
				title: '<spring:message code="cart-POPUP-confirm-accept-HEAD" text="Terms & conditions"/>',
				modal:true,
				width:400,
				position: ['center', 100]
			
			}
		);
		jQuery(popup).load(url);
}
</script>

<portlet:actionURL var="theUrl">
	<portlet:param name="action" value="checkout"/>
</portlet:actionURL>
<portlet:actionURL var="changeDeliveryAddressURL">
	<portlet:param name="action" value="changeDeliveryAddress"/>
</portlet:actionURL>

<c:set var="continueShoppingURL" value="${themeDisplay.URLHome}/${prefs.continueFriendlyUrl}"></c:set>

	


<div class="order-info row-fluid">
	<div class="span6">	
		<form:form action="${theUrl}" id="<%=renderResponse.getNamespace() + \"wrapup\" %>" name="wrapup" method="post" modelAttribute="orderRequest" cssClass="form-horizontal">
				
					<legend>
						<spring:message code="cart-VIEW-delivery-address-LEGEND" text="Point of delivery"/>
					</legend>
		
					<jis:form-select cid="podId" idFieldName="Id" descriptionFieldName="Name" 
					key="cart-VIEW-pods-SELECT" clabel="Delivery Address" size="30" />
			
			<legend><spring:message code="cart-VIEW-order-unique-LEGEND" text="Order unique point of delivery"/></legend>
				<div class="control-group">
					<div class="controls">
						<label class="checkbox" for="<portlet:namespace/>orderUniqueCheckbox">
							<%if(orderUnique) {%>
							<input id="<portlet:namespace/>orderUniqueCheckbox" name="<portlet:namespace/>orderUniqueCheckbox" type="checkbox" checked="true"/>
							<%} else { %>
							<input id="<portlet:namespace/>orderUniqueCheckbox" name="<portlet:namespace/>orderUniqueCheckbox" type="checkbox" />
							<%}%>
						<spring:message code="cart-VIEW-order-unique-CHECKBOX" text="Order unique"/>
						</label>
					</div>
				</div>
				<div id="<portlet:namespace/>podInputs">
					<jis:form-input 	cid="Name"			key="cart-VIEW-pod-name-INPUT"			clabel="Company name" 	size="30"	mandatory="true" ></jis:form-input>
					<jis:form-input 	cid="CoName"		key="cart-VIEW-co-address-INPUT"		clabel="C/O Address" 	size="30"	mandatory="false" ></jis:form-input>
					<jis:form-input 	cid="Street"	key="cart-VIEW-street-address-INPUT"	clabel="Street Address" size="30"	mandatory="true"></jis:form-input>
					<jis:form-input 	cid="City"	key="cart-VIEW-city-INPUT"				clabel="City" 			size="15"	mandatory="true"></jis:form-input>
					<jis:form-input 	cid="PostalCode"		key="cart-VIEW-postal-code-INPUT"		clabel="Postal Code" 	size="7"	mandatory="true"></jis:form-input> 
					<jis:form-select 	cid="countryCode"	key="cart-VIEW-country-SELECT"			clabel="Country" 		size="30"	mandatory="false" idFieldName="code" descriptionFieldName="description"></jis:form-select>
				</div>
				
			
	</div>	
	<div class="span6">	
			<fieldset class="form-horizontal">
				<legend>				
					<c:if test="<%= JeevesSessionUtil.getCartOrderNo(portletSession)!=null%>">
						<b><spring:message code="cart-VIEW-order-number-STRING" text="Order number"/> - <%= JeevesSessionUtil.getCartOrderNo(portletSession)%></b>
					</c:if>
				</legend>
					
				<jis:form-input size="30" 
					clabel="Your reference"
					key="cart-VIEW-your-reference-INPUT"
					cid="yourReference"></jis:form-input>
								
				<jis:form-input size="30"
					clabel="Goods label"
					key="cart-VIEW-goods-label-INPUT" 
					cid="goodsLabel"></jis:form-input>
							
				<jis:form-input size="30" 
					clabel="Your order ID"
					key="cart-VIEW-your-order-id-INPUT" 
					cid="customerOrderNumber"></jis:form-input>
					
				<jis:form-select cid="partDeliveryAllowed" size="30" 
					clabel="Part Delivery Allowed"
					key="cart-VIEW-part-delivery-allowed-SELECT"
					idFieldName="code" descriptionFieldName="description"/>
	
				<c:if test="${hasDispatchMethods}">
					<jis:form-select cid="dispatchMethod" size="30" 
						clabel="Dispatch method"
						key="cart-VIEW-dispatch-method-SELECT"
						idFieldName="code" descriptionFieldName="description"/>
				</c:if>
				<div class="control-group">
					<label class="control-label"  for="externalText"><spring:message code="cart-VIEW-text-edit-TEXTAREA" text="Order Message"/></label>
					<div class="controls"><form:textarea path="externalText" rows="5" cols="50" /></div>
				</div>
			</fieldset>
			<c:if test='<%=!"".equals(renderRequest.getAttribute("payTypes"))%>'>
				<fieldset class="form-horizontal">
						<legend><spring:message code="cart-VIEW-payment-options-LEGEND" text="Payment options"/></legend>
						<%
							String sChecked = "CHECKED";
							String sPaytypes = (String)renderRequest.getAttribute("payTypes");
							String[] sPaytypesArr = sPaytypes.split(";");
							String sOptions = "";
							if(!sPaytypes.trim().equals("") && sPaytypesArr.length > 0){
								for(int n = 0; n < sPaytypesArr.length;n++){
									String[] sCardTypeArr = sPaytypesArr[n].split("=");
									if(sCardTypeArr.length == 2){	
						%>
										<input type="radio" <%=sChecked%> id="<portlet:namespace/>PayType_<%=sCardTypeArr[0]%>" name="PayType" value="<%=sCardTypeArr[0]%>">
										<spring:message code="cart-EDIT-confirm-paytype-text-<%=sCardTypeArr[0]%>" text="<%=sCardTypeArr[1]%>"/><br>
						<%
										sChecked = "";
									}
								}
							}
						%>
				</fieldset>	
			</c:if>
			<%if(bActivateAcceptConf){%>
			<div>
				<input type="checkbox" id="<portlet:namespace/>acceptCondition" onClick="tryAcceptConditionCheck();">
				<spring:message code="cart-EDIT-confirm-accept-cond-CHECKBOX" text="I have read and accepted the terms & conditions."/>
				<a href="" onClick="<%=sAcceptConfirm%>"><spring:message code="cart-EDIT-confirm-accept-cond-LINK" text=" Read the terms & conditions."/></a>
				<c:set var="acceptConfirm" value="DISABLED=DISABLED"/>
			</div>
			<%}%>
			<div class="form-actions">
			
				<button class="btn" type="button" onclick="location.href='${continueShoppingURL}'" value="<spring:message code="cart-VIEW-continue-shopping-BUTTON" text="Continue Shopping"/>"><spring:message code="cart-VIEW-continue-shopping-BUTTON" text="Continue Shopping"/></button>
				<button class="btn btn-primary" id="<portlet:namespace/>confirmButton" type="submit" class="submit" value="<spring:message code="cart-VIEW-confirm-BUTTON" text="Confirm"/>" ${acceptConfirm} ><spring:message code="cart-VIEW-confirm-BUTTON" text="Confirm"/></button>
			</div>
		</form:form>
	</div>
</div>
<script>
jQuery(function(){
	jQuery("select[id='podId']").change(function(){
		jQuery('#<portlet:namespace/>wrapup').attr("action", "${changeDeliveryAddressURL}").submit();
		
	});
	
	function isUniqueChecked() {
		isUniqueCheckedHelper(true);
	}

	function initUniqueChecked(){
		isUniqueCheckedHelper(false);
	}
	function isUniqueCheckedHelper(reload) {

		if (jQuery('input[id="<portlet:namespace/>orderUniqueCheckbox"]').is(':checked')){
			
			jQuery('div[id="<portlet:namespace/>podInputs"] input').removeAttr("disabled");
			jQuery('div[id="<portlet:namespace/>podInputs"] select').removeAttr("disabled");
			<%if(!orderUnique){%>			   
				jQuery('div[id="<portlet:namespace/>podInputs"] input').val("");
				jQuery('div[id="<portlet:namespace/>podInputs"] select').val("");
			<% } %>
			jQuery('select[id="podId"]').attr("disabled", true);
			
		} else {
			jQuery('div[id="<portlet:namespace/>podInputs"] input').attr("disabled", true);
			jQuery('div[id="<portlet:namespace/>podInputs"] select').attr("disabled", true);
			jQuery('select[id="podId"]').removeAttr("disabled");
			if(reload){
				jQuery('#<portlet:namespace/>wrapup').attr("action", "${changeDeliveryAddressURL}").submit();
			}			
		}
	}
	initUniqueChecked();
	jQuery('input[id="<portlet:namespace/>orderUniqueCheckbox"]').click(isUniqueChecked);
});
</script>

