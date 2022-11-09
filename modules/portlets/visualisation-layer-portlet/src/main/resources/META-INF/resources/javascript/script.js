/////*
//// * Construct a WMS layer with given params
//// */
//function constructWMSSource(params) {
//	var source = new ol.layer.Image({
//		name : params['NAME'],
//		crossOrigin : 'anonymous',
//		source : new ol.source.ImageWMS({
//			wrapDateLine : false,
//			wrapX : false,
//			noWrap : true,
//			ratio : 1,
//			url : params['BASEURL'],
//			params : {
//				'FORMAT' : params['FORMAT'],
//				'VERSION' : params['VERSION'],
//				"STYLES" : params['STYLES'],
//				"LAYERS" : params['LAYERS'],
//				"ENV" : params['ENV'],
////				"exceptions" : params['exceptions'],
//			
//
//			}
//		})
//	});
//	return source;
//}

/*
 * Construct a WMS layer with given params
 */
function constructWMSSource(params) {

	var source = new ol.layer.Tile({
		name : params['NAME'],
		source : new ol.source.TileWMS({
			url : params['BASEURL'],
			params : {
				'FORMAT' : params['FORMAT'],
				'VERSION' : params['VERSION'],
				"STYLES" : params['STYLES'],
				"LAYERS" : params['LAYERS'],
				"ENV" : params['ENV'],
			// "exceptions" : params['exceptions'],

			}
		})
	})
	return source;
}

/*
 * Construct a WMTS layer with given params
 */
function constructWMTSSource(params) {
	var url = params['BASEURL'] + '?'
	for ( var param in params) {
		if (baseParams.indexOf(param.toUpperCase()) < 0) {
			url = url + param + '=' + params[param] + '&';
		}
	}
	url = url.slice(0, -1);

	var source = new ol.source.WMTS({
		title : params['LAYER'],
		name : params['LAYER'],
		url : url,
		layer : params['LAYER'],
		matrixSet : params['TILEMATRIXSET'],
		format : params['FORMAT'],
		projection : params['PROJECTION'],
		tileGrid : new ol.tilegrid.WMTS({
			tileSize : [ 256, 256 ],
			extent : params['PROJECTION'].getExtent(),
			origin : ol.extent.getTopLeft(params['PROJECTION'].getExtent()),
			resolutions : params['RESOLUTIONS'],
			matrixIds : params['TILEMATRIX']
		}),
		style : params['STYLE'],
		wrapX : true
	});
	return source;
}

/*
 * set a two color scale with given params
 */
function setTwoColorColorScale(data, valueMin, valueMax, colorMin, colorMax,
		mapDiv) {

	var layer = getLayerByName(data, mapDiv);
	layer.getSource().updateParams(
			{
				STYLES : 'raster',
				ENV : 'colorMin:' + colorMin + ';colorMax:' + colorMax
						+ ';valueMin:' + valueMin + ';valueMax:' + valueMax
						+ ''
			});

}

/*
 * set a three color scale with given params
 */
function setThreeColorColorScale(data, valueMin, valueAvg, valueMax, colorMin,
		colorAvg, colorMax, mapDiv) {

	var layer = getLayerByName(data, mapDiv);
	layer.getSource().updateParams(
			{
				STYLES : 'threeColorGradient',
				ENV : 'colorMin:' + colorMin + ';colorAvg:' + colorAvg
						+ ';colorMax:' + colorMax + ';valueMin:' + valueMin
						+ ';valueAvg:' + valueAvg + ';valueMax:' + valueMax
						+ ''
			});

}

// return a layer object by its fileName
function getLayerByName(fileName, mapDiv) {
	console.log("getting layer by following fileName: " + fileName);
	var layerReturned;

	jQuery('#' + mapDiv).data('map').getLayers().forEach(function(layer) {

		if (layer.get('name') != undefined & layer.get('name') === fileName) {

			layerReturned = layer;
		}
	});

	return layerReturned;
}

// Displays distance in degrees and meters for a geometry drawed on the map
function getRulerDistance(mapDiv, portletNamespace) {

	removeMapInteractions(jQuery('#mapSingleLayer' + portletNamespace).data(
			'map'), ol.interaction.Draw);
	removeMapVectorLayers(jQuery('#mapSingleLayer' + portletNamespace).data(
			'map'));

	jQuery("#" + portletNamespace + "customProfile").hide();
	jQuery("#" + portletNamespace + "subsetStats").hide();
	jQuery("#" + portletNamespace + "rulerDistanceInfo").show();
	// define a style for the ruler distance vector line
	var vectorStyle = new ol.style.Style({
		fill : new ol.style.Fill({
			color : 'rgba(255, 255, 255, 0.2)'
		}),
		stroke : new ol.style.Stroke({
			color : '#ffcc33',
			width : 2
		}),

		image : new ol.style.Circle({
			radius : 7,
			stroke : new ol.style.Stroke({
				color : 'white',
				width : 2
			}),
			fill : new ol.style.Fill({
				color : '#ffcc33'
			})
		})

	});

	// creates the vector layer object
	var vectorLayer = new ol.layer.Vector({
		source : new ol.source.Vector(),
		style : vectorStyle
	});

	// add the layer to the map
	jQuery('#' + mapDiv).data('map').addLayer(vectorLayer);

	var resultElementDegrees = jQuery('#' + portletNamespace
			+ 'rulerDistanceDegrees');
	var resultElementMeters = jQuery('#' + portletNamespace
			+ 'rulerDistanceMeters');
	var measuringTool;

	// enable interaction on the map for ruler distance
	var enableMeasuringTool = function() {
		map.removeInteraction(measuringTool);

		var geometryType = 'LineString';
		var html = geometryType === 'Polygon' ? '<sup>2</sup>' : '';

		measuringTool = new ol.interaction.Draw({
			type : geometryType,
			source : vectorLayer.getSource(),
			maxPoints: 2
		});

		// display ruler distance information
		measuringTool
				.on(
						'drawstart',
						function(event) {

							var source = vectorLayer.getSource();
							source.forEachFeature(function(feature) {
								var coord = feature.getGeometry()
										.getCoordinates();
							});

							vectorLayer.getSource().clear();

							event.feature
									.on(
											'change',
											function(event) {

												var newPoints = [];
												var coords = event.target
														.getGeometry()
														.getCoordinates();
												coords
														.forEach(function(
																coordinate) {
															newPoints
																	.push(ol.proj
																			.transform(
																					coordinate,
																					'EPSG:4326',
																					'EPSG:3857'));
														});

												var newGeom = new ol.geom.LineString(
														newPoints);

												var measurementDegrees = geometryType === 'Polygon' ? event.target
														.getGeometry()
														.getArea()
														: event.target
																.getGeometry()
																.getLength();
												var measurementMeters = geometryType === 'Polygon' ? event.target
														.getGeometry()
														.getArea()
														: newGeom.getLength();

												var measurementFormattedDegrees = measurementDegrees
														.toFixed(2)
														+ ' degrees';
												var measurementFormattedMeters = measurementMeters > 100 ? (measurementMeters / 1000)
														.toFixed(2)
														+ ' km'
														: measurementMeters
																.toFixed(2)
																+ 'm';
//												resultElementDegrees
//														.html(measurementFormattedDegrees
//																+ html);
												resultElementMeters
														.html(measurementFormattedMeters
																+ html);

											});

						});

		jQuery('#' + mapDiv).data('map').addInteraction(measuringTool);
	};

	enableMeasuringTool();

}
