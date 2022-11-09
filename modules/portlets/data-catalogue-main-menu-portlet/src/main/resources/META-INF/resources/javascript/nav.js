/**
 * Checking privacy type, if private the collection User data must be filled
 * 
 * @returns
 */
function checkPrivacy() {
	console.log("checking privacy");
	
	var privacyCheckBox = jQuery('.form-radio.privacyTypeCheck:checkbox:checked');


	if (privacyCheckBox.length === 1 && privacyCheckBox[0].value === "PRIVATE") {
		console.log('Private request detected, filling collection input');
		document.getElementById('groundCampaignName').value = 'USER_DATA';
	} else {
		document.getElementById('groundCampaignName').value = '';
	}

}

/**
 * Toggle Navigation overlay
 * 
 * @returns
 */
function closeNav() {
	jQuery("#overlay").toggle();
}

/**
 * Function called at catalogueToggle element click
 * 
 * @returns
 */
function catalogueToggle() {
	var testContainer = document.getElementById("searchmap");
	var canvasChildNode = testContainer.querySelector('canvas');
	canvasChildNode.style.display = "block";

}

/**
 * Toggle Result List
 * 
 * @returns
 */
function collapseResultList() {
	document.getElementById("resultListDiv").className = "d-none";
}

/**
 * remove Portlet from page
 */

function delete_row(e) {
	var nodeToRemove = e.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
	nodeToRemove.remove();

}
