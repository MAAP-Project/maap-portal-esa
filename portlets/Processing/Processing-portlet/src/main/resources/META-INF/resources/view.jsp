<%@ include file="/init.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>



<body>
	<liferay-ui:error key="error" message="${errorMessage}" />




	<!-- Page Content -->
	<div class="contenu-processing row">
		<!-- We include the page of the main side bar -->
		<%@ include file="/main-side-bar.jsp"%>

		<div id="divDataTable" class="col-md-9  backgroud-content-processing">

			<div id="btnFullscreen" class="card row card-header"
				style="height: 70px; width: 100%; font-family: NotesEsaReg; color: white; margin-bottom: 0px; display: none;">
				<input data-fullScreen="false" type="image" id="toogle-side-menu"
					alt="fullscreen" class="btn" style="height: 50px; float: right;"
					src="<%=request.getContextPath()%>/media/fullscreen.png"
					alt="Card image cap"></input>
				<!-- data-toggle="modal"
					data-target="#exampleModalCenter" -->

			</div>
			<div id="processingFrame" class="row" style="display: none">

				<%@ include file="/development-environment.jsp"%>
			</div>

			<div id="catalogue_frame" class="row" style="margin-right: 15px;">
				<%@ include file="/catalogue-algorithm.jsp"%>
			</div>
		</div>
	</div>


	<script>
		$("#btnFullscreen").click(function() {

			openFullscreen();

		});

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
		console.log("ready!");
		$("#processingFrame").hide();

		$('#dtBasicExample').DataTable();
		$('.dataTables_length').addClass('bs-select');
		$("#catalogue_frame").show();
		$('#spinner').hide();

		var currentView;
		//We reload the page when we click on the button last update
		function reinitList() {
			$('#spinner').show();
			location.reload();
		}
		//Show and hide iframe
		function showHide(iframe) {
			if (iframe == "Gitlab") {
				window.open("https://gitlab.biomass-maap.com/", "_blank");
				$("#btnExpand").css("display", "none");
				//$("#che_iframe").hide();
				//$("#jupyter_iframe").hide();
				//$("#gitlab_iframe").show();
			} else if (iframe == "Jupyter") {

				currentView = iframe;
				var iframe = $("#jupyter_iframe");
				iframe.attr("src", iframe.data("src"));

				$("#jupyter_iframe").show();
				$("#che_iframe").hide();
				$("#copa_iframe").hide();
				$("#gitlab_iframe").hide();
				$("#processingFrame").css("display", "");
				$("#btnFullscreen").css("display", "");

				$("#catalogue_frame").hide();

			} else if (iframe == "Che") {
				console.log("Che");
				currentView = iframe;
				var iframe = $("#che_iframe");
				iframe.attr("src", iframe.data("src"));
				//show che and hide others
				$("#che_iframe").show();
				$("#gitlab_iframe").hide();
				$("#copa_iframe").hide();
				$("#jupyter_iframe").hide();
				$("#processingFrame").css("display", "");
				$("#btnFullscreen").css("display", "");
				$("#catalogue_frame").hide();

			} else if (iframe == "Copa") {
				currentView = iframe;
				//show che and hide others
				$("#copa_iframe").show();
				$("#che_iframe").hide();
				$("#gitlab_iframe").hide();
				$("#jupyter_iframe").hide();
				$("#processingFrame").css("display", "");
				$("#btnFullscreen").css("display", "");
				$("#catalogue_frame").hide();

			} else {
				//showthe catalogue
				$("#catalogue_frame").show();
				$("#che_iframe").hide();
				$("#gitlab_iframe").hide();
				$("#copa_iframe").hide();
				$("#jupyter_iframe").hide();
				$("#processingFrame").css("display", "");
				$("#btnFullscreen").css("display", "none");
				$("#processingFrame").hide();

			}
		}

		//Toogle

		$("#toogle-side-menu").click(function() {

			console.log(currentView);
			if (currentView == "Che") {

				var iframe = $("#che_iframe_full_screen");
				iframe.attr("src", iframe.data("src"));

				$("#exampleModalCenter").css("display", "");
				$("#full-page-app").css("display", "");
				$("#che_modal_content").show();
				$("#jupyter_modal_content").hide();
				$("#copa_modal_content").hide();
			} else if (currentView == "Jupyter") {

				var iframe = $("#jupyter_iframe_full_screen");
				iframe.attr("src", iframe.data("src"));

				$("#exampleModalCenter").css("display", "");

				$("#full-page-app").css("display", "");
				$("#che_modal_content").hide();
				$("#jupyter_modal_content").show();
				$("#copa_modal_content").hide();
			} else if (currentView == "Copa") {
				$("#exampleModalCenter").css("display", "");
				$("#full-page-app").css("display", "");
				$("#che_modal_content").hide();
				$("#jupyter_modal_content").hide();
				$("#copa_modal_content").show();
			} else {
				$("#exampleModalCenter").css("display", "none");
			}

		});

		//catalogue algorithm
		$(document).ready(function() {
			$('#resultListTable').DataTable();
		});

		//This list is used to add a topic, when a topic is checked
		function searchAlgo() {
			$("#lastPublished").removeAttr('checked');
			$('#badgesDataTable').find('.badge-info').remove();
			var topicArray = [];
			$('input.topic:checkbox:checked').each(function() {
				topicArray.push($(this).val());

				//var badge = '<span class="badge badge-info">'+$(this).val()+'</span>';

				badge = document.createElement("span");
				badge.innerHTML = $(this).val();
				badge.className = "badge badge-info";
				document.getElementById("badgesDataTable").appendChild(badge);

				//document.getElementById("badgesDataTable").appendChild(document.createTextNode(badge));
				console.log(topicArray);
			});

			//We get the value of the input text for tags
			tag = $("#inputTag").val();

			if (tag != null) {
				badge = document.createElement("span");
				badge.innerHTML = tag;
				badge.className = "badge badge-info";
				document.getElementById("badgesDataTable").appendChild(badge);
			}
			searchAlgorithm(topicArray, tag);
			$("#inputTag").val("");
		}

		//card algo 
		$('#algoInfo').on('show.bs.modal', function(event) {
			var button = $(event.relatedTarget) // Button that triggered the modal
			console.log("inside the card")
		})

		//copy to clipboard
		function copyToclipBoard(idBtn) {
			console.log("the id btn is " + idBtn);
			/* Get the text field */
			var copyText = document.getElementById(idBtn);
			/* Select the text field */
			copyText.select();

			/* Copy the text inside the text field */
			document.execCommand("copy");
		}

		function outFunc(id) {
			var tooltip = document.getElementById(id);
		}

		//When user click on enter
		$('#inputTag').keypress(function(e) {
			if (e.which == 13)
				searchAlgo();
		});

		//We detect when tabs are clicked
		function changeColorTab(index) {
			console.log(index);
			if (index = 1) {
				$('#nav-tab a:first-child').css("color", "#008542"); // Select first tab
				$('#nav-tab a:nth-child(2)').css("color", "#00338D");
			} else {
				$('#nav-tab a:first-child').css("color", "#00338D"); // Select first tab
				$('#nav-tab a:nth-child(2)').css("color", "#008542");
			}
		}
	</script>
	<aui:script>
		//Function used to search an algorithm
		function searchAlgorithm(listCriteria, tag) {

			var dataCriterria = JSON.stringify(listCriteria);
			console.log("search : " + dataCriterria);
			AUI()
					.use(
							'aui-base',
							'aui-io-request',
							function(A) {
								A.io
										.request(
												'${refreshAlgoResultList}',
												{
													dataType : 'json',
													method : 'POST',
													form : {
														id : "id"
													},
													data : {
														<portlet:namespace/>listCriteria : dataCriterria,
														<portlet:namespace/>tags : tag
													},
													on : {
														start : function() {
															console
																	.log('start');
															$('#spinner')
																	.show();
														},
														success : function() {
															$(
																	'#resultListTable')
																	.DataTable()
																	.clear();
															$(
																	'#resultListTable')
																	.DataTable()
																	.destroy();
															$('#spinner')
																	.hide();
															document
																	.getElementById("resultListTable").className = "table";

															var dataResultListJson = this
																	.get('responseData');
															console
																	.log(dataResultListJson);

															//We iterate on the list to get the algorithm and to recreate data
															for (var i = 0; i < dataResultListJson.length; i++) {
																var algorithm = dataResultListJson[i];

																//We recreate the body
																tr = document
																		.createElement("tr");
																tdName = document
																		.createElement("td");
																tdDescription = document
																		.createElement("td");
																tdAuthor = document
																		.createElement("td");
																tdLastUpdate = document
																		.createElement("td");
																tdApplicationZone = document
																		.createElement("td");
																tdReadMore = document
																		.createElement("td");

																//setting element classes
																tr.className = "dataTableValues";

																//We get the data content
																var id = algorithm.id;
																var name = algorithm.name;
																var descriptionResume = algorithm.description
																		.substring(
																				0,
																				51)
																		+ "...";
																var description = algorithm.description;
																console
																		.log(algorithm.author["BmaapUser"]);
																var author = algorithm.author["BmaapUser"].name
																var lastUpdateDate = algorithm.lastUpdateDate;
																var applicationZone = algorithm.applicationZone;

																//Wwe put data inside tag 
																tdName
																		.appendChild(document
																				.createTextNode(name));
																tdDescription
																		.appendChild(document
																				.createTextNode(descriptionResume));
																tdAuthor
																		.appendChild(document
																				.createTextNode(author));
																tdLastUpdate
																		.appendChild(document
																				.createTextNode(lastUpdateDate));
																tdApplicationZone
																		.appendChild(document
																				.createTextNode(applicationZone));
																tdReadMore
																		.appendChild(document
																				.createTextNode(name));
																tdReadMore.innerHTML = '<button type="button" style="height: 27px;" class="btn read-more"	data-toggle="modal" data-target="#'+algorithm.id+'">Read more</button>';

																//Append child final
																tr
																		.appendChild(tdName);
																tr
																		.appendChild(tdDescription);
																tr
																		.appendChild(tdAuthor);
																tr
																		.appendChild(tdLastUpdate);
																tr
																		.appendChild(tdApplicationZone);
																tr
																		.appendChild(tdReadMore);

																//We recreate cards

																//We recreate the rows
																document
																		.getElementById(
																				"resultListTableBody")
																		.appendChild(
																				tr);
																$(
																		'#resultListTableBody')
																		.find(
																				'.carMoreInfo')
																		.remove();

																$(
																		".carMoreInfo")
																		.remove();
																divCard = document
																		.createElement("div");
																//setting element classes
																divCard.className = "row";

																var modal = '						<div class="modal fade" id="'+algorithm.id+'" tabindex="-1"'+
								'							role="dialog" aria-labelledby="exampleModalLabel"'+
								'							aria-hidden="true" style="display: none;">'
																		+ '							<div class="modal-dialog modal-dialog-aligement col-md-12"'+
								'								role="document">'
																		+ '								<div class="modal-content">'
																		+ '									<div class="modal-header">'
																		+ '										<h5 class="modal-title" id="exampleModalLabel" style="	height: 42px;width: 398px;	color: #00338D;font-family: NotesEsaReg;font-size: 35px; margin-left: 50px; margin-top: 35px; line-height: 42px;">ALGORITHM'
																		+ '											INFORMATION</h5>'
																		+ '										<button type="button" class="close" data-dismiss="modal"'+
								'											aria-label="Close">'
																		+ '											<span aria-hidden="true">×</span>'
																		+ '										</button>'
																		+ '									</div>'
																		+ '									<div class="modal-body">'
																		+ ''
																		+ '										<div class="card col-md-12" style="border: none;">'
																		+ '											<div class="card-body scrollbar">'
																		+ '													<fieldset class="p-8">'
																		+ '														<legend>GENERAL INFORMATION</legend>'
																		+ '														<div class="row contentFiedlset">'
																		+ '															<div class="col-md-6">'
																		+ '																<h5 class="card-title bold">Name</h5>'
																		+ '																<h6 class="card-subtitle mb-2 text-muted dataTableValue">'
																		+ algorithm.name
																		+ ''
																		+ '																</h6>'
																		+ '															</div>'
																		+ '															<div class="col-md-6">'
																		+ '																<h5 class="card-title bold">Author</h5>'
																		+ '																<h6 class="card-subtitle mb-2 text-muted dataTableValue">Auteur</h6>'
																		+ '															</div>'
																		+ '														</div>'
																		+ '														<div class="row contentFiedlset">'
																		+ '															<div class="col-md-6">'
																		+ '																<h5 class="card-title bold">Last update</h5>'
																		+ '																<h6 class="card-subtitle mb-2 text-muted dataTableValue">'
																		+ algorithm.lastUpdateDate
																		+ '</h6>'
																		+ '															</div>'
																		+ '															<div class="col-md-6">'
																		+ '																<h5 class="card-title bold">Current version</h5>'
																		+ '																<h6 class="card-subtitle mb-2 text-muted dataTableValue">'
																		+ algorithm.currentVersion
																		+ '</h6>'
																		+ '															</div>'
																		+ '														</div>'
																		+ '														<div class="row contentFiedlset">'
																		+ '															<div class="col-md-6">'
																		+ '																<h5 class="card-title bold">Status</h5>'
																		+ '																<h6 class="card-subtitle mb-2 text-muted dataTableValue">'
																		+ algorithm.status
																		+ '</h6>'
																		+ '															</div>'
																		+ '															<div class="col-md-6">'
																		+ '																<h5 class="card-title bold">Privacy</h5>'
																		+ '																<h6 class="card-subtitle mb-2 text-muted dataTableValue">'
																		+ algorithm.privacy
																		+ '</h6>'
																		+ '															</div>'
																		+ '														</div>'
																		+ '														<div class="row contentFiedlset">'
																		+ '															<div class="col-md-6">'
																		+ '																<h5 class="card-title bold">Topic</h5>'
																		+ '																<h6 class="card-subtitle mb-2 text-muted dataTableValue">'
																		+ algorithm.topic
																		+ '</h6>'
																		+ '															</div>'
																		+ '															<div class="col-md-6">'
																		+ '																<h5 class="card-title bold">Project</h5>'
																		+ '																<h6 class="card-subtitle mb-2 text-muted dataTableValue">'
																		+ algorithm.project
																		+ '</h6>'
																		+ '															</div>'
																		+ '														</div>'
																		+ '													</fieldset>'

																		+ '													<fieldset class="p-8">'
																		+ '														<legend>DESCRIPTION</legend>'
																		+ '														<div class="row contentFiedlset">'
																		+ '															<div class="tab-content" id="nav-tabContent">'
																		+ '																'
																		+ algorithm.description
																		+ ''
																		+ '															</div>'
																		+ ''
																		+ '														</div>'
																		+ ''
																		+ '													</fieldset>'

																		+ '													<fieldset class="p-8">'
																		+ '														<legend>PROCESSING</legend>'
																		+ '														<div class="row contentFiedlset">'
																		+ '															<div class="input-group mb-2">'
																		+ '																<div class="input-group-prepend">'
																		+ '																	<div class="input-group-text ">Source code url</div>'
																		+ '																</div>'
																		+ '																<input type="text" class="form-control algo-url"'+
								'																	value="'+algorithm.gitUrlSource+'" id="urlSource'+algorithm.id+''+
								'																	placeholder="Username" readonly>'
																		+ '																 <div class="input-group-prepend">'
																		+ '																	<button id="myTooltip"   class="input-group-text tooltiptext" onmouseout="outFunc()" onclick="copyToclipBoard(\'urlSource'
																		+ algorithm.id
																		+ '\')"><span class="tooltiptext" id="myTooltip"></span>Copy</button>'
																		+ '																 </div>'
																		+ '															</div>'
																		+ '														</div>'
																		+ '														<div class="row contentFiedlset">'
																		+ '															<div class="input-group mb-2">'
																		+ '																<div class="input-group-prepend">'
																		+ '																	<div class="input-group-text">Gitlab Url</div>'
																		+ '																</div>'
																		+ '																<input type="text" class="form-control algo-url"'+
								'																	value="'+algorithm.gitUrl+'" id="urlRepo'+algorithm.id+'"'+
								'																	placeholder="Username" readonly>'
																		+ '																<div class="input-group-prepend">'
																		+ '																	<button class="input-group-text tooltiptext" onmouseout="outFunc()" onclick="copyToclipBoard(\'urlRepo'
																		+ algorithm.id
																		+ '\')"><span class="tooltiptext" id="myTooltip"></span>Copy</button>'
																		+ '																 </div>'
																		+ '															</div>'
																		+ '														</div>'
																		+ '													</fieldset>'

																		+ '													<fieldset class="p-8">'
																		+ '														<legend>DOCUMENTATION & CONFIGURATION</legend>'
																		+ '														<div class="row contentFiedlset">'
																		+ '															<nav>'
																		+ '																<div class="nav nav-tabs" id="nav-tab" role="tablist">'
																		+ '																	<a class="nav-item nav-link active"'+
								'																		id="nav-doc-tab-'+algorithm.id+'" data-toggle="tab"'+
								'																		href="#nav-doc-'+algorithm.id+'" role="tab"'+
								'																		aria-controls="nav-doc-'+algorithm.id+'"'+
								'																		aria-selected="true">Documentation</a> <a'+
								'																		class="nav-item nav-link"'+
								'																		id="nav-conf-tab-'+algorithm.id+'" data-toggle="tab"'+
								'																		href="#nav-conf-'+algorithm.id+'" role="tab"'+
								'																		aria-controls="nav-conf-'+algorithm.id+'"'+
								'																		aria-selected="false">Configuration</a>'
																		+ '																</div>'
																		+ '															</nav>'
																		+ '															<div class="tab-content" id="nav-tabContent">'
																		+ ''
																		+ '																<div class="tab-pane fade p-2 show active"'+
								'																	id="nav-doc-'+algorithm.id+'" role="tabpanel"'+
								'																	aria-labelledby="nav-doc-tab-'+algorithm.id+' "'+
								'																	class="pre-scrollable scrollbar">'
																		+ algorithm.documentation
																		+ '</div>'
																		+ '																<div class="tab-pane p-2  fade" id="nav-conf-'+algorithm.id+'"'+
								'																	role="tabpanel"'+
								'																	aria-labelledby="nav-conf-tab-'+algorithm.id+'"'+
								'																	class="pre-scrollable scrollbar">'
																		+ algorithm.configuration
																		+ '</div>'
																		+ '															</div>'
																		+ ''
																		+ '														</div>'
																		+ ''
																		+ '													</fieldset>'
																		+ '													<fieldset class="p-8">'
																		+ '														<legend>Tags</legend>'
																		+ '														<span class="badge badge-info">'
																		+ algorithm.tags
																		+ '</span>'
																		+ '													</fieldset>'
																		+ ''
																		+ ''
																		+ '											</div>'
																		+ '										</div>'
																		+ ''
																		+ '									</div>'
																		+ '									<div class="modal-footer"></div>'
																		+ '								</div>'
																		+ '							</div>'
																		+ '					</div>';
																console
																		.log(algorithm.id);
																divCard.innerHTML = modal;
																document
																		.getElementById(
																				"algoDatable")
																		.appendChild(
																				divCard);
																//document.getElementById("algoDatable").innerHTML = modal;
																//$( "#algoDatable" ).append( ''+modal+'' );
															}
														},
														failure : function() {
															console
																	.log('failure');
														},
														end : function() {
															console.log("end");
															$(
																	'#resultListTable')
																	.DataTable();
														}
													}

												})
							});

		}

		//Modal for more info about an algo
	</aui:script>
		


	
	<style>
.processingIframes {
	width: 100%;
	height: 100%;
}

#processingFrame {
	width: 100%;
	height: 100%;
}

.devEnv {
	display: none;
}

.devEnvBlock {
	display: block;
}

#tabs {
	display: none;
}

#cheCard {
	border-color: #282E44;
	border-style: solid;
	border-width: medium;
}

#container {
	max-width: 100%;
}

#gitlabCard {
	border-color: #F3CFA2;
	border-style: solid;
	border-width: medium;
}

#jupyterbCard {
	border-color: #F37726;
	border-style: solid;
	border-width: medium;
}

.algo-url {
	font-family: 'NotesEsaReg';
	font-weight: bold;
	color: #008542;
	border-top-color: rgb(0, 51, 141);
	border-bottom-color: rgb(0, 51, 141);
	border-left-color: rgb(0, 51, 141);
	border-bottom-color: rgb(0, 51, 141);
}

.contenu-processing {
	
}

<!--
css of the store side menu -->*, *::before, *::after {
	box-sizing: border-box;
}

#sideMenuFormAlgo {
	min-height: 100%;
}

#sideMenuFormAlgo {
	position: relative;
}

.tree {
	padding: 20px 0;
	line-height: 1;
}

.tree::after {
	content: '';
	display: block;
	clear: left;
}

.tree div {
	clear: left;
}

input[type="checkbox"] {
	color: #5c5d5e;
	text-decoration: none;
	cursor: pointer;
	display: block;
	float: left;
	clear: left;
	position: relative;
	padding: 5px;
	border-radius: 5px;
}

label {
	margin-left: 5px;
}

label::before, a::before {
	display: block;
	position: absolute;
	top: 6px;
	left: -25px;
	font-family: 'NotesEsaReg';
}

input:focus+label, a:focus {
	outline: none;
}

.sub {
	display: none;
	margin-left: 30px;
}

input:checked ~ .sub {
	display: block;
}

input[type="reset"] {
	display: block;
	width: 100%;
	padding: 10px;
	border: none;
	border-radius: 10px;
	color: #e8ebed;
	background-color: #6b7c87;
	font-family: inherit;
	font-size: .9em;
	cursor: pointer;
	-webkit-appearance: none;
	-moz-appearance: none;
}

input[type="reset"]:focus {
	outline: none;
	box-shadow: 0 0 0 4px #b9c3c9;
}

<!--
datatable -->#resultListDiv {
	max-width: 60%;
	overflow: scroll;
	font-family: NotesEsaReg;
	max-height: 60%;
	position: absolute;
	right: 0;
	bottom: 0;
	background-color: white;
	z-index: 150;
	padding: 40px;
	border: 1px solid #0098DB;
	background-color: white;
}

.dataTables_wrapper .dataTables_filter input {
	border: 1px solid #9AA5B8;
	background-color: #FFFFFF;
}

.dtrg-group {
	text-transform: uppercase;
	color: #008542;
	font-weight: bold;
	background-color: #C1C7D3;
}

<!--
store -->.modal-dialog-aligement {
	margin: auto;
}

.text-card-algo {
	border: 0;
	padding-left: 5px;
}

fieldset {
	border-bottom: 1px solid #00338D !important;
	margin: 0;
	margin-bottom: 0px;
	xmin-width: 0;
	padding: 20px;
	padding-left: 20px;
	position: relative;
	background-color: #f5f5f5;
	padding-left: 10px !important;
	margin-bottom: 20px;
}

legend {
	font-size: 14px;
	font-weight: bold;
	margin-bottom: 0px;
	border: 1px solid #ddd;
	border-radius: 4px;
	padding: 5px 5px 5px 10px;
	background-color: #ffffff;
}

.contentFiedlset {
	margin: 20px;
}

.modal-dialog {
	position: relative;
	width: 50%;
}

.modal-open .modal {
	margin: auto;
	overflow-y: scroll;
}

textarea {
	overflow-y: scroll;
	height: 100px;
	resize: none;
	/* Remove this if you want the user to resize the textarea */
}

/* Copy to clipboard */
.tooltip {
	position: relative;
	display: inline-block;
}

.tooltip .tooltiptext {
	visibility: hidden;
	width: 140px;
	background-color: #555;
	color: #fff;
	text-align: center;
	border-radius: 6px;
	padding: 5px;
	position: absolute;
	z-index: 1;
	bottom: 150%;
	left: 50%;
	margin-left: -75px;
	opacity: 0;
	transition: opacity 0.3s;
}

.tooltip .tooltiptext::after {
	content: "";
	position: absolute;
	top: 100%;
	left: 50%;
	margin-left: -5px;
	border-width: 5px;
	border-style: solid;
	border-color: #555 transparent transparent transparent;
}

.tooltip:hover .tooltiptext {
	visibility: visible;
	opacity: 1;
}

#spinner {
	text-align: center;
	display: none;
	width: 70px;
	width: 70px;
	border: 0px solid black;
	position: absolute;
	top: 50%;
	left: 50%;
	padding: 2px;
	z-index: 100;
	filter: blur(1px);
}

.algorithm-store-result {
	height: 28px;
	color: #008542;
	font-family: NotesEsaReg;
	font-size: 24px;
	line-height: 28px;
	margin-top: 30px;
	margin-left: 36px;
}

.backgroud-content-processing {
	
}

#catalogue_frame {
	border: 1px solid #0098DB;
	background-color: #FFFFFF;
	box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.5);
}

.modal-content {
	border: 1px solid #0098DB;
	border-radius: 0px;
	font-family: NotesEsaReg;
	color: #06456B;
}

.dataTableHeader {
	height: 18px;
	color: #06456B;
	width: 145px;
	color: #596E82;
	font-family: NotesEsaReg;
	font-size: 15px;
	font-weight: bold;
	letter-spacing: 0.59px;
	line-height: 18px;
}

.dataTableValues {
	height: 44px;
	color: #06456B;
	font-family: NotesEsaReg;
	font-size: 18px;
	letter-spacing: 0.12px;
	line-height: 22px;
}

.read-more {
	border: 1px solid #008542;
	background-color: #FFFFFF;
	height: 16px;
	width: 125px;
	color: #008542;
	font-family: Roboto;
	font-size: 14px;
	font-weight: bold;
	line-height: 16px;
	text-align: center;
}

.page-item.active .page-link {
	z-index: 1;
	color: #FFFFFF;
	background-color: #008542;
	border-color: #FFFFFF;
}

.btn {
	border-radius: 0px;
}

<!--
Catalogue algorithm -->.modal-title {
	
}

.modal-header {
	border-bottom: none;
}

fieldset {
	background-color: #FFFFFF;
}

:


















none
















;
}
fieldset {
	background-color: #FFFFFF;
}

.card-title {
	font-family: NotesEsaReg;
	font-weight: bold;
	color: #00338D;
}

.card-subtitle {
	font-family: NotesEsaReg;
	color: #00338D !important;
}

.tab-content {
	font-family: NotesEsaReg;
	color: #00338D !important;
}

legend {
	border: 0px solid #ddd;
	font-size: 20px;
	font-weight: bold;
	margin-bottom: 0px;
	border-radius: 4px;
	padding: 5px 5px 5px 10px;
	background-color: #ffffff;
	color: #00338D;
}

.form-control:disabled, .form-control[readonly] {
	background-color: #FFFFFF;
	opacity: 1;
}

.input-group-text {
	color: #00338D;
	background-color: #FFFFFF;
	border: 0.0625rem solid #00338D;
}

.fullscreen {
	background-color: #008542;
}
</style>
</body>