<%@ include file="/init.jsp"%>


<portlet:defineObjects />


<div class="visualisationContainer">

	<liferay-ui:error key="error" message="${errorMessage}" />

	<div class="container-fluid visualisationTitle">
		<div class="row">
			<div class="col-md-6">
				<p class="navbar-brand text-uppercase visualisationTitle">Visualisation_Overlay</p>
				<p class="navbar-brand text-uppercase visualisationSubTitle">${granule.name}</p>
			</div>



			<div class="col-md-6 text-right">
				<button class="aui-dropdown2-trigger aui-button dataRow-btn"
					aria-controls="options<portlet:namespace/>">
					<img 
					src="<%=request.getContextPath()%>/media/icons/Gear.svg" />
				</button>
				<aui-dropdown-menu id="options<portlet:namespace/>">
				<aui-item-link id="showHideAttributeTable<portlet:namespace/>"
					value="Show/Hide">Show/Hide attribute table</aui-item-link> <aui-item-link
					for="style<portlet:namespace/>">Set style ... </aui-item-link> </aui-dropdown-menu>
				<aui-dropdown-menu id="style<portlet:namespace/>">

				<c:forEach items="${granuleList}" var="granuleVar">
					<c:if test="${not empty granuleVar.dataList.get(0).mins}">
						<aui-item-link
							for="dataStyle<portlet:namespace/>${granuleVar.name}">${granuleVar.name}</aui-item-link>
						<aui-dropdown-menu
							id="dataStyle<portlet:namespace/>${granuleVar.name}">
						<aui-section label="Two-Color Scale"> <aui-item-link
							onclick="setColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#ffffff','#008000','mapOverlay<portlet:namespace/>')">GreenScale
						<div class="colorGradientGreenScale"></div>
						</aui-item-link> <aui-item-link
							onclick="setColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#000000','#ffffff','mapOverlay<portlet:namespace/>')">GreyScale
						<div class="colorGradientGrayScaleBW"></div>
						</aui-item-link> <aui-item-link
							onclick="setColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#ffffff','#000000','mapOverlay<portlet:namespace/>')">GreyScale
						<div class="colorGradientGrayScaleWB"></div>
						</aui-item-link> </aui-item-link> <aui-item-link
							onclick="setColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#ffffff','#008000','mapOverlay<portlet:namespace/>')">GreenScale
						<div class="colorGradientGreenScale"></div>
						</aui-item-link> <aui-item-link
							onclick="setColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#ffffff','#FF8C00','mapOverlay<portlet:namespace/>')">Oranges
						<div class="colorGradientOrangeScale"></div>
						</aui-item-link></aui-section> <aui-section label="Three-Color Scale">  <!-- THREE COLOR GRADIENT --> <aui-item-link
					onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#000000','#F00C93','#FFFF00','mapOverlay<portlet:namespace/>')">Inferno
				<div class="colorGradientInfernoScale"></div>
				</aui-item-link> <aui-item-link
					onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#0000FF','#F00C93','#FFFF00','mapOverlay<portlet:namespace/>')">Plasma
				<div class="colorGradientPlasmaScale"></div>
				</aui-item-link> <aui-item-link
					onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#8A2BE2','#ffffff','#008000','mapOverlay<portlet:namespace/>')">PRGn
				<div class="colorGradientPRGnScale"></div>
				</aui-item-link> <aui-item-link
					onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#F00C93','#ffffff','#008000','mapOverlay<portlet:namespace/>')">PiYG
				<div class="colorGradientPiYGScale"></div>
				</aui-item-link>
				<aui-item-link
					onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#FF0000','#FFFF00','#80FF00','mapOverlay<portlet:namespace/>')">RedToGreen
				<div class="colorGradientRedToGreenScale"></div>
				</aui-item-link>
				<aui-item-link
					onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#000000','#C0C0C0','#ffffff','mapOverlay<portlet:namespace/>')">Gray
				<div class="colorGradientGrayScale"></div>
				</aui-item-link>
				</aui-section>  </aui-dropdown-menu>
					</c:if>
				</c:forEach> </aui-dropdown-menu>

				<button onClick="delete_row(this)" class="aui-button dataRow-btn"
					role="button">
					<img class="dataRow-btn-logo"
					src="<%=request.getContextPath()%>/media/icons/close.svg" />
				</button>

			</div>
			<c:forEach items="${granuleList}" var="granuleVar">
			
				<c:if test="${not empty granuleVar.dataList.get(0).mins}">
			
					<input data-name="${granuleVar.name}"
						data-min="${granuleVar.dataList.get(0).mins.get(0)}"
						data-max="${granuleVar.dataList.get(0).maxs.get(0)}"
						data-avg="${granuleVar.dataList.get(0).avgs.get(0)}"
						class="overlayList<portlet:namespace/>"
						value="${granuleVar.dataList.get(0).layerName}" type="hidden">

				</c:if>
				<c:if test="${empty granuleVar.dataList.get(0).mins}">
					<input data-name="${granuleVar.name}"
						class="overlayList<portlet:namespace/>"
						value="${granuleVar.dataList.get(0).layerName}" type="hidden">
				</c:if>
			</c:forEach>
		</div>



	</div>
	<!-- Map displaying the chosen layers -->
	<div id="mapOverlay<portlet:namespace/>" class="mapSingleLayer map"></div>
	<small>for SLC data, the signal amplitude is displayed</small>


	<!-- Attribute table of the layers for a given pixel -->
	<div class="featureinfoContainer"
		id="featureinfodiv<portlet:namespace/>">
		<h3>Attribute Table</h3>
		<div id="<portlet:namespace/>featureinfotable">
			<em>Click on the map to get feature info</em>

		</div>
	</div>
</div>
