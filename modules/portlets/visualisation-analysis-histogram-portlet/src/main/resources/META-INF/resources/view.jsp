<%@ include file="/init.jsp"%>


<portlet:defineObjects />
<div class="visualisationContainer visuPortletContainer">
	<liferay-ui:error key="error" message="${errorMessage}" />
	<div class="container-fluid visualisationTitle">
		<div class="row">
			<div class="col-md-6">
				<p class="navbar-brand text-uppercase visualisationTitle">Visualisation_Analysis_Histogram</p>
				<p class="navbar-brand text-uppercase visualisationSubTitle">${granule.name}</p>

			</div>
			<div class="col-md-6 text-right">


				<button onClick="delete_row(this)" class="aui-button dataRow-btn"
					role="button">
					<img class="dataRow-btn-logo"
						src="<%=request.getContextPath()%>/media/icons/close.svg" />
				</button>
			</div>
		</div>
	</div>

	<div id="histogram<portlet:namespace/>"></div>
</div>