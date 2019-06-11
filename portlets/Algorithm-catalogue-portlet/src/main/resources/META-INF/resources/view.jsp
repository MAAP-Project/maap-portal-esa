<%@ include file="/init.jsp"%>

<body>

	<!-- Page Content -->
	<div class="container">

		<div class="row">

			<!-- We include the page of the main side bar -->
			<%@ include file="/main-side-bar.jsp"%>


			<div class="col-lg">

				<div class="row mb-4">
					<div class="col-sm-1">
						<button type="button" class="btn btn-dark" data-toggle="collapse" data-target="#mainSideBarCatalogueAlgo" aria-expanded="true" aria-controls="mainSideBarCatalogueAlgo">X</button>
					</div>
					<div class="col-sm-4">XX Results for : Last published</div>
				</div>
				
				<%
					for (int i = 0; i < 10; i++) {
				%>
				<div class="card border-dark mb-3">
					<table class="table text-dark card-header">
						<thead>
							<tr>
								<th scope="col">Title</th>
								<th scope="col">Description</th>
								<th scope="col">Author</th>
								<th scope="col">Last Update</th>
								<th scope="col">Application zone</th>
								<th scope="col">Language</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>Seb Algo</td>
								<td>Ceci est un test</td>
								<td>Sebastien Nouvellon</td>
								<td>03/10/2018</td>
								<td>France</td>
								<td>Python</td>
							</tr>
						</tbody>
					</table>

				</div>
				<%
					}
				%>
			</div>
			<!-- /.col-lg-9 -->

		</div>
		<!-- /.row -->

	</div>
	<!-- /.container -->

<script type="text/javascript">
  var app = angular.module('MyApp', [])
app.controller('MyController', function($scope) {
  //This will hide the DIV by default.
  $scope.IsVisible = true;
  $scope.ShowHide = function() {
    //If DIV is visible it will be hidden and vice versa.
    $scope.IsVisible = !$scope.IsVisible;
  }
});

</script>
</body>