<%@ include file="/init.jsp"%>

<div class="bg-faded">
	<div class="container">
		<div class="row">
			<div class="col-4 column">

				<h1>Explore</h1>
				<ul class="list-group list-group-flush">
					<li class="list-group-item bg-inverse text-white"><form
							action="${formRedirect}" method="post">
							<button type="submit" class="btn btn-secondary pull-left">
								<span class="glyphicon glyphicon-chevron-left"
									aria-hidden="true"></span>
							</button>
							<h2>Processed Data</h2>
							<input name="<portlet:namespace/>redirectURL" value="view"
								type="hidden" />

						</form></li>
				</ul>
				<br>
				<button type="button" class="btn btn-dark btn-lg btn-block">Apply</button>
			</div>
			<div class="col-8 column">
				<div id="searchmap"></div>
			</div>
		</div>

	</div>
</div>