

<%@ include file="/init.jsp"%>


<portlet:defineObjects />
<div class="visualisationContainer">
	<%-- <liferay-ui:error key="error" message="${errorMessage}" />

	<div class="container-fluid ">
		<div class="row">
			<div class="col-md-6">
				<p class="navbar-brand text-uppercase visualisationTitle">ROI_Attribute_Table</p>
				<p class="navbar-brand text-uppercase visualisationSubTitle">${data.fileName}</p>
			</div>
			<div class="col-md-6 text-right">
				<button onClick="delete_row(this)"
					class="dropdown-toggle visualisationButton custom-button-width .navbar-right"
					role="button">
					<span class="glyphicon glyphicon-remove"></span>
				</button>
			</div>
		</div>
	</div> --%>
	<liferay-ui:error key="error" message="${errorMessage}" />

	<div class="container-fluid visualisationTitle">
		<div class="row">
			<div class="col-md-6">
				<p class="navbar-brand text-uppercase visualisationTitle">Visualisation_ROI_Attribute_Table</p>
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

	<div class="row">
		<div class="col-md-12">
			<input class="form-control" id="searchRoiTable" type="text"
				placeholder="Search.."> <br>
			<table class="table table-bordered table-striped table-hover">
				<thead class="text-center">
					<th scope="col">#</th>
					<c:forEach
						items="${listFeatures.get(0).getAttributeTable().keySet()}"
						var="key">
						<th class="dataTableHeader text-uppercase" scope="col">${key}</th>
					</c:forEach>
				</thead>
				<tbody id="roiTable">

					<c:forEach items="${listFeatures}" var="feature">
						<tr>
							<th class="important-bmap" scope="row">${feature.getId()}</th>

							<c:forEach items="${feature.getAttributeTable()}" var="attribute">
								<td class="dataTableValues">${attribute.value}</td>
							</c:forEach>
						</tr>
					</c:forEach>



				</tbody>
			</table>
		</div>
	</div>
</div>