<%@ include file="/init.jsp"%>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

<div id="carouselControls" class="carousel slide" data-ride="carousel">
	<div class="carousel-inner">
		<div class="carousel-item active">
			<img class="d-block w-100"
				src="<%=request.getContextPath()%>/media/HP-image.jpg"
				alt="First slide">
			<div class="carousel-caption d-none d-md-block textBlock">
				<p class="imgTitle">Welcome</p>
				<h1 class="imgText">Welcome to the ESA <br/>MAAP !</h1>
				<button type="button" class="btn btnColor"
					onclick="lightbox_open();">Start the video</button>
			</div>
		</div>
		<div class="carousel-item">
			<img class="d-block w-100"
				src="<%=request.getContextPath()%>/media/img1.jpg"
				alt="Second slide">
			<div class="carousel-caption d-none d-md-block textBlock">
				<p class="imgTitle">Process and visualise</p>
				<h1 class="imgText">Process and visualise Biomass data.</h1>
				<button type="button" class="btn btnColor" onclick="lightbox_open();">Start the video</button>
			</div>
		</div>
		<div class="carousel-item">
			<img class="d-block w-100"
				src="<%=request.getContextPath()%>/media/img3.jpg"
				alt="Third slide">
			<div class="carousel-caption d-none d-md-block textBlock">
				<p class="imgTitle">Share and Collaborate</p>
				<h1 class="imgText">Share and collaborate on projects with scientists </h1>
				<button type="button" class="btn btnColor" onclick="lightbox_open();">Start the video</button>
			</div>
		</div>
	</div>
	<a class="carousel-control-prev" href="#carouselExampleIndicators"
		role="button" data-slide="prev"> <span
		class="carousel-control-prev-icon" aria-hidden="true"></span> <span
		class="sr-only">Previous</span>
	</a> <a class="carousel-control-next" href="#carouselExampleIndicators"
		role="button" data-slide="next"> <span
		class="carousel-control-next-icon" aria-hidden="true"></span> <span
		class="sr-only">Next</span>
	</a>
</div>
<!-- html5 video -->
<div id="light" onClick="lightbox_close();">
	<video id="VisaChipCardVideo" controls>
		<source
			src="<%=request.getContextPath()%>/media/airbus-defence-and-space-to-build-biomass-the-european-space-agencys-forest-mission.mp4"
			type="video/mp4">
		<!--Browser does not support <video> tag -->
	</video>
</div>
<div id="fade" onClick="lightbox_close();"></div>

<style>
.portlet-content {
	margin: 0;
	padding: 0;
}

#column-1 {
	padding-left: 0;
	padding-right: 0;
}

.imgTitle {
	text-decoration: underline;
	height: 27px;
	font-family: 'NotesEsaReg';
	font-weight: normal;
	font-size: 22px;
	text-align: left;
}

.carousel-item {
  height: 550px;
}

.textBlock {
    height: auto;
    margin: 0 auto;
}

.btnColor {
	float: left;
	height: 74px;
	width: 444px;
	border: 1px solid #979797;
	background-color: #008542;
	font-family: 'NotesEsaReg';
	font-weight: bold;
	color: #FFFFFF;
	font-size: 36px;
	text-align: left;
	padding-left: 25px;
}

.imgText {
	width: 920px;
	height: 184px;
	font-family: 'NotesEsaReg';
	font-weight: bold;
	text-align: left;
	font-size: 80px;
}


#fade {
	display: none;
	position: fixed;
	top: 0%;
	left: 0%;
	width: 100%;
	height: 100%;
	background-color: black;
	z-index: 1001;
	-moz-opacity: 0.8;
	opacity: .80;
	filter: alpha(opacity = 80);
}

#VisaChipCardVideo {
	
	top: 50%;
	transform: translateY(-50%);
	width: 90%;
	margin: auto;
	display: block;
}

#light {
	display: none;
	position: absolute;
	max-width: auto;
	max-height: auto;
	background: transparent;
	z-index: 1002;
	overflow: visible;
	margin: auto;
	top: 100%;
	left: 0%;
	width: 100%;
	height: 100%;
}

#boxclose {
	float: right;
	cursor: pointer;
	color: #fff;
	border: 1px solid #AEAEAE;
	border-radius: 3px;
	background: #222222;
	font-size: 31px;
	font-weight: bold;
	display: inline-block;
	line-height: 0px;
	padding: 11px 3px;
	position: absolute;
	right: 2px;
	top: 2px;
	z-index: 1002;
	opacity: 0.9;
}

.boxclose:before {
	content: "×";
}

#fade:hover ~ #boxclose {
	display: none;
}
</style>

<script>
	window.document.onkeydown = function(e) {
		if (!e) {
			e = event;
		}
		if (e.keyCode == 27) {
			lightbox_close();
		}
	}

	function lightbox_open() {
		var lightBoxVideo = document.getElementById("VisaChipCardVideo");
		window.scrollTo(0, 0);
		document.getElementById('light').style.display = 'block';
		document.getElementById('fade').style.display = 'block';
		lightBoxVideo.play();
	}

	function lightbox_close() {
		var lightBoxVideo = document.getElementById("VisaChipCardVideo");
		document.getElementById('light').style.display = 'none';
		document.getElementById('fade').style.display = 'none';
		lightBoxVideo.pause();
	}

	//Caroussel next and previous
	$('a[data-slide="prev"]').click(function() {
		$('#carouselControls').carousel('prev');
	});

	$('a[data-slide="next"]').click(function() {
		$('#carouselControls').carousel('next');
	});
</script>