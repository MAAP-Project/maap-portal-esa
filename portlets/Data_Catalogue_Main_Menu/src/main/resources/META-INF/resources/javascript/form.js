// Store Period input form in cookie
function registerPeriod() {

	var periodList = document.getElementsByClassName("periodInput");

	var inputFilled = false;

	$('#searchMenuList').show();
	$('#searchButton').show();
	$('#clearButton').show();

	$('#dataCategorySearch').hide();
	$('#locationSearch').hide();
	$('#periodSearch').hide();

}
/**
 * FORM MANAGEMENT
 */
// Store location input form in cookie
function registerLocation() {

	$('#searchMenuList').show();
	$('#searchButton').show();
	$('#clearButton').show();

	$('#dataCategorySearch').hide();
	$('#locationSearch').hide();
	$('#periodSearch').hide();

}

// Store dataCategory input form in cookie
function registerDataCategory() {

	$('#searchMenuList').show();
	$('#searchButton').show();
	$('#clearButton').show();

	$('#dataCategorySearch').hide();
	$('#locationSearch').hide();
	$('#periodSearch').hide();

}

/**
 * Clear form and cookie if exists
 * 
 * @returns
 */
function clearForm() {
	document.getElementById("searchForm").reset();
	$('#resultListTable').DataTable().clear();
	$('#resultListTable').DataTable().destroy();
	$('#resultListTable').DataTable();

	$('#coordinatesList').empty();
	$('#locationInputsHidden').empty();
	collapseResultList();
	clearMapSearchBoundingBox();
	clearMapVectorResults();

}
/**
 * remove data from layer list on remove button click
 */
function removeDataFromLayerList(listGroupItemId, collectionName, datafileName,
		element) {
	if (element != null) {
		element.className = 'btn btn-link btn-add-data pull-right';
		element.innerHTML = '<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>';
		element.setAttribute('onclick', 'addDataLayerList(\'' + collectionName
				+ '\', \'' + datafileName + '\',this);');
	}

	if (listGroupItemId) {
		document.getElementById(listGroupItemId).outerHTML = "";
	}

	var count = parseInt($('#countLayers').text());
	$('#countLayers').text(count - 1);
	$('#countLayersNav').text(count - 1);
	removeEntryFromLayerList(collectionName, datafileName);

}

/**
 * retrieve layerlist from local storage
 */
function retrieveLayerList() {
	var layerListEntries = JSON.parse(localStorage.getItem("layerList")) || [];

	for (i in layerListEntries) {
		/*
		 * console.log(layerListEntries[i]);
		 * console.log(layerListEntries[i].collectionName);
		 * console.log(layerListEntries[i].datafileName);
		 */
		retrieveLayerEntry(layerListEntries[i].collectionName,
				layerListEntries[i].datafileName);
	}

}

/**
 * retrieve layerEntry and add it to layer list
 */
function retrieveLayerEntry(collectionName, datafileName) {
	if (ajaxLoading == false) {
		addDataLayerList(collectionName, datafileName, null);
	} else {
		window.setTimeout("retrieveLayerEntry('" + collectionName + "','"
				+ datafileName + "');", 100);
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