<%@ include file="/init.jsp"%>

<!-- The main side bar when the user is in the main page of the algorithm catalogue -->
<div class="col-md-2 border-right" id="mainSideBarCatalogueAlgo">

	<h2 class="my-4 text-center">Algorithm Store</h2>

	<div class="card-header border .bg-secondary">Topic</div>
	<div class="border container">
		<!--The div tag before the form-->
		<div id="sideMenuFormAlgo">
			<div class="tree form-group">
			<input id="lastPublished" type="checkbox" 
							class="topic" onclick="reinitList();"> <label>Last published</label>
				<c:forEach items="${lisTopicProject}" var="entry">
					<div>
						<input id="${entry.key}" type="checkbox" value="${entry.key}"
							class="topic" onclick="searchAlgo();"> <label
							value="${entry.key}" for="${entry.key}">${entry.key}</label>
						<c:forEach items="${entry.value}" var="item" varStatus="loop">
							<div class="sub">
								<input id="${item}" type="checkbox" value="${entry.key}/${item}"
									class="topic" onclick="searchAlgo();"> <label
									value="${entry.key}/${item}" for="${item}">${item}</label>
							</div>
						</c:forEach>
					</div>
					<br>
				</c:forEach>
			</div>
			<input id="inputTag" class="form-control mb-3" type="text"
				placeholder="tags, author, etc">
			<!-- 				<div class="form-group"> -->
			<!-- 					<button class="btn btn-secondary" type="reset">Collapse -->
			<!-- 						All</button> -->
			
			<button class="btn mb-3 form-control btn-secondary" style="margin: auto;"
				type="reset" onclick="searchAlgo();">Search</button>
	</div>
</div>
</div>
