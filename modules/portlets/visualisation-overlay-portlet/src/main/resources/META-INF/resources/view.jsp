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
					<img src="<%=request.getContextPath()%>/media/icons/Gear.svg" />
				</button>


				<!-- OPTIONS MENU DROPDOWN -->
				<aui-dropdown-menu id="options<portlet:namespace/>">

				<aui-section> <aui-item-link
					for="style<portlet:namespace/>">Set style ... </aui-item-link> <aui-item-link
					id="showHideAttributeTable<portlet:namespace/>" value="Show/Hide">Show/Hide
				attribute table</aui-item-link> </aui-section> <aui-section>
				<div class="aui-dropdown2-heading">
					<strong>Actions</strong>
				</div>
				<!-- Ruler distance only applicable for geolocated layers --> <c:if
					test="${granule.dataList.get(0).geometryType eq 'geolocated'}">
					<aui-item-link
						onclick="getRulerDistance('mapOverlay<portlet:namespace/>','<portlet:namespace/>')">Get
					Ruler Distance</aui-item-link>
				</c:if> <aui-item-link for="statsRoi<portlet:namespace/>">Get
				Statistics from Roi ... </aui-item-link> <aui-item-link
					for="rasterCompare<portlet:namespace/>">Compare two
				rasters ... </aui-item-link> <aui-item-link id="clearAction<portlet:namespace/>">Clear</aui-item-link>

				</aui-section> </aui-dropdown-menu>

				<aui-dropdown-menu id="style<portlet:namespace/>">


				<c:forEach items="${granuleList}" var="granuleVar">
					<c:if
						test="${not empty granuleVar.dataList.get(0).mins  && not empty granuleVar.collection.categoryKeyWords}">
						<!-- Custom colorScaling only applicable for Esa granules, raster type -->
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
						</aui-item-link></aui-section> <aui-section label="Three-Color Scale"> <!-- THREE COLOR GRADIENT -->
						<aui-item-link
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


						</aui-item-link> <aui-item-link
							onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#FF0000','#FFFF00','#80FF00','mapOverlay<portlet:namespace/>')">RedToGreen
						<div class="colorGradientRedToGreenScale"></div>
						</aui-item-link> 
						<aui-item-link
							onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#80FF00','#FFFF00','#FF0000','mapOverlay<portlet:namespace/>')">GreenToRed
						<div class="colorGradientGreenToRedScale"></div>
						</aui-item-link>
						<aui-item-link
							onclick="setThreeColorColorScaleOverlay('${granuleVar.name}',${granuleVar.dataList.get(0).mins.get(0)},${granuleVar.dataList.get(0).avgs.get(0)},${granuleVar.dataList.get(0).maxs.get(0)},'#000000','#C0C0C0','#ffffff','mapOverlay<portlet:namespace/>')">Gray
						<div class="colorGradientGrayScale"></div>
						</aui-item-link> </aui-section> </aui-dropdown-menu>
					</c:if>

				</c:forEach> </aui-dropdown-menu>
				<aui-dropdown-menu id="statsRoi<portlet:namespace/>">

				<aui-section label="Base raster"> <c:forEach
					items="${granuleList}" var="granuleRaster">
					<c:if
						test="${not empty granuleRaster.collection.categoryKeyWords  && not empty granuleRaster.dataList.get(0).mins}">
						<aui-item-link
							for="statsRoiFromBase<portlet:namespace/>${granuleRaster.name}">${granuleRaster.name}</aui-item-link>
						<aui-dropdown-menu
							id="statsRoiFromBase<portlet:namespace/>${granuleRaster.name}">
						<aui-section label="Roi Subset"> <c:forEach
							items="${granuleList}" var="granuleRoi">
							<c:if
								test="${not empty granuleRoi.collection.categoryKeyWords &&  empty granuleRoi.dataList.get(0).mins}">
								<aui-item-link
									onclick="generateStatsFromRoi('${granuleRaster.collection.shortName}:@${granuleRaster.name}','${granuleRoi.collection.shortName}:@${granuleRoi.name}','<portlet:namespace/>')">${granuleRoi.name}</aui-item-link>
							</c:if>
						</c:forEach> </aui-section> </aui-dropdown-menu>
					</c:if>




				</c:forEach> </aui-section> </aui-dropdown-menu>

				<aui-dropdown-menu id="rasterCompare<portlet:namespace/>">

				<aui-section label="X axis Raster"> <c:forEach
					items="${granuleList}" var="granuleRasterXaxis">


					<c:if
						test="${not empty granuleRasterXaxis.dataList.get(0).mins  && not empty granuleRasterXaxis.collection.categoryKeyWords}">
						<aui-item-link
							for="compareXYRasters<portlet:namespace/>${granuleRasterXaxis.name}">${granuleRasterXaxis.name}</aui-item-link>
						<aui-dropdown-menu
							id="compareXYRasters<portlet:namespace/>${granuleRasterXaxis.name}">
						<aui-section label="Y axis raster"> <c:forEach
							items="${granuleList}" var="granuleRasterYaxis">
							<c:if
								test="${not empty granuleRasterYaxis.dataList.get(0).mins  && not empty granuleRasterYaxis.collection.categoryKeyWords}">
								<c:if
									test="${!(granuleRasterXaxis.name).equals(granuleRasterYaxis.name) }">
									<aui-item-link
										onclick="generatePlotComparison('mapOverlay<portlet:namespace/>','${granuleRasterXaxis.collection.shortName}:@${granuleRasterXaxis.name}','${granuleRasterYaxis.collection.shortName}:@${granuleRasterYaxis.name}','<portlet:namespace/>')">${granuleRasterYaxis.name}</aui-item-link>
								</c:if>
							</c:if>

						</c:forEach> </aui-section> </aui-dropdown-menu>
					</c:if>



				</c:forEach> </aui-section> </aui-dropdown-menu>


				<!-- OPTIONS MENU DROPDOWN -->

				<button onClick="delete_row(this)" class="aui-button dataRow-btn"
					role="button">
					<img class="dataRow-btn-logo"
						src="<%=request.getContextPath()%>/media/icons/close.svg" />
				</button>

			</div>
			<c:forEach items="${granuleList}" var="granuleVar">
				<c:if test="${granuleVar.collection.categoryKeyWords!=null}">
					<c:set var="isEsa" scope="page">true</c:set>
				</c:if>
				<!--  raster -->
				<c:if test="${not empty granuleVar.dataList.get(0).mins}">
					<input data-name="${granuleVar.name}" data-isesa="${isEsa}"
						data-min="${granuleVar.dataList.get(0).mins.get(0)}"
						data-max="${granuleVar.dataList.get(0).maxs.get(0)}"
						data-avg="${granuleVar.dataList.get(0).avgs.get(0)}"
						class="overlayList<portlet:namespace/>"
						value="${granuleVar.dataList.get(0).layerName}" type="hidden">

				</c:if>
				<!--  roi -->
				<c:if test="${empty granuleVar.dataList.get(0).mins}">
					<input data-isesa="${isEsa}" data-name="${granuleVar.name}"
						class="overlayList<portlet:namespace/>"
						value="${granuleVar.dataList.get(0).layerName}" type="hidden">
				</c:if>
			</c:forEach>
		</div>



	</div>
	<!-- Map displaying the chosen layers -->
	<div id="mapOverlay<portlet:namespace/>" class="mapSingleLayer map"></div>
	<small>for SLC data, the signal amplitude is displayed</small> <br>

	<div id="plotComparisonInfo<portlet:namespace/>"
		class="alert alert-info" role="alert">Please select the area you
		want to plot (maximum 100 000 pixels). This area has to cover both
		chosen rasters</div>


	<!-- Attribute table of the layers for a given pixel -->
	<div class="featureinfoContainer"
		id="featureinfodiv<portlet:namespace/>">
		<!-- <h3>Attribute Table</h3> -->
		<div id="<portlet:namespace/>featureinfotable">
			<em>Click on the map to get feature info</em>

		</div>
	</div>
	<div id="<portlet:namespace/>rulerDistanceInfo">
		<dl class="border-around">
			<dt>Ruler Distance</dt>
		<%-- 	<dd id="<portlet:namespace/>rulerDistanceDegrees"></dd> --%>
			<dd id="<portlet:namespace/>rulerDistanceMeters"></dd>

		</dl>
		<%-- <table class="text-center">
			<tr>
				<td colspan="2" class="attributeTableCell attributeTableContent">Ruler
					Distance</td>
			</tr>
			<tr>
				<td class="attributeTableCell attributeTableContent"
					id="<portlet:namespace/>rulerDistanceDegrees">degrees</td>
				<td class="attributeTableCell attributeTableContent"
					id="<portlet:namespace/>rulerDistanceMeters">meters</td>
			</tr>
		</table> --%>
	</div>
	<div class="text-center" id="statsRoiInfo<portlet:namespace/>">

		<dl class="border-around">
		</dl>


	</div>
	<div id="error<portlet:namespace/>" class="alert alert-danger"
		role="alert">
		<small><strong>Error</strong> while trying to display the
			raster comparison graph. Please check if the area you selected
			overlap both rasters. Be aware the maximum pixels the graph can
			render is 100 000.</small>
	</div>
	<div class="text-center" id="plotComparison<portlet:namespace/>"></div>
</div>
