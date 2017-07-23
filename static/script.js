$(document).ready(function() {
	$(".dropdown > .bar-entry-link").click(function() {
		$(this).next().toggle();
	});
});
