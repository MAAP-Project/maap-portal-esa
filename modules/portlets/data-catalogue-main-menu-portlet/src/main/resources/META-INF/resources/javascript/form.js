// Store Period input form in cookie
function registerPeriod() {

	var periodList = document.getElementsByClassName("periodInput");

	var inputFilled = false;

	jQuery('#searchMenuList').show();
	jQuery('#searchButton').show();
	jQuery('#clearButton').show();
	jQuery('#privacyTypeForm').show();

	jQuery('#dataCategorySearch').hide();
	jQuery('#locationSearch').hide();
	jQuery('#periodSearch').hide();
}
/**
 * FORM MANAGEMENT
 */
// Store location input form in cookie
function registerLocation() {

	jQuery('#searchMenuList').show();
	jQuery('#searchButton').show();
	jQuery('#clearButton').show();
	jQuery('#privacyTypeForm').show();

	jQuery('#dataCategorySearch').hide();
	jQuery('#locationSearch').hide();
	jQuery('#periodSearch').hide();

}

// Store dataCategory input form in cookie
function registerDataCategory() {

	jQuery('#searchMenuList').show();
	jQuery('#searchButton').show();
	jQuery('#clearButton').show();
	jQuery('#privacyTypeForm').show();

	jQuery('#dataCategorySearch').hide();
	jQuery('#locationSearch').hide();
	jQuery('#periodSearch').hide();

}

/**
 * Clear form and cookie if exists
 * 
 * @returns
 */
function clearForm() {
	document.getElementById("searchForm").reset();
	jQuery('#resultListTable').DataTable().clear();
	jQuery('#resultListTable').DataTable().destroy();
	jQuery('#resultListTable').DataTable();

	jQuery('#coordinatesList').empty();
	jQuery('#locationInputsHidden').empty();
	collapseResultList();
	clearMapSearchBoundingBox();
	clearMapVectorResults();
	clearMapOverlays();

}

// clear map when user clicks on reset
function deletecoordinates() {
	console.log("deleteCoordinates event triggered");
	clearMapSearchBoundingBox();
	jQuery('#coordinatesList').empty();
	jQuery('#locationInputsHidden').empty();
}

// at click on drawBoundingBox button, reset interaction and coordinatelist
function drawboundingbox() {
	console.log("drawing search location");
	searchMap.removeInteraction(draw_interaction);
	addDrawInteraction();
	jQuery('#customPoints').hide();
	jQuery('#coordinatesList').empty();
	jQuery('#locationInputsHidden').empty();
}

function addbtnlocation() {
	console.log("addBtnLocation event triggered");
	var latitude = document.getElementById('latInput').value;
	var longitude = document.getElementById('lonInput').value;
	var newitem = latitude + ',' + longitude;
	var uniqid = Math.round(new Date().getTime() + (Math.random() * 100));

	if (latitude != "" && longitude != "") {
		jQuery('#coordinatesList').append(
				'<li id="' + uniqid + '" class="coordinatesSearch">Lon '
						+ latitude + ' , Lat ' + longitude + '</li>');

		jQuery('#locationInputsHidden')
				.append(
						'<input class="locationInput"  type="hidden" name="<portlet:namespace/>coordinatesInputs" value="'
								+ newitem + '"></li>');
		jQuery('#addBtnLocation').disabled = false;
		jQuery('#addBtnLocation').className = "btn btn-dark disabled";

	} else {
		jQuery('#addBtnLocation').disabled = true;
		jQuery('#addBtnLocation').className = "btn btn-dark";
		jQuery('#latLongNoMatch').show();
	}

}

/**
 * remove data from layer list on remove button click
 */
function removeDataFromLayerList(listGroupItemId, collectionName, datafileName,
		element) {

	// console.log("removing data from layerlist");
	//
	// if (element != null && element instanceof HTMLElement) {
	// console.log("HTMLElement found");
	// } else if (element != null && !(element instanceof HTMLElement)) {
	//
	// console.log("not HTMLElement");
	// }

	if (element != null) {
		element.className = 'btn btn-link btn-add-data pull-right';
		element.innerHTML = '<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>';

		var addDataLayerListFunction = 'addDataLayerList(\'' + collectionName
				+ '\', \'' + datafileName + '\', \''
				+ element.getAttribute('data-privacy') + '\', \''
				+ element.getAttribute('data-id') + '\');';
		element.setAttribute('onclick', addDataLayerListFunction);

	}

	if (listGroupItemId) {
		document.getElementById(listGroupItemId).outerHTML = "";
	}

	var count = parseInt(jQuery('#countLayers').text());
	jQuery('#countLayers').text(count - 1);
	jQuery('#countLayersNav').text(count - 1);
	removeEntryFromLayerList(collectionName, datafileName);

	
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
}

/**
 * retrieve layerlist from local storage
 */
function retrieveLayerList() {
	var layerListEntries = JSON.parse(localStorage.getItem("layerList")) || [];

	for (i in layerListEntries) {

		retrieveLayerEntry(layerListEntries[i].collectionName,
				layerListEntries[i].datafileName, layerListEntries[i].privacy);
	}

}

/**
 * retrieve layerEntry and add it to layer list
 */
function retrieveLayerEntry(collectionName, datafileName, privacy) {
	if (ajaxLoading == false) {
		addDataLayerList(collectionName, datafileName, privacy, null);
	} else {
		window.setTimeout("retrieveLayerEntry('" + collectionName + "','"
				+ datafileName + "','" + privacy + "');", 100);
	}
}

/**
 * retrieve layerlist from local storage
 */
function removeEntryFromLayerList(collectionName, datafileName) {
	var layerListEntries = JSON.parse(localStorage.getItem("layerList")) || [];

	for (i in layerListEntries) {

		if (layerListEntries[i].collectionName == collectionName
				&& layerListEntries[i].datafileName == datafileName) {

			layerListEntries.splice(i, 1);
		}

	}
	localStorage.setItem('layerList', JSON.stringify(layerListEntries));

}

/**
 * generateResultListTable from given json
 */
function generateResultListTable(dataResultListJson, noProductImagePath) {

	if (dataResultListJson !== undefined && dataResultListJson !== null
			&& dataResultListJson !== "") {
		if (dataResultListJson.collectionDataList !== undefined
				&& dataResultListJson.collectionDataList !== null
				&& dataResultListJson.collectionDataList !== "") {
			// for each element in result list , create a data table row
			for (var i = 0; i < dataResultListJson.collectionDataList.length; i++) {

				tr = document.createElement("tr");

				tdControl = document.createElement("td");
				tdFilePreview = document.createElement("td");
				tdFileName = document.createElement("td");
				tdAcquDate = document.createElement("td");
				tdCollection = document.createElement("td");
				tdSubRegion = document.createElement("td");
				tdGranuleScene = document.createElement("td");
				tdPrivacy = document.createElement("td");
				tdAction = document.createElement("td");

				// setting elements classes
				tr.className = dataResultListJson.collectionDataList[i].granuleGrouping;
				tdFileName.className = "dataTableValues";
				tdAcquDate.className = "dataTableValues";
				tdCollection.className = "dataTableValues";
				tdSubRegion.className = "dataTableValues";
				tdGranuleScene.className = "dataTableValues";
				tdPrivacy.className = "dataTableValues";
				tdAction.className = "dataTableValues";

				var dataID = dataResultListJson.collectionDataList[i].id;

				var datafileName = dataResultListJson.collectionDataList[i].granuleName;

				tdFileName.appendChild(document.createTextNode(datafileName));
				var imgSrc = null;

				// if it is a nasa product no layer preview is available,
				// showing no image png instead of layer preview
				if (dataResultListJson.collectionDataList[i].granuleGrouping == 'Nasa_products') {

					imgSrc = noProductImagePath;
				} else {

					imgSrc = dataResultListJson.collectionDataList[i].layerPreviewURL;
				}

				// filling all the cells with adequate content
				tdFilePreview.innerHTML = '<img id="setMapExtent'
						+ dataResultListJson.collectionDataList[i].collection
						+ '-' + datafileName + '"  class="layerPreview" src='
						+ imgSrc + '>';

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

				// showing private/public badge info
				switch (dataResultListJson.collectionDataList[i].privacy) {
				case 'PRIVATE':
					tdPrivacy.innerHTML = '<span class="badge badge-info">'
							+ dataResultListJson.collectionDataList[i].privacy
							+ '</span>';

					break;
				case 'PUBLIC':
					tdPrivacy.innerHTML = '<span class="badge badge-success">'
							+ dataResultListJson.collectionDataList[i].privacy
							+ '</span>';

					break;

				}

				// constructing button to add the layer
				tdAction.innerHTML = '<button data-privacy=\''
						+ dataResultListJson.collectionDataList[i].privacy
						+ '\' data-collection=\''
						+ dataResultListJson.collectionDataList[i].collection
						+ '\'  data-filename=\''
						+ datafileName
						+ '\' id="btn-add-rmv-'
						+ dataResultListJson.collectionDataList[i].collection
						+ '-'
						+ datafileName
						+ '" type="button" onClick="addDataLayerList(\''
						+ dataResultListJson.collectionDataList[i].collection
						+ '\', \''
						+ datafileName
						+ '\', \''
						+ dataResultListJson.collectionDataList[i].privacy
						+ '\',this)" class="btn btn-link btn-add-data pull-right"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span> </button>';

				// append the cells to the row
				tr.appendChild(tdFilePreview);
				tr.appendChild(tdFileName);
				tr.appendChild(tdCollection);
				tr.appendChild(tdSubRegion);
				tr.appendChild(tdGranuleScene);
				tr.appendChild(tdAcquDate);
				tr.appendChild(tdPrivacy);
				tr.appendChild(tdAction);

				// append the row to the datatable
				document.getElementById("resultListTableBody").appendChild(tr);
				tr.setAttribute("id", 'trLayer'
						+ dataResultListJson.collectionDataList[i].collection
						+ '-' + datafileName);

				// Display of the centroid on the map if the data is
				// georeferenced

				var centroidLon = dataResultListJson.collectionDataList[i].centroidLon;
				var centroidLat = dataResultListJson.collectionDataList[i].centroidLat;
				var minimumX = dataResultListJson.collectionDataList[i].minimumX;
				var minimumY = dataResultListJson.collectionDataList[i].minimumY;
				var maximumX = dataResultListJson.collectionDataList[i].maximumX;
				var maximumY = dataResultListJson.collectionDataList[i].maximumY;
				var granuleWkt = dataResultListJson.collectionDataList[i].wkt;

				// constructing bounding box overlay of data on the map
				if ((typeof granuleWkt !== "undefined")
						&& (typeof granuleWkt !== "undefined")) {
					var coord = [ centroidLat, centroidLon ];

					var format = new ol.format.WKT();
					var feature = format.readFeature(granuleWkt);
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

					// style of the vector overlay
					_myStroke = new ol.style.Stroke({
						color : 'rgba(241, 90, 34, 1)',
						width : 1
					});

					_myFill = new ol.style.Fill({
						color : 'rgba(240, 255, 0, 0.07)'
					});

					myStyle = new ol.style.Style({
						stroke : _myStroke,
						fill : _myFill
					});

					// constructing vector object
					var vector = new ol.layer.Vector(
							{
								name : dataResultListJson.collectionDataList[i].collection
										+ ':@' + datafileName,

								source : new ol.source.Vector({
									features : [ feature ]
								}),
								style : [ myStyle ]
							});

					// add the vector to the map and setting zIndex
					searchMap.addLayer(vector);
					vector.setZIndex(40);
					var extent = vector.getSource().getExtent();

					var setExtentElement = document
							.getElementById('setMapExtent'
									+ dataResultListJson.collectionDataList[i].collection
									+ '-' + datafileName + '');
					var fileTrElement = document
							.getElementById('trLayer'
									+ dataResultListJson.collectionDataList[i].collection
									+ '-' + datafileName + '');

					setExtentElement
							.setAttribute(
									'onclick',
									'setMapExtent("'
											+ dataResultListJson.collectionDataList[i].collection
											+ ':@' + datafileName + '")');

					fileTrElement
							.setAttribute(
									'onmouseover',
									'highlightVector("'
											+ dataResultListJson.collectionDataList[i].collection
											+ ':@' + datafileName + '")');

					fileTrElement
							.setAttribute(
									'onmouseout',
									'initializeVector("'
											+ dataResultListJson.collectionDataList[i].collection
											+ ':@' + datafileName + '")');

				}

			}

		}
	}

}
