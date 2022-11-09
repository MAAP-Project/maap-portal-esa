<%@ include file="/init.jsp"%>


<button class="btn" onclick="openFullscreen()" style="float: right; padding-bottom: 0;
padding-top: 0;"><i class="fa fa-expand" style="color: #19914f"></i></button>

<div id="processingFrame">
	<iframe id="edavIframe" title="Edav Iframe" style="min-height: 900px" allow="clipboard-read; clipboard-write"
		height="100%" width="100%" src="${ESA_MAAP_EDAV_URL}">
	</iframe>
</div>



<script>
/*Function to trigger full screen mode*/

		//catalogue algorithm
		jQuery(document).ready(function() {
		
		});


function triggerFullScreen() {

	openFullscreen();
}

/* Function to open fullscreen mode */
function openFullscreen() {
	var elem = document.getElementById("processingFrame");
	if (elem.requestFullscreen) {
		elem.requestFullscreen();
	} else if (elem.mozRequestFullScreen) { /* Firefox */
		elem.mozRequestFullScreen();
	} else if (elem.webkitRequestFullscreen) { /* Chrome, Safari & Opera */
		elem.webkitRequestFullscreen();
	} else if (elem.msRequestFullscreen) { /* IE/Edge */
		elem.msRequestFullscreen();
	}
}
</script>

<style>

.portlet-content {
	padding: 0px;
}

#column-1 {
	padding: 0px;
}

#portlet_com_esa_maap_explore_portlet_ExplorePortlet_INSTANCE_OShTdsnMfG6I>.portlet-content {
	padding: 0px;
}
</style>