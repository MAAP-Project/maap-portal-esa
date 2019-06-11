<!-- PERIOD  -->
<div id="periodSearch">

	<div class="list-group-item text-uppercase mainMenuBack  rounded-0  ">
		<div class="navLinkContainer">


			<span class="btn pull-right glyphicon glyphicon-menu-left"
				aria-hidden="true"></span><span class="mainMenuBackLink">
				Period</span>
		</div>
	</div>


	<div class="categorySubContainer">
		<label class="inputLabel" for="startDateAcquisition">Start
			Date: </label>
		<div class="input-group">

			<div class="input-group-prepend">
				<div class="input-group-text">

					<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>

				</div>
			</div>
			<input type="date" class="form-control periodInput"
				name="<portlet:namespace/>startDateAcquisition"
				id="startDateAcquisition"><br>

		</div>
		<small>e.g. 07/08/2015</small> <br>
		<br>
		<label class="inputLabel" for="endDateAcquisition">End Date: </label>
		<div class="input-group">

			<div class="input-group-prepend">
				<div class="input-group-text">

					<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>

				</div>
			</div>
			<input type="date" class="form-control periodInput"
				name="<portlet:namespace/>endDateAcquisition"
				id="endDateAcquisition"><br>
		</div>
		<small>e.g. 01/01/2019</small> <br> <br>

		<div class="text-center">
			<button type="button" onclick='registerPeriod()'
				name="searchGroundData" class="btn applyButtons rounded-0">Apply</button>
		</div>
	</div>

</div>