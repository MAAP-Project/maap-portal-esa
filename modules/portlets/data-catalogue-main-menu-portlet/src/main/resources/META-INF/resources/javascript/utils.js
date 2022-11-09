/**
 * UTILS SCRIPT 
 */



/**
 * COOKIES MANAGEMENT
 */




/**
 * Get a Cookie value by its name
 * 
 * @param cname
 * @returns
 */
function getCookie(cname) {
	var name = cname + "=";
	var decodedCookie = decodeURIComponent(document.cookie);
	var ca = decodedCookie.split(';');
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ') {
			c = c.substring(1);
		}
		if (c.indexOf(name) == 0) {
			return c.substring(name.length, c.length);
		}
	}
	return "";
}

/**
 * set a Cookie in browser
 * 
 * @param name
 * @param value
 * @param days
 * @returns
 */
function setCookie(name, value, days) {
	var expires = "";
	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		expires = "; expires=" + date.toUTCString();
	}
	document.cookie = name + "=" + (value || "") + expires + "; path=/";
}



/**
 * Clear cookie by cookie name
 * 
 * @returns
 */
function eraseCookie(name) {
	document.cookie = name + '=; Max-Age=-99999999;';
}


/**
 * END OF COOKIES MANAGEMENT
 */




/**
 * Copy a given string to clipboard
 * 
 * @param str
 * @returns
 */
function copyStringToClipboard(str) {
	// Create new element
	var el = document.createElement('textarea');
	// Set value (string to be copied)
	el.value = str;
	// Set non-editable to avoid focus and move outside of view
	el.setAttribute('readonly', '');
	el.style = {
		position : 'absolute',
		left : '-9999px'
	};
	document.body.appendChild(el);
	// Select text inside element
	el.select();
	// Copy text to clipboard
	document.execCommand('copy');
	// Remove temporary element
	document.body.removeChild(el);

}


/**
 * Generate a random String
 * 
 * @returns
 */
function generateString() {
	var text = "";
	var char_list = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	for (var i = 0; i < 20; i++) {
		text += char_list.charAt(Math.floor(Math.random()
				* char_list.length));
	}
	return text;
}

/**
 * insert a node element after a referenceNode
 * @param el
 * @param referenceNode
 * @returns
 */
function insertAfter(el, referenceNode) {
    referenceNode.parentNode.insertBefore(el, referenceNode.nextSibling);
}