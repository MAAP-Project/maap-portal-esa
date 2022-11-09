<%@ include file="/init.jsp"%>


<div class="row">

	<div class="algorithm-store-result">ALGORITHM STORE RESULT</div>
	<div id="algoDatable" class="col-md-12 dataTables_wrapper" style="padding: 60px;">
	<div id="badgesDataTable">
	
	</div>
		<div class="loading" id="spinner"></div> 
		<table id="resultListTable" class="table">
			<!-- 			<div id="tagsBadge"> -->
			<!-- 				<span class="badge badge-info">Last published</span> -->
			<!-- 			</div> -->
			<thead>
				<tr>
					<th class="dataTableHeader text-uppercase" scope="col">Name</th>
					<th class="dataTableHeader text-uppercase" scope="col">Description</th>
					<th class="dataTableHeader text-uppercase" scope="col">Author</th>
					<th class="dataTableHeader text-uppercase" scope="col">Last
						Update</th>
					<th class="dataTableHeader text-uppercase" scope="col">Application
						Zone</th>
					<th class="dataTableHeader text-uppercase" scope="col"></th>
				</tr>
			</thead>
			<tbody id="resultListTableBody" class="text-center">
				<c:forEach items="${listAlgo}" var="listAlgo">
					<tr class="dataTableValues">
						<td>${listAlgo.name}</td>
						
						     <c:set var = "doc" value = "${listAlgo.description}"/>
     						 <c:set var = "documentation" value = "${fn:substring(doc, 0, 50)}" />
      
						<td>${documentation}...</td>
						<td>${listAlgo.author.name}</td>
						<td>${listAlgo.lastUpdateDate}</td>
						<td>${listAlgo.applicationZone}</td>
						<td><button type="button" style="height: 27px;" class="btn read-more"
								data-toggle="modal" data-target="#${listAlgo.id}">Read
								more</button></td>
					</tr>
					<div class="row carMoreInfo">
						<div class="modal fade" id="${listAlgo.id}" tabindex="-1"
							role="dialog" aria-labelledby="exampleModalLabel"
							aria-hidden="true" style="display: none;">
							<div class="modal-dialog modal-dialog-aligement col-md-12"
								role="document">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title" id="exampleModalLabel" style="	height: 42px;width: 398px;	color: #00338D;
	font-family: NotesEsaReg;font-size: 35px; margin-left: 50px; margin-top: 35px;	line-height: 42px;">ALGORITHM	INFORMATION</h5>
										<button type="button" class="close" data-dismiss="modal"
											aria-label="Close">
											<span aria-hidden="true">&times;</span>
										</button>
									</div>
									<div class="modal-body">

										<div class="card col-md-12" style="border: none; box-shadow:none;">
											<div class="card-body scrollbar">
													<fieldset class="">
														<legend>GENERAL INFORMATION</legend>
														<div class="row contentFiedlset">
															<div class="col-md-6">
																<h5 class="card-title bold">Name</h5>
																<h6 class="card-subtitle mb-2 text-muted dataTableValue">${listAlgo.name}
																</h6>
															</div>
															<div class="col-md-6">
																<h5 class="card-title bold">Author</h5>
																<h6 class="card-subtitle mb-2 text-muted dataTableValue">${listAlgo.author.name}</h6>
															</div>
														</div>
														<div class="row contentFiedlset">
															<div class="col-md-6">
																<h5 class="card-title bold">Last update</h5>
																<h6 class="card-subtitle mb-2 text-muted dataTableValue">${listAlgo.lastUpdateDate}</h6>
															</div>
															<div class="col-md-6">
																<h5 class="card-title bold">Current version</h5>
																<h6 class="card-subtitle mb-2 text-muted dataTableValue">${listAlgo.currentVersion}</h6>
															</div>
														</div>
														<div class="row contentFiedlset">
															<div class="col-md-6">
																<h5 class="card-title bold">Status</h5>
																<h6 class="card-subtitle mb-2 text-muted dataTableValue">${listAlgo.status}</h6>
															</div>
															<div class="col-md-6">
																<h5 class="card-title bold">Privacy</h5>
																<h6 class="card-subtitle mb-2 text-muted dataTableValue">${listAlgo.privacy}</h6>
															</div>
														</div>
														<div class="row contentFiedlset">
															<div class="col-md-6">
																<h5 class="card-title bold">Topic</h5>
																<h6 class="card-subtitle mb-2 text-muted dataTableValue">${listAlgo.topic}</h6>
															</div>
															<div class="col-md-6">
																<h5 class="card-title bold">Project</h5>
																<h6 class="card-subtitle mb-2 text-muted dataTableValue">${listAlgo.project}</h6>
															</div>
														</div>
												</fieldset>
													
												<fieldset class="">
													<legend>DESCRIPTION</legend>
													<div class="row contentFiedlset">
														<div class="tab-content" id="nav-tabContent">
															${listAlgo.description}</div>
													</div>
												</fieldset>

												<fieldset class="">
														<legend>PROCESSING</legend>
														<div class="row contentFiedlset">
															<div class="input-group mb-2">
																<div class="input-group-prepend">
																	<div class="input-group-text ">Source code url</div>
																</div>
																<input type="text" class="form-control algo-url"
																	value="${listAlgo.gitUrlSource}" id="urlSource${listAlgo.id}"
																	placeholder="Username" readonly>
																 <div class="input-group-prepend">
																	<button id="myTooltip"   class="input-group-text tooltiptext" onmouseout="outFunc('myTooltip${listAlgo.id}')" 
																	onclick="copyToclipBoard('urlSource${listAlgo.id}')">
																	Copy</button>
																 </div>
															</div>
														</div>
														<div class="row contentFiedlset">
															<div class="input-group mb-2">
																<div class="input-group-prepend">
																	<div class="input-group-text">Gitlab Url</div>
																</div>
																<input type="text" class="form-control algo-url"
																	value="${listAlgo.gitUrl}" id="urlRepo${listAlgo.id}"
																	placeholder="Username" readonly>
																<div class="input-group-prepend">
																	<button class="input-group-text tooltiptext" onmouseout="outFunc('myTooltip${listAlgo.id}')" 
																	onclick="copyToclipBoard('urlRepo${listAlgo.id}')">
																	Copy</button>
																 </div>
															</div>
														</div>
													</fieldset>

													<fieldset class="">
														<legend>DOCUMENTATION & CONFIGURATION</legend>
														<div class="row contentFiedlset">
															<nav>
																<div class="nav nav-tabs" id="nav-tab" role="tablist">
																	<a class="nav-item nav-link active"
																		id="nav-doc-tab-${listAlgo.id}" data-toggle="tab"
																		href="#nav-doc-${listAlgo.id}" style="color:#008542;" role="tab"
																		aria-controls="nav-doc-${listAlgo.id}"
																		aria-selected="true" onClick="changeColorTab(1)">Documentation</a> 
																	<a
																		class="nav-item nav-link"
																		id="nav-conf-tab-${listAlgo.id}" style="color:#00338D;" data-toggle="tab"
																		href="#nav-conf-${listAlgo.id}" role="tab"
																		aria-controls="nav-conf-${listAlgo.id}"
																		aria-selected="false" onClick="changeColorTab(2)">Configuration</a>
																</div>
															</nav>
															<div class="tab-content" id="nav-tabContent">

																<div class="tab-pane fade p-2 show active"
																	id="nav-doc-${listAlgo.id}" role="tabpanel"
																	aria-labelledby="nav-doc-tab-${listAlgo.id} "
																	class="pre-scrollable scrollbar">${listAlgo.documentation}</div>
																<div class="tab-pane p-2  fade" id="nav-conf-${listAlgo.id}"
																	role="tabpanel"
																	aria-labelledby="nav-conf-tab-${listAlgo.id}"
																	class="pre-scrollable scrollbar">${listAlgo.configuration}</div>
															</div>

														</div>

													</fieldset>
													<fieldset class=">
														<legend>Tags</legend>
														<span class="badge badge-info">${listAlgo.tags}</span>
													</fieldset>

											</div>
										</div>

									</div>
									<div class="modal-footer"></div>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>

			</tbody>

		</table>
	</div>
	<!-- /.col-lg-9 -->
</div>

