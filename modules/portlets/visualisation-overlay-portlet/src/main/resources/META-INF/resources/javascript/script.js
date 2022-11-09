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

	 var url = params['BASEURL']+'?'
	  for (var param in params) {
	    if (baseParams.indexOf(param.toUpperCase()) < 0) {
	      url = url + param + '=' + params[param] + '&';
	    }
	  }
	  url = url.slice(0, -1);

	  console.log(params['PROJECTION']);
	  console.log(params['PROJECTION'].getExtent());
	  console.log(ol.extent.getTopLeft(params['PROJECTION'].getExtent()));
	  console.log(params['RESOLUTIONS']);
	  var source = new ol.source.WMTS({
	  title:params['LAYER'],
	  name:params['LAYER'],
	    url: url,
	    layer: params['LAYER'],
	    matrixSet: params['TILEMATRIXSET'],
	    format: params['FORMAT'],
	    projection: params['PROJECTION'],
	    tileGrid: new ol.tilegrid.WMTS({
	      tileSize: [256,256],
	      extent: params['PROJECTION'].getExtent(),
	      origin: ol.extent.getTopLeft(params['PROJECTION'].getExtent()),
	      resolutions: params['RESOLUTIONS'],
	      matrixIds: params['TILEMATRIX']
	    }),
	    style: params['STYLE'],
	    wrapX: true
	  });
	  return source;
}