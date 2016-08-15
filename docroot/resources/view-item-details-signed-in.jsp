<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ include file="../init.jsp" %>
<%@ page import="se.jeeves.customerportal.util.JeevesDocumentUtil" %>
<%@ page import="se.jeeves.access.Item" %>

<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>

<%
String id = JeevesSessionUtil.getItemNumber(renderRequest.getPortletSession());

pageContext.setAttribute("allowed2Buy", true);//JeevesUserUtil.getAllowed2Buy(renderRequest.getPortletSession()));
pageContext.setAttribute("showPrice", true); //JeevesSessionUtil.getShowPrice(renderRequest.getPortletSession()));

Item item = (se.jeeves.access.Item) request.getAttribute("item");
String[] items ={item.getItemNumber().toLowerCase()};
Map<String, List<String>> itemDocumentURLMap = JeevesDocumentUtil.getJeevesDocumentUrlsMap(themeDisplay,items);
pageContext.setAttribute("itemDocumentURLMap", itemDocumentURLMap);

List<String> pathList=itemDocumentURLMap.get(item.getItemNumber().toLowerCase());
pageContext.setAttribute("pathList", pathList);
List<String> imagePath = null;
List<String> downloadPath = null;
if(pathList!=null){
	imagePath = new ArrayList<String>();
	downloadPath = new ArrayList<String>();
for (String path : pathList) {
	 String[] pathLsitArray = path.split("\\?");
     if(pathLsitArray[1].equals("image")){
    	 imagePath.add(pathLsitArray[0]);
     }else{
    	 downloadPath.add(path); 
     }
}
}
pageContext.setAttribute("imagePath", imagePath);
pageContext.setAttribute("downloadPath", downloadPath);

%>



<jis:document documentNamesVar="documentNames" documentsVar="documents" itemnumber="<%= id %>"></jis:document>
<div class="hero-unit single-product">
<div id="<portlet:namespace/>errormsg"></div>
<div id="<portlet:namespace/>loading"></div>
<portlet:actionURL var="backActionURL">
	<portlet:param name="action" value="backAction" />
</portlet:actionURL>
<a href="${backActionURL}" class="close-product-button">Close <i class="icon-remove"></i></a>
<c:if test="${fn:length(item.packageItems)>1}">
	<div onMouseOut="document.getElementById('popup').style.display='none';" onMouseOver="document.getElementById('popup').style.display='block';">
			<button class="btn btn-primary icon-info"></button>
	</div>
</c:if>

<div class="results-grid"  id="popup" style="position:absolute;display:none;border: 2px solid rgb(0, 0, 0); z-index: 999;">
	<table class="table table-striped">
		<tr class="portlet-section-header results-header">
			<th class="col-1">
				<spring:message code="itemlist-VIEW-id-TABLEHEADER" text="Item NO.***" />
			</th>
			<th class="col-1">
				<spring:message code="itemlist-VIEW-stock-available" text="Quantity***" />
			</th>
			<th class="col-1">
				<spring:message code="itemlist-VIEW-article-description-STRING" text="Description***" />
			</th>
			<th class="col-1">
				<spring:message code="itemlist-VIEW-in-stock-STRING" text="Quantity in stock***" />
			</th>
		</tr>
		<c:forEach items="${item.packageItems}" var="pItem" varStatus="i">

			<tr class="portlet-section-body-hover results-row alt">

				<td>${pItem.packageItemNumber}</td>
			    <td>${pItem.packageItemQuantity}</td>
			    <td>${pItem.packageItemDescription}</td>
			    <td>${stockMap[pItem.packageItemNumber]}</td>
		    </tr>

		</c:forEach>
		</table>

</div>
<div class="row">
	
<div class="span6 product-images-wrapper">
	<c:if test="${not empty imagePath}">
		<c:set value="<portlet:namespace/>_img" var="imageId" />
			<div id="imageViewer" >
				
				<c:forEach items="${imagePath}" var="imageUrl" varStatus="i">
					
					<div class="carousel-item item-image" style="background:url(${imageUrl}) center center;
  background-size:cover;" >
					</div>
				</c:forEach>
			</div>
	</c:if>
</div>
	
<div class="span6 product-details-wrapper">
<h2 class="product-title">${item.description}</h2>

<p class="price-wrapper">
	<c:if test="${not empty priceMap}">
		<c:choose>
			<c:when test="${fn:length(priceBrackets[item.itemNumber]) > 1}">
			
				<div onMouseOver="document.getElementById('popupitem.getItemNumber()').style.display='block';"
					onMouseOut="document.getElementById('popupitem.getItemNumber()').style.display='none';" />
					${priceMap[item.itemNumber]} SEK
						<button class="btn btn-primary icon-info"></button>
				</div>
				
				
			</c:when>
			<c:otherwise>
				<span class="price">${priceMap[item.itemNumber]} SEK</span>
			</c:otherwise>
		</c:choose>
	</c:if>
</p>

<p class="product-item-number">
<b><spring:message code="itemlist-VIEW-article-itemnumber-STRING" text="Item no" />:</b> ${item.itemNumber}
</p>

<p class="product-stock-wrapper">
	<c:if test="${1 <= item.webpublish && item.webpublish < 3 && showPrice}">
		

		<!-- Set variable itemBrackets to the price brackets for the current item. -->
		<c:set value="${priceBrackets[item.itemNumber]}" var="itemBrackets" />
		<c:if test="${fn:length(itemBrackets) > 1}">
			<div class="results-grid" id="popupitem.getItemNumber()" style="position:absolute;display:none;border: 2px solid rgb(0, 0, 0);z-index:999;">
		      <table class="table table-striped">
			      <tr class="portlet-section-header results-header">
				      <th class="col-1">
				      	<spring:message code="cart-VIEW-quantity-TABLEHEADER" text="Quantity***" />
				      </th>
				      <th class="col-1">
				      	<spring:message code="itemlist-VIEW-price-TABLEHEADER" text="Price***" />
				      </th>
				      <th class="col-1">
				      	<spring:message code="itemlist-VIEW-discount-TABLEHEADER" text="Discount***" />
				      </th>
			      </tr>
			      <c:forEach var="bracket" items="${itemBrackets}" varStatus="i">
			      	<c:choose>
			      		<c:when test="${i.count % 2 == 1}">
			      			<c:set var="altClass" value="portlet-section-body-hover results-row" />

			      		</c:when>
			      		<c:otherwise>
			      			 <c:set var="altClass" value="portlet-section-body-hover results-row alt" />
			      		</c:otherwise>
			      	</c:choose>
			      		<tr class="${altClass}">
				      		<td>
				      			<c:choose>
				      				<c:when test="${i.index == 0 }">
				      		   		  0-
				      		   		</c:when>
				      		   		<c:otherwise>
				      		   		  ${bracket.lowerBound} -
				      		   		</c:otherwise>
				      			</c:choose>
				      			<c:choose>
				      				<c:when test="${i.count < fn:length(itemBrackets)}">
				      		   		  ${itemBrackets[i.count].lowerBound - 1}
				      		   		</c:when>
				      		   		<c:otherwise>
				      		   		  &#8734;
				      		   		</c:otherwise>
				      			</c:choose>
								${item.unit}
							</td>
							<td align="right"> ${bracket.price} ${userSession.userInfo.currency}</td>
				        	<td>${bracket.discount} </td>
						</tr>
			      </c:forEach>
		      </table>
		    </div>
		</c:if>
	</c:if>


<c:if test="${1 <= item.webpublish && item.webpublish < 3}">
	<b><span class="quantity"><spring:message code="itemlist-VIEW-in-stock-STRING" text="In stock***"></spring:message>:</b> ${stockMap[item.itemNumber]} ${item.unit}</span>
</c:if>

<c:if test="${not empty downloadPath}">
<div >
<span style="font-weight: bold;"><spring:message code="admin-EDIT-docs-administration-TAB" text="Documents" ></spring:message></span>
	<ul>
	<%
	for (String path :downloadPath){
	    String[] pathLsitArray = path.split("\\?");
    %>
      <li>
      		<a target="_blank" href="<%=pathLsitArray[0]%>"><%=pathLsitArray[1]%></a>
      </li>
    <%
	}
	%>
	</ul>
</div>
</c:if>
</p>

<p>
<c:if test="${not empty item.specification}">
	<b><spring:message code="itemlist-VIEW-article-specification-STRING" text="Specification***" /></b><br>
	${item.specification}
</c:if>
</p>

<p>
<c:if test="${not empty item.description2}">
	<b><spring:message code="itemlist-VIEW-article-description2-STRING" text="Description2***" /></b><br>
	${item.description2}
</c:if>
</p>



<c:if test="${not empty documentNames}">
<ul>
	<c:forEach items="${documents}" var="document" varStatus="i">
		<li>
		    <a target="_blank" href="${document}">
		 	   ${documentNames[i.count-1]}
		    </a>
	    </li>
	</c:forEach>
</ul>
</c:if>

<c:if test="${not empty item.replacedByItem}">
	<b><spring:message code="itemlist-VIEW-article-replaced-by" text="Item replaced by***" /></b><br>
	<liferay-portlet:actionURL anchor="false" copyCurrentRenderParameters="true"  portletName="${prefs.itemListId}" var="replacedUrl" windowState="<%= WindowState.NORMAL.toString() %>">
		<liferay-portlet:param name="action" value="itemDetails"></liferay-portlet:param>
		<liferay-portlet:param name="itemNumber" value="${item.replacedByItem}"></liferay-portlet:param>

	</liferay-portlet:actionURL>
	<a href=${replacedUrl}>${item.replacedByItem}</a>

</c:if>

<c:if test="${not empty item.replacesItem}">
	<b><spring:message code="itemlist-VIEW-article-replaces" text="Replaces***" /></b><br>
	<liferay-portlet:actionURL anchor="false" copyCurrentRenderParameters="true"  portletName="${prefs.itemListId}" var="replacesUrl" windowState="<%= WindowState.NORMAL.toString() %>">
		<liferay-portlet:param name="action" value="itemDetails"></liferay-portlet:param>
		<liferay-portlet:param name="itemNumber" value="${item.replacesItem}"></liferay-portlet:param>

	</liferay-portlet:actionURL>
	<a href=${replacesUrl}>${item.replacesItem}</a>
</c:if>

<div class="buyBox">
<table>
	<tr>
		<td>
			<c:if test="${item.webpublish == 1}">
				<c:if test="${not empty quantityMap}">
					<c:set value="${quantityMap[item.itemNumber]}" var="qty" />
					<c:if test="${empty qty}">
						<c:set value="1" var="qty" />
					</c:if>
				</c:if>
				<c:choose>
					<c:when test="${not empty item.packageSizeSales && item.packageSizeSales != 0}">
						<c:set value="${item.packageSizeSales}" var="qty" />
					</c:when>
					<c:otherwise>
						<c:set value="1" var="qty" />
					</c:otherwise>
				</c:choose>
				
				<c:if test="${allowed2Buy == false}">
					<c:set value="disabled='disabled' style='color:grey;'" var="sBuyDisabled" />
				</c:if>
								
				<liferay-portlet:resourceURL anchor="false" portletMode="VIEW" portletName="${prefs.itemListId}" var="itemDetailsAddUrl" id="addItem" windowState="<%= WindowState.NORMAL.toString() %>">
					<liferay-portlet:param name="fromPage" value="detail"></liferay-portlet:param>
				</liferay-portlet:resourceURL>	
				  
				<div class="input-append">
   					<input type="text" ${sBuyDisabled} size="4" class="input-mini" id="<portlet:namespace/>quantity" value="${qty}" />
   					<button id="<portlet:namespace/>buy" data-item-number="${item.itemNumber}" class="btn btn-primary" ${sBuyDisabled}>
           				<spring:message code="itemlist-VIEW-article-buy-BUTTON" text="Buy***" /> 
           			</button>			
				</div>
			</c:if>
		</td>
		<td>
				<c:if test="${itemListPreferences.batchActivate == true && item.batch == true}">
					&nbsp;
					<liferay-portlet:renderURL anchor="false" copyCurrentRenderParameters="true"  portletName="${prefs.itemListId}" var="popupBatch" windowState="exclusive">
						<liferay-portlet:param name="action" value="popupBatch" />
						<liferay-portlet:param name="popup" value="itemlist/batch-popup" />
						<liferay-portlet:param name="itemNumber" value="${item.itemNumber}" />
						<liferay-portlet:param name="salt" value="<%= String.valueOf(new Date().getTime()) %>" />
						<liferay-portlet:param name="oldWindowState" value="normal" />
					</liferay-portlet:renderURL>
					<a href="" onclick="<portlet:namespace/>popupBatch('${popupBatch}');return false;" />
						<liferay-ui:icon image="manage_task" message='<%= messageSource.getMessage("itemlist-POPUPBATCH-buy-batch-BUTTON",null, locale) %>'></liferay-ui:icon>
					</a>
				</c:if>
			</td>
		</tr>
	</table>
	
	
</div>

</div>

</div>
</div> <!-- hero unit -->


<style>
.item-image {
 	height: 400px;
 	width: 400px;
}  
</style>


<script>
AUI().use(
	'aui-carousel','aui-node',
	function(A) {
		var imageViewer = A.one("#imageViewer");
		if( imageViewer ) {
			new A.Carousel({
				contentBox: imageViewer,
				height: 400,
				width: 400	
			}).render();
		}
  }
);
AUI().use("aui-io-request", 
        'aui-node',
        function(A){
        var button = A.one('#<portlet:namespace/>buy');      
        button.on(
                   'click',
                   function(clickedObject){                                                                                                                                                                                            var button = clickedObject.currentTarget;
                         var itemNumber = button.getData('item-number');  
                         var quantity = button.siblings("#<portlet:namespace/>quantity").get('value');
                         console.log("itemNumber: "+itemNumber+" quantity: "+quantity);
                         A.one("#<portlet:namespace/>loading").addClass('loading-animation').show();
                         A.one("#<portlet:namespace/>errormsg").hide();
                         A.io.request('${itemDetailsAddUrl}', {
                			   method: 'get',
                			   data: {
                				   "fromPage":"detail",
                				   "itemNumber": itemNumber,					 
                					"quantity":quantity                					
                			   },
                			on: { 
                				success: function() {                 					
                					var data = this.get('responseData');
                					var content= JSON.parse(data); 
                					var error = content.errors;                				
                					 if(error ==null || error == "undefined"){ 
                						 A.one("#<portlet:namespace/>loading").hide();                						
                						 <portlet:namespace/>refreshAPortlet();         								
         							 }
                					 else{
                						 A.one("#<portlet:namespace/>loading").hide();
        								 A.one("#<portlet:namespace/>errormsg").addClass('portlet-msg-error').html(error).show();	
                					 }                 									   	
                				} 
                			} 
                		}); 
                   }
        );
  }
);
function <portlet:namespace/>refreshAPortlet() {	
	Liferay.fire(
			'refreshCart',
			{
				id: '<portlet:namespace/>'									
			}
		);		
}
Liferay.on(
		'refreshAfterProductTreeisClicked',
		function(event) {		  
		    Liferay.Portlet.refresh('#p_p_id<portlet:namespace />');		    
		}
);
Liferay.on(
		'refreshDetails',
		function(event) {				
		    Liferay.Portlet.refresh('#p_p_id<portlet:namespace />');		    
		}
);
function <portlet:namespace />popupBatch(url) {
	var popup = Liferay.Popup(
			{
				title: '<spring:message code="itemlist-POPUP-header-info-batch-POPUPTITLE" text="Batch information" />',
				modal:true,
				width:550,
				position: ['center', 100]

			}
		);

	jQuery(popup).load(url);
}

	

<%
	String deliveryInfo = (String)renderRequest.getPortletSession().getAttribute("deliveryInfo", PortletSession.APPLICATION_SCOPE);
	renderRequest.getPortletSession().removeAttribute("deliveryInfo", PortletSession.APPLICATION_SCOPE);
	if (deliveryInfo != null) {
%>

	<liferay-portlet:renderURL anchor="false" copyCurrentRenderParameters="true" portletName="${prefs.itemListId}" var="popupUrl" windowState="exclusive">
		<liferay-portlet:param name="action" value="popup" />
		<liferay-portlet:param name="popup" value="itemlist/popup" />
		<liferay-portlet:param name="dummy" value='<%= ""+System.currentTimeMillis() %>'/>
		<liferay-portlet:param name="oldWindowState" value="normal" />
		<liferay-portlet:param name="deliveryInfo" value="<%= deliveryInfo %>" />
	</liferay-portlet:renderURL>
	jQuery(document).ready(<portlet:namespace />popup('${popupUrl}'));

	function <portlet:namespace />popup(url) {
		var popup = Liferay.Popup(
				{
					title: '<spring:message code="cart-POPUP-delivery-date-question-POPUPHEADER" text="Delivery date" />',
					modal:true,
					width:400,
					height:400,
					onClose:<portlet:namespace />popupClose
				}
			);

			jQuery(popup).load(url);
	}

	function <portlet:namespace />popupClose() {
			form = document.getElementById('<portlet:namespace />allocated');
			form.submit();
	}
<%} %>


</script>

