<!-- LOCATION  -->
<div id="locationSearch">
	<div class="list-group-item text-uppercase mainMenuBack  rounded-0">
		<div class="navLinkContainer">


			<span class="btn pull-right glyphicon glyphicon-menu-left"
				aria-hidden="true"></span><span class="mainMenuBackLink">
				Location </span>
		</div>
	</div>



	<div class="categorySubContainer">

		<span class="categorySubTitleActive text-uppercase">Coordinates</span>


		<div id="coordinates">
		
			<div style="margin: auto;" class="row">

				<button type="button"
					class="btn rounded-0 locationButtons col-lg-12 col-sm-12" id="addCustomPoints">Add
					coordinates</button>


				<button type="button"
					class="btn rounded-0 locationButtons col-lg-12 col-sm-12" id="drawBoundingBox">Draw
					on Map</button>
			</div>


			<br>
			<div id="customPoints">
				<div class="form-group">
					<label class="inputLabel" for="latInput">Longitude</label> <input
						type="number" class="form-control locationInputs rounded-0"
						id="latInput" step=".01" placeholder="0.01" required>

				</div>
				<div class="form-group">

					<label class="inputLabel" for="lonInput">Latitude</label> <input
						type="number" class="form-control locationInputs rounded-0"
						id="lonInput" step=".01" placeholder="0.01" required>

				</div>
				<small>A minimum of 4 Coordinates have to be filled</small>
				<div class="alert alert-danger alert-dismissible fade show"
					aria-label="Close" id="latLongNoMatch" role="alert"
					style="display: none;">
					Latitude and Longitude shall be completed
					<button type="button" class="close" data-dismiss="alert"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>


				<div class="text-center">
					<button type="button" id="addBtnLocation" name="addbtn" value="Add"
						class="btn rounded-0 locationButtons">+ Add</button>
				</div>
			</div>


			<hr>

			<div id="coordinatesListDiv">
				<span id="selectedCoordinates">Selected coordinates:</span>

				<ol id="coordinatesList">
				</ol>
			</div>


			<div>
				<button id="deleteCoordinates" type="button"
					class="btn btn-outline-dark rounded-0">Reset</button>
			</div>
		</div>

		<br>
		<div class="text-center">
			<button type="button" onclick="registerLocation()"
				class="btn applyButtons  rounded-0">Apply</button>
		</div>
	</div>
</div>
<!-- /LOCATION  -->