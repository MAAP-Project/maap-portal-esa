



// creates a draw interaction
	function addDrawInteraction() {
		console.log('add draw interaction function called');
		$('#coordinatesList').innerHTML = "";
		// create the interaction
		draw_interaction = new ol.interaction.Draw({
			source : vector_layer.getSource(),

			type : /** @type {ol.geom.GeometryType} */
			"Polygon",
			minPoints : 4

		});
		// add it to the map
		searchMap.addInteraction(draw_interaction);

		// when a new feature has been drawn...
		draw_interaction.on('drawstart', function(event) {
			console.log('draw Start interaction event called');

			$('#coordinatesList').innerHTML = "";
		});

		// when a new feature has been drawn...
		draw_interaction.on('drawend', function(event) {
			console.log('draw end interaction event called');
			var featureCoord = event.feature.getGeometry().getCoordinates(false);
			getCoordinatesFeature(featureCoord);

		});
	}
	

	
	// clears the map of all vector layers
	function clearMapVectorResults() {
		
		console.log('clearing map of vector layers');

		searchMap.getLayers().forEach(function(layer) {
			

		    if(layer instanceof ol.layer.Vector && layer
					.get('name') != 'searchVector') {

		    	 var features = layer.getSource().getFeatures();
		    	    features.forEach((feature) => {
		    	    	layer.getSource().removeFeature(feature);
		    	    });

		    }

		    
		
		})
		 
	}
	// clears the map of all vector layers
	function clearMapSearchBoundingBox() {
		 var features = vector_layer.getSource().getFeatures();
 	    features.forEach((feature) => {
 	    	vector_layer.getSource().removeFeature(feature);
 	    });
 	    vector_layer.getSource().clear();

	}
	
	// set map extent with a given layer extent
	function setMapExtent(fileName) {
		var extent;
		// Search layer by name
		searchMap.getLayers().forEach(
				function(sublayer) {

					if (sublayer.get('name') != undefined
							& sublayer.get('name') === fileName) {

						layerReturned = sublayer;
						extent = sublayer.getSource().getExtent();

					}
				})
		// if a extent is found, set the view to the layer extent
		if (extent != undefined & extent != null) {
			searchMap.getView().fit(extent, {duration: 2000,size: searchMap.getSize(), maxZoom:16});
			
		}
	}

	function highlightVector(fileName) {
		var primaryStyle = new ol.style.Style({
			fill : new ol.style.Fill({
				color : 'rgba(63, 195, 128, 0.5)'
			}),
			stroke : new ol.style.Stroke({
				color : 'rgba(63, 195, 128, 1)',
				width : 1
			})
		});

		searchMap.getLayers().forEach(
				function(sublayer) {

					if (sublayer.get('name') != undefined
							& sublayer.get('name') === fileName) {
						sublayer.setStyle(primaryStyle);
					}
				})

	}
	function initializeVector(fileName) {
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
		
		

		searchMap.getLayers().forEach(
				function(sublayer) {

					if (sublayer.get('name') != undefined
							& sublayer.get('name') === fileName) {
						sublayer.setStyle(myStyle);
					}
				})

	}
	// return a layer object by its fileName
	function searchLayerByName(fileName) {
		console.log("getting layer by following fileName: " + fileName);
		var layerReturned;

		searchMap
				.getLayers()
				.forEach(
						function(layer) {
	
													if (layer.get('name') != undefined
															& layer
																	.get('name') === fileName) {

														layerReturned = layer;

													}
												
							

						});

		return layerReturned;
	}