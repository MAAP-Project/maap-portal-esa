/*
 * NAVIGATION MAIN MENU
 */

$('#periodSearch').hide();
$('#locationSearch').hide();
$('#dataCategorySearch').hide();

$("li.periodSearch").click(function() {
	$('#periodSearch').css("display", "block");

	$('#periodSearch').show();
	$('#searchMenuList').hide();
	$('#searchButton').hide();
	$('#clearButton').hide();

});
$("li.locationSearch").click(function() {
	$('#locationSearch').css("display", "block");

	$('#locationSearch').show();
	$('#searchMenuList').hide();
	$('#searchButton').hide();
	$('#clearButton').hide();

});

$("li.dataCategorySearch").click(function() {
	$('#dataCategorySearch').css("display", "block");

	$('#dataCategorySearch').show();
	$('#searchMenuList').hide();
	$('#searchButton').hide();
	$('#clearButton').hide();

});

$(".mainMenuBack").click(function() {
	$('#searchMenuList').show();
	$('#searchButton').show();
	$('#clearButton').show();

	$('#dataCategorySearch').hide();
	$('#locationSearch').hide();
	$('#periodSearch').hide();

});



