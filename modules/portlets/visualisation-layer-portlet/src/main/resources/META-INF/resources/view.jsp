<%@ include file="/init.jsp"%>



<portlet:defineObjects />
<div class="visualisationContainer visuPortletContainer">
	<liferay-ui:error key="error" message="${errorMessage}" />
	<div class="container-fluid visualisationTitle">
		<div class="row">
			<div class="col-md-6">
				<div class="row">
					<div class="col-md-12 text-wrap">
						<p class="navbar-brand text-uppercase visualisationTitle">Visualisation_Layer</p>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12 text-wrap">
						<p class="navbar-brand text-uppercase visualisationSubTitle">${granule.name}</p>
					</div>
				</div>

			</div>
			<div class="col-md-6 text-right">
				<!-- OPTIONS MENU DROPDOWN -->
				<button class="aui-dropdown2-trigger aui-button dataRow-btn"
					aria-controls="options<portlet:namespace/>">
					<img src="<%=request.getContextPath()%>/media/icons/Gear.svg" />
				</button>

				<aui-dropdown-menu id="options<portlet:namespace/>">
				<!-- Custom color scale is applicable only for ESA layers, raster type -->

				<c:if
					test="${fileType ne 'ROI' && not empty granule.collection.categoryKeyWords}">
					<aui-section> <aui-item-link
						for="style<portlet:namespace/>">Set style ... </aui-item-link></aui-section>

				</c:if> <aui-item-link id="showHideAttributeTable<portlet:namespace/>"
					value="Show/Hide">Show/Hide attribute table</aui-item-link><aui-section>
				<div class="aui-dropdown2-heading">
					<strong>Actions</strong>
				</div>
				<!-- Custom profile is applicable only for ESA layers, raster type -->

				<c:if
					test="${fileType ne 'ROI' && not empty granule.collection.categoryKeyWords}">

					<aui-item-link id="<portlet:namespace/>customProfilItemCheckbox"
						onclick="getCustomProfile(this,'mapSingleLayer<portlet:namespace/>','<portlet:namespace/>','${granule.collection.shortName}','${granule.name}')">Get
					CustomProfile</aui-item-link>



				</c:if> <!-- Custom color scale is applicable only for geolocated layers -->

				<c:if test="${granule.dataList.get(0).geometryType eq 'geolocated'}">

					<aui-item-link
						onclick="getRulerDistance('mapSingleLayer<portlet:namespace/>','<portlet:namespace/>')">Get
					Ruler Distance</aui-item-link>
					<!--  Only applicable for ESA layers of Raster type -->
					<c:if
						test="${fileType ne 'ROI' && granule.dataList.get(0).geometryType eq 'geolocated' && not empty granule.collection.categoryKeyWords}">
						<aui-item-link id="<portlet:namespace/>subsetStatsItemCheckbox"
							onclick="getZonalStats(this,'mapSingleLayer<portlet:namespace/>','<portlet:namespace/>','${granule.collection.shortName}','${granule.name}')">Get
						Zonal Statistics</aui-item-link>
					</c:if>

				</c:if> <!-- Clear vectors & map interactions--> <aui-item-link
					id="clearAction<portlet:namespace/>">Clear</aui-item-link>
				</aui-section> </aui-dropdown-menu>

				<c:if test="${fileType ne 'ROI'}">

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
					</aui-item-link>
					<aui-item-link
						onclick="setThreeColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).avgs.get(0)},${granule.dataList.get(0).maxs.get(0)},'#80FF00','#FFFF00','#FF0000','mapSingleLayer<portlet:namespace/>')">GreenToRed
					<div class="colorGradientGreenToRedScale"></div>
					</aui-item-link> <aui-item-link
						onclick="setThreeColorColorScale('${granule.name}',${granule.dataList.get(0).mins.get(0)},${granule.dataList.get(0).avgs.get(0)},${granule.dataList.get(0).maxs.get(0)},'#000000','#C0C0C0','#ffffff','mapSingleLayer<portlet:namespace/>')">Gray
					<div class="colorGradientGrayScale"></div>
					</aui-item-link> </aui-section> </aui-dropdown-menu>
				</c:if>
				<!-- OPTIONS MENU DROPDOWN-->
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
	<div id="coords"></div>
	<!-- Attribute table of the layer for a given pixel -->
	<div class="featureinfoContainer"
		id="featureinfodiv<portlet:namespace/>">
		<!-- <h3 style="color: #00338d;">Attribute Table</h3> -->
		<small>Click on the map to get feature info</small>
		<div id="<portlet:namespace/>featureinfotable"></div>
	</div>


	<!-- Analysis functionnalities divs-->

	<div class="text-center" id="<portlet:namespace/>rulerDistanceInfo">
		<dl class="border-around">
			<dt>Ruler Distance</dt>
			<%-- <dd id="<portlet:namespace/>rulerDistanceDegrees">degrees</dd> --%>
			<dd id="<portlet:namespace/>rulerDistanceMeters">meters</dd>
		</dl>



	</div>
	<div class="text-center" id="<portlet:namespace/>customProfile"></div>
	<div class="text-center" id="<portlet:namespace/>subsetStats">
		<dl class="border-around">


		</dl>
	</div>



</div>


