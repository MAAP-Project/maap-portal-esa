<%@ include file="/init.jsp"%>





<ul class="nav nav-tabs" id="myTab" role="tablist">
	<li onClick='catalogueToggle()' class="nav-item"><a class="nav-link active"
		id="dataCatalogueWrapper-tab" data-toggle="tab"
		href="#dataCatalogueWrapper" role="tab"
		aria-controls="dataCatalogueWrapper" aria-selected="true">Catalogue</a></li>
	<li class="nav-item"><a class="nav-link" id="workspace-tab"
		data-toggle="tab" href="#workspaceTab" role="tab"
		aria-controls="workspaceTab" aria-selected="false">Workspace <span
			id="countLayersNav" class="badge badge-success pull-right rounded-0">
				0</span></a></li>
</ul>
<div class="tab-content" id="myTabContent">

	<div class="loading" id="spinner"></div>
	<div class="tab-pane fade show active" id="dataCatalogueWrapper"
		role="tabpanel" aria-labelledby="dataCatalogueWrapper-tab">
		<!-- overlaySearchMenu -->

		<div id="menu">
			<div id="overlay">



				<div id="searchMenu" class="list-group">
					<a style="text-decoration: none; color: white;"
						href="javascript:void(0)" class="closebtn" onclick="closeNav()">
						<div class="list-group-item subMenuContainer subMenu rounded-0">
							<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
							<span class="mb-0 text-uppercase subMenuTitle">Explore</span>
						</div>
					</a>


					<div id="collapseOne">
						<div id="searchMenuList">

							<ul class="list-group">
								<li
									class="list-group-item text-uppercase navItemData dataCategorySearch rounded-0">
									<div class="navLinkContainer">
										<span id="dataCategoryLink" class="navItemLink"> Data
											Category </span> <span id="category-menu-right"
											class="btn pull-right glyphicon glyphicon-menu-right category-menu-right"
											aria-hidden="true"></span>
									</div>
								</li>
								<li
									class="list-group-item text-uppercase navItemData locationSearch rounded-0">
									<div class="navLinkContainer">
										<span id="locationLink" class="navItemLink"> Location </span>
										<span id="location-menu-right"
											class="btn pull-right glyphicon glyphicon-menu-right location-menu-right"
											aria-hidden="true"></span>
									</div>

								</li>
								<li
									class="list-group-item text-uppercase navItemData periodSearch rounded-0">
									<div class="navLinkContainer">
										<span id="periodLink" class="navItemLink"> Period </span> <span
											id="period-menu-right"
											class="btn pull-right glyphicon glyphicon-menu-right "
											aria-hidden="true"></span>
									</div>
								</li>



							</ul>
						</div>



						<form name="searchForm" id="searchForm" method="post">
							<!-- LOCATION  -->
							<%@include file="locationForm.jsp"%>

							<!-- /LOCATION  -->

							<div id="locationInputsHidden"></div>

							<!-- PERIOD -->
							<%@include file="periodForm.jsp"%>
							<!-- /PERIOD -->


							<!-- DATACATEGORY -->
							<%@include file="dataCategoryForm.jsp"%>
							<!-- /DATACATEGORY -->


							<div id="searchButton">
								<div class="text-center">
									<button id="searchButton" type="button"
										class="btn rounded-0 navSearchButton">
										<!-- onclick="getresultList();" -->
										<span class="navSearchButtonText text-uppercase">
											Search</span>
									</button>
								</div>
							</div>
							<br>
							<div id="clearButton">

								<div class="text-center">
									<button type="button" onclick="clearForm()"
										class="btn rounded-0 navSearchButton">
										<span class="navSearchButtonText text-uppercase">Clear
											Search</span>
									</button>
									



									<!-- <button type="button" class="btn btn-secondary"
										data-toggle="modal" data-target="#modalTest">Read more</button> -->
								</div>

							</div>
						</form>
					</div>
				</div>




			</div>

			<!-- MAP -->
			<div id="mouseLocation"></div>
			<div id="searchmap"></div>
			<!-- / MAP -->

			<!-- RESULT LIST -->
			<div class="d-none" id="resultListDiv">
				<%@ include file="resultList.jsp"%>
			</div>
			<!-- / RESULT LIST -->
		</div>

	</div>

	<!-- VISUALISATION WORKSPACE -->

	<div class="tab-pane fade " id="workspaceTab" role="tabpanel"
		aria-labelledby="workspace-tab">
		<%@ include file="layerlist.jsp"%>

		<div class="row dragContainer dropper" id="visualisationWorkspace"></div>

	</div>

	<!-- /VISUALISATION WORKSPACE -->

</div>





