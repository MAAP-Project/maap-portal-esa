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
						<button type="button" class="btn btn-dark" data-toggle="collapse"
							data-target="#mainSideBarCatalogueAlgo" aria-expanded="true"
							aria-controls="mainSideBarCatalogueAlgo">X</button>
					</div>
					<div class="col-sm-10"
						style="text-align: center;"><h3>Algorithm Officialisation form</h3></div>
				</div>

				<form role="form">
					<br style="clear: both">


					<div class="form-group">
						<input type="text" class="form-control" id="algorithmContributer"
							name="algorithmContributer" placeholder="Contributer name"
							required>
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="algorithmName"
							name="algorithmName" placeholder="Algorithm name" required>
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="geographicalnZone"
							name="applicationZone" placeholder="Geographical zone">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="averageTime"
							name="averageTime" placeholder="Average Time">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="currentVer"
							name="currentVer" placeholder="Current version" required>
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="gitUrl" name="gitUrl"
							placeholder="Git url" required>
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="privacy"
							name="privacy" placeholder="Privacy" required>
					</div>
					<div class="form-group">
						<input type="text" class="form-control" id="statusEnum"
							name="statusEnum" placeholder="Language" required>
					</div>
					<div class="form-group">
						<button type="button" id="submit" name="submit"
							class="btn btn-dark center-block">Submit Form</button>
					</div>
				</form>
			</div>
			<!-- /.col-lg-9 -->

		</div>
		<!-- /.row -->

	</div>
	<!-- /.container -->

</body>