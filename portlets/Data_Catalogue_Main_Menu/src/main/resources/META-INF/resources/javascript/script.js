function addEntry(collectionName, datafileName) {
	// Parse any JSON previously stored in allEntries
	var existingEntries = JSON.parse(localStorage.getItem("layerList"));
	if (existingEntries == null)
		existingEntries = [];
	var collectionName = collectionName;
	var datafileName = datafileName;
	var entry = {
		"collectionName" : collectionName,
		"datafileName" : datafileName
	};
	localStorage.setItem("entry", JSON.stringify(entry));
	// Save allEntries back to local storage
	existingEntries.push(entry);
	localStorage.setItem("layerList", JSON.stringify(existingEntries));
}

function clearLayerList() {
	localStorage.removeItem('layerList');
	$('#collapseTwo > .list-group-item').remove();
	$('#countLayers').text('0');
	$('#countLayersNav').text('0');
}