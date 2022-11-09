<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%><%@
taglib
	uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%><%@
taglib
	uri="http://liferay.com/tld/theme" prefix="liferay-theme"%>
<%@ taglib prefix="liferay-ui" uri="http://liferay.com/tld/ui"%>


<liferay-theme:defineObjects />


<portlet:resourceURL var="refreshResultList" id='researchTrigger' />

<portlet:resourceURL var="doAction" id='doActionTrigger' />
<portlet:resourceURL var="shareData" id='shareDataTrigger' />
<portlet:resourceURL var="getCollectionNames"
	id='getCollectionNamesTrigger' />

<portlet:defineObjects />
<!-- <script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script> -->

<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/external/jquery/core/2.1.3/jquery.min.js"></script>
<link rel="stylesheet"
	href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

<script>
	/* jQuery.noConflict(); */
	var jQuery = $.noConflict(true);
</script>

<!--  AUI  -->
<!-- <script src="http://aui-cdn.atlassian.com/aui-adg/6.0.9/js/aui.min.js"></script> -->
<!-- <link rel="stylesheet"
	href="http://aui-cdn.atlassian.com/aui-adg/6.0.9/css/aui.min.css"
	media="all"> -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/external/aui/core/aui.min.js"></script>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/style/external/aui.min.css"
	media="all">

<!-- OPENLAYERS -->
<!-- <link rel="stylesheet"
	href="https://openlayers.org/en/latest/css/ol.css" /> -->
<!-- <script type="text/javascript"
	src="https://openlayers.org/en/latest/build/ol.js"></script> -->
<!-- <script
	src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL,Object.assign"></script> -->

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/style/external/ol.css" media="all">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/external/openlayers/ol.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/external/openlayers/polyfill.js"></script>

<!-- OL-EXT -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/style/external/ol-ext.min.css"
	media="all">

<!-- <link rel="stylesheet"
	href="https://cdn.rawgit.com/Viglino/ol-ext/master/dist/ol-ext.min.css" /> -->
<!-- <script type="text/javascript"
	src="https://cdn.rawgit.com/Viglino/ol-ext/master/dist/ol-ext.min.js"></script> -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/external/openlayers/ol-ext.min.js"></script>


<!-- GEOCODER -->
<link
	href="<%=request.getContextPath()%>/style/external/ol-geocoder.min.css"
	rel="stylesheet">
<!-- <link href="https://unpkg.com/ol-geocoder/dist/ol-geocoder.min.css"
	rel="stylesheet"> -->
<!-- <script src="https://unpkg.com/ol-geocoder"></script> -->
<script
	src="<%=request.getContextPath()%>/javascript/external/openlayers/ol-geocoder.js"></script>

<!-- FONT IMPORTS -->
<link href="https://fonts.googleapis.com/css?family=Roboto"
	rel="stylesheet">


<!-- DATA TABLES -->
<!-- <script type="text/javascript"
	src="https://cdn.datatables.net/v/dt/dt-1.10.18/r-2.2.2/rg-1.1.0/datatables.min.js"></script> -->
<script
	src="<%=request.getContextPath()%>/javascript/external/datatables/datatables.min.js"></script>


<!-- LOADING SPINNER STYLE -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/css-spinning-spinners/1.1.0/load8.css" />
<%-- <link href="<%=request.getContextPath()%>/style/external/load8.css"
	rel="stylesheet"> --%>

<!-- PLOTLY -->
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

<!-- BMAP SCRIPTS -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/style/style.css">


<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/utils.js"></script>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/form.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/map.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/nav.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/script.js"></script>


<script>
	console.log('${collectionNamesList}');
	var collectionNames = null;
	console.log
	/*An array containing all the country names in the world:*/
	if('${collectionNamesList}'){
		
		 collectionNames = JSON.parse('${collectionNamesList}');
	}
	

	/*initiate the autocomplete function on the "myInput" element, and pass along the countries array as possible autocomplete values:*/
	jQuery("groundCampaignName").ready(
			function() {
				if(collectionNames!=null){
				autocomplete(document.getElementById("groundCampaignName"),
						collectionNames);}
			})

	// make interactions global so they can later be removed
	var select_interaction, draw_interaction, modify_interaction;
	//AddData to layer List method 
	function addDataLayerList(collectionName, datafileName, privacy, element) {
		console.log("adding data to layer list");

		if (element != null && element instanceof HTMLElement) {
			console.log("HTMLElement found");
		} else if (element != null && !(element instanceof HTMLElement)) {
			console
					.log("element is not HTMLElement but an id. Getting DOM element from id");
			var element = document.querySelector('[data-id="' + element + '"]');
		}
		if (!ajaxLoading) {

			ajaxLoading = true;

			AUI()
					.use(
							'aui-base',
							'aui-io-request',
							function(A) {

								A.io
										.request(
												'${doAction}',
												{
													dataType : 'html',
													method : 'POST',
													data : {
														<portlet:namespace/>portletActionName : "/layerListDataRow",
														<portlet:namespace/>collectionName : collectionName,
														<portlet:namespace/>granuleName : datafileName,
														<portlet:namespace/>privacy : privacy
													},
													on : {//ajax call start function
														start : function() {
															jQuery(
																	'#overlayLoading')
																	.show();
															jQuery('#spinner')
																	.show();

														},//ajax call end function
														end : function() {
														},
														//ajax call success function
														success : function() {
															//reading server response
															console
																	.log(this
																			.get('responseData'));

															var response = JSON
																	.parse(this
																			.get('responseData'));
															//if an error is raised, display an error message to the client 
															if (response
																	&& response.error) {

																jQuery(
																		'#inner-error-message')
																		.html(
																				response.error);
																jQuery(
																		'#errorMessage')
																		.fadeIn();
																closeAlertMessage();

																ajaxLoading = false;
																jQuery(
																		'#overlayLoading')
																		.hide();

																jQuery(
																		'#spinner')
																		.hide();
															} else {

																//loading portion of jsp contaning the layer row
																if (response === ""
																		|| !response) {
																	//else, display the layer in the layerlist

																	//incrementing count in layerlist
																	var count = parseInt(jQuery(
																			'#countLayers')
																			.text());
																	jQuery(
																			'#countLayers')
																			.text(
																					count + 1);
																	jQuery(
																			'#countLayersNav')
																			.text(
																					count + 1);

																	//append a new div to the layer list container containing hte layer
																	var uniqueID = generateString();
																	/* var data = this
																			.get('responseData'); */
																	var layerList = document
																			.getElementById("collapseTwo");

																	var listGroupItem = document
																			.createElement("div");
																	listGroupItem
																			.setAttribute(
																					"id",
																					uniqueID);

																	listGroupItem
																			.setAttribute(
																					"class",
																					"list-group-item dataRow_"
																							+ datafileName
																							+ "");
																	layerList
																			.prepend(listGroupItem);

																	var idDiv = '#'
																			+ uniqueID;

																	jQuery(
																			idDiv)
																			.load(
																					'${doAction}',
																					function() {
																						if (element != null) {
																							addEntry(
																									collectionName,
																									datafileName,
																									privacy);
																						}
																						console
																								.log('Searching for granules the given data can overlay with');

																						//getting data the given data can overlay with
																						//getting the submenus for each data
																						var overlayWithSectionElements = document
																								.getElementsByClassName("overlayWithSection");

																						//Layer names
																						var layerListDatas = document
																								.getElementsByClassName("layerListDatasNames");

																						var layerListItem = document
																								.getElementsByClassName("layerListItem");

																						var res = [];
																						var resNames = [];
																						for (var x = 0; x < layerListDatas.length; x++) {

																							res
																									.push(layerListDatas[x]
																											.getAttribute('data-value'));

																							resNames
																									.push(layerListItem[x]
																											.getAttribute('data-value'));
																						}

																						//For each overlay menu in layerlist, clear and update the layer list available for overlay
																						for (var i = 0; i < overlayWithSectionElements.length; i++) {
																							overlayWithSectionElements[i].innerHTML = "";

																							for (var j = 0; j < res.length; j++) {
																								if (res[j] != null) {
																									var dataBaseOverlay = overlayWithSectionElements[i]
																											.getAttribute('data-value');

																									if (dataBaseOverlay != resNames[j]) {

																										overlayWithSectionElements[i]
																												.insertAdjacentHTML(
																														'beforeend',
																														'<aui-item-checkbox  class="overlayWithItem'+dataBaseOverlay+'"  data-value="'+res[j]+'" interactive>'
																																+ resNames[j]
																																+ '</aui-item-checkbox>');
																									}
																								}

																							}

																						}
																						// resetting the ajaxloading attribute to false and hiding spinner
																						ajaxLoading = false;
																						jQuery(
																								'#overlayLoading')
																								.hide();

																						jQuery(
																								'#spinner')
																								.hide();
																					});

																	if (element != null) {
																		//change the button style and onclick event to allow remove functionnality

																		element.innerHTML = '<span class="glyphicon glyphicon-minus" aria-hidden="true"></span>';
																		element.className = 'btn btn-link btn-remove-data pull-right';

																		element
																				.setAttribute(
																						'onclick',
																						'removeDataFromLayerList(\''
																								+ listGroupItem.id
																								+ '\', \''
																								+ collectionName
																								+ '\', \''
																								+ datafileName
																								+ '\',this);');

																		element
																				.setAttribute(
																						"data-id",
																						listGroupItem.id);
																		element
																				.setAttribute(
																						"data-privacy",
																						privacy);
																		element
																				.setAttribute(
																						"data-collection",
																						collectionName);
																		element
																				.setAttribute(
																						"data-filename",
																						datafileName);

																	}
																} else {
																	ajaxLoading = false;
																	jQuery(
																			'#overlayLoading')
																			.hide();

																	jQuery(
																			'#spinner')
																			.hide();
																}

															}

														}
													}
												});

							});

		}
	}

	//On search button click, retrieving result of search

	function searchAction() {
		console.log('search button triggered');
		clearMapSearchBoundingBox();
		clearMapVectorResults();
		clearMapOverlays();

		if (typeof select_interaction !== "undefined") {
			select_interaction.getFeatures().clear();
		}

		//destroying old search result
		jQuery('#resultListTable').DataTable().clear();
		jQuery('#resultListTable').DataTable().destroy();
		/* 	e.preventDefault(); */
		jQuery(".requiredInput").remove();

		var collectionInput = jQuery('#groundCampaignName').val();

		if (collectionInput.length < 1) {
			jQuery('#dataCategoryLink')
					.after(
							'<small class="requiredInput">Collection name is required</small>');
		} else {

			if (!ajaxLoading) {
				ajaxLoading = true;
				/*  AJAX SERVE RESOURCE */
				AUI()
						.use(
								'aui-base',
								'aui-io-request',
								function(A) {

									A.io
											.request(
													'${refreshResultList}',
													{
														dataType : 'json',
														method : 'POST',
														form : {
															id : 'searchForm'
														},
														on : {

															start : function() {
																jQuery(
																		'#overlayLoading')
																		.show();
																jQuery(
																		'#spinner')
																		.show();
															},
															success : function() {
																jQuery(
																		'#overlayLoading')
																		.hide();

																jQuery(
																		'#spinner')
																		.hide();
																document
																		.getElementById("resultListDiv").className = "d-block";

																document
																		.getElementById("resultListTable").className = "table";

																var dataResultListJson = this
																		.get('responseData');

																if (dataResultListJson.error) {
																	console
																			.error(dataResultListJson.error);

																	jQuery(
																			'#inner-error-message')
																			.html(
																					dataResultListJson.error);
																	jQuery(
																			'#errorMessage')
																			.fadeIn();
																	closeAlertMessage();
																} else {
																	var ctx = "${pageContext.request.contextPath}";
																	imgSrc = ctx
																			+ "/media/No_image.png";
																	generateResultListTable(
																			dataResultListJson,
																			imgSrc);
																}

																ajaxLoading = false;
															},
															failure : function() {
																console
																		.log('failure');
															},
															end : function() {

																var groupColumn = 4;
																var resultTable = jQuery(
																		'#resultListTable')
																		.DataTable(
																				{
																					columnDefs : [ {
																						"targets" : [ groupColumn ],
																						"visible" : false
																					} ],
																					orderFixed : [ [
																							groupColumn,
																							'desc' ] ],
																					rowGroup : {
																						startRender : function(
																								rows,
																								group) {

																							return '<tr colspan="7"><td id ="'+group+'"class="details-controlRowGroup"></td><td>'
																									+ group
																									+ '</td></tr> ';

																						},
																						dataSrc : groupColumn
																					}
																				});
																resultTable
																		.rowGroup()
																		.dataSrc(
																				groupColumn);

																//collapse of row grouping childs
																jQuery(
																		'#resultListTable')
																		.on(
																				'click',
																				'td.details-controlRowGroup',
																				function() {
																					jQuery(
																							'.'
																									+ this.id)
																							.toggle();

																					var child = resultTable
																							.row(this).child;

																					if (child
																							.isShown()) {
																						child
																								.hide();
																					} else {
																						child
																								.show();
																					}
																				})

															}
														}

													})
								});

			}
		}

	}

	//Display a given portlet
	function portletAction(granuleName, collectionName, privacyType,
			portletActionName) {

		if (!ajaxLoading) {

			ajaxLoading = true;
			var overlayList = [];

			AUI()
					.use(
							'aui-base',
							'aui-io-request',
							function(A) {

								//if the portletaction is overlay then for the dataChecklist an overlay is done with all the data checked
								if (portletActionName == "/visualisationOverlay") {

									var overlayItems = document
											.getElementsByClassName("overlayWithItem"
													+ granuleName);

									for (var i = 0; i < overlayItems.length; i++) {
										var isChecked = overlayItems.item(i)
												.hasAttribute('checked');
										if (isChecked) {
											overlayList.push(overlayItems.item(
													i).getAttribute(
													'data-value'));
										}

									}

								}

								//AJAX request to serveResource method 
								A.io
										.request(
												'${doAction}',
												{
													dataType : 'html',
													method : 'POST',
													data : {
														/* <portlet:namespace/>id : dataId, */
														<portlet:namespace/>collectionName : collectionName,
														<portlet:namespace/>granuleName : granuleName,
														<portlet:namespace/>privacy : privacyType,
														<portlet:namespace/>portletActionName : portletActionName,
														<portlet:namespace/>dataOverlayList : overlayList
																.toString()
													},
													on : {
														start : function() {
															console
																	.log('loading Portlet...');

															jQuery(
																	'#overlayLoading')
																	.show();
															jQuery('#spinner')
																	.show();

														},
														end : function() {
															console.log('end');

														},
														success : function() {
															console
																	.log('Success on loading Portlet...');

															console
																	.log("passed followed values : "
																			+ overlayList);

															var uniqueID = generateString();

															var visuWK = document
																	.getElementById("visualisationWorkspace");

															var porletActionDiv = document
																	.createElement("div");

															porletActionDiv
																	.setAttribute(
																			"id",
																			uniqueID);

															porletActionDiv.className = "gallery_product col-lg-6 col-md-6 col-sm-4 col-xs-6 filter sprinkle draggable";
															porletActionDiv
																	.setAttribute(
																			"draggable",
																			"true");
															jQuery( "#visualisationWorkspace" ).prepend( porletActionDiv );
															/* visuWK
																	.appendChild(porletActionDiv); */

															var idDiv = '#'
																	+ uniqueID;

															jQuery(idDiv)
																	.load(
																			'${doAction}',
																			function() {
																				ajaxLoading = false;
																				jQuery(
																						'#overlayLoading')
																						.hide();
																				jQuery(
																						'#spinner')
																						.hide();

																			});

														},
														failure : function() {
															console
																	.log('failure on loading Portlet');
														}

													}
												});

							});

		}
	}

	/*
	 Function to share user data to CMR 
	 */
	function shareData(granuleId) {
		/* alert('share!') */

		if (!ajaxLoading) {

			ajaxLoading = true;
			var overlayList = [];

			AUI()
					.use(
							'aui-base',
							'aui-io-request',
							function(A) {

								//AJAX request to serveResource method 
								A.io
										.request(
												'${shareData}',
												{
													dataType : 'html',
													method : 'POST',
													data : {
														/* <portlet:namespace/>id : dataId, */
														<portlet:namespace/>granuleId : granuleId
													},
													on : {
														start : function() {
															console
																	.log('loading Portlet...');
															jQuery(
																	'#bottomleftoverlay')
																	.css(
																			"display",
																			"block");

															jQuery(
																	'#bottomleftoverlay')
																	.attr(
																			"class",
																			"alert alert-info alert-dismissible fade show");
															jQuery(
																	'#alertContent')
																	.html(
																			"<strong>Sharing "
																					+ granuleId
																					+ ". </strong><p>This might take a while...</p>");
															/* 					jQuery('#overlayLoading').show();
																				jQuery('#spinner').show(); */

														},
														end : function() {
															console.log('end');
															jQuery(
																	'#bottomleftoverlay')
																	.css(
																			"display",
																			"block");
															jQuery(
																	'#bottomleftoverlay')
																	.attr(
																			"class",
																			"alert alert-success fade show");
															jQuery(
																	'#alertContent')
																	.html(
																			"<strong>Success! </strong><p>"
																					+ granuleId
																					+ " has been shared and is now available for all users</p>");
															var response = this
																	.get('responseData');

															if (response == "400") {
																jQuery(
																		'#bottomleftoverlay')
																		.css(
																				"display",
																				"block");
																jQuery(
																		'#bottomleftoverlay')
																		.attr(
																				"class",
																				"alert alert-danger fade show");
																jQuery(
																		'#alertContent')
																		.html(
																				"<strong>Error! </strong><p>"
																						+ granuleId
																						+ " couldn't be shared. Please contact the administrator");

															} else if (response == "200") {
																jQuery(
																		'#bottomleftoverlay')
																		.css(
																				"display",
																				"block");

																jQuery(
																		'#bottomleftoverlay')
																		.attr(
																				"class",
																				"alert alert-success fade show");
																jQuery(
																		'#alertContent')
																		.html(
																				"<strong>Success! </strong><p>"
																						+ granuleId
																						+ " has been shared and is now available for all users</p>");
																var str = "How are you doing today?";
																var res = granuleId
																		.split(":@");
																updateEntry(
																		res[0],
																		res[1],
																		'PUBLIC');

															}

														},
														success : function() {
															console
																	.log('Success on loading Portlet...');

															/* var str = "How are you doing today?";
															var res = granuleId
																	.split(":@");
															updateEntry(res[0],
																	res[1],
																	'PUBLIC'); */

															/* 	jQuery('#overlayLoading').hide();
																jQuery('#spinner').hide(); */

															ajaxLoading = false;

														},
														failure : function() {
															console
																	.log('failure on loading Portlet');
														}

													}
												});

							});

		}
	}

	var searchMap;
	var vector_layer;
	// variable used by ajax calls to prevent ajax call to be triggered several
	// times

	var ajaxLoading = false;

	jQuery(document).ready(checkContainer);

	function checkContainer() {
		if (jQuery('#searchmap').is(':visible')) {
			/*
			 * NAVIGATION MAIN MENU
			 */

			jQuery('#periodSearch').hide();
			jQuery('#locationSearch').hide();
			jQuery('#dataCategorySearch').hide();

			jQuery("li.periodSearch").click(function() {
				jQuery('#periodSearch').css("display", "block");

				jQuery('#periodSearch').show();
				jQuery('#searchMenuList').hide();
				jQuery('#searchButton').hide();
				jQuery('#clearButton').hide();
				jQuery('#privacyTypeForm').hide();

			});
			jQuery("li.locationSearch").click(function() {
				jQuery('#locationSearch').css("display", "block");

				jQuery('#locationSearch').show();
				jQuery('#searchMenuList').hide();
				jQuery('#searchButton').hide();
				jQuery('#clearButton').hide();
				jQuery('#privacyTypeForm').hide();

			});

			jQuery("li.dataCategorySearch").click(function() {
				jQuery('#dataCategorySearch').css("display", "block");

				jQuery('#dataCategorySearch').show();
				jQuery('#searchMenuList').hide();
				jQuery('#searchButton').hide();
				jQuery('#clearButton').hide();
				jQuery('#privacyTypeForm').hide();

			});

			jQuery(".mainMenuBack").click(function() {
				jQuery('#searchMenuList').show();
				jQuery('#searchButton').show();
				jQuery('#clearButton').show();
				jQuery('#privacyTypeForm').show();

				jQuery('#dataCategorySearch').hide();
				jQuery('#locationSearch').hide();
				jQuery('#periodSearch').hide();

			});
			/**
			 * on load, hide the spinner
			 */
			jQuery('#spinner').hide();
			jQuery('#overlayLoading').hide();

			// delete element from coordinate list
			jQuery('#coordinatesList').delegate(".listelement", "click",
					function() {
						var elemid = jQuery(this).attr('data-id');
						jQuery("#" + elemid).remove();
					});

			// create a vector layer used for editing
			vector_layer = new ol.layer.Vector({
				name : 'searchVector',
				source : new ol.source.Vector(),
				style : new ol.style.Style({
					fill : new ol.style.Fill({
						color : 'rgb(32,178,170, 0.2)'
					/* 	color : 'rgba(246, 71, 71, 0.7)' */
					}),
					stroke : new ol.style.Stroke({
						color : '#20B2AA',
						width : 2
					/* 	color : 'rgba(246, 71, 71, 1)',
						width : 1 */
					}),
					image : new ol.style.Circle({
						radius : 7,
						fill : new ol.style.Fill({
							color : '#20B2AA'
						})
					})
				})
			});

			// Creation of base maps
			var baseLayers = new ol.layer.Group({
				title : 'Base Maps',

				openInLayerSwitcher : true,
				layers : [ new ol.layer.Tile({
					name : 'OpenStreetMap',
					type : 'base',
					visible : false,
					source : new ol.source.OSM({
						title : "OpenStreetMap",
						wrapDateLine : false,
						wrapX : false,
						noWrap : true
					}),
					isBaseLayer : true
				}), new ol.layer.Tile({
					name : 'Stamen Terrain',
					type : 'base',
					source : new ol.source.Stamen({
						title : "Stamen terrain",
						wrapDateLine : false,
						wrapX : false,
						noWrap : true,
						layer : "terrain"
					}),
					type : 'base',
					isBaseLayer : true
				})

				]
			});

			// Popup overlay for layer information
			var popup = new ol.Overlay.Popup({
				popupClass : "default", // "tooltips", "warning" "black" "default",
				// "tips",
				// "shadow",
				closeBox : true,
				positioning : 'auto',
				autoPan : true,
				autoPanAnimation : {
					duration : 250
				}
			});

			// setting projection to EPSG 4326 standard
			var projection = ol.proj.get('EPSG:4326');

			// setting map extent
			var maxExtent = [ -180, -90, 180, 90 ];

			// setting map center
			var centerpos = [ 0, 0 ];
			var newpos = ol.proj.transform(centerpos, 'EPSG:4326', 'EPSG:4326');

			// Creation of the map wit a Stamen Terrain layer
			searchMap = new ol.Map({
				target : 'searchmap',
				layers : [ baseLayers, vector_layer ],
				overlays : [ popup ],
				view : new ol.View({

					extent : ol.proj.transformExtent(maxExtent, 'EPSG:4326',
							'EPSG:4326'),
					projection : projection,
					center : newpos,
					minZoom : 4,
					zoom : 4

				})
			});

			// Main control bar
			var mainbar = new ol.control.Bar();
			searchMap.addControl(mainbar);

			// adding geocoder feature to be able to search location on map
			var geocoder = new Geocoder('nominatim', {
				provider : 'osm',
				lang : 'en',
				placeholder : 'Search for ...',
				limit : 5,
				debug : false,
				autoComplete : true,
				keepOpen : true
			});

			mainbar.addControl(new ol.control.FullScreen());
			mainbar.addControl(geocoder);
			// on address chosen show popup and set view to given location
			geocoder.on('addresschosen', function(evt) {
				window.setTimeout(function() {
					searchMap.getView().setZoom(12);
					popup.show(evt.coordinate, evt.address.formatted);
				}, 1000);
			});

			// adding mouse position control to the map (lat lon)
			var mouse_position = new ol.control.MousePosition({
				coordinateFormat : ol.coordinate.createStringXY(4),
				projection : 'EPSG:4326',
				target : document.getElementById('mouseLocation')
			});
			searchMap.addControl(mouse_position);
			/* Standard Controls */

			mainbar.setPosition("top-right");

			// Add selection tool (a toggle control with a explore Toggle interaction)
			var exploreCtrl = new ol.control.Toggle({
				html : '<span>EXPLORE</span>',
				className : "exploreToggle",
				title : "exploreToggle",
				interaction : new ol.interaction.Select(),
				active : true,
				onToggle : function(active) {
					jQuery("#overlay").toggle();
				}
			});
			searchMap.addControl(exploreCtrl);

			// Style of Markers
			var styleMarker = new ol.style.Style({
				image : new ol.style.Circle({
					radius : 6,
					stroke : new ol.style.Stroke({
						color : 'white',
						width : 2
					}),
					fill : new ol.style.Fill({
						color : 'green'
					})
				})
			});

			// Control Select on features : display of a popup with Data's metadatas
			var select = new ol.interaction.Select({});
			searchMap.addInteraction(select);
			select
					.getFeatures()
					.on(
							[ 'add' ],
							function(e) {
								var feature = e.element;
								var featureHeader = '<strong class="important-bmap">'
										+ feature.get('name') + '</strong>';
								var featureDesc = feature.get('name');
								var content = "";
								content += featureHeader;
								var stringifyFunc = ol.coordinate
										.createStringXY(2);
								content += '<img class="layerPreview" src="'
										+ feature.get('imgSrc') + '">';
								content += '<p class="dataOverview"><strong>Collection: </strong> '
										+ feature.get('collection') + '</p>';
								content += '<p class="dataOverview"><strong>Acquisition Date: </strong>'
										+ feature.get('acquisitionDate')
										+ '</p>';
								/* 	content += '<p class="dataOverview"><strong>Centroid Lat: </strong>'
											+ feature.get('centroidLat') + '</p>';
									content += '<p class="dataOverview"><strong>Centroid Lon: </strong>'
											+ feature.get('centroidLon') + '</p>'; */

								if (feature.get('name')) {
									popup.show(feature.getGeometry()
											.getFirstCoordinate(), content);
								}
							})

			select.getFeatures().on([ 'remove' ], function(e) {
				popup.hide();
			})

			// on load, retrieve layer list from local storage
			retrieveLayerList();

		}

		else {
			setTimeout(checkContainer, 50); //wait 50 ms, then try again
		}

	}

	// When the customing points functionnality is clicked on, we remove the drawing
	// interaction if its exists and display the custom Points div

	jQuery('#addCustomPoints').on('click', function(e) {
		searchMap.removeInteraction(draw_interaction);
		jQuery('#customPoints').show();
		jQuery('#coordinatesList').empty();
		jQuery('#locationInputsHidden').empty();
		clearMapSearchBoundingBox();

	});

	// Toogle
	jQuery("#explore-toggle-container").click(function() {
		jQuery("#overlaySearchMenu").toggle("slide");
		jQuery("#resultListTableDiv").toggle("slide");

	});

	// Get coordinates of drawed box (need portletNamespace tag can't be
	// externalized to .js file)
	function getCoordinatesFeature(coordinatesString) {
		jQuery('#coordinatesList').innerHTML = "";
		var coordinatesTable = coordinatesString.toString().split(",");

		for (var i = 0; i < (coordinatesTable.length - 2); i += 2) {
			var lat = parseFloat(coordinatesTable[i]);
			var lon = parseFloat(coordinatesTable[i + 1]);

			var latFixed = (lat).toFixed(4);
			var lonFixed = (lon).toFixed(4);

			var newitem = latFixed + ',' + lonFixed;

			var uniqid = Math.round(new Date().getTime()
					+ (Math.random() * 100));

			if (coordinatesTable[i] != "" && coordinatesTable[i + 1] != "") {

				jQuery('#coordinatesList').append(
						'<li id="' + uniqid
								+ '" class="coordinatesSearch">Lon '
								+ latFixed + ' , Lat ' + lonFixed + '</li>');

				jQuery('#locationInputsHidden')
						.append(
								'<input class="locationInput" type="hidden" name="<portlet:namespace/>coordinatesInputs" value="'
										+ newitem + '"></li>');

				searchMap.removeInteraction(draw_interaction);

			} else {

				jQuery('#latLongNoMatch').show();
			}

		}

	}

	function closeAlertBox() {
		jQuery('#bottomleftoverlay').css("display", "none");

	}

	function autocomplete(inp, arr) {
		/*the autocomplete function takes two arguments,
		the text field element and an array of possible autocompleted values:*/
		var currentFocus;
		/*execute a function when someone writes in the text field:*/
		inp
				.addEventListener(
						"input",
						function(e) {
							var a, b, i, val = this.value;
							/*close any already open lists of autocompleted values*/
							closeAllLists();
							if (!val) {
								return false;
							}
							currentFocus = -1;
							/*create a DIV element that will contain the items (values):*/
							a = document.createElement("DIV");
							a.setAttribute("id", this.id + "autocomplete-list");
							a.setAttribute("class", "autocomplete-items");
							a.addEventListener("focusout", function(e) {
								closeAllLists();
							})
							/* document.getElementById("groundCampaignNameautocomplete-list").addEventListener("mouseleave", function(e) {
								console.log("closing lists");
								closeAllLists();
							}) */
							/*append the DIV element as a child of the autocomplete container:*/
							this.parentNode.appendChild(a);
							/*for each item in the array...*/
							for (i = 0; i < arr.length; i++) {
								var pos = arr[i].toUpperCase().indexOf(
										val.toUpperCase());
								/*check if the item starts with the same letters as the text field value:*/
								if (pos > -1) {
									/*create a DIV element for each matching element:*/
									b = document.createElement("DIV");
									/*make the matching letters bold:*/
									b.innerHTML = arr[i].substr(0, pos);
									b.innerHTML += "<strong>"
											+ arr[i].substr(pos, val.length)
											+ "</strong>";
									b.innerHTML += arr[i].substr(pos
											+ val.length);
									/*insert a input field that will hold the current array item's value:*/
									b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
									/*execute a function when someone clicks on the item value (DIV element):*/
									b
											.addEventListener(
													"click",
													function(e) {
														/*insert the value for the autocomplete text field:*/
														inp.value = this
																.getElementsByTagName("input")[0].value;
														/*close the list of autocompleted values,
														(or any other open lists of autocompleted values:*/
														closeAllLists();
													});
									a.appendChild(b);
								}
							}
						});

		inp
				.addEventListener(
						"focusin",
						function(e) {
							var a, b, i, val = this.value;
							/*close any already open lists of autocompleted values*/
							closeAllLists();
							/* if (!val) {
								return false;
							} */
							currentFocus = -1;
							/*create a DIV element that will contain the items (values):*/
							a = document.createElement("DIV");
							a.setAttribute("id", this.id + "autocomplete-list");
							a.setAttribute("class", "autocomplete-items");
							/*append the DIV element as a child of the autocomplete container:*/
							this.parentNode.appendChild(a);

							for (i = 0; i < arr.length; i++) {
								var pos = arr[i].toUpperCase().indexOf(
										val.toUpperCase());
								if (pos > -1) {
									/*create a DIV element for each matching element:*/
									b = document.createElement("DIV");
									/*make the matching letters bold:*/
									b.innerHTML = arr[i].substr(0, pos);
									b.innerHTML += "<strong>"
											+ arr[i].substr(pos, val.length)
											+ "</strong>";
									b.innerHTML += arr[i].substr(pos
											+ val.length);
									/*insert a input field that will hold the current array item's value:*/
									b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
									b
											.addEventListener(
													"click",
													function(e) {
														/*insert the value for the autocomplete text field:*/
														inp.value = this
																.getElementsByTagName("input")[0].value;
														/*close the list of autocompleted values,
														(or any other open lists of autocompleted values:*/
														closeAllLists();
													});
									a.appendChild(b);
								}

								var x = document.getElementById(this.id
										+ "autocomplete-list");
								if (x)
									x = x.getElementsByTagName("div");
								if (e.keyCode == 40) {
									/*If the arrow DOWN key is pressed,
									increase the currentFocus variable:*/
									currentFocus++;
									/*and and make the current item more visible:*/
									addActive(x);
								} else if (e.keyCode == 38) { //up
									/*If the arrow UP key is pressed,
									decrease the currentFocus variable:*/
									currentFocus--;
									/*and and make the current item more visible:*/
									addActive(x);
								} else if (e.keyCode == 13) {
									/*If the ENTER key is pressed, prevent the form from being submitted,*/
									e.preventDefault();
									if (currentFocus > -1) {
										/*and simulate a click on the "active" item:*/
										if (x)
											x[currentFocus].click();
									}
								}

							}

						});
		/*execute a function presses a key on the keyboard:*/
		inp.addEventListener("keydown", function(e) {

			var x = document.getElementById(this.id + "autocomplete-list");
			if (x)
				x = x.getElementsByTagName("div");
			if (e.keyCode == 40) {
				/*If the arrow DOWN key is pressed,
				increase the currentFocus variable:*/
				currentFocus++;
				/*and and make the current item more visible:*/
				addActive(x);
			} else if (e.keyCode == 38) { //up
				/*If the arrow UP key is pressed,
				decrease the currentFocus variable:*/
				currentFocus--;
				/*and and make the current item more visible:*/
				addActive(x);
			} else if (e.keyCode == 13) {
				/*If the ENTER key is pressed, prevent the form from being submitted,*/
				e.preventDefault();
				if (currentFocus > -1) {
					/*and simulate a click on the "active" item:*/
					if (x)
						x[currentFocus].click();
				}
			}
		});
		function addActive(x) {
			/*a function to classify an item as "active":*/
			if (!x)
				return false;
			/*start by removing the "active" class on all items:*/
			removeActive(x);
			if (currentFocus >= x.length)
				currentFocus = 0;
			if (currentFocus < 0)
				currentFocus = (x.length - 1);
			/*add class "autocomplete-active":*/
			x[currentFocus].classList.add("autocomplete-active");
		}
		function removeActive(x) {
			/*a function to remove the "active" class from all autocomplete items:*/
			for (var i = 0; i < x.length; i++) {
				x[i].classList.remove("autocomplete-active");
			}
		}
		function closeAllLists(elmnt) {
			/*close all autocomplete lists in the document,
			except the one passed as an argument:*/
			var x = document.getElementsByClassName("autocomplete-items");
			for (var i = 0; i < x.length; i++) {
				if (elmnt != x[i] && elmnt != inp) {
					x[i].parentNode.removeChild(x[i]);
				}
			}
		}
		/*execute a function when someone clicks in the document:*/
		/* 		document.addEventListener("click", function(e) {
		 closeAllLists(e.target);
		 }); */
	}
/* 	//I'm using "click" but it works with any event
	document.addEventListener('click', function(event) {
		if (document.getElementById("groundCampaignNameautocomplete-list")) {
			var isClickInside = document.getElementById(
					"groundCampaignNameautocomplete-list").contains(
					event.target);

			if (!isClickInside) {
				
				closeAllLists();
			}
			
		
		}

	}); */
</script>
