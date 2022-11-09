<%@ include file="/init.jsp"%>

<!-- The main side bar when the user is in the main page of the algorithm catalogue -->
<div class="col-lg-3 border-right" id="mainSideBarCatalogueAlgo">

	<h1 class="my-4 text-center ">Algorithm Store</h1>
	<!-- Button to go to the page to search an algorithm -->
	<div class="mb-3">
		<button type="button"
			class="btn btn-block btn-dark text-center text-white center-block">Search
			algorithms</button>
	</div>

	<div class="card-header border .bg-secondary">Last published</div>
	<div class="card-header border .bg-secondary">Topic</div>
	<div class="list-group">
		<a href="${myActionVar}" class="list-group-item pl-5 border-bottom">Radar</a> <a
			href="#" class="list-group-item pl-5 border-bottom">Lidar</a>
	</div>

	<portlet:actionURL name="redirectionFromSideMenu"
		var="sampleActionMethodURL">
			nom de de l'url
		</portlet:actionURL>



	<portlet:actionURL name="redirectionFromSideMenu" var="myActionVar">
		<portlet:param name="myParam" value="${currentElement.id}"></portlet:param>
	</portlet:actionURL>



<!-- tu n'as qu'à utiliser les paramèters GET -->
<!-- ton actionURL génère par exemple ceci : http://localhost:8080/my-portlet?action=myaction&menu=RADAR -->
<!-- dans ta méthode render, tu fais request.getParameter('menu') 
dans ton href tu concatènes l'actionURL et tu fais un append &menu=RADAR-->
	<!-- Button to go to the page to submit an algorithm -->

	<form action="${formRedirect}" method="post">
		<input name="<portlet:namespace/>redirectURL" value="formSubmitAlgo"
			type="hidden" />
		<button type="submit"
			class="btn btn-block btn-dark text-center text-white center-block">Submit
			your algorithm</button>
	</form>

</div>