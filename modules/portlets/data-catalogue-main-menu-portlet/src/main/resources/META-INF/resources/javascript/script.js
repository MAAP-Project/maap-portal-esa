/**
 * set fading time for error message
 * 
 * @returns
 */
function closeAlertMessage() {
	window.setTimeout(function() {
		jQuery("#errorMessage").fadeOut(300)
	}, 5000);
}

function addEntry(collectionName, datafileName, privacy) {
	// Parse any JSON previously stored in allEntries
	var existingEntries = JSON.parse(localStorage.getItem("layerList"));
	if (existingEntries == null)
		existingEntries = [];
	var entry = {
		"collectionName" : collectionName,
		"datafileName" : datafileName,
		"privacy" : privacy
	};
	localStorage.setItem("entry", JSON.stringify(entry));
	// Save allEntries back to local storage
	existingEntries.push(entry);
	localStorage.setItem("layerList", JSON.stringify(existingEntries));
}

function clearLayerList() {
	localStorage.removeItem('layerList');
	localStorage.removeItem('entry');
	jQuery('#collapseTwo > .list-group-item').remove();
	jQuery('#countLayers').text('0');
	jQuery('#countLayersNav').text('0');

	var btnRemoveDataList = jQuery('.btn.btn-link.btn-remove-data.pull-right');

	for (var i = 0; i < btnRemoveDataList.length; i++) {
		var addDataLayerListFunction = 'addDataLayerList(\''
				+ btnRemoveDataList[i].getAttribute("data-collection")
				+ '\', \'' + btnRemoveDataList[i].getAttribute("data-filename")
				+ '\', \'' + btnRemoveDataList[i].getAttribute('data-privacy')
				+ '\', \'' + btnRemoveDataList[i].getAttribute('data-id')
				+ '\');';
		btnRemoveDataList[i].setAttribute('onclick', addDataLayerListFunction);
		btnRemoveDataList[i].className = 'btn btn-link btn-add-data pull-right';
		btnRemoveDataList[i].innerHTML = '<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>';

	}

}

function updateEntry(collectionName, granuleName, privacyType) {
	// Parse any JSON previously stored in allEntries
	var existingEntries = JSON.parse(localStorage.getItem("layerList"));

	for (var i = 0; i < existingEntries.length; i++) {
		console.log(existingEntries[i].collectionName);
		console.log(existingEntries[i].datafileName);
		console.log(existingEntries[i].privacy);
		if ((existingEntries[i].collectionName == collectionName)
				&& (existingEntries[i].datafileName == granuleName)) {
			console.log('trouvé');
			existingEntries[i].privacy = privacyType;

		}

	}
	console.log(existingEntries);
	localStorage.setItem("layerList", JSON.stringify(existingEntries));

}

/**
 * remove data from LayerList
 */
function delete_Entry(collectionName, datafileName, element) {

	element.parentNode.parentNode.parentNode.parentNode.outerHTML = "";

	var buttonElement = document.getElementById('btn-add-rmv-' + collectionName
			+ '-' + datafileName + '');
	removeDataFromLayerList(null, collectionName, datafileName, buttonElement);

}
