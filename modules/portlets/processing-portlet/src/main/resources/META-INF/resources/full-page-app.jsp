<%@ include file="/init.jsp"%>



<!-- Modal -->
<div class="modal fade" id="exampleModalCenter" tabindex="-1"
	role="dialog" aria-labelledby="exampleModalCenterTitle"
	aria-hidden="true" style="display: none; padding-right: 0px;">
	<div id="processingModalDialog"
		class="modal-dialog modal-dialog-centered-processing" role="document"
		style="width: 100%; margin: 0.5rem;">
		<div id="che_modal_content" class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLongTitle">Eclipse che</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div id="eclipse-che-full-page" class="modal-body">
				<iframe class="processingIframes" alt="" border="0" frameborder="0"  hspace="0"
					id="che_iframe_full_screen" longdesc="" scrolling="auto"
					src="about:blank" data-src="${BMAP_ECLIPSECHE_URL}" title="" vspace="0"
					tabindex="0"> Your browser does not support inline frames
					or is currently configured not to display inline frames.</iframe>

			</div>
		</div>


		<div id="jupyter_modal_content" class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLongTitle">Jupyter</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div id="jupyter-che-full-page" class="modal-body">
				<iframe alt="" border="0" frameborder="0" height="100%" hspace="0"
					id="jupyter_iframe_full_screen" longdesc="" scrolling="auto"
					src="about:blank" data-src="${BMAP_JUPYTER_URL}" title="" width="100%" vspace="0"
					tabindex="0"> Your browser does not support inline frames
					or is currently configured not to display inline frames.</iframe>

			</div>
		</div>

		<div id="copa_modal_content" class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLongTitle">Ochestrator</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div id="copa-full-page" class="modal-body">
				<iframe alt="" border="0" frameborder="0" height="100%" hspace="0"
					id="copa_iframe_full_screen" longdesc="" scrolling="auto"
					src="${BMAP_COPA_URL}?user_id=${user_id}&user_first_name=${fname}&user_last_name=${lname}&user_email=${email}&user_password=${password}" title="" width="100%" vspace="0"
					tabindex="0"> Your browser does not support inline frames
					or is currently configured not to display inline frames.</iframe>

			</div>
		</div>
	</div>
</div>

<style>
.modal-dialog-centered-processing {
	display: flex;
	min-height: calc(100% - ( 0.5rem * 2));
}
</style>