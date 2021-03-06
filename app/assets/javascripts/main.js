var sessionStorageManager = {
	LoginFailedTimes: "LoginFailedTimes",
	AlertEmailExisted: "AlertEmailExisted"
};

var isMobile = {
    Android: function () {
        return navigator.userAgent.match(/Android/i) ? true : false;
    },
    BlackBerry: function () {
        return navigator.userAgent.match(/BlackBerry/i) ? true : false;
    },
    iOS: function () {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i) ? true : false;
    },
    Windows: function () {
        return navigator.userAgent.match(/IEMobile/i) ? true : false;
    },
    Any: function () {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Windows());
    },
    AndroidOrIOS: function () {
        return (isMobile.Android() || isMobile.iOS());
    }
};

(function ($) {
	
	$.extend({

		valid_email: function (email) {
	        var patten = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i);
	        return patten.test(email);
	    },
		is_in_frame: function (email) {
		    try {
		        return window.self !== window.top;
		    } catch (e) {
		        return true;
		    }
		},
		show_error: function (message) {
			$("#divErrorMessage").html(message);
		    $("#divErrorMessage").show();
		},
		hide_error: function () {
		    $("#divErrorMessage").hide();
		},
		show_loading: function (message) {
		    $(".loading").show();
		},
		hide_loading: function () {
		    $(".loading").hide();
		},
		validate_number: function (number) {
			var regex = "^[0-9]+$";
			
			var patten = new RegExp(regex);
			return patten.test(number);
		}
	});
	
})(jQuery)