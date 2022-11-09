<%@ include file="/init.jsp"%>

<div class="visualisationContainer visuPortletContainer">
	<liferay-ui:error key="error" message="${errorMessage}" />
	<div class="container-fluid visualisationTitle">
		<div class="row">
			<div class="col-md-6">
				<p class="navbar-brand text-uppercase visualisationTitle">Visualisation_Analysis_Statistics</p>
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

	<table class="table">
		<tr class="tableCell">
			<td></td>
			<c:set var="count" value="0" scope="page" />
			<c:forEach items="${granule.dataList.get(0).mins}">
				<c:set var="count" value="${count + 1}" scope="page" />
				<th class="tableHeader">Band ${count}</th>

			</c:forEach>
		</tr>
		<tr class="tableCell">
			<th>Minimum</th>
			<c:forEach items="${granule.dataList.get(0).mins}" var="minElement">

				<fmt:formatNumber var="minElementFixedDecimal" type="number"
					minFractionDigits="2" maxFractionDigits="2"
					value="${minElementFixedDecimal}" />


				<td>${minElement}</td>

			</c:forEach>
		</tr>
		<tr class="tableCell">
			<th>Maximum</th>
			<c:forEach items="${granule.dataList.get(0).maxs}" var="maxElement">

				<td>${maxElement}</td>

			</c:forEach>
		</tr>
		<tr class="tableCell">
			<th>Average</th>
			<c:forEach items="${granule.dataList.get(0).avgs}" var="avgElement">

				<td>${avgElement}</td>

			</c:forEach>
		</tr>
		<tr class="tableCell">
			<th>Standard Deviation</th>
			<c:forEach items="${granule.dataList.get(0).stdDeviations}"
				var="stdDevElement">

				<td>${stdDevElement}</td>

			</c:forEach>
		</tr>
	</table>

</div>