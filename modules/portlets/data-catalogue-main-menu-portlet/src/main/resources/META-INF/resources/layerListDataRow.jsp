<%@page
	import="com.esa.bmap.datacataloguemainmenu.constants.DataCatalogueMainMenuPortletKeys"%>
<%@ taglib prefix="liferay-ui" uri="http://liferay.com/tld/ui"%>

<%@ page import="com.esa.bmap.model.Granule"%>
<%@ page import="com.esa.bmap.model.Privacy"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<div class="row">
	<div
		class="col-lg-7 col-sm-12 col-sm-12 col-xs-12 layerListDataRowNameDiv">
		<input type="hidden" id="layerListId${granule.name}"
			data-value="${granule.collection.shortName}/${granule.name}"
			data-privacy="${granule.privacy}"
			class="important-bmap layerListDatasNames"><span
			id="layerListFileName${granule.name}" data-value="${granule.name}"
			class="layerListItem">${granule.name}</span>
	</div>
	<div
		class="col-lg-5 col-sm-12 col-sm-12 col-xs-12 layerListDataRowButtonsDiv">
		<div class="btn-group pull-right" role="group">
			<!-- PORTLET ACTION VISUALIZE LAYER -->

			<!-- IF DATA IS AVAILABLE FOR VIZUALIZATION -->
			<%
				if (((Granule) (request.getAttribute("granule"))).getDataList().get(0).getLayerName() != null) {
			%>
			<form>


				<aui:input type="hidden" name="id" id="ID" value="${granule.name}" />
				<aui:input type="hidden" name="portletAction" id="PORTLETACTION"
					value="/visualisationLayer" />

				<button class="aui-button dataRow-btn" value="open" type="button"
					onclick="portletAction('${granule.name}','${granule.collection.shortName}','${granule.privacy}',  '<%=
							DataCatalogueMainMenuPortletKeys.VISUALISATION_LAYER_JSP
			%>');">
					<img class="dataRow-btn-logo"
						src="<%=request.getContextPath()%>/media/icons/on.svg" />
				</button>
			</form>

			<%
				} else {
			%>
			<!-- ELSE WE DO NOT PERMIT THE VISUALIZATION -->
			<button title="Data not available for visualisation"
				class="aui-button dataRow-btn" value="open" type="button" disabled>
				<img class="dataRow-btn-logo"
					src="<%=request.getContextPath()%>/media/icons/off.svg" />
			</button>

			<%
				}
			%>

			<!-- / PORTLET ACTION VISUALIZE LAYER -->



			<!-- VISUALISE DATA METADATA -->
			<div class="dropdown">
				<button class="aui-button dataRow-btn btn-dataRow-info"
					type="button">
					<img class="dataRow-btn-logo "
						src="<%=request.getContextPath()%>/media/icons/Infos.svg" />
				</button>


				<div class="dropdown-content metadataInfo">
					<dl class="row">
						<dt class="col-sm-5">Name</dt>
						<dd class="col-sm-7">${granule.name}</dd>
						<dt class="col-sm-5">Acquisition Date</dt>
						<dd class="col-sm-7">${granule.dataList.get(0).acquisitionDate}</dd>
						<dt class="col-sm-5">Last update Date</dt>
						<dd class="col-sm-7">${granule.updateDate}</dd>
						<%
							if (((Granule) (request.getAttribute("granule"))).getCollection().getCategoryKeyWords() != null) {
						%>
						<dt class="col-sm-5">Provider</dt>
						<dd class="col-sm-7">ESA</dd>
						<dt class="col-sm-5">Category Key Words</dt>
						<dd class="col-sm-7">${granule.collection.categoryKeyWords}</dd>
						<%
							} else {
						%>
						<dt class="col-sm-5">Provider</dt>
						<dd class="col-sm-7">NASA</dd>
						<%
							}
						%>
						<hr>
						<dt class="col-sm-5">Collection</dt>
						<dd class="col-sm-7">${granule.collection.shortName}</dd>
						<dt class="col-sm-5">Sub Region</dt>
						<dd class="col-sm-7">${granule.subRegion.name}</dd>
						<dt class="col-sm-5">Native EPSG Code</dt>
						<dd class="col-sm-7">${granule.epsgCodeNative}</dd>
						<dt class="col-sm-5">Declared EPSG Code</dt>
						<dd class="col-sm-7">${granule.epsgCodeDeclared}</dd>
						<dt class="col-sm-5">Quadrangle Type</dt>
						<dd class="col-sm-7">${granule.quadrangle.type}</dd>
						<dt class="col-sm-5">Envelope Coordinates</dt>
						<dd class="col-sm-7">${granule.quadrangle.geometry}</dd>
						<hr>
						<dt class="col-sm-5">Geometry Type</dt>
						<dd class="col-sm-7">${granule.dataList.get(0).geometryType}</dd>
						<dt class="col-sm-5">Product Type</dt>
						<dd class="col-sm-7">${granule.productType}</dd>

						<!-- METADATA available only for raster files -->
						<%
							if (request.getAttribute("fileType").equals("tiff") || request.getAttribute("fileType").equals("tif")) {
						%>

						<dt class="col-sm-5">Polarization</dt>
						<dd class="col-sm-7">${granule.polarization}</dd>

						<dt class="col-sm-5">Processing Level</dt>
						<dd class="col-sm-7">${granule.collection.processingLevel}</dd>
						<hr>
						<%
							}
						%>
						<hr>
						<!-- METADATA available only for data having granule scenes -->
						<%
							if (((Granule) (request.getAttribute("granule"))).getGranuleScene() != null) {
								if ((((Granule) (request.getAttribute("granule"))).getProductType() != null)
										&& !(((Granule) (request.getAttribute("granule"))).getProductType()
												.equals(Granule.PRODUCT_TYPE_DEM))) {
						%>


						<dt class="col-sm-5">Scene</dt>
						<dd class="col-sm-7">${granule.granuleScene.name}</dd>

						<dt class="col-sm-5">Scene Heading</dt>
						<dd class="col-sm-7">${granule.granuleScene.heading}</dd>
						<dt class="col-sm-5">Scene z-flight</dt>
						<dd class="col-sm-7">${granule.granuleScene.zFlight}</dd>
						<dt class="col-sm-5">Scene slrStart</dt>
						<dd class="col-sm-7">${granule.granuleScene.slrStart}</dd>
						<dt class="col-sm-5">Scene pixelSpacing</dt>
						<dd class="col-sm-7">${granule.granuleScene.pixelSpacing}</dd>
						<dt class="col-sm-5">Scene surfaceResol</dt>
						<dd class="col-sm-7">${granule.granuleScene.surfaceResol}</dd>
						<dt class="col-sm-5">Scene grdResol</dt>
						<dd class="col-sm-7">${granule.granuleScene.grdResol}</dd>
						<hr>
						<%
							}
							}
						%>
					</dl>
				</div>
			</div>


			<!-- / VISUALISE DATA METADATA -->

			<button class="aui-button dataRow-btn aui-dropdown2-trigger"
				aria-controls="has-submenu${instanceID}">
				<img class="dataRow-btn-logo"
					src="<%=request.getContextPath()%>/media/icons/Gear.svg" />
			</button>

			<button class="aui-button dataRow-btn" type="button"
				onClick="delete_Entry('${granule.collection.shortName}','${granule.name}',this)">
				<img class="dataRow-btn-logo"
					src="<%=request.getContextPath()%>/media/icons/close.svg" />
			</button>
			<aui-dropdown-menu id="has-submenuTiff${instanceID}">
			<aui-section label="Action"> <!--  ACTION available only for public data -->


			<aui-dropdown-menu id="has-submenu${instanceID}">
			<aui-section label="Action"> <!--  ACTION available only for public data -->
			<%
				if (((Granule) (request.getAttribute("granule"))).getPrivacy().equals(Privacy.PUBLIC)) {
			%> <%
 	if (request.getAttribute("fileType").equals("roi")) {
 			String s = ((Granule) request.getAttribute("granule")).getDataList().get(0).getUrlToData();
 			/* 	String  = "message.txt.cpabe"; */
 			int indexOfLast = s.lastIndexOf(".");
 			String newString = s;
 			if (indexOfLast >= 0)
 				newString = s.substring(0, indexOfLast);
 %> <aui-item-link
				onclick="window.open('<%=newString + ".zip"%>');return false;">Download
			File </aui-item-link> <%
 	} else {
 %> <aui-item-link
				onclick="window.open('${granule.dataList.get(0).urlToData}');return false;">Download
			File </aui-item-link> <%
 	}
 %> <%
 	}
 %><!--  ACTION available only for private data --> <%
 	if (((Granule) (request.getAttribute("granule"))).getPrivacy().equals(Privacy.PRIVATE)) {
 %> <aui-item-link
				onclick="shareData('${granule.collection.shortName}:@${granule.name}')">Share
			Product</aui-item-link> <%
 	}
 %> <!--  OTHER --> <aui-item-link
				onclick="copyStringToClipboard('${granule.collection.shortName}:@${granule.name}')">Copy
			to Clipboard </aui-item-link>  <%
 	if (((Granule) (request.getAttribute("granule"))).getDataList().get(0).getLayerName() != null) {
 %> <aui-item-link for="overlayWith${instanceID}">Overlay
			with ... </aui-item-link> <%
 	} else {
 %> <aui-item-link for="overlayWith${instanceID}" disabled>Overlay
			with ... </aui-item-link> <%
 	}
 %> </aui-section> <!--  AVAILABLE only for raster data  --> <%
 	if (((Granule) (request.getAttribute("granule"))).getDataList().get(0).getLayerName() != null
 			&& ((Granule) (request.getAttribute("granule"))).getCollection().getCategoryKeyWords() != null
 			&& (request.getAttribute("fileType").equals("tiff")
 					|| request.getAttribute("fileType").equals("tif"))) {
 		//TODO
 %> <aui-section class="analysisSection" data-value="${instanceID}"
				label="ANALYSIS">
			<aui-item-link
				onclick="portletAction('${granule.name}','${granule.collection.shortName}','${granule.privacy}', '<%=
							DataCatalogueMainMenuPortletKeys.VISUALISATION_ANALYSIS_HIST_JSP
			%>');">Display
			Histogram </aui-item-link> <aui-item-link
				onclick="portletAction('${granule.name}','${granule.collection.shortName}','${granule.privacy}',  '<%=
							DataCatalogueMainMenuPortletKeys.VISUALISATION_ANALYSIS_STATS_JSP
			%>');">Display
			Basic Statistics </aui-item-link><aui-item-link disabled>Generate RGB</aui-item-link> <aui-item-link
				disabled>Band Math ... </aui-item-link> <aui-item-link disabled>Sync
			With ... </aui-item-link> </aui-section> <%
 	} else if (((Granule) (request.getAttribute("granule"))).getDataList().get(0).getLayerName() != null
 			&& ((Granule) (request.getAttribute("granule"))).getCollection().getCategoryKeyWords() != null
 			&& request.getAttribute("fileType").equals("roi")) {
 %><form>
				<aui:input type="hidden" name="id" id="ID" value="${granule.name}" />
				<aui:input type="hidden" name="portletAction" id="PORTLETACTION"
					value="<%=DataCatalogueMainMenuPortletKeys.VISUALISATION_ROI_ATTRIBUTE_TABLE_JSP%>" />

				<aui-item-link
					onclick="portletAction('${granule.name}','${granule.collection.shortName}','${granule.privacy}', '<%=
							DataCatalogueMainMenuPortletKeys.VISUALISATION_ROI_ATTRIBUTE_TABLE_JSP
			%>');">Display
				Attribute Table</aui-item-link>
				
			</form>

			<%
				}
			%> </aui-dropdown-menu> <aui-dropdown-menu id="overlayWith${instanceID}">
			<aui-section class="overlayWithSection" data-value="${granule.name}"
				label="OVERLAY WITH"></aui-section> <aui-section> <aui-item-link
				onclick="portletAction('${granule.name}','${granule.collection.shortName}','${granule.privacy}',  '<%=
							DataCatalogueMainMenuPortletKeys.VISUALISATION_OVERLAY_JSP
			%>');">Apply
			</aui-item-link></aui-section> </aui-dropdown-menu>
		</div>
	</div>