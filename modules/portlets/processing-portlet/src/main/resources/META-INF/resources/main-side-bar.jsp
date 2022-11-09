<%@ include file="/init.jsp"%>

<!-- The main side bar when the user is in the main page of the algorithm catalogue -->
<div class="col-md-3" id="mainSideBarCatalogueAlgo">






	<div id="accordion">
		<div class="card card-main-menu">
			<!-- <div class="card-header" id="headingOne">
				<h5 class="mb-0">
					<button class="btn btn-link2 procesing-tools-text"
						data-toggle="collapse" data-target="#collapseOne"
						aria-expanded="true" aria-controls="collapseOne">

						<div class="row">
							<div class="col-md-2" style="float: left;">
								<img style="width: 100%;" class="card-img-top"
									src="<%=request.getContextPath()%>/media/menu.png"
									alt="Card image cap">
							</div>
							<p class="col-md-8"
								style="text-align: center; margin: auto; font-size: larger;">PROCESSING
								TOOLS</p>
							<div class="col-md-2">
								<img id="processingArrow" style="width: 100%;"
									class="card-img-top"
									src="<%=request.getContextPath()%>/media/down-arrow.png"
									alt="Card image cap">
							</div>
						</div>
					</button>
				</h5>
			</div>

			 <div id="collapseOne" class="collapse show"
				aria-labelledby="headingOne" data-parent="#accordion">
				<div class="card-body">
					<div class="col-md">
						<c:if
							test="${ROLE == 'Administrator' || ROLE == 'Algorithm Developer'}">
							<div class="row processing-cots">
								<img class="card-img-top img-cots"
									style="max-width: 50%; flex: 0 0 auto;"
									src="<%=request.getContextPath()%>/media/eclipse-che.png"
									alt="Card image cap">
								<button onclick="showHide('Che')"
									style="height: auto; margin: auto; max-width: 50%; flex: 0 0 auto;"
									class="btn read-more col-md-6">Use Eclipse</button>
							</div>
						</c:if>

						<div class="row processing-cots">
							<img class="card-img-top img-cots"
								style="max-width: 50%; flex: 0 0 auto;"
								src="<%=request.getContextPath()%>/media/logo_copa.png"
								alt="Card image cap">
							<button onclick="showHide('Copa')"
								style="height: auto; margin: auto; max-width: 50%; flex: 0 0 auto;"
								class=" col-md-6 btn read-more">Use Orchestrator</button>
						</div>
						<c:if
							test="${ROLE == 'Administrator' || ROLE == 'Algorithm Developer'}">
							<div class="row">
								<img class="card-img-top  img-cots"
									style="max-width: 50%; flex: 0 0 auto;"
									src="<%=request.getContextPath()%>/media/gitlab.png"
									alt="Card image cap">
								<button onclick="showHide('Gitlab')"
									style="height: auto; margin: auto; max-width: 50%; flex: 0 0 auto;"
									class=" col-md-6 btn read-more">Use Gitlab</button>
							</div>
						</c:if>

					</div>


				</div>
			</div>  -->
		</div>
		<div class="card card-main-menu">
			<div class="card-header card-header-store" id="headingTwo">

				<h5 class="mb-0">
					<button class="btn btn-link2 collapsed algorithm-store-text"
						data-toggle="collapse" data-target="#collapseTwo"
						aria-expanded="false" aria-controls="collapseTwo"
						onclick="showHide('catalogue')">
						<div class="row">
							<p class="col-md-10"
								style="text-align: center; margin: auto; font-size: larger;">ALGORITHM
								STORE</p>
							<div class="col-md-2">
								<img id="catalogueArrow" style="width: 100%;"
									class="card-img-top"
									src="<%=request.getContextPath()%>/media/up-arrow.png"
									alt="Card image cap">
							</div>
						</div>
					</button>
				</h5>
			</div>
			<div id="collapseTwo" class="collapse show" aria-labelledby="headingTwo"
				data-parent="#accordion">
				<div class="card-body">
					<div class="lastTopic">
						<!-- last published algorithm -->
						<input id="lastPublished" type="checkbox" class="topic"
							onclick="reinitList();" checked> <label>LAST
							PUBLISHED</label>
					</div>
					<div class="topicAndProjects">
						<!--The div tag before the form-->
						<div class="tree form-group">

							<c:forEach items="${lisTopicProject}" var="entry">
								<div>
									<input  id="${entry.key}" type="checkbox" value="${entry.key}"
										class="topic" onclick="checkChildren(this);searchAlgo();"> <label
										value="${entry.key}" for="${entry.key}">${entry.key}</label>
									<c:forEach items="${entry.value}" var="item" varStatus="loop">
										<div class="sub">
											<input id="${item}" type="checkbox" data-topic="${entry.key}"
												value="${entry.key}/${item}" class="topic"
												onclick="checkMainTopic(this);searchAlgo();"> <label
												value="${entry.key}/${item}" for="${item}">${item}</label>
										</div>
									</c:forEach>
								</div>
								<br>
							</c:forEach>
						</div>
						<h1 class="search-by">Search by</h1>
						<input id="inputTag" class="form-control mb-3"
							style="border: 1px solid #9AA5B8; background-color: #FFFFFF;"
							type="text" placeholder="tags, author, etc">
						<button class="btn mb-3 form-control"
							style="margin: auto; border: 1px solid #008542; font-family: Roboto; background-color: #FFFFFF; color: #008542; font-family: Roboto; font-weight: bold;"
							type="reset" onclick="searchAlgo();">Search</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>



<script>
	//When we collapse, we activate the positions of the arrow
	jQuery('#collapseTwo').collapse('show');

	jQuery('#collapseOne')
			.on(
					'show.bs.collapse',
					function() {

						jQuery('#processingArrow')
								.attr('src',
										"${pageContext.request.contextPath}/media/up-arrow.png");
						jQuery('#catalogueArrow')
								.attr('src',
										"${pageContext.request.contextPath}/media/down-arrow.png");
					})

	jQuery('#collapseTwo')
			.on(
					'show.bs.collapse',
					function() {

						jQuery('#processingArrow')
								.attr('src',
										"${pageContext.request.contextPath}/media/down-arrow.png");
						jQuery('#catalogueArrow')
								.attr('src',
										"${pageContext.request.contextPath}/media/up-arrow.png");

					})
</script>
<style>
#accordion {
	border: 1px solid #0098DB;;
}

.btnUser {
	
}

.search-by {
	height: 16px;
	width: 205px;
	color: #546E84;
	font-family: Arial;
	font-size: 14px;
	line-height: 16px;
}

.card-header:first-child {
	border-radius: 0;
}

col-md-6-menu {
	max-width: 50%;
	flex: 0 0 auto;
}

.img-cots {
	height: 25%;
	width: 25%;
}

.topicAndProjects {
	color: #22597E;
	font-family: NotesEsaReg;
	font-size: 18px;
	font-weight: bold;
	line-height: 22px;
}

.lastTopic {
	border-bottom: 1px solid #596E82;
	height: 32px;
	color: #22597E;
	font-family: NotesEsaReg;
	font-size: 18px;
	font-weight: bold;
	line-height: 22px;
}

.btn-link2:hover {
	color: #FFFFFF;
	text-decoration: none;
}

.btn-link2 {
	background-color: transparent;
}

.rowAlign {
	align-items: center;
	justify-content: center;
}

.procesing-tools-text {
	color: #FFFFFF;
	font-family: NotesEsaReg;
	font-weight: bold;
}

.card-main-menu {
	margin-bottom: 0;
	border: 0;
}

.card-header {
	background-color: #596E82;
}

.card-header-store {
	background-color: #008542;
}

.algorithm-store-text {
	color: #FFFFFF;
	font-family: NotesEsaReg;
	font-weight: bold;
	font-size: large;
}

.processing-cots {
	margin-bottom: 10px;
	border-bottom: 1px solid #C1C7D3;
}
</style>