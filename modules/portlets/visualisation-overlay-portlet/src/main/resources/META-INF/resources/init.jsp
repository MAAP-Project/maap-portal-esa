<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%><%@
taglib
	uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%><%@
taglib
	uri="http://liferay.com/tld/theme" prefix="liferay-theme"%><%@
taglib
	uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>

<portlet:resourceURL var="displayRoiStats" id='displayRoiStatsTrigger' />
<portlet:resourceURL var="displayPlotComparison"
	id='displayPlotComparisonTrigger' />



<liferay-theme:defineObjects />

<portlet:defineObjects />
<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/script.js"></script>

<script>
//showing attribute table by default
jQuery("#<portlet:namespace/>rulerDistanceInfo").hide();

jQuery("#featureinfodiv<portlet:namespace/>").show();
jQuery("#statsRoiInfo<portlet:namespace/>").hide();

jQuery("#plotComparison<portlet:namespace/>").hide();
jQuery("#error<portlet:namespace/>").hide();
jQuery("#plotComparisonInfo<portlet:namespace/>").hide();

//wms & wmts output format
var FORMAT_PNG = 'image/png';

//setting projection system for geolocated layers
var PROJECTION_EPSG_4326 = new ol.proj.Projection({
		code : 'EPSG:4326',
		units : 'degrees',
		extent: [-180.0,-90.0,180.0,90.0],
		axisOrientation : 'neu',
		global : true
});

//setting projection systemn for non-geolocated layers
var PROJECTION_EPSG_900913  = new ol.proj.Projection({
    code: 'EPSG:900913',
    units: 'm',
    extent: [-2.003750834E7,-2.003750834E7,2.003750834E7,2.003750834E7],
    axisOrientation: 'neu',
    global: false
});
//setting projection systemn for non-geolocated layers
var PROJECTION_EPSG_404000  = new ol.proj.Projection({
    code: 'EPSG:404000',
    units: 'm',
    extent: [-2.003750834E7,-2.003750834E7,2.003750834E7,2.003750834E7],
    axisOrientation: 'neu',
    global: false
});

var baseParams = ['VERSION','LAYER','STYLE','TILEMATRIX','TILEMATRIXSET','SERVICE','FORMAT'];
/**
EVENT LISTENERS
**/

//on click, remove drawing map interactions on the map & existing drawed vector layers
/* jQuery("#removeMapInteraction<portlet:namespace/>").click(function() {
	removeMapInteractions(jQuery('#mapOverlay<portlet:namespace/>').data('map'), ol.interaction.Draw);
	removeMapVectorLayers(jQuery('#mapOverlay<portlet:namespace/>').data('map'));
	
}); */
jQuery("#clearAction<portlet:namespace/>").click(function() {
	removeMapInteractions(jQuery('#mapOverlay<portlet:namespace/>').data('map'), ol.interaction.Draw);
	removeMapVectorLayers(jQuery('#mapOverlay<portlet:namespace/>').data('map'));
	jQuery("#<portlet:namespace/>rulerDistanceInfo").hide();

	jQuery("#featureinfodiv<portlet:namespace/>").hide();
	jQuery("#statsRoiInfo<portlet:namespace/>").hide();

	jQuery("#plotComparison<portlet:namespace/>").hide();
	jQuery("#error<portlet:namespace/>").hide();
	}); 

	/**
	Show or hide the layers attribute table 
	 **/
	jQuery('#showHideAttributeTable<portlet:namespace/>').click(function() {
		jQuery("#featureinfodiv<portlet:namespace/>").toggle();
	});

	
	/**
	Display the map with all the chosen layers on overlay, in the same order as chosen on menu , with an OSM base map)
	 **/

	 var layerList=[];
	 
	 
	 //set map bounds with the ones of the first chosen data
	 var bounds = [ parseFloat(${minX}), parseFloat(${minY}), parseFloat(${maxX}), parseFloat(${maxY}) ];
	
	 
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
						visible : false,
		    	    source: new ol.source.OSM({title: "OpenStreetMap",
						wrapDateLine: false,
			            wrapX: false,
			            noWrap: true})
		    	}),
		    	new ol.layer.Tile({
					name : 'Stamen Terrain',
					visible : true,
					source : new ol.source.Stamen({
						title: "Stamen terrain",
						wrapDateLine: false,
			            wrapX: false,
			            noWrap: true,
						layer : "terrain"
					}),
					type : 'base'
				}),

		    	new ol.layer.Tile({
					name : 'Stamen Watercolor',type: 'base',visible: false,
					crossOrigin: 'anonymous',
					source : new ol.source.Stamen({
						title: "Stamen Watercolor",
						wrapDateLine: false,
			            wrapX: false,
			            noWrap: true,
						layer : "watercolor"
					}),
					crossOrigin: 'anonymous',
					type : 'base'
				})
		    	,

		    	new ol.layer.Tile({
					name : 'Stamen Toner',type: 'base',visible: false,
					crossOrigin: 'anonymous',
					source : new ol.source.Stamen({
						title: "Stamen Toner",
						wrapDateLine: false,
			            wrapX: false,
			            noWrap: true,
						layer : "toner"
					}),
					crossOrigin: 'anonymous',
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
			var isEsa= items[i].getAttribute('data-isesa');
	
	
			var baseUrl;
			if(isEsa=="true"){
				baseUrl='${geoserverWMS}';	
			}
			else{
				baseUrl='${NASACartoWMS}';	

			}

			//setting params needed to construct layer
			params = {
					'NAME': fileName ,
					'FORMAT' : FORMAT_PNG,
					'VERSION' : '1.1.1',
					'STYLES' : '',
					'LAYERS' : layername,
					'exceptions' : 'application/vnd.ogc.se_inimage',
					'BASEURL' : baseUrl
					};
			if (statMin != null){
			params['ENV'] = 'valueMin:'+statMin+';valueMax:'+statMax+'';

		}	
			
			//construct WMS layer source
			var layer = constructWMSSource(params); 
			
			//WMTS
			/*  var gridsetName = 'EPSG:4326';
			var gridNames = ['EPSG:4326:0', 'EPSG:4326:1', 'EPSG:4326:2', 'EPSG:4326:3', 'EPSG:4326:4', 'EPSG:4326:5', 'EPSG:4326:6', 'EPSG:4326:7', 'EPSG:4326:8', 'EPSG:4326:9', 'EPSG:4326:10', 'EPSG:4326:11', 'EPSG:4326:12', 'EPSG:4326:13', 'EPSG:4326:14', 'EPSG:4326:15', 'EPSG:4326:16', 'EPSG:4326:17', 'EPSG:4326:18', 'EPSG:4326:19', 'EPSG:4326:20', 'EPSG:4326:21'];


			var resolutions = [0.703125, 0.3515625, 0.17578125, 0.087890625, 0.0439453125, 0.02197265625, 0.010986328125, 0.0054931640625, 0.00274658203125, 0.001373291015625, 6.866455078125E-4, 3.4332275390625E-4, 1.71661376953125E-4, 8.58306884765625E-5, 4.291534423828125E-5, 2.1457672119140625E-5, 1.0728836059570312E-5, 5.364418029785156E-6, 2.682209014892578E-6, 1.341104507446289E-6, 6.705522537231445E-7, 3.3527612686157227E-7];
			

			params = {
			  'VERSION': '1.0.0',
			  'BASEURL' : '${geoserverWMTS}' ,
			  'LAYER': layername,
			  'STYLE': '',
			  'TILEMATRIX': gridNames,
			  'TILEMATRIXSET': gridsetName,
			  'SERVICE': 'WMTS',
			  'PROJECTION': PROJECTION_EPSG_4326,
			  'RESOLUTIONS': resolutions,
			  'FORMAT': FORMAT_PNG
			};
			
			console.log(params);
			//if stat min is not null updating params with statistics information
			if (statMin != null){
				params['ENV'] = 'valueMin:'+statMin+';valueMax:'+statMax+'';
		
			}
			console.log(params);
			var layer = new ol.layer.Tile({
			  source: constructWMTSSource(params)
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
					projection : PROJECTION_EPSG_4326.getCode()
				})
			}), new ol.control.FullScreen(), new ol.control.MousePosition({
				coordinateFormat : ol.coordinate.createStringXY(4),
				projection : PROJECTION_EPSG_4326.getCode()
			}) ]),
			target : 'mapOverlay<portlet:namespace/>',
			layers : [baseLayers, layers],
			view : new ol.View({
				projection : PROJECTION_EPSG_4326
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
					
					
					//setting params needed to construct layer
		params = {
					'NAME': fileName ,
					'FORMAT' : FORMAT_PNG,
					'VERSION' : '1.1.1',
					'STYLES' : '',
					'LAYERS' : layername,
					'exceptions' : 'application/vnd.ogc.se_inimage',
					'BASEURL' : '${geoserverWMS}'
					};
		if (statMin != null){
			params['ENV'] = 'valueMin:'+statMin+';valueMax:'+statMax+'';

		}	
			//construct WMS layer source
			var layer = constructWMSSource(params);
			
			//WMTS
		/* 				var gridsetName = 'EPSG:900913';
			var gridNames = ['EPSG:900913:0', 'EPSG:900913:1', 'EPSG:900913:2', 'EPSG:900913:3', 'EPSG:900913:4', 'EPSG:900913:5', 'EPSG:900913:6', 'EPSG:900913:7', 'EPSG:900913:8', 'EPSG:900913:9', 'EPSG:900913:10', 'EPSG:900913:11', 'EPSG:900913:12', 'EPSG:900913:13', 'EPSG:900913:14', 'EPSG:900913:15', 'EPSG:900913:16', 'EPSG:900913:17', 'EPSG:900913:18', 'EPSG:900913:19', 'EPSG:900913:20', 'EPSG:900913:21', 'EPSG:900913:22', 'EPSG:900913:23', 'EPSG:900913:24', 'EPSG:900913:25', 'EPSG:900913:26', 'EPSG:900913:27', 'EPSG:900913:28', 'EPSG:900913:29', 'EPSG:900913:30'];
			var resolutions = [156543.03390625, 78271.516953125, 39135.7584765625, 19567.87923828125, 9783.939619140625, 4891.9698095703125, 2445.9849047851562, 1222.9924523925781, 611.4962261962891, 305.74811309814453, 152.87405654907226, 76.43702827453613, 38.218514137268066, 19.109257068634033, 9.554628534317017, 4.777314267158508, 2.388657133579254, 1.194328566789627, 0.5971642833948135, 0.29858214169740677, 0.14929107084870338, 0.07464553542435169, 0.037322767712175846, 0.018661383856087923, 0.009330691928043961, 0.004665345964021981, 0.0023326729820109904, 0.0011663364910054952, 5.831682455027476E-4, 2.915841227513738E-4, 1.457920613756869E-4];
							params = {
			  'VERSION': '1.0.0',
			  'BASEURL' : '${geoserverWMTS}' ,
			  'LAYER': layername,
			  'STYLE': '',
			  'TILEMATRIX': gridNames,
			  'TILEMATRIXSET': gridsetName,
			  'SERVICE': 'WMTS',
			  'RESOLUTIONS': resolutions,
			  'PROJECTION': PROJECTION_EPSG_900913,
			  'FORMAT': FORMAT_PNG
			};
							if (statMin != null){
								params['ENV'] = 'valueMin:'+statMin+';valueMax:'+statMax+'';
					
							}				
							
			var layer = new ol.layer.Tile({
			  source: constructWMTSSource(params)
			});  */
				 		
		
					layer.set('name', fileName)
					layerList.push(layer);
				
				} 
			
				 //set a layergroup with the chosen layers for the layerswitcher
				 var layers = new ol.layer.Group({
					    title: 'Layers',
					    openInLayerSwitcher: true,
					    layers: layerList
					  });
				
				
		
/* 
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
							projection : PROJECTION_EPSG_900913
						})
					}), new ol.control.FullScreen(), new ol.control.MousePosition({
						coordinateFormat : ol.coordinate.createStringXY(4),
						projection : PROJECTION_EPSG_900913.getCode()
					}) ]),
					target : 'mapOverlay<portlet:namespace/>',
					layers : [layers],
					view : new ol.View({
						projection : PROJECTION_EPSG_900913
					})
				}); */
				
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
							projection : PROJECTION_EPSG_404000
						})
					}), new ol.control.FullScreen(), new ol.control.MousePosition({
						coordinateFormat : ol.coordinate.createStringXY(4),
						projection : PROJECTION_EPSG_404000.getCode()
					}) ]),
					target : 'mapOverlay<portlet:namespace/>',
					layers : [layers],
					view : new ol.View({
						projection : PROJECTION_EPSG_404000
					})
				}); 
			 
		 }
	
		jQuery('#mapOverlay<portlet:namespace/>').data('map', map);
		
		//fitting map to bounds
		jQuery('#mapOverlay<portlet:namespace/>').data('map').getView().fit(bounds, map.getSize());

		
		
	
	/**
	On pointer click, shows the values of the layers 
	 **/
	 jQuery('#mapOverlay<portlet:namespace/>')
			.data('map')
			.on(
					'singleclick',
					function(evt1) {

						var infodiv = document
								.getElementById("<portlet:namespace/>featureinfotable");
						infodiv.innerHTML = "";

						var view = jQuery('#mapOverlay<portlet:namespace/>').data(
								'map').getView();
						var viewResolution = view.getResolution();
						var url = '';
						var layerGroups = jQuery('#mapOverlay<portlet:namespace/>')
								.data('map').getLayers();
						var i=0;
						//getting all visible layers of map and displaying pixel info of pixel clicked
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

																	try {
																
																				var myArr = JSON
																				.parse(this.responseText);
																		
																					var feature = myArr.features[0];
																					/* console.log(feature); */
																				if(feature){
																					i++;
																					var myArr = JSON
																					.parse(this.responseText);
																					
																			var feature = myArr.features[0];
																			var props = feature.properties;
									
																			var dl = document
																					.createElement('dl');
																			dl.setAttribute("class", "border-around");
											
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
																		
																		/* if(jQuery("<portlet:namespace/>featureinfotable").children().length < 1){document
																			.getElementById('<portlet:namespace/>featureinfotable').innerHTML = '<tr><td class="attributeTableContent">Value: </td><td class=" attributeTableContent">N/A</td></tr>';} */
																		

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
								
									if(i< 1){document
										.getElementById('<portlet:namespace/>featureinfotable').innerHTML = '<tr><td class="attributeTableContent">Value: </td><td class=" attributeTableContent">N/A</td></tr>';}
								});

					}); 
					
					
					
	

	 
		 /**
		  * returns a layer object by its name
		  * @param {fileName} fileName
		  * @param {mapDiv} div of the targeted map
		  */
	 function getLayerByNameOverlay(fileName, mapDiv){
		  console.log("getting layer by following fileName: "+fileName);
		 var layerReturned;
		 
		 jQuery('#'+mapDiv).data('map').getLayers().forEach(function (layer) {
			 
			 /* console.log("Checking if "+layer.get('name')+ " equals "+fileName); */
			 if (layer instanceof ol.layer.Group) {
          layer.getLayers().forEach(function(sublayer) {
        	
        	   if (sublayer.get('name') != undefined & sublayer.get('name') === fileName) {
		    	
		    	layerReturned= sublayer;
		    	
		    } 
          });
        }
		  
		});
		 
	 return layerReturned;
	 }
	 

	 /**
		  * Displays distance in degrees and meters for a geometry drawed on the map
		  * @param {mapDiv} div of the targeted map
		  * @param {portletNamespace} Liferay portletNamespace (id of the portlet)
		  */
	 function getRulerDistance(mapDiv, portletNamespace){

//showing and hiding adequate divs
		jQuery("#plotComparison"+portletNamespace).hide();
  		var rulerDistanceDivID= "#" + portletNamespace + "rulerDistanceInfo";
		 jQuery("#statsRoiInfo"+ portletNamespace).hide();
		jQuery(rulerDistanceDivID).show();
	
		//defining ruler distance line vector style
		  var vectorStyle = new ol.style.Style({
			    fill: new ol.style.Fill({
			    	 color: 'rgba(255, 255, 255, 0.2)'
			    }),
			    stroke: new ol.style.Stroke({
			    color: '#ffcc33',
			      width: 2
			    }),
			    
			    image: new ol.style.Circle({
			    	 radius: 7,
			          stroke: new ol.style.Stroke({
			            color: 'white',
			            width: 2
			          }), fill: new ol.style.Fill({color: '#ffcc33'})
			    })
			    
			    
			  });
		
		 //creating layer object representing the ruler distance line
	 var vectorLayer = new ol.layer.Vector({
		  source: new ol.source.Vector(),
		  style: vectorStyle
		});
	 //adding the layer to the map
	 jQuery('#'+mapDiv).data('map').addLayer(vectorLayer);
	 
	 var resultElementDegrees = jQuery('#'+portletNamespace+'rulerDistanceDegrees');
	 var resultElementMeters = jQuery('#'+portletNamespace+'rulerDistanceMeters');
	 var measuringTool;
	 
	 //enabling interaction on the map 
	 var enableMeasuringTool = function() {
		  map.removeInteraction(measuringTool);

		  var geometryType = 'LineString';
		  var html = geometryType === 'Polygon' ? '<sup>2</sup>' : '';

		  measuringTool = new ol.interaction.Draw({
		    type: geometryType,
		    source: vectorLayer.getSource(),
			maxPoints: 2
		  });

		  //on drawstart, clearing the vector layer 
		  measuringTool.on('drawstart', function(event) {
			
			  var source = vectorLayer.getSource();
			  source.forEachFeature(function(feature){
				  var coord = feature.getGeometry().getCoordinates();
				});
			  
			
		    vectorLayer.getSource().clear();

		    //on change, getting the lenght of the line and display it in degrees and meters
		    event.feature.on('change', function(event) {	    	
		   
		    	var newPoints = [];
		    	var coords=event.target.getGeometry().getCoordinates();
		    	coords.forEach(function(coordinate){
		    		  newPoints.push(ol.proj.transform(coordinate, 'EPSG:4326', 'EPSG:3857'));
		    		}); 
		   
		    	 var newGeom= new ol.geom.LineString(newPoints);
		    	 
		    		
		      var measurementDegrees = geometryType === 'Polygon' ? event.target.getGeometry().getArea() : event.target.getGeometry().getLength();
		      var measurementMeters = geometryType === 'Polygon' ? event.target.getGeometry().getArea() : newGeom.getLength();
		      

		      var measurementFormattedDegrees = measurementDegrees.toFixed(2) + ' degrees' ;
		      var measurementFormattedMeters =  measurementMeters > 100 ? (measurementMeters / 1000).toFixed(2) + ' km' :  measurementMeters.toFixed(2)  + 'm' ;
		  /*     resultElementDegrees.html(measurementFormattedDegrees + html);  */
		      resultElementMeters.html(measurementFormattedMeters + html); 
		      
		    });    
	
		  });

		  jQuery('#'+mapDiv).data('map').addInteraction(measuringTool);
		};


		enableMeasuringTool();
		
		
		
	 }
		  /**
			  * Set colorScaling for a given data 
			  * @param {data} data to colorscale (name of the layer)
			  * @param {valueMin} min pixel value
			  * @param {valueMax} max pixel value
			  * @param {colorMin} min color to begin the colorScale
			  * @param {colorMax} max color to begin the colorScale
			  * @param {mapDiv} div of the map the layer is on
			  */
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

			  /**
				  * Set three-colorScaling for a given data 
				  * @param {data} data to colorscale (name of the layer)
				  * @param {valueMin} min pixel value
				  * @param {valueAvg} avg pixel value
				  * @param {valueMax} max pixel value
				  * @param {colorMin} min color to begin the colorScale
				  * @param {avg} avg color of colorScale
				  * @param {colorMax} max color to begin the colorScale
				  * @param {mapDiv} div of the map the layer is on
				  */
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

		jQuery('#' + mapDiv)
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
	
	  /**
	  * generate and displays stats for a raster cropped with a given ROI 
	  * @param {granuleRasterId} granule id of the raster 
	  * @param {granuleRoiId} granule id of the  roi
	  * @param {portletNameSpace} Liferay portletNamespace (id of the portlet)
	  */
	function generateStatsFromRoi(granuleRasterId, granuleRoiId, portletNameSpace){

		jQuery("#statsRoiInfo"+portletNameSpace).show();
		jQuery("#"+portletNameSpace+"rulerDistanceInfo").hide();
		jQuery("#plotComparison"+portletNameSpace).hide();
		jQuery("#error"+portletNameSpace).hide();
	    if (!ajaxLoading) {

			ajaxLoading = true;

			AUI()
					.use(
							'aui-base',
							'aui-io-request',
							function(A) {

								
								//AJAX request to serveResource method 
								A.io
										.request(
												'${displayRoiStats}',
												{
													dataType : 'html',
													method : 'POST',
													data : {
														
														<portlet:namespace/>granuleRasterId : granuleRasterId,
														<portlet:namespace/>granuleRoiId : granuleRoiId
													
													},
													on : {
														start : function() {
															console
																	.log('loading...');

															jQuery('#overlayLoading')
															.show();
													jQuery('#spinner')
													.show();
														},
														end : function() {
															console
															.log('end');
															jQuery('#overlayLoading')
															.hide();
													jQuery('#spinner')
													.hide();

														},
														success : function() {
															console
																	.log('Success');
															
																var obj = JSON.parse(this.get('responseData'));								
																var objStats=obj.data.stats;
																jQuery("#statsRoiInfo"+portletNameSpace+" dl").empty();
																var chosenData = document.createElement("dt");
																
																var rasterName = granuleRasterId.split(':@');
																var roiName = granuleRoiId.split(':@');
																chosenData.innerHTML = rasterName[1] + " - " + roiName[1];  
																jQuery("#statsRoiInfo"+portletNameSpace+" dl").append(chosenData);
														//display stats in the div
																 for (i = 0; i < objStats.length; i++) {
																	var objStatsNode = objStats[i];
																	var featureIndex = document.createElement("dd");
															    	featureIndex.innerHTML = "feature index : " +i;
															    	jQuery("#statsRoiInfo"+portletNameSpace+" dl").append(featureIndex);
																    for (var key in objStatsNode){
																    	
																        var attrName = key;
																        var attrValue = objStatsNode[key];
														
																        var attrValueNode = document.createElement("dd");
																        attrValueNode.innerHTML = attrName+ ": " +attrValue;   
																        jQuery("#statsRoiInfo"+portletNameSpace+" dl").append(attrValueNode);
																     
																    }
																	
																 } 

														},
														failure : function() {
															console
																	.log('failure');
														}

													}
												});

							});

		} 
	 
ajaxLoading = false;
	}
	
	
	  /**
		  * generate and displays two raster's plot comparison
		  * @param {granuleRasterXaxis} granule id of the raster on x axis
		  * @param {granuleRasterYaxis} granule id of the raster on y axis
		  * @param {portletNameSpace} Liferay portletNamespace (id of the portlet)
		  */
	function generatePlotComparison(mapDiv, granuleRasterXaxis, granuleRasterYaxis, portletNameSpace){
		jQuery("#statsRoiInfo"+portletNameSpace).hide();
		jQuery("#"+portletNameSpace+"rulerDistanceInfo").hide();
		jQuery("#error"+portletNameSpace).hide();
		jQuery("#plotComparison"+portletNameSpace).show();
		jQuery("#plotComparisonInfo"+portletNameSpace).show();

		// create a vector layer used for editing
			var plot_compare_vector_layer = new ol.layer.Vector({
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
		
		
			//add the layer to the map
			jQuery('#'+mapDiv).data('map').addLayer(plot_compare_vector_layer);
			// create the interaction
			plot_compare_interaction = new ol.interaction.Draw({
				source : plot_compare_vector_layer.getSource(),

				type : /** @type {ol.geom.GeometryType} */
				"Polygon",
				minPoints : 4

			});
			
			// add it to the map
			jQuery('#'+mapDiv).data('map').addInteraction(plot_compare_interaction);
			
			plot_compare_interaction.on('drawstart', function(event) {
				
			
				jQuery("#error"+portletNameSpace).hide();
				jQuery("#plotComparison"+portletNameSpace).empty();
				jQuery("#plotComparisonInfo"+portletNameSpace).hide();
				console.log('draw Start interaction event called');
				plot_compare_vector_layer.getSource().clear();
				
			});
			// at draw end, send an ajax request to get the zonal stats of the drawed geometry
			/* plot_compare_interaction.on('drawend', function(event) { */
				
				
				plot_compare_vector_layer.getSource().on('addfeature', function(evt){
				var feature = evt.feature;
				var format = new ol.format.WKT();
			    //the vector corresponds to the geometry drawed
				var vectorWKT=format.writeGeometry(evt.feature.getGeometry());
				console.log(vectorWKT);
				
				
			    if (!ajaxLoading) {

					ajaxLoading = true;

					AUI()
							.use(
									'aui-base',
									'aui-io-request',
									function(A) {

										
										//AJAX request to serveResource method 
										A.io
												.request(
														'${displayPlotComparison}',
														{
															dataType : 'html',
															method : 'POST',
															data : {
																
																<portlet:namespace/>granuleRasterXaxis : granuleRasterXaxis,
																<portlet:namespace/>granuleRasterYaxis : granuleRasterYaxis,
																<portlet:namespace/>vectorWKT : vectorWKT
															
															},
															on : {
																start : function() {
																	console
																			.log('loading...');

																	jQuery('#overlayLoading')
																	.show();
															jQuery('#spinner')
															.show();

																},
																end : function() {
																	console
																	.log('end');
																	jQuery('#overlayLoading')
																	.hide();
															jQuery('#spinner')
															.hide();

																},
																success : function() {
																	console
																			.log('Success');
															//creating image with the given base64 response
															var scatterPlotCompareImg = document.createElement("IMG");
															var plotImgSrc="data:image/png;base64,"+this.get('responseData');
															//display the image on the web page
															try {
															    window.atob(this.get('responseData'));
															    scatterPlotCompareImg.setAttribute("src", plotImgSrc);
																jQuery("#plotComparison"+portletNameSpace).html(scatterPlotCompareImg);
															} catch(e) {
															    jQuery("#error"+portletNameSpace).show();
															}
															
															

																},
																failure : function() {
																	console
																			.log('failure');
																}

															}
														});

									});

				} 
			 
		ajaxLoading = false;
			})
		
		
	}
	
</script>
