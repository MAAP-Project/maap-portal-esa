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

<script type="text/javascript">

	/**
	 Show or hide the layers attribute table 
	 **/
	$('#showHideAttributeTable<portlet:namespace/>').click(function() {
		$("#featureinfodiv<portlet:namespace/>").toggle();
	});


	/**
	 Display the map with  the chosen layer
	 **/

	geoserverWMS="${geoserverWMS}";
	layername = "${granule.dataList.get(0).layerName}";
	console.log(layername);

	var format = 'image/png';

	var bounds = [ parseFloat(${minX}), parseFloat(${minY}), parseFloat(${maxX}), parseFloat(${maxY}) ];

	if("${fileType eq 'roi'}"==="true"){
		console.log('ROI');
		//setting projection system for georeferenced layer
		var projection = new ol.proj.Projection({
			code : 'EPSG:4326',
			units : 'degrees',
			axisOrientation : 'neu',
			global : true
		});

		var untiled = new ol.layer.Image({
			name : "${granule.name}",
			crossOrigin: 'anonymous',
			source : new ol.source.ImageWMS({
				wrapDateLine: false,
	            wrapX: false,
	            noWrap: true,
				ratio : 1,
				url : '${geoserverWMS}',
				params : {
					'FORMAT' : format,
					'VERSION' : '1.1.1',
					"STYLES" : '',
					"LAYERS" : layername,
					"exceptions" : 'application/vnd.ogc.se_inimage'

				}
			})
		});
		var baseLayer;
		
	
		 baseLayers = new ol.layer.Group({
		    title: 'Base Map',
		    openInLayerSwitcher: true,
		    layers: [

		    	new ol.layer.Tile({
						name : 'OpenStreetMap',type: 'base',
						crossOrigin: 'anonymous',
		    	    source: new ol.source.OSM({title: "OpenStreetMap",
						wrapDateLine: false,
			            wrapX: false,
			            noWrap: true})
		    	}),
		    	new ol.layer.Tile({
					name : 'Stamen Terrain',type: 'base',visible: false,
					crossOrigin: 'anonymous',
					source : new ol.source.Stamen({
						title: "Stamen terrain",
						wrapDateLine: false,
			            wrapX: false,
			            noWrap: true,
						layer : "terrain"
					}),
					crossOrigin: 'anonymous',
					type : 'base'
				})
		     
		    ]
		  });
		 
		 
		//Map creation with default controls
			var map = new ol.Map({
				controls : ol.control.defaults({
					attributionOptions : ({
						collapsible : false
					})
				}).extend([
					
					 // Add a new Layerswitcher to the map
				      new ol.control.LayerSwitcher(),
					
					new ol.control.OverviewMap({
					collapsed : true,
					view : new ol.View({
						projection : projection
					})
				}), new ol.control.FullScreen(), new ol.control.MousePosition({
					coordinateFormat : ol.coordinate.createStringXY(4),
					projection : 'EPSG:4326',
					target : document.getElementById('mouseLocation')
				}) ]),
				target : 'mapSingleLayer<portlet:namespace/>',
				layers : [baseLayers, untiled],
				view : new ol.View({
					projection : projection
				})
			});

			
			$('#mapSingleLayer<portlet:namespace/>').data('map', map);
		
	}else {
		
		 if("${granule.dataList.get(0).geometryType}"=='geolocated'){
			
			//setting projection system for georeferenced layer
			var projection = new ol.proj.Projection({
				code : 'EPSG:4326',
				units : 'degrees',
				axisOrientation : 'neu',
				global : true
			});

			var untiled = new ol.layer.Image({
				name : "${granule.name}",
				crossOrigin: 'anonymous',
				source : new ol.source.ImageWMS({
					wrapDateLine: false,
		            wrapX: false,
		            noWrap: true,
					ratio : 1,
					url : '${geoserverWMS}',
					params : {
						'FORMAT' : format,
						'VERSION' : '1.1.1',
						"STYLES" : '',
						"LAYERS" : layername,
						"TRANSPARENT": true ,
						'ENV': 'valueMin:${statsMin};valueMax:${statsMax}',
						"exceptions" : 'application/vnd.ogc.se_inimage'

					}
				})
			});
			var baseLayer;
			
		
			 baseLayers = new ol.layer.Group({
			    title: 'Base Map',
			    openInLayerSwitcher: true,
			    layers: [

			    	new ol.layer.Tile({
							name : 'OpenStreetMap',type: 'base',
							crossOrigin: 'anonymous',
			    	    source: new ol.source.OSM({title: "OpenStreetMap",
							wrapDateLine: false,
				            wrapX: false,
				            noWrap: true})
			    	}),
			    	new ol.layer.Tile({
						name : 'Stamen Terrain',type: 'base',visible: false,
						source : new ol.source.Stamen({
							title: "Stamen terrain",
							wrapDateLine: false,
				            wrapX: false,
				            noWrap: true,
							layer : "terrain"
						}),
						crossOrigin: 'anonymous',
						type : 'base'
					})
			     
			    ]
			  });
			//Map creation with default controls
				var map = new ol.Map({
					controls : ol.control.defaults({
						attributionOptions : ({
							collapsible : false
						})
					}).extend([
						
						 // Add a new Layerswitcher to the map
					      new ol.control.LayerSwitcher(),
						
						new ol.control.OverviewMap({
						collapsed : true,
						view : new ol.View({
							projection : projection
						})
					}), new ol.control.FullScreen(), new ol.control.MousePosition({
						coordinateFormat : ol.coordinate.createStringXY(4),
						projection : 'EPSG:4326'
					}) ]),
					target : 'mapSingleLayer<portlet:namespace/>',
					layers : [baseLayers, untiled],
					view : new ol.View({
						projection : projection
					})
				});

				$('#mapSingleLayer<portlet:namespace/>').data('map', map);}
		 
		 else{
		    var projection = new ol.proj.Projection({
		        code: 'EPSG:404000',
		        units: 'm',
		        axisOrientation: 'neu',
		        global: false
		    });
			
			var untiled = new ol.layer.Image({
				name : "${granule.name}",
				crossOrigin: 'anonymous',
				source : new ol.source.ImageWMS({
					wrapDateLine: false,
		            wrapX: false,
		            noWrap: true,
					ratio : 1,
					url : '${geoserverWMS}',
					params : {
						'FORMAT' : format,
						'VERSION' : '1.1.1',
						"STYLES" : '',
						"LAYERS" : layername,
						"TRANSPARENT": true ,
						'ENV': 'valueMin:${statsMin};valueMax:${statsMax}',
						"exceptions" : 'application/vnd.ogc.se_inimage'

					}
				})
			});
			//Map creation with default controls
			var map = new ol.Map({
				controls : ol.control.defaults({
					attributionOptions : ({
						collapsible : false
					})
				}).extend([
					
					 // Add a new Layerswitcher to the map
				      new ol.control.LayerSwitcher(),
					
					new ol.control.OverviewMap({
					collapsed : true,
					view : new ol.View({
						projection : projection
					})
				}), new ol.control.FullScreen(), new ol.control.MousePosition({
					coordinateFormat : ol.coordinate.createStringXY(4),
					projection : 'EPSG:4326'
				}) ]),
				target : 'mapSingleLayer<portlet:namespace/>',
				layers : [untiled],
				view : new ol.View({
					projection : projection,
					zoom: 0
				})
			});

			
			$('#mapSingleLayer<portlet:namespace/>').data('map', map);	
			
			};
		 
	 } 
	//fitting map to bounds
	$('#mapSingleLayer<portlet:namespace/>').data('map').getView().fit(bounds, map.getSize());

	/**
	 On pointer click, shows the pixel value of the layer
	 **/
	 $('#mapSingleLayer<portlet:namespace/>').data('map')
			.on(
					'singleclick',
					function(evt1) {
						var infodiv = document
								.getElementById("<portlet:namespace/>featureinfotable");
						infodiv.innerHTML = "";

						var view = $('#mapSingleLayer<portlet:namespace/>').data('map').getView();
						var viewResolution = view.getResolution();
						var url = '';
						var layers = $('#mapSingleLayer<portlet:namespace/>').data('map').getLayers();
						console.log($('#mapSingleLayer<portlet:namespace/>').data('map').getLayers());

						layers
								.forEach(function(layer, i, layers) {
									console.log(layer.get('name'));

									if (layer.getVisible()
											&& typeof layer.get('name') !== "undefined") {
										console.log('true');
										url = layer
												.getSource()
												.getGetFeatureInfoUrl(
														evt1.coordinate,
														viewResolution,
														view.getProjection(),
														{
															'INFO_FORMAT' : 'application/json',
															'FEATURE_COUNT' : '300'
														});
										console.log(url);
										if (url) {
											console.log('urlok');
											var xmlhttp = new XMLHttpRequest();

											xmlhttp.onreadystatechange = function() {
												if (this.readyState == 4
														&& this.status == 200) {
													console.log('');
													try {
														
														console.log(this.responseText);

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
																.createTextNode(layer
																		.get('name')));

												dl.appendChild(dt);

												for ( var attributename in props) {

													var dd = document
															.createElement('dd');

													dd
															.appendChild(document
																	.createTextNode(attributename
																			+ ": "
																			+ props[attributename]));
													console.log(attributename);
													dl.appendChild(dd);

												}

												infodiv.appendChild(dl);

													} catch (err) {
														infodiv.innerHTML = '<tr><td class="attributeTableContent">Value: </td><td class=" attributeTableContent">N/A</td></tr>';


													}
												}
											};
											xmlhttp.open("GET", url, true);
											xmlhttp.send();
										}

									}
								});

					});

	
	  function setTwoColorColorScale(data,valueMin,valueMax,colorMin,colorMax, mapDiv){
		
		
var layer=getLayerByName(data, mapDiv);  
layer.getSource().updateParams({STYLES: 'raster', ENV: 'colorMin:'+colorMin+';colorMax:'+colorMax+';valueMin:'+valueMin+';valueMax:'+valueMax+''}); 

		} 
	 
	 
	 function setThreeColorColorScale(data,valueMin,valueAvg,valueMax,colorMin,colorAvg,colorMax, mapDiv){
		
		
var layer=getLayerByName(data, mapDiv);  
layer.getSource().updateParams({STYLES: 'threeColorGradient', ENV: 'colorMin:'+colorMin+';colorAvg:'+colorAvg+';colorMax:'+colorMax+';valueMin:'+valueMin+';valueAvg:'+valueAvg+';valueMax:'+valueMax+''}); 

		}
	 
	 //return a layer object by its fileName
	 function getLayerByName(fileName, mapDiv){
		  console.log("getting layer by following fileName: "+fileName);
		 var layerReturned;
		 console.log(mapDiv);
		 $('#'+mapDiv).data('map').getLayers().forEach(function (layer) {
			 
			 console.log("Checking if "+layer.get('name')+ " equals "+fileName);
			 console.log(layer.get('name'));
		    if (layer.get('name') != undefined& layer.get('name') === fileName) {
		    	
		    	layerReturned= layer;
		    }
		});
	 
	 return layerReturned;
	 }
	
	
</script>
