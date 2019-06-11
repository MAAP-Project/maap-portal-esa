<%@ include file="/init.jsp"%>

<div class="container">
	<div class="col-md-5">
		<div class="form-area">
			<form role="form">
				<br style="clear: both">
				<h3 style="margin-bottom: 25px; text-align: center;">Algorithm Officilisation
					form</h3>

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
						name="applicationZone" placeholder="Geographical zone" >
				</div>
				<div class="form-group">
					<input type="text" class="form-control" id="averageTime"
						name="averageTime" placeholder="Average Time" >
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
					<input type="text" class="form-control" id="privacy" name="privacy"
						placeholder="Privacy" required>
				</div>
				<div class="form-group">
					<input type="text" class="form-control" id="statusEnum"
						name="statusEnum" placeholder="Privacy" required>
				</div>
				<div class="form-group">
					<button type="button" id="submit" name="submit"
						class="btn btn-primary center-block">Submit Form</button>
				</div>
			</form>
		</div>
	</div>
</div>