<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%><%@
taglib
	uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%><%@
taglib
	uri="http://liferay.com/tld/theme" prefix="liferay-theme"%><%@
taglib
	uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>

<liferay-theme:defineObjects />

<portlet:defineObjects />

<script>
	/**
	Show or hide the layers attribute table 
	 **/
	$('#showHideAttributeTable<portlet:namespace/>').click(function() {
		$("#featureinfodiv<portlet:namespace/>").toggle();
	});

	
	
	/**
	Display the map with all the chosen layers on overlay, in the same order as chosen on menu , with an OSM base map)
	 **/

	 var layerList=[];
	 
	 
	 //set map bounds with the ones of the first chosen data
	 var bounds = [ parseFloat(${minX}), parseFloat(${minY}), parseFloat(${maxX}), parseFloat(${maxY}) ];
	 
	 //set wms output format
	 var format = 'image/png';
	 
	 //set the map target	 
	 var divMap='#mapOverlay<portlet:namespace/>';
	 
	 //superimpose the chosen layers together. The epsg is the one of the first layer chosen
		var items = document.getElementsByClassName('overlayList<portlet:namespace/>');
	 
		 //Set base layers to be either Stamen or Openstreetmap layer, openstreetmap by default
		var baseLayers = new ol.layer.Group({
		    title: 'Base Layers',
		    openInLayerSwitcher: true,
		    layers: [

		    	new ol.layer.Tile({
						name : 'OpenStreetMap',
						visible : true,
		    	    source: new ol.source.OSM({title: "OpenStreetMap",
						wrapDateLine: false,
			            wrapX: false,
			            noWrap: true})
		    	}),
		    	new ol.layer.Tile({
					name : 'Stamen Terrain',
					visible : false,
					source : new ol.source.Stamen({
						title: "Stamen terrain",
						wrapDateLine: false,
			            wrapX: false,
			            noWrap: true,
						layer : "terrain"
					}),
					type : 'base'
				})
		     
		    ]
		  });

		var map = null;
		
		 //if georeferenced the EPSG code is 4326 and baseLayers must be available
		 if("${granule.dataList.get(0).geometryType}"=='geolocated'){
			

		for (var i = 0; i < items.length; i++) {

			var layername = items[i].value;
			var fileName= items[i].getAttribute('data-name');
			var statMin= items[i].getAttribute('data-min');
			var statMax= items[i].getAttribute('data-max');
			var statAvg= items[i].getAttribute('data-avg');



	
			//WMS Geoserver calls
			var layer = new ol.layer.Image({
				name: fileName,
				source : new ol.source.ImageWMS({
					ratio : 1,
					url : '${geoserverWMS}',
					params : {
						'FORMAT' : format,
						'VERSION' : '1.1.1',
						"STYLES" : '',
						"LAYERS" : layername,"TRANSPARENT": true ,
						
						"exceptions" : 'application/vnd.ogc.se_inimage',
					}
				})
			});
			if (statMin != null){
				console.log(statMin);
				layer.getSource().updateParams(
						{
							'ENV': 'valueMin:'+statMin+';valueMax:'+statMax+''
						});
			}
		
		/* 	if(){}
			layer.getSource().updateParams(
					{
						'ENV': 'valueMin:'+statMin+';valueMax:'+statMax+''
					});
			  */
			
			
			layer.set('name', fileName)
			layerList.push(layer);
		
		}
	
		 //set a layergroup with the chosen layers for the layerswitcher
		 var layers = new ol.layer.Group({
			    title: 'Layers',
			    openInLayerSwitcher: true,
			    layers: layerList
			  });
		
		
		
		
		//set the projection (the one of the first layer chosen)
		var projection = new ol.proj.Projection({
				code : 'EPSG:4326',
				units : 'degrees',
				axisOrientation : 'neu',
				global : true
			});

		//Map creation with default controls
		 map = new ol.Map({
			controls : ol.control.defaults({
				attributionOptions : ({
					collapsible : false
				})
			}).extend([
				 // Add a new Layerswitcher to the map
			      new ol.control.LayerSwitcher(), new ol.control.OverviewMap({
				collapsed : true,
				view : new ol.View({
					projection : "EPSG:4326"
				})
			}), new ol.control.FullScreen(), new ol.control.MousePosition({
				coordinateFormat : ol.coordinate.createStringXY(4),
				projection : 'EPSG:4326'
			}) ]),
			target : 'mapOverlay<portlet:namespace/>',
			layers : [baseLayers, layers],
			view : new ol.View({
				projection : projection
			})
		});


		 }
		 
		 else{
	
			 
			 //else it is not georeferenced and a projection code 404000 is set (geoserver projection code for non georeferenced data)

				for (var i = 0; i < items.length; i++) {

					var layername = items[i].value;
					var fileName= items[i].getAttribute('data-name');
					var statMin= items[i].getAttribute('data-min');
					var statMax= items[i].getAttribute('data-max');
					var statAvg= items[i].getAttribute('data-avg');

					//WMS Geoserver calls
					var layer = new ol.layer.Image({
						name: fileName,
						source : new ol.source.ImageWMS({
							ratio : 1,
							url : '${geoserverWMS}',
							params : {
								'FORMAT' : format,
								'VERSION' : '1.1.1',
								"STYLES" : '',
								"LAYERS" : layername,
								"TRANSPARENT": true ,
								/*  'ENV': 'valueMin:'+statMin+';valueMax:'+statMax+'',  */
								"exceptions" : 'application/vnd.ogc.se_inimage',
							}
						})
					});
					if (statMin != null){
						console.log(statMin);
						layer.getSource().updateParams(
								{
									'ENV': 'valueMin:'+statMin+';valueMax:'+statMax+''
								});
					}
				
					layer.set('name', fileName)
					layerList.push(layer);
				
				}
			
				 //set a layergroup with the chosen layers for the layerswitcher
				 var layers = new ol.layer.Group({
					    title: 'Layers',
					    openInLayerSwitcher: true,
					    layers: layerList
					  });
				
				
				
				
				//set the projection (the one of the first layer chosen)
			 var projection = new ol.proj.Projection({
		        code: 'EPSG:404000',
		        units: 'm',
		        axisOrientation: 'neu',
		        global: false
		    });
			

				//Map creation with default controls
				 map = new ol.Map({
					controls : ol.control.defaults({
						attributionOptions : ({
							collapsible : false
						})
					}).extend([
						 // Add a new Layerswitcher to the map
					      new ol.control.LayerSwitcher(), new ol.control.OverviewMap({
						collapsed : true,
						view : new ol.View({
							projection : projection
						})
					}), new ol.control.FullScreen(), new ol.control.MousePosition({
						coordinateFormat : ol.coordinate.createStringXY(4),
						projection : projection
					}) ]),
					target : 'mapOverlay<portlet:namespace/>',
					layers : [layers],
					view : new ol.View({
						projection : projection
					})
				});
			 
		 }
	
		$('#mapOverlay<portlet:namespace/>').data('map', map);
		
		//fitting map to bounds
		$('#mapOverlay<portlet:namespace/>').data('map').getView().fit(bounds, map.getSize());

		
		
	
	/**
	On pointer click, shows the values of the layers 
	 **/
	 $('#mapOverlay<portlet:namespace/>')
			.data('map')
			.on(
					'singleclick',
					function(evt1) {

						var infodiv = document
								.getElementById("<portlet:namespace/>featureinfotable");
						infodiv.innerHTML = "";

						var view = $('#mapOverlay<portlet:namespace/>').data(
								'map').getView();
						var viewResolution = view.getResolution();
						var url = '';
						var layerGroups = $('#mapOverlay<portlet:namespace/>')
								.data('map').getLayers();

						layerGroups
								.forEach(function(layer, i) {
									if (layer instanceof ol.layer.Group
											&& layer.get('title') == 'Layers') {
										var subLayers = layer.getLayers();
										subLayers
												.forEach(function(subLayer, j) {
													if (subLayer.getVisible()
															&& typeof subLayer
																	.get('name') !== "undefined") {
														url = subLayer
																.getSource()
																.getGetFeatureInfoUrl(
																		evt1.coordinate,
																		viewResolution,
																		view
																				.getProjection(),
																		{
																			'INFO_FORMAT' : 'application/json',
																			'FEATURE_COUNT' : '300'
																		});
														if (url) {
															var xmlhttp = new XMLHttpRequest();

															xmlhttp.onreadystatechange = function() {
																if (this.readyState == 4
																		&& this.status == 200) {
																	
																/* 
																	infodiv
																	.appendChild(document
																			.createTextNode(subLayer
																					.get('name'))); */

																	try {
																	/* 	console.log(this.responseText); */
																	var myArr = JSON
																				.parse(this.responseText);
																		console.log(myArr);
										var feature = myArr.features[0];
									if(myArr.features[0]){
										
										var myArr = JSON
										.parse(this.responseText);

								var feature = myArr.features[0];
								var props = feature.properties;

								var dl = document
										.createElement('dl');

								var dt = document
										.createElement('dt');

								dt
										.appendChild(document
												.createTextNode(subLayer
														.get('name')));

								dl
										.appendChild(dt);

								for ( var attributename in props) {

									var dd = document
											.createElement('dd');

									dd
											.appendChild(document
													.createTextNode(attributename
															+ ": "
															+ props[attributename]));
									dl
											.appendChild(dd);

								}

								infodiv
										.appendChild(dl); 
										
									}

																	} catch (err) {
																		document
																				.getElementById('<portlet:namespace/>featureinfotable').innerHTML = '<tr><td class="attributeTableContent">Value: </td><td class=" attributeTableContent">N/A</td></tr>';

																	} 
																}
															};
															xmlhttp.open("GET",
																	url, true);
															xmlhttp.send();
														}

													}

												})

									}

								});

					}); 
					
					
					
					
	function setColorScaleOverlay(data, valueMin, valueMax, colorMin, colorMax,
			mapDiv) {
		console.log("Setting colorScale for following data: " + data);

		var layer = getLayerByNameOverlay(data, mapDiv);

		layer.getSource().updateParams(
				{
					ENV : 'colorMin:' + colorMin + ';colorMax:' + colorMax
							+ ';valueMin:' + valueMin + ';valueMax:' + valueMax
							+ ''
				});

	}

	function setThreeColorColorScaleOverlay(data, valueMin, valueAvg, valueMax,
			colorMin, colorAvg, colorMax, mapDiv) {
		console.log("Setting colorScale for following data: " + data);

		var layer = getLayerByNameOverlay(data, mapDiv);
		layer.getSource().updateParams(
				{
					STYLES : 'threeColorGradient',
					ENV : 'colorMin:' + colorMin + ';colorAvg:' + colorAvg
							+ ';colorMax:' + colorMax + ';valueMin:' + valueMin
							+ ';valueAvg:' + valueAvg + ';valueMax:' + valueMax
							+ ''
				});

	}

	//return a layer object by its fileName
	function getLayerByNameOverlay(fileName, mapDiv) {
		console.log("getting layer by following fileName: " + fileName);
		var layerReturned;

		$('#' + mapDiv)
				.data('map')
				.getLayers()
				.forEach(
						function(layer) {

							/* console.log("Checking if "+layer.get('name')+ " equals "+fileName); */
							if (layer instanceof ol.layer.Group) {
								layer
										.getLayers()
										.forEach(
												function(sublayer) {

													if (sublayer.get('name') != undefined
															& sublayer
																	.get('name') === fileName) {

														layerReturned = sublayer;

													}
												});
							}

						});

		return layerReturned;
	}
</script>
