<div class="row">
	<div class="col-6">
		<p class="navbar-brand text-uppercase visualisationTitle">Results</p>
	</div>
	<div class="col-6 text-right">
		<button type="button" id="resultListCollapseBtn"
			onclick="collapseResultList()"
			class="btn btn-link resultListCollapse">
			<span class="glyphicon glyphicon-remove"></span>
		</button>
	</div>
</div>

<table id="resultListTable" class="display nowrap" cellspacing="0"
	width="100%">

	<thead>

		<tr>
			<th class="dataTableHeader text-uppercase">Preview</th>
			<th class="dataTableHeader text-uppercase">Name</th>
			<th class="dataTableHeader text-uppercase">Collection</th>
			<th class="dataTableHeader text-uppercase">SubRegion</th>
			<th class="dataTableHeader text-uppercase">Scene</th>
			<th class="dataTableHeader text-uppercase">Acquisition Date</th>
			<th class="dataTableHeader text-uppercase">Privacy</th>
			<th class="dataTableHeader text-uppercase">Actions</th>

		</tr>

	</thead>

	<tbody id="resultListTableBody" class="text-center">

	</tbody>
	<tfoot>
		<tr>
			<th class="dataTableHeader text-uppercase">Preview</th>
			<th class="dataTableHeader text-uppercase">Name</th>
			<th class="dataTableHeader text-uppercase">Collection</th>
			<th class="dataTableHeader text-uppercase">SubRegion</th>
			<th class="dataTableHeader text-uppercase">Scene</th>
			<th class="dataTableHeader text-uppercase">Acquisition Date</th>
			<th class="dataTableHeader text-uppercase">Privacy</th>
			<th class="dataTableHeader text-uppercase">Actions</th>
		</tr>
	</tfoot>

</table>



