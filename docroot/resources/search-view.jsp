<%@ include file="../init.jsp" %>
<%@page import="com.liferay.portal.model.Organization"%>
<%@page import="com.liferay.portal.model.Group"%>

<c:set var="friendlyUrl" value="${themeDisplay.portalURL}/${searchPreferences.searchFriendlyUrl}"></c:set>

<portlet:resourceURL var="searchUrl" id="search" ></portlet:resourceURL>


<aui:nav collapsible="true" cssClass="nav-account-controls" icon="user" id="navAccountControls">

	<c:if test="<%= user.hasMySites() %>">
		<div class="search-wrapper">
			<div class="input-append">
				<input type="text" class="input input-large" value="${searchQuery}"  id="<portlet:namespace/>searchQuery"  minlength="${searchPreferences.minimumSearchChars}"/>
				<button type="button" class="btn"  id="<portlet:namespace/>btnSubmit"><i class="icon-search"></i></button>
			</div>
		</div>
		<aui:nav-item cssClass="my-sites" dropdown="<%= true %>" id="mySites" label="my-sites" wrapDropDownMenu="<%= false %>">
			<liferay-ui:my-sites classNames="<%= new String[] {Group.class.getName(), Organization.class.getName()} %>" cssClass="dropdown-menu my-sites-menu" />
		</aui:nav-item>
	</c:if>

</aui:nav>
	
	



<aui:script >

function <portlet:namespace/>refreshPortlet() {	
	Liferay.fire(
			'onSearch',
			{
				id: '<portlet:namespace/>'									
			}
		);
	
}
function <portlet:namespace/>performSearch(A){
	var searchQuery=A.one("#<portlet:namespace/>searchQuery").get('value');
    
	A.io.request('${searchUrl}',{
		dataType: 'json',
		method: 'POST',
		data: {
			<portlet:namespace/>searchQuery: searchQuery,
		},
		on: {
			success: function() {
				var data = this.get('responseData');
				if(data.tooShortSearch == "undefined"){
					<portlet:namespace/>refreshPortlet(); 
	            }
				if (!"${searchUrl}".startsWith("${friendlyUrl}")) {
					window.location.href = "${friendlyUrl}";
				}
				
				
				
			}
        }
	});
}

AUI().use('aui-base','aui-io-request', function(A){
  	var btnSubmit = A.one("#<portlet:namespace/>btnSubmit");

	btnSubmit.on('click',function(){
		<portlet:namespace/>performSearch(A);  		
  	});
	
	var searchQuery = A.one("#<portlet:namespace/>searchQuery");
	searchQuery.on('keypress',function(event){
		if(event.keyCode==13){
			<portlet:namespace/>performSearch(A);
		}
	});	

			
});
AUI().use('aui-base', function(A){   
	Liferay.on(
			'refreshAfterProductTreeisClicked',
			function(event) {	
				var searchQueryNode=A.one("#<portlet:namespace/>searchQuery");
				if (searchQueryNode.val()) {
				    Liferay.Portlet.refresh('#p_p_id<portlet:namespace />');
				}
			}
	);	
});
</aui:script>