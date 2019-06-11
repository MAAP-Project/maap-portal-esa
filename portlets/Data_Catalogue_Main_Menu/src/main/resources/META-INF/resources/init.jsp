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


<portlet:defineObjects />


<!--  AUI Core -->
<!-- <script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script> -->
<script src="//aui-cdn.atlassian.com/aui-adg/6.0.9/js/aui.min.js"></script>
<link rel="stylesheet"
	href="//aui-cdn.atlassian.com/aui-adg/6.0.9/css/aui.min.css"
	media="all">

<!-- OPENLAYERS -->
<link rel="stylesheet"
	href="https://openlayers.org/en/latest/css/ol.css" />
<script type="text/javascript"
	src="https://openlayers.org/en/latest/build/ol.js"></script>
<script
	src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL,Object.assign"></script>
<!-- /OPENLAYERS -->

<!-- OL-EXT -->
<link rel="stylesheet"
	href="https://cdn.rawgit.com/Viglino/ol-ext/master/dist/ol-ext.min.css" />
<script type="text/javascript"
	src="https://cdn.rawgit.com/Viglino/ol-ext/master/dist/ol-ext.min.js"></script>
<!-- / OL-EXT -->


<!-- GEOCODER -->
<link href="https://unpkg.com/ol-geocoder/dist/ol-geocoder.min.css"
	rel="stylesheet">
<script src="https://unpkg.com/ol-geocoder"></script>
<!-- /GEOCODER -->

<!-- FONT IMPORTS -->
<link href="https://fonts.googleapis.com/css?family=Roboto"
	rel="stylesheet">


<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>


<!-- <script type="text/javascript"
	src="https://cdn.datatables.net/v/bs4/dt-1.10.18/rg-1.1.0/sl-1.2.6/datatables.min.js"></script> -->

<!-- DATA TABLES -->
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/v/bs4/dt-1.10.18/rg-1.1.0/sl-1.2.6/datatables.min.css" />

<script type="text/javascript"
	src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<script type="text/javascript"
	src="https://cdn.datatables.net/responsive/2.2.3/js/dataTables.responsive.min.js"></script>
<script type="text/javascript"
	src="https://cdn.datatables.net/rowgroup/1.1.0/js/dataTables.rowGroup.min.js"></script>
<!-- / DATA TABLES -->


<!-- LOADING SPINNER STYLE -->
<link rel="stylesheet"
	href="//cdnjs.cloudflare.com/ajax/libs/css-spinning-spinners/1.1.0/load8.css" />

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
	//variable used by ajax calls to prevent ajax call to be triggered several times
	var ajaxLoading = false;

	/**
	 * on load, hide the spinner
	 */
	$('#spinner').hide();

	/**
	 * Toggle Navigation overlay
	 * 
	 * @returns
	 */
	function closeNav() {
		$("#overlay").toggle();
	}

	/**
	 * Function called at catalogueToggle element click
	 * 
	 * @returns
	 */
	function catalogueToggle() {
		var testContainer = document.getElementById("searchmap");
		var canvasChildNode = testContainer.querySelector('canvas');
		canvasChildNode.style.display = "block";

	}

	/**
	 * Toggle Result List
	 * 
	 * @returns
	 */
	function collapseResultList() {
		document.getElementById("resultListDiv").className = "d-none";
		// $('#resultListDiv').style.display = "none"; */
	}

	retrieveLayerList();

	/**
	 * remove Portlet from page
	 */

	function delete_row(e) {
		var nodeToRemove = e.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
		nodeToRemove.remove();

	}
	/**
	 * remove data from LayerList
	 */
	function delete_Entry(collectionName, datafileName, element) {

		element.parentNode.parentNode.parentNode.parentNode.outerHTML = "";

		var buttonElement = document.getElementById('btn-add-rmv-'
				+ collectionName + '-' + datafileName + '');
		removeDataFromLayerList(null, collectionName, datafileName,
				buttonElement);

	}

	$('#coordinatesList').delegate(".listelement", "click", function() {
		var elemid = $(this).attr('data-id');
		$("#" + elemid).remove();
	});

	// create a vector layer used for editing
	var vector_layer = new ol.layer.Vector({
		name : 'searchVector',
		source : new ol.source.Vector(),
		style : new ol.style.Style({
			fill : new ol.style.Fill({
				color : 'rgba(255, 255, 255, 0.2)'
			}),
			stroke : new ol.style.Stroke({
				color : '#ffcc33',
				width : 2
			}),
			image : new ol.style.Circle({
				radius : 7,
				fill : new ol.style.Fill({
					color : '#ffcc33'
				})
			})
		})
	});
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

	// Popup overlay
	var popup = new ol.Overlay.Popup({
		popupClass : "default", // "tooltips", "warning" "black" "default", "tips",
		// "shadow",
		closeBox : true,
		positioning : 'auto',
		autoPan : true,
		autoPanAnimation : {
			duration : 250
		}
	});

	var projection = ol.proj.get('EPSG:4326');

	var maxExtent = [ -180, -90, 180, 90 ];

	var centerpos = [ 0, 0 ];
	var newpos = ol.proj.transform(centerpos, 'EPSG:4326', 'EPSG:4326');

	// Creation of the map wit a Stamen Terrain layer
	var searchMap = new ol.Map({
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
		html : '<span">EXPLORE</span>',
		className : "exploreToggle",
		title : "exploreToggle",
		interaction : new ol.interaction.Select(),
		active : true,
		onToggle : function(active) {
			$("#overlay").toggle();
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
	// On selected => show/hide popup
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
						var stringifyFunc = ol.coordinate.createStringXY(2);
						content += '<img class="layerPreview" src="'
								+ feature.get('imgSrc') + '">';
						content += '<p class="dataOverview"><strong>Collection: </strong> '
								+ feature.get('collection') + '</p>';
						content += '<p class="dataOverview"><strong>Acquisition Date: </strong>'
								+ feature.get('acquisitionDate') + '</p>';
						content += '<p class="dataOverview"><strong>Centroid Lat: </strong>'
								+ feature.get('centroidLat') + '</p>';
						content += '<p class="dataOverview"><strong>Centroid Lon: </strong>'
								+ feature.get('centroidLon') + '</p>';

						if (feature.get('name')) {
							popup.show(feature.getGeometry()
									.getFirstCoordinate(), content);
						}
					})
	select.getFeatures().on([ 'remove' ], function(e) {
		popup.hide();
	})

	/*
	 * //adding scaleline control to the map var scaleline=new
	 * ol.control.ScaleLine(); searchMap.addControl(scaleline);
	 */
	// make interactions global so they can later be removed
	var select_interaction, draw_interaction, modify_interaction;

	// get the interaction type
	var $interaction_type = $('[name="interaction_type"]');
	// rebuild interaction when changed
	$interaction_type.on('click', function(e) {
		// add new interaction
		if (this.value === 'draw') {
			addDrawInteraction();
		} else {
			addModifyInteraction();
		}
	});
	// clear map when user clicks on reset
	$("#deleteCoordinates").click(function() {
		clearMapSearchBoundingBox();
		$('#coordinatesList').empty();
		$('#locationInputsHidden').empty();
	});

	geocoder.on('addresschosen', function(evt) {
		window.setTimeout(function() {
			searchMap.getView().setZoom(12);
			popup.show(evt.coordinate, evt.address.formatted);
		}, 1000);
	});

	// at click on drawBoundingBox button, reset interaction and coordinatelist
	$('#drawBoundingBox').on('click', function(e) {
		searchMap.removeInteraction(draw_interaction);
		addDrawInteraction();

		$('#coordinatesList').empty();
		$('#locationInputsHidden').empty();

	});

	// When the customing points functionnality is clicked on, we remove the drawing
	// interaction if its exists and display the custom Points div

	$('#addCustomPoints').on('click', function(e) {
		searchMap.removeInteraction(draw_interaction);
		document.getElementById("customPoints").style.display = "block";
		$('#coordinatesList').empty();
		$('#locationInputsHidden').empty();
		clearMapSearchBoundingBox();

	});

	// Toogle
	$("#explore-toggle-container").click(function() {
		$("#overlaySearchMenu").toggle("slide");
		$("#resultListTableDiv").toggle("slide");

	});

	// Get coordinates of drawed box (need portletNamespace tag can't be externalized to .js file)
	function getCoordinatesFeature(coordinatesString) {
		$('#coordinatesList').innerHTML = "";
		var coordinatesTable = coordinatesString.toString().split(",");

		for (var i = 0; i < (coordinatesTable.length - 2); i += 2) {
			var lat = parseFloat(coordinatesTable[i]);
			var lon = parseFloat(coordinatesTable[i + 1]);

			var latFixed = (lat).toFixed(4);
			var lonFixed = (lon).toFixed(4);

			/* var point = latFixed + "," + lonFixed; */
			var newitem = latFixed + ',' + lonFixed;

			var uniqid = Math.round(new Date().getTime()
					+ (Math.random() * 100));

			if (coordinatesTable[i] != "" && coordinatesTable[i + 1] != "") {

				$('#coordinatesList').append(
						'<li id="' + uniqid + '" class="coordinatesSearch">Lon '
								+ latFixed + ' , Lat ' + lonFixed + '</li>');

				$('#locationInputsHidden')
						.append(
								'<input class="locationInput" type="hidden" name="<portlet:namespace/>coordinatesInputs" value="'
										+ newitem + '"></li>');

				searchMap.removeInteraction(draw_interaction);

			} else {

				$('#latLongNoMatch').show();
			}

		}

	}

	//At button click, adding coordinate to coordinatelist
	$('#addBtnLocation')
			.click(
					function() {
						var latitude = document.getElementById('latInput').value;
						var longitude = document.getElementById('lonInput').value;
						var newitem = latitude + ',' + longitude;
						var uniqid = Math.round(new Date().getTime()
								+ (Math.random() * 100));

						if (latitude != "" && longitude != "") {
							$('#coordinatesList').append(
									'<li id="' + uniqid + '" class="coordinatesSearch">Lon '
											+ latitude + ' , Lat ' + longitude
											+ '</li>');

							$('#locationInputsHidden')
									.append(
											'<input class="locationInput"  type="hidden" name="<portlet:namespace/>coordinatesInputs" value="'
													+ newitem + '"></li>');
							$('#addBtnLocation').disabled = false;
							$('#addBtnLocation').className = "btn btn-dark disabled";

						} else {
							$('#addBtnLocation').disabled = true;
							$('#addBtnLocation').className = "btn btn-dark";
							$('#latLongNoMatch').show();
						}

						return false;
					});
</script>
<aui:script>
	/* function getresultList() { */
	$('#searchButton')
			.click(
					function(e) {
						clearMapSearchBoundingBox();
						clearMapVectorResults();
						//destroying old search result
						$('#resultListTable').DataTable().clear();
						$('#resultListTable').DataTable().destroy();
						e.preventDefault();
						$(".requiredInput").remove();

						var collectionInput = $('#groundCampaignName').val();

						if (collectionInput.length < 1) {
							$('#dataCategoryLink')
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

																				$(
																						'#spinner')
																						.show();
																			},
																			success : function() {
																				$(
																						'#spinner')
																						.hide();
																				document
																						.getElementById("resultListDiv").className = "d-block";

																				document
																						.getElementById("resultListTable").className = "table table-striped";
																				document
																						.getElementById("resultListTable").className = "table table-striped";

																				var dataResultListJson = this
																						.get('responseData');
																				if (dataResultListJson !== undefined
																						&& dataResultListJson !== null
																						&& dataResultListJson !== "") {
																					if (dataResultListJson.collectionDataList !== undefined
																							&& dataResultListJson.collectionDataList !== null
																							&& dataResultListJson.collectionDataList !== "") {
																						for (var i = 0; i < dataResultListJson.collectionDataList.length; i++) {

																							tr = document
																									.createElement("tr");

																							tdControl = document
																									.createElement("td");
																							tdFilePreview = document
																									.createElement("td");
																							tdFileName = document
																									.createElement("td");
																							tdAcquDate = document
																									.createElement("td");
																							tdCollection = document
																									.createElement("td");
																							tdSubRegion = document
																									.createElement("td");
																							tdGranuleScene = document
																									.createElement("td");
																							tdAction = document
																									.createElement("td");

																							//setting elements classes
																							/* th.className = "important-bmap"; */
																							tr.className = dataResultListJson.collectionDataList[i].granuleGrouping;
																							/* tdControl.className = "details-control"; */
																							tdFileName.className = "dataTableValues";
																							tdAcquDate.className = "dataTableValues";
																							tdCollection.className = "dataTableValues";
																							tdSubRegion.className = "dataTableValues";
																							tdGranuleScene.className = "dataTableValues";
																							tdAction.className = "dataTableValues";

																							var dataID = dataResultListJson.collectionDataList[i].id;

																							var datafileName = dataResultListJson.collectionDataList[i].granuleName;

																							tdFileName
																									.appendChild(document
																											.createTextNode(datafileName));
																							var imgSrc = null;

																							if (dataResultListJson.collectionDataList[i].granuleGrouping == 'Nasa_products') {

																								var ctx = "${pageContext.request.contextPath}";
																								imgSrc = ctx
																										+ "/media/No_image.png";
																							} else {

																								imgSrc = dataResultListJson.collectionDataList[i].layerPreviewURL;
																							}

																							/* tdFilePreview.innerHTML = '<img  class="layerPreview" src='+imgSrc+'>'; */
																							tdFilePreview.innerHTML = '<img id="setMapExtent'
																							+ dataResultListJson.collectionDataList[i].collection
																							+ '-'
																							+ datafileName
																							+ '"  class="layerPreview" src='+imgSrc+'>';

																							tdCollection
																									.appendChild(document
																											.createTextNode(dataResultListJson.collectionDataList[i].collection));

																							tdSubRegion
																									.appendChild(document
																											.createTextNode(dataResultListJson.collectionDataList[i].subRegion));

																							tdGranuleScene
																									.appendChild(document
																											.createTextNode(dataResultListJson.collectionDataList[i].granuleGrouping));
																							tdAcquDate
																									.appendChild(document
																											.createTextNode(dataResultListJson.collectionDataList[i].acquisitionDate));

																							tdAction.innerHTML = '<button id="btn-add-rmv-'
																									+ dataResultListJson.collectionDataList[i].collection
																									+ '-'
																									+ datafileName
																									+ '" type="button" onClick="addDataLayerList(\''
																									+ dataResultListJson.collectionDataList[i].collection
																									+ '\', \''
																									+ datafileName
																									+ '\',this)" class="btn btn-link btn-add-data pull-right"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span> </button>';

																							tr
																									.appendChild(tdFilePreview);
																							tr
																									.appendChild(tdFileName);
																							tr
																									.appendChild(tdCollection);
																							tr
																									.appendChild(tdSubRegion);
																							tr
																									.appendChild(tdGranuleScene);
																							tr
																									.appendChild(tdAcquDate);
																							tr
																									.appendChild(tdAction);

																							document
																									.getElementById(
																											"resultListTableBody")
																									.appendChild(
																											tr);
																							tr
																									.setAttribute(
																											"id",
																											'trLayer'
																													+ dataResultListJson.collectionDataList[i].collection
																													+ '-'
																													+ datafileName);

																							// Display of the centroid on the map if the data is georeferenced

																							var centroidLon = dataResultListJson.collectionDataList[i].centroidLon;
																							var centroidLat = dataResultListJson.collectionDataList[i].centroidLat;
																							var minimumX = dataResultListJson.collectionDataList[i].minimumX;
																							var minimumY = dataResultListJson.collectionDataList[i].minimumY;
																							var maximumX = dataResultListJson.collectionDataList[i].maximumX;
																							var maximumY = dataResultListJson.collectionDataList[i].maximumY;
																							var granuleWkt = dataResultListJson.collectionDataList[i].wkt;

																							if ((typeof granuleWkt !== "undefined")
																									&& (typeof granuleWkt !== "undefined")) {
																								var coord = [
																										centroidLat,
																										centroidLon ];

																								var format = new ol.format.WKT();
																								var feature = format
																										.readFeature(granuleWkt);
																								feature
																										.setProperties({
																											'name' : dataResultListJson.collectionDataList[i].granuleName,
																											'imgSrc' : imgSrc,
																											'type' : "markers",
																											'collection' : dataResultListJson.collectionDataList[i].collection,
																											'subRegion' : dataResultListJson.collectionDataList[i].subRegion,
																											'acquisitionDate' : dataResultListJson.collectionDataList[i].acquisitionDate,
																											'centroidLat' : dataResultListJson.collectionDataList[i].centroidLat,
																											'centroidLon' : dataResultListJson.collectionDataList[i].centroidLon
																										});

																								_myStroke = new ol.style.Stroke(
																										{
																											color : 'rgba(241, 90, 34, 1)',
																											width : 1
																										});

																								_myFill = new ol.style.Fill(
																										{
																											color : 'rgba(240, 255, 0, 0.07)'
																										});

																								myStyle = new ol.style.Style(
																										{
																											stroke : _myStroke,
																											fill : _myFill
																										});

																								var vector = new ol.layer.Vector(
																										{
																											name : dataResultListJson.collectionDataList[i].collection
																													+ ':@'
																													+ datafileName,

																											source : new ol.source.Vector(
																													{
																														features : [ feature ]
																													}),
																											style : [ myStyle ]
																										});
																								searchMap
																										.addLayer(vector);
																								vector
																										.setZIndex(40);
																								var extent = vector
																										.getSource()
																										.getExtent();

																								var setExtentElement = document
																										.getElementById('setMapExtent'
																												+ dataResultListJson.collectionDataList[i].collection
																												+ '-'
																												+ datafileName
																												+ '');
																								var fileTrElement = document
																										.getElementById('trLayer'
																												+ dataResultListJson.collectionDataList[i].collection
																												+ '-'
																												+ datafileName
																												+ '');

																								setExtentElement
																										.setAttribute(
																												'onclick',
																												'setMapExtent("'
																														+ dataResultListJson.collectionDataList[i].collection
																														+ ':@'
																														+ datafileName
																														+ '")');

																								fileTrElement
																										.setAttribute(
																												'onmouseover',
																												'highlightVector("'
																														+ dataResultListJson.collectionDataList[i].collection
																														+ ':@'
																														+ datafileName
																														+ '")');

																								fileTrElement
																										.setAttribute(
																												'onmouseout',
																												'initializeVector("'
																														+ dataResultListJson.collectionDataList[i].collection
																														+ ':@'
																														+ datafileName
																														+ '")');

																							}

																						}

																					}
																				}
																				ajaxLoading = false;
																			},
																			failure : function() {
																				console
																						.log('failure');
																			},
																			end : function() {

																				var groupColumn = 4;
																				var resultTable = $(
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

																											return '<tr><td id ="'+group+'"class="details-controlRowGroup"></td><td>'
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
																				$(
																						'#resultListTable')
																						.on(
																								'click',
																								'td.details-controlRowGroup',
																								function() {
																									$(
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

																				//collapse on rows details
																				/* 			$(
																									'#resultListTable')
																									.on(
																											'click',
																											'td.details-control',
																											function() {
																												var tr = $(
																														this)
																														.closest(
																																'tr');
																												var row = resultTable
																														.row(tr);

																												if (row.child
																														.isShown()) {
																													// This row is already open - close it
																													row.child
																															.hide();
																													tr
																															.removeClass('shown');
																												} else {
																													// Open this row
																													row
																															.child(
																																	format(tr
																																			.data('child-value')))
																															.show();
																													tr
																															.addClass('shown');
																												}
																											}) */

																			}
																		}

																	})
												});

							}
						}

					})
	//returns hidden value
	/* 	function format(value) {
	 return '<div>Hidden Value: ' + value + '</div>';
	 } */

	//AddData to layer List method 
	function addDataLayerList(collectionName, datafileName, element) {

		if (element != null) {
			addEntry(collectionName, datafileName);
		}

		console.log("addDataLayerList");

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
													dataType : 'json',
													method : 'POST',
													data : {
														<portlet:namespace/>portletActionName : "/layerListDataRow",
														<portlet:namespace/>collectionName : collectionName,
														<portlet:namespace/>granuleName : datafileName
													},
													on : {//ajax call start function
														start : function() {

															if (element != null) {
																$('#spinner')
																		.show();
															}

														},//ajax call end function
														end : function() {
															if (element != null) {
																$('#spinner')
																		.hide();
															}
														}

														,
														//ajax call success function
														success : function() {
															var count = parseInt($(
																	'#countLayers')
																	.text());
															$('#countLayers')
																	.text(
																			count + 1);
															$('#countLayersNav')
																	.text(
																			count + 1);

															var uniqueID = generateString();
															var data = this
																	.get('responseData');

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

															$(idDiv)
																	.load(
																			'${doAction}',
																			function() {

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
																				ajaxLoading = false;

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

															}

														}
													}
												});

							});

		}
	}

	//Display a given portlet
	function portletAction(granuleName, collectionName, portletActionName) {

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
													dataType : 'json',
													method : 'POST',
													data : {
														/* <portlet:namespace/>id : dataId, */
														<portlet:namespace/>collectionName : collectionName,
														<portlet:namespace/>granuleName : granuleName,
														<portlet:namespace/>portletActionName : portletActionName,
														<portlet:namespace/>dataOverlayList : overlayList
																.toString()
													},
													on : {
														start : function() {
															console
																	.log('loading Portlet...');

															$('#spinner')
																	.show();

														},
														end : function() {

															$('#spinner')
																	.hide();

														},
														success : function() {
															console
																	.log('Success on loading Portlet...');

															console
																	.log("passed followed values : "
																			+ overlayList);
															var data = this
																	.get('responseData');

															var idData = data.id;

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

															visuWK
																	.appendChild(porletActionDiv);

															var idDiv = '#'
																	+ uniqueID;

															$(idDiv)
																	.load(
																			'${doAction}',
																			function() {
																				ajaxLoading = false;
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
</aui:script>
	











<!-- / BMAP SCRIPTS -->