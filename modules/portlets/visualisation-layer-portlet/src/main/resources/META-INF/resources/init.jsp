<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%><%@
taglib
	uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%><%@
taglib
	uri="http://liferay.com/tld/theme" prefix="liferay-theme"%><%@
taglib
	uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>
<portlet:resourceURL var="displayCustomProfile"
	id='displayCustomProfileTrigger' />
<portlet:resourceURL var="displayZonalStats"
	id='displayZonalStatsTrigger' />

<!-- 
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script> -->

<liferay-theme:defineObjects />

<portlet:defineObjects />

<script type="text/javascript"
	src="<%=request.getContextPath()%>/javascript/script.js"></script>
<script type="text/javascript">
/**
 On portlet display 
**/

// showing attribute table by default
jQuery("#<portlet:namespace/>rulerDistanceInfo").hide();
jQuery("#<portlet:namespace/>customProfile").hide();
jQuery("#<portlet:namespace/>subsetStats").hide();
jQuery("#featureinfodiv<portlet:namespace/>").show();

/**
EVENT LISTENERS
**/

//on click, remove drawing map interactions on the map & existing drawed vector layers

 jQuery("#clearAction<portlet:namespace/>").click(function() {
removeMapInteractions(jQuery('#mapSingleLayer<portlet:namespace/>').data('map'), ol.interaction.Draw);
removeMapVectorLayers(jQuery('#mapSingleLayer<portlet:namespace/>').data('map'));
jQuery("#<portlet:namespace/>rulerDistanceInfo").hide();
jQuery("#<portlet:namespace/>customProfile").hide();
jQuery("#<portlet:namespace/>subsetStats").hide();
jQuery("#featureinfodiv<portlet:namespace/>").hide();
}); 



//on click, toggle the attribute table 
jQuery('#showHideAttributeTable<portlet:namespace/>').click(function() {
		jQuery("#featureinfodiv<portlet:namespace/>").toggle();
});


/**
 * MAP DISPLAY
 */
 
 
/**
Display the map with  the chosen layer
**/

//getting granule's layerName
layername = "${granule.dataList.get(0).layerName}";

var esaAttribute = "${granule.getCollection().getCategoryKeyWords()}";

var urlCarto=null;
console.log(esaAttribute)
if(esaAttribute){
	console.log("ESA Granule detected");
	urlCarto='${geoserverWMS}';
}else{
	console.log("Nasa Granule detected");
	urlCarto='${NASACartoWMS}';
	}


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

//setting map bounds (map extent) with granule's envelope
var bounds = [ parseFloat(${minX}), parseFloat(${minY}), parseFloat(${maxX}), parseFloat(${maxY}) ];
//var bounds = [ parseFloat(${9.84375}), parseFloat(${-1.40625}), parseFloat(${11.25}), parseFloat(${0}) ];




//9.84375,-1.40625,11.25,0 ok
//setting map bounds (map extent) with granule's envelope
//var bounds = [ parseFloat(-10.205956), parseFloat(-0.171108), parseFloat(10.205956), parseFloat(0.171108) ];

//setting base maps layers
	 baseLayers = new ol.layer.Group({
	    title: 'Base Map',
	    openInLayerSwitcher: true,
	    layers: [

	    	new ol.layer.Tile({
					name : 'OpenStreetMap',type: 'base',visible: false,
					crossOrigin: 'anonymous',
	    	    source: new ol.source.OSM({title: "OpenStreetMap",
					wrapDateLine: false,
		            wrapX: false,
		            noWrap: true})
	    	}),
	    	new ol.layer.Tile({
				name : 'Stamen Terrain',type: 'base',
				source : new ol.source.Stamen({
					title: "Stamen terrain",
					wrapDateLine: false,
		            wrapX: false,
		            noWrap: true,
					layer : "terrain"
				}),
				crossOrigin: 'anonymous',
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
			}),

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
//if roi setting projection to 4326 and display the given layer
if("${fileType eq 'ROI'}"==="true"){


//setting the layer to display with default geoserver style 

params = {
		'NAME': '${granule.name}' ,
		'FORMAT' : FORMAT_PNG,
		'VERSION' : '1.1.1',
		'STYLES' : '',
		'LAYERS' : layername,
		'exceptions' : 'application/vnd.ogc.se_inimage',
		'BASEURL' : urlCarto
		};

//construct WMS source
var layer = constructWMSSource(params);
		 
//Map creation with default controls and defined parameters
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
						projection : PROJECTION_EPSG_4326
					})
				}), new ol.control.FullScreen(), new ol.control.MousePosition({
					coordinateFormat : ol.coordinate.createStringXY(4),
					projection : PROJECTION_EPSG_4326.getCode(),
					target : document.getElementById('mouseLocation')
				}) ]),
				target : 'mapSingleLayer<portlet:namespace/>',
				layers : [baseLayers, layer],
				view : new ol.View({
					projection : PROJECTION_EPSG_4326
				})
});

//setting map attribute for given div
jQuery('#mapSingleLayer<portlet:namespace/>').data('map', map);
		
	}else {
	
//if granule is georeferenced 
if("${granule.dataList.get(0).geometryType}"=='geolocated'){
	
	
/*
 * 
 *
 *  WMS 
 *
 *
 */
  
//setting params for rendering layer
		params = {
					'NAME' :'${granule.name}' ,
					'FORMAT' : FORMAT_PNG,
					'VERSION' : '1.1.1',
					'STYLES' : '',
					'LAYERS' : layername,
					'exceptions' : 'application/vnd.ogc.se_inimage',
					'BASEURL' : urlCarto,
					'ENV':'valueMin:${statsMin};valueMax:${statsMax}' 
					};
					
				
		//constructing wms source 
			var layer = constructWMSSource(params); 
	
		 
		
			/*
			 * 
			 *
			 *  WMTS 
			 *
			 *
			 */		
		/* //constructing wmts source
var gridsetName = 'EPSG:4326';
var gridNames = ['EPSG:4326:0', 'EPSG:4326:1', 'EPSG:4326:2', 'EPSG:4326:3', 'EPSG:4326:4', 'EPSG:4326:5', 'EPSG:4326:6', 'EPSG:4326:7', 'EPSG:4326:8', 'EPSG:4326:9', 'EPSG:4326:10', 'EPSG:4326:11', 'EPSG:4326:12', 'EPSG:4326:13', 'EPSG:4326:14', 'EPSG:4326:15', 'EPSG:4326:16', 'EPSG:4326:17', 'EPSG:4326:18', 'EPSG:4326:19', 'EPSG:4326:20', 'EPSG:4326:21'];


//var resolutions = [0.703125, 0.3515625, 0.17578125, 0.087890625, 0.0439453125, 0.02197265625, 0.010986328125, 0.0054931640625, 0.00274658203125, 0.001373291015625, 6.866455078125E-4, 3.4332275390625E-4, 1.71661376953125E-4, 8.58306884765625E-5, 4.291534423828125E-5, 2.1457672119140625E-5, 1.0728836059570312E-5, 5.364418029785156E-6, 2.682209014892578E-6, 1.341104507446289E-6, 6.705522537231445E-7, 3.3527612686157227E-7];
baseParams = ['VERSION','LAYER','STYLE','TILEMATRIX','TILEMATRIXSET','SERVICE','FORMAT'];
var tileGrid = ol.tilegrid.createXYZ({
    extent: PROJECTION_EPSG_4326.getExtent(),
    tileSize: 256
});

console.log('projection resolutions', tileGrid.getResolutions());
params = {
  'VERSION': '1.0.0',
  'BASEURL' : '${geoserverWMTS}' ,
  'LAYER': layername,
  'STYLE': '',
  'TILEMATRIX': gridNames,
  'TILEMATRIXSET': gridsetName,
  'SERVICE': 'WMTS',
  'PROJECTION': PROJECTION_EPSG_4326,
  'RESOLUTIONS': tileGrid.getResolutions(),
  'FORMAT': FORMAT_PNG
};
var layer = new ol.layer.Tile({
  source: constructWMTSSource(params)
});   */


		
		

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
							projection : PROJECTION_EPSG_4326
						})
					}), new ol.control.FullScreen(), new ol.control.MousePosition({
						coordinateFormat : ol.coordinate.createStringXY(4),
						projection : PROJECTION_EPSG_4326.getCode()
					}) ]),
					target : 'mapSingleLayer<portlet:namespace/>',
					layers : [baseLayers, layer],
					view : new ol.View({
						projection : PROJECTION_EPSG_4326
					})
				});

				jQuery('#mapSingleLayer<portlet:namespace/>').data('map', map);}
		 
		 else{
				/*
				 * 
				 *
				 *  WMS 
				 *
				 *
				 */		
		  		params = {
						'NAME' :'${granule.name}' ,
						'FORMAT' : FORMAT_PNG,
						'VERSION' : '1.1.1',
						'STYLES' : '',
						'LAYERS' : layername,
						'exceptions' : 'application/vnd.ogc.se_inimage',
						'BASEURL' : urlCarto,
						'ENV':'valueMin:${statsMin};valueMax:${statsMax}'
						};
					
			//constructing wms source 
				var layer = constructWMSSource(params);   
			
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
							projection : PROJECTION_EPSG_404000
						})
					}), new ol.control.FullScreen(), new ol.control.MousePosition({
						coordinateFormat : ol.coordinate.createStringXY(4),
						projection : PROJECTION_EPSG_404000.getCode()
					}) ]),
					target : 'mapSingleLayer<portlet:namespace/>',
					layers : [layer],
					view : new ol.View({
						projection : PROJECTION_EPSG_404000,
						zoom: 0
					})
				});	
				
				/*
				 * 
				 *
				 *  WMTS 
				 *
				 *
				 */		
/* 				//constructing wmts service
var gridsetName = 'EPSG:900913';
var gridNames = ['EPSG:900913:0', 'EPSG:900913:1', 'EPSG:900913:2', 'EPSG:900913:3', 'EPSG:900913:4', 'EPSG:900913:5', 'EPSG:900913:6', 'EPSG:900913:7', 'EPSG:900913:8', 'EPSG:900913:9', 'EPSG:900913:10', 'EPSG:900913:11', 'EPSG:900913:12', 'EPSG:900913:13', 'EPSG:900913:14', 'EPSG:900913:15', 'EPSG:900913:16', 'EPSG:900913:17', 'EPSG:900913:18', 'EPSG:900913:19', 'EPSG:900913:20', 'EPSG:900913:21', 'EPSG:900913:22', 'EPSG:900913:23', 'EPSG:900913:24', 'EPSG:900913:25', 'EPSG:900913:26', 'EPSG:900913:27', 'EPSG:900913:28', 'EPSG:900913:29', 'EPSG:900913:30'];
//var resolutions = [156543.03390625, 78271.516953125, 39135.7584765625, 19567.87923828125, 9783.939619140625, 4891.9698095703125, 2445.9849047851562, 1222.9924523925781, 611.4962261962891, 305.74811309814453, 152.87405654907226, 76.43702827453613, 38.218514137268066, 19.109257068634033, 9.554628534317017, 4.777314267158508, 2.388657133579254, 1.194328566789627, 0.5971642833948135, 0.29858214169740677, 0.14929107084870338, 0.07464553542435169, 0.037322767712175846, 0.018661383856087923, 0.009330691928043961, 0.004665345964021981, 0.0023326729820109904, 0.0011663364910054952, 5.831682455027476E-4, 2.915841227513738E-4, 1.457920613756869E-4];
				
var tileGrid = ol.tilegrid.createXYZ({
    extent: PROJECTION_EPSG_900913.getExtent(),
    tileSize: 256
});				
		
params = {
  'VERSION': '1.0.0',
  'BASEURL' : '${geoserverWMTS}' ,
  'LAYER': layername,
  'STYLE': '',
  'TILEMATRIX': gridNames,
  'TILEMATRIXSET': gridsetName,
  'SERVICE': 'WMTS',
  'RESOLUTIONS': tileGrid.getResolutions(),
  'PROJECTION': PROJECTION_EPSG_900913,
  'FORMAT': FORMAT_PNG
};
var tiled = new ol.layer.Tile({
  source: constructWMTSSource(params)
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
						projection : PROJECTION_EPSG_900913
					})
				}), new ol.control.FullScreen(), new ol.control.MousePosition({
					coordinateFormat : ol.coordinate.createStringXY(4),
					projection : PROJECTION_EPSG_900913.getCode()
				}) ]),
				target : 'mapSingleLayer<portlet:namespace/>',
				layers : [tiled],
				view : new ol.View({
					projection : PROJECTION_EPSG_900913,
					zoom: 0
				})
			});  */

			
			jQuery('#mapSingleLayer<portlet:namespace/>').data('map', map);	
			
			};
		 
	 } 
	//fitting map to bounds
	jQuery('#mapSingleLayer<portlet:namespace/>').data('map').getView().fit(bounds, map.getSize());

	/**
	 On mouse click click, shows the pixel value of the layer
	 **/
	 jQuery('#mapSingleLayer<portlet:namespace/>').data('map')
			.on(
					'singleclick',
					function(evt1) {
						console.log(jQuery('#mapSingleLayer<portlet:namespace/>').data('map').getView().getResolution());
						//reseting div content
						var infodiv = document
								.getElementById("<portlet:namespace/>featureinfotable");
						infodiv.innerHTML = "";

						var view = jQuery('#mapSingleLayer<portlet:namespace/>').data('map').getView();
						var viewResolution = view.getResolution();
						var url = '';
						//getting all map layers
						var layers = jQuery('#mapSingleLayer<portlet:namespace/>').data('map').getLayers();
						//for each layers in map, if geoserver service returns a value with the given coordinates, show pixel values
						layers
								.forEach(function(layer, i, layers) {
									
									if (layer.getVisible()
											&& typeof layer.get('name') !== "undefined") {
										
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
								
										if (url) {
											
											var xmlhttp = new XMLHttpRequest();

											xmlhttp.onreadystatechange = function() {
												if (this.readyState == 4
														&& this.status == 200) {
												
													try {
														//on request success, parse the json to get the pixel value, and append to the wanted div
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
													
													dl.appendChild(dd);

												}

												infodiv.appendChild(dl);

													} catch (err) {
														var dl = document
														.createElement('dl');
												dl.setAttribute("class", "border-around");

												var dt = document
														.createElement('dt');

												dt
														.appendChild(document
																.createTextNode(layer
																		.get('name')));

												dl.appendChild(dt);

												

													var dd = document
															.createElement('dd');

													dd
															.appendChild(document
																	.createTextNode("N/A"));
													
													dl.appendChild(dd);

												

												infodiv.appendChild(dl);


													}
												}
											};
											xmlhttp.open("GET", url, true);
											xmlhttp.send();
										}

									}
								});

					});

	
	
/**
 * Display a raster profile from a drawed vector
 *@param {element} node onclick element
 *@param {mapDiv} map id the user drawed on
 *@param {portletNamespace} liferay portletNamespace
 *@param {collectionName} collectionName of the granule you want to display the profile
 *@param {granuleName} granuleName of the granule you want to display the profile
 */
function getCustomProfile(element, mapDiv, portletNamespace, collectionName, granuleName) {
//removing existing draw interactions & drawed layers on map
removeMapInteractions(jQuery('#mapSingleLayer'+portletNamespace).data('map'), ol.interaction.Draw);
removeMapVectorLayers(jQuery('#mapSingleLayer'+portletNamespace).data('map'));

//initializing custom Draw interaction
var customProfileTool;

//toggle customProfile div and hiding others
jQuery("#"+portletNamespace+"customProfile").show();
jQuery("#"+portletNamespace+"rulerDistanceInfo").hide();
jQuery("#"+portletNamespace+"subsetStats").hide();



console.log('getting custom Profile');

//defining drawed vector style
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

//initializing vector layer with style defined beforehand
var vectorLayer = new ol.layer.Vector({
source: new ol.source.Vector(),
style: vectorStyle
});

//adding vector layer to the map
jQuery('#'+mapDiv).data('map').addLayer(vectorLayer);




var enablecustomProfileTool = function() {
	//removing possibly existing customProfile interaction
	 jQuery('#mapSingleLayer'+portletNamespace).data('map').removeInteraction(customProfileTool);

	//defining custom Profile draw interaction (two points line)
	  customProfileTool = new ol.interaction.Draw({
		type: 'LineString',
		maxPoints: 2,
	    source: vectorLayer.getSource()
	  });
	//get vectorLayer-two-points-line source
	  var source = vectorLayer.getSource();
	  
	// when a new feature has been drawn...
	  customProfileTool.on('drawstart', function(event) {
	  	console.log('draw Start interaction event called');
	  	vectorLayer.getSource().clear();
	  });
	  
	  
	  //on feature add, send a ajax request to get the data corresponding to the custom profile
	  source.on('addfeature', function(evt){
		    var feature = evt.feature;
		    var coords = feature.getGeometry().getCoordinates();
		    var format = new ol.format.WKT();
		    //the vector corresponds to the geometry drawed
			var vectorWKT=format.writeGeometry(evt.feature.getGeometry());
			console.log(vectorWKT);
			
			
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
													'${displayCustomProfile}',
													{
														dataType : 'html',
														method : 'POST',
														data : {
															
															<portlet:namespace/>collectionName : collectionName,
															<portlet:namespace/>granuleName : granuleName,
															<portlet:namespace/>vectorWKT : vectorWKT
																	.toString()
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
																
																var data = [];
																var obj = JSON.parse(this.get('responseData'));
																

																for (i = 0; i < obj.data.band.length; i++) {
																
															 	var xArray = [];
															 	var profileValues=obj.data.band[i].profile.values;
																
																var arraySplit = profileValues.replace(/\s|\[|\]/g,"").split(",");
													
																//plotly chart creation
															var trace = {
																			name : "band " + i,
																			 mode: 'lines+markers',
																			  y: arraySplit,
																			  type: 'scatter',
																			  marker : {
																					color :  "rgba(100, 200, 102, 1)",
																					line : {
																						color : "rgba(100, 200, 102, 1)",
																						width : 1,
																						shape: 'hvh'
																					}
																				}
																			};
																	data.push(trace);  
																} 
															
																var layout = {
																		  title: {
																		    text:'${granule.name} custom profile',
																		    font: {
																		      family: 'Courier New, monospace',
																		      size: 11
																		    },
																		    xref: 'paper',
																		    x: 0.05,
																		  },
																		  xaxis: {
																		    title: {
																		      text: 'pixels',
																		      font: {
																		        family: 'Courier New, monospace',
																		        size: 11,
																		        color: '#7f7f7f'
																		      }
																		    },
																		  },
																		  yaxis: {
																		    title: {
																		      text: 'pixel value',
																		      font: {
																		        family: 'Courier New, monospace',
																		        size: 11,
																		        color: '#7f7f7f'
																		      }
																		    }
																		  }
																		};
																		Plotly.newPlot(portletNamespace+'customProfile', data, layout,{
																			modeBarButtonsToRemove: ['sendDataToCloud','hoverCompareCartesian','select2d','hoverClosestCartesian','lasso2d', 'resetScale2d'],
																			responsive : true
																		});

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
   
		});
		// add custom profile interaction to map
	  jQuery('#'+mapDiv).data('map').addInteraction(customProfileTool);
	};


	enablecustomProfileTool();

		
		}

//get Zonal Stats of a raster file
function getZonalStats(element, mapDiv, portletNamespace, collectionName, granuleName) {
	//remove existing draw interaction on the given map 
	removeMapInteractions(jQuery('#mapSingleLayer'+portletNamespace).data('map'), ol.interaction.Draw);
	removeMapVectorLayers(jQuery('#mapSingleLayer'+portletNamespace).data('map'));
	
	//show the subsetStats div
	 jQuery("#"+portletNamespace+"customProfile").hide();
	 jQuery("#"+portletNamespace+"rulerDistanceInfo").hide();
	 jQuery("#"+portletNamespace+"subsetStats").show();


	// create a vector layer used for editing
		var zonal_stats_vector_layer = new ol.layer.Vector({
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
jQuery('#'+mapDiv).data('map').addLayer(zonal_stats_vector_layer);

// create the interaction
zonal_draw_interaction = new ol.interaction.Draw({
	source : zonal_stats_vector_layer.getSource(),

	type : /** @type {ol.geom.GeometryType} */
	"Polygon",
	minPoints : 4

});
// add it to the map
jQuery('#'+mapDiv).data('map').addInteraction(zonal_draw_interaction);

// at draw start reset the stats in the div
zonal_draw_interaction.on('drawstart', function(event) {
	console.log('draw Start interaction event called');
	 jQuery("#<portlet:namespace/>subsetStats dl").empty();
});

// at draw end, send an ajax request to get the zonal stats of the drawed geometry
zonal_draw_interaction.on('drawend', function(event) {
	console.log('draw end interaction event called');
	var format = new ol.format.WKT();
	//get wkt from drawed vector
	var vectorWKT=format.writeGeometry(event.feature.getGeometry());
	console.log(vectorWKT);
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
												'${displayZonalStats}',
												{
													dataType : 'html',
													method : 'POST',
													data : {
														
														<portlet:namespace/>collectionName : collectionName,
														<portlet:namespace/>granuleName : granuleName,
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
															
															var obj = JSON.parse(this.get('responseData'));								
															var objStats=obj.data.stats;
															var titleNode = document.createElement("dt");
															titleNode.innerHTML = "Zonal Statistics";
															jQuery("#"+portletNamespace+"subsetStats dl").empty();
															jQuery("#"+portletNamespace+"subsetStats dl").append(titleNode);
													
															
													//display stats in the div
															 for (i = 0; i < objStats.length; i++) {
																var objStatsNode = objStats[i];
															    for (var key in objStatsNode){
															        var attrName = key;
															        var attrValue = objStatsNode[key];
															          
															        var attrValueNode = document.createElement("dd");
															        attrValueNode.innerHTML = attrName + ": " +attrValue;   
															        
															        jQuery("#"+portletNamespace+"subsetStats dl").append(attrValueNode);
															     
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
zonal_stats_vector_layer.getSource().clear();

});


		
		}
		

</script>

