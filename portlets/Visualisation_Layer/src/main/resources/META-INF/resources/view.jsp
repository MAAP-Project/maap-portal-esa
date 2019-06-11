<%@ include file="/init.jsp"%>


<portlet:defineObjects />
<div class="visualisationContainer visuPortletContainer">
	<liferay-ui:error key="error" message="${errorMessage}" />
	<div class="container-fluid visualisationTitle">
		<div class="row">
			<div class="col-md-6">
				<p class="navbar-brand text-uppercase visualisationTitle">Visualisation_Layer</p>
				<p class="navbar-brand text-uppercase visualisationSubTitle">${granule.name}</p>

			</div>
			<div class="col-md-6 text-right">
				<button class="aui-dropdown2-trigger aui-button dataRow-btn"
					aria-controls="options<portlet:namespace/>">
					<img src="<%=request.getContextPath()%>/media/icons/Gear.svg" />
				</button>
				<aui-dropdown-menu id="options<portlet:namespace/>">

				<aui-item-link id="showHideAttributeTable<portlet:namespace/>"
					value="Show/Hide">Show/Hide attribute table</aui-item-link> <c:if
					test="${fileType ne 'roi'}">
					<aui-item-link for="style<portlet:namespace/>">Set
					style ... </aui-item-link>
				</c:if></aui-dropdown-menu>

				<c:if test="${fileType ne 'roi'}">
					<aui-dropdown-menu id="style<portlet:namespace/>">

					<aui-section label="Two-Color Scale"> <aui-item-link
						onclick="setTwoColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).maxs.get(0)},'#000000','#ffffff','mapSingleLayer<portlet:namespace/>')">GreyScale
					<div class="colorGradientGrayScaleBW"></div>
					</aui-item-link> <aui-item-link
						onclick="setTwoColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).maxs.get(0)},'#ffffff','#000000','mapSingleLayer<portlet:namespace/>')">GreyScale
					<div class="colorGradientGrayScaleWB"></div>
					</aui-item-link> </aui-item-link> <aui-item-link
						onclick="setTwoColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).maxs.get(0)},'#ffffff','#008000','mapSingleLayer<portlet:namespace/>')">GreenScale
					<div class="colorGradientGreenScale"></div>
					</aui-item-link> <aui-item-link
						onclick="setTwoColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).maxs.get(0)},'#ffffff','#FF8C00','mapSingleLayer<portlet:namespace/>')">Oranges
					<div class="colorGradientOrangeScale"></div>
					</aui-item-link></aui-section><!-- THREE COLOR GRADIENT --> <aui-section
						label="Three-Color Scale"> <aui-item-link
						onclick="setThreeColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).avgs.get(0)},${granule.dataList.get(0).maxs.get(0)},'#000000','#F00C93','#FFFF00','mapSingleLayer<portlet:namespace/>')">Inferno
					<div class="colorGradientInfernoScale"></div>
					</aui-item-link> <aui-item-link
						onclick="setThreeColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).avgs.get(0)},${granule.dataList.get(0).maxs.get(0)},'#0000FF','#F00C93','#FFFF00','mapSingleLayer<portlet:namespace/>')">Plasma
					<div class="colorGradientPlasmaScale"></div>
					</aui-item-link> <aui-item-link
						onclick="setThreeColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).avgs.get(0)},${granule.dataList.get(0).maxs.get(0)},'#8A2BE2','#ffffff','#008000','mapSingleLayer<portlet:namespace/>')">PRGn
					<div class="colorGradientPRGnScale"></div>
					</aui-item-link> <aui-item-link
						onclick="setThreeColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).avgs.get(0)},${granule.dataList.get(0).maxs.get(0)},'#F00C93','#ffffff','#008000','mapSingleLayer<portlet:namespace/>')">PiYG
					<div class="colorGradientPiYGScale"></div>
					</aui-item-link> <aui-item-link
						onclick="setThreeColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).avgs.get(0)},${granule.dataList.get(0).maxs.get(0)},'#FF0000','#FFFF00','#80FF00','mapSingleLayer<portlet:namespace/>')">RedToGreen
					<div class="colorGradientRedToGreenScale"></div>
					</aui-item-link> <aui-item-link
						onclick="setThreeColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).avgs.get(0)},${granule.dataList.get(0).maxs.get(0)},'#000000','#C0C0C0','#ffffff','mapSingleLayer<portlet:namespace/>')">Gray
					<div class="colorGradientGrayScale"></div>
					</aui-item-link> </aui-section> </aui-dropdown-menu>
				</c:if>

				<button onClick="delete_row(this)" class="aui-button dataRow-btn"
					role="button">
					<img class="dataRow-btn-logo"
						src="<%=request.getContextPath()%>/media/icons/close.svg" />
				</button>
			</div>
		</div>
	</div>

	<div id="mouseLocation<portlet:namespace/>" class="mouseLocationVisu"></div>

	<!-- Map displaying the chosen layer -->
	<div id="mapSingleLayer<portlet:namespace/>" class="mapSingleLayer map"></div>
	<small>for SLC data, the signal amplitude is displayed</small>

	<!-- Attribute table of the layer for a given pixel -->
	<div class="featureinfoContainer"
		id="featureinfodiv<portlet:namespace/>">
		<h3>Attribute Table</h3>
		<em>Click on the map to get feature info</em>
		<div id="<portlet:namespace/>featureinfotable"></div>
	</div>

</div>
