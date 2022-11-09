<!-- DATA CATEGORY -->
<%@ page import="com.esa.bmap.model.Polarization" %>
<div id="dataCategorySearch">


	<div class="list-group-item text-uppercase mainMenuBack  rounded-0  ">
		<div class="navLinkContainer">


			<span class="btn pull-right glyphicon glyphicon-menu-left"
				aria-hidden="true"></span><span class="mainMenuBackLink">
				Data Category </span>
		</div>
	</div>

	<!-- 	<nav>
						<div class="nav nav-tabs" id="nav-tab" role="tablist">

							<a class="nav-item nav-link btn btn-outline-dark"
								id="nav-profile-tab" data-toggle="tab" href="#nav-profile"
								role="tab" aria-controls="nav-profile" aria-selected="false">Ground
								Campaign</a>

						</div>
					</nav> -->

	<div class="categorySubContainer">
		<span class="categorySubTitleActive text-uppercase">Ground Data</span>
		<br>
		<div class="tab-content" id="nav-tabContent">
			<div class="tab-pane fade show active" id="nav-profile"
				role="tabpanel" aria-labelledby="nav-profile-tab">

				<div class="form-group">
					<label class="inputLabel" for="groundCampaignName">Collection
						(e.g. Ground Campaign name)<small> <i>Required</i></small>
					</label> <input type="text" pattern="^[-_a-zA-Z0-9\\s]*$"
						name="<portlet:namespace/>groundCampaignName"
						class="form-control dataCategoryInputs" id="groundCampaignName"
						placeholder="i.e: afrisar_dlr" onload="getCollectionNames()">
				</div>

				<div class="form-group">
					<label class="inputLabel" for="subregionName">Sub Region</label> <input
						pattern="^[-_a-zA-Z0-9\\s_ ]*$" type="text"
						name="<portlet:namespace/>subRegionName"
						class="form-control dataCategoryInputs" id="subregionName"
						placeholder="i.e: La Lope">
				</div>

				<div class="form-group">
					<label class="inputLabel" for="polarizationType">Polarization</label></br>
					<select id="polarizationType" class="dataCategoryInputs"
						name="<portlet:namespace/>polarizationType">
						<c:set var="enumValues" value="<%=Polarization.values()%>" />

						<!-- <option  selected></option> -->
						<option selected label=" "></option>
						<c:forEach items="${enumValues}" var="enumValue">
							<option value="${enumValue}">${enumValue}</option>
						</c:forEach>
					
					</select>
				</div>
				<div class="form-group">
					<label class="inputLabel" for="sensorMode">Geometry Type</label> </br> <select
						class="dataCategoryInputs" name="<portlet:namespace/>geometryType">
						<!-- <option disabled selected></option> -->
						<option selected label=" "></option>
						<option value="geolocated">geolocated</option>
						<option value="non-geolocated">non-geolocated</option>
					</select>
				</div>
				<div class="form-group">
					<label class="inputLabel" class="control-label" for="productType">Product
						Type</label> <select id="productType" class="dataCategoryInputs"
						name="<portlet:namespace/>productType">
						<!-- <option  selected></option> -->
						<option selected label=" "></option>
						<option value="SLC">SLC</option>
						<option value="DEM">DEM</option>
						<option value="GRD">GRD</option>
						<option value="ROI">ROI</option>
					</select>
				</div>
				<div class="form-group">
					<label class="inputLabel" for="instrumentName">Instrument</label> <input
						pattern="^[a-zA-Z0-9\\s]*$" type="text"
						name="<portlet:namespace/>instrumentName"
						class="form-control dataCategoryInputs" id="instrumentName"
						placeholder="i.e: SAR P-band">
				</div>
				<div class="form-group">
					<label class="inputLabel" for="processingLevel">Processing
						Level</label> <input pattern="^[a-zA-Z0-9\\s]*$" type="text"
						name="<portlet:namespace/>processingLevel"
						class="form-control dataCategoryInputs" id="processingLevel"
						placeholder="i.e: L1">
				</div>
				<%-- 				<div class="form-group">
					<label class="inputLabel" for="heading">Heading</label> <input
						pattern="^[a-zA-Z0-9\\s]*$" type="text"
						name="<portlet:namespace/>heading"
						class="form-control dataCategoryInputs" id="heading"
						placeholder="i.e: 90.0">
				</div> --%>
				
				<div class="text-center">
					<button type="button" onclick='registerDataCategory()'
						name="searchGroundData" class="btn applyButtons  rounded-0">Apply</button>
				</div>

			</div>
			<!-- <div class="tab-pane fade" id="nav-contact" role="tabpanel"
		aria-labelledby="nav-contact-tab">...</div> -->
		</div>
	</div>

</div>
<style>
* {
  box-sizing: border-box;
}

body {
  font: 16px Arial;  
}

/*the container must be positioned relative:*/
.autocomplete {
  position: relative;
  display: inline-block;
}

input {
  border: 1px solid transparent;
  background-color: #f1f1f1;
  padding: 10px;
  font-size: 16px;
}

input[type=text] {
  background-color: #f1f1f1;
  width: 100%;
}

input[type=submit] {
  background-color: DodgerBlue;
  color: #fff;
  cursor: pointer;
}

.autocomplete-items {
  position: absolute;
  border: 1px solid #d4d4d4;
  border-bottom: none;
  border-top: none;
  z-index: 99;
  /*position the autocomplete items to be the same width as the container:*/
  top: 100%;
  left: 0;
  right: 0;
}

.autocomplete-items div {
  padding: 10px;
  cursor: pointer;
  background-color: #fff; 
  border-bottom: 1px solid #d4d4d4; 
}

/*when hovering an item:*/
.autocomplete-items div:hover {
  background-color: #e9e9e9; 
}

/*when navigating through the items using the arrow keys:*/
.autocomplete-active {
  background-color: DodgerBlue !important; 
  color: #ffffff; 
}

</style>