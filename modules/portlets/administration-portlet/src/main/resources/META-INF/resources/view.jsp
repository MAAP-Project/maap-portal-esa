<%@ include file="/init.jsp"%>

<portlet:actionURL name="deleteAlgoAction" var="deleteAlgo" />
<portlet:actionURL name="addAlgoAction" var="addAlgo" />

<div class="container">
		<h1 style="font-family: 'NotesEsaReg';">Administration Dashboard</h1>
		<h3 style="font-family: 'NotesEsaReg';">
			Here you will find forms to manage the algorithms store. You can add
			or remove an algorithm.
			</h3>

	<liferay-ui:success key="success" message="${sucessMessage}" />
	<liferay-ui:error key="error" message="${errorMessage}" />


	<div class="row">
		<!-- First column with the form to add an algorithm -->
		<div class="col background-admin-algo">
			<div>
				<div class="form-area" id="divFormAdd">
					<form role="form" id="formAddAlgoId" method="post"
						action="<%=addAlgo%>">
						<br style="clear: both">
						<h3 style="margin-bottom: 25px; text-align: center;">Add new
							Algorithm</h3>
						<div class="form-group">
							<input class="form-control" name="<portlet:namespace/>algoSourceUrl2" id="algoSourceUrl2Id" label=""
								placeholder="HTTPS git source code url" type="text"
								required="true">
								<validator name="required" />
							</input>
						</div>
						<div class="form-group">
							<input name="<portlet:namespace/>dockerImageUrl" class="form-control" id="dockerImageUrl" label=""
								placeholder="Docker image url" type="text" required="true">
								
							</input>
						</div>
						<div class="form-group">
							<select name="<portlet:namespace/>author" class="form-control" label="" required="true">
								<option value="" selected="true" disabled="true">Author</option>
								<c:forEach items="${users}" var="user">
									<option value="${user.userId}">${user.firstName} ${user.lastName}</option>
								</c:forEach>
							</select>
						</div>
						<div class="form-group">
							<input name="<portlet:namespace/>applicationZone" class="form-control" id="applicationZone" label=""
								type="text" placeholder="Application zones">
							</input>
						</div>
						<div class="form-group">
							<input name="<portlet:namespace/>averageTime" class="form-control" id="averageTime" label=""
								type="text" placeholder="Execution average time">
							</input>
						</div>
						<div class="form-group">
							<input name="<portlet:namespace/>currentVer" class="form-control" id="currentVer" label="" type="text"
								placeholder="Current version">
							</input>
						</div>
						<div class="form-group">
							<button type="submit" id="submit" 
								 name="submit"
								class="btn btn-primary center-block" >Add algorithm</button>
						</div>
						
					</form>
				</div>
			</div>

		</div>
		<div class="col">

			<div class="col background-admin-algo">
				<div>
					<div class="form-area">
						<form role="form" method="post" action="<%=deleteAlgo%>">
							<br style="clear: both">
							<h3 style="margin-bottom: 25px; text-align: center;">Delete
								an Algorithm</h3>
							<div class="form-group">
								<input type="text" class="form-control" id="algoSourceUrl"
									name="<portlet:namespace/>algoSourceUrl"
									placeholder="HTTPS git source code url" required>
							</div>
							<div class="form-group">
								<button type="submit" id="submit" name="submit"
									class="btn btn-primary center-block">Delete algorithm</button>
							</div>
						</form>
					</div>
				</div>
			</div>
					<%
						String urlGluu= System.getenv("ESA_GLUU_REGISTER_URL");
					%>

			<div class="col background-admin-algo">
				<div>
					<div class="form-area">
						<h3 style="margin-bottom: 25px; text-align: center;">Create a
							new user on Gluu</h3>
							<div class="form-group">
								<aui:button-row>
									<aui:button type="submit" value="Create a
							new user" onclick="window.location.href='https://gluu.biomass-maap.com/identity/home'" />
								</aui:button-row>
							</div>

					</div>
				</div>
			</div>
		</div>

	</div>
</div>



<style>
.background-admin-algo {
	margin: auto;
	box-shadow: 0 1px 1px 0 rgba(0, 0, 0, 0.17), 0 3px 10px 0
		rgba(11, 0, 0, 0.2);
	border-radius: 5px;
	margin-top: 30px;
	text-align: left;
	font-family: 'NotesEsaReg';
	text-decoration: none;
	color: black;
	padding: 50px 50px 50px 50px;
	margin: 50px auto;
	border: 1px solid #0098DB;
	
}

.btn-primary  {
	border: 1px solid #979797;
	background-color: #008542;
	color: white;
}
</style>
<script>
	//We reset the form value
jQuery( window ).load(function() {
  
	document.getElementById("formAddAlgoId").form.reset();
});

</script>


