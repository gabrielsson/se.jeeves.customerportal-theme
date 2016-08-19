<%@ include file="../init.jsp" %>
<div id="<portlet:namespace/>cartRows">
	<c:if test="${not empty orderRows || !cartPreferences.hideNavigation}">
		<c:choose>
			<c:when test="${listModel.viewMode==0}">
				<jis:ui-table-new listModel="${listModel}" dataSet="${orderRows}" pager="false" listId="cart"></jis:ui-table-new>
			</c:when>
			<c:when test="${listModel.viewMode==1}">
				<jis:ui-divgrid-new listModel="${listModel}" dataSet="${orderRows}"></jis:ui-divgrid-new>
			</c:when>
		</c:choose>
		<div class="cart-total-wrapper">
			<h2>
				<c:choose>
					<c:when test="<%=JeevesSessionUtil.isAnonymous(renderRequest)%>"> 
						<c:if test="${cartPreferences.showTotalsWhenAnonymous}">
								<spring:message code="total" text="Total:"/> <c:out value="${cart.orderSum}"></c:out> <c:out value="${cart.currencyCode}"></c:out>
						</c:if>
					</c:when>
					<c:otherwise>
						<spring:message code="total" text="Total:"/> <c:out value="${cart.orderSum}"></c:out> <c:out value="${cart.currencyCode}"></c:out>
					</c:otherwise>
				</c:choose>
			</h2>
		</div>
	</c:if>
</div>

