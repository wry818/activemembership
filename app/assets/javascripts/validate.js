$( document ).ready(function() {
	
    //*********************************************************************************************************
    //      CHECKOUT FORM
    //*********************************************************************************************************
    $("#checkout_form").validate({
        // validate the previously selected element when the user clicks out
        onfocusout: function(element) {
            $(element).valid();
        },
        highlight: function(element) {
            $(element).closest('.field').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.field').removeClass('has-error');
        },
		errorPlacement: function(error, element) {
		     if (element.attr("type") == "checkbox")
		       error.appendTo(element.parent());
		     else
		       error.insertAfter(element);
		},
        // validation rules
        rules: {
			"checkout[email]": { required: true },
			"checkout[first_name]": { required: true },
			"checkout[last_name]": { required: true },
			"checkout[address]": { required: true },
			"checkout[city]": { required: true },
			"checkout[state]": { required: true },
			"checkout[email]": { required: true },
			"checkout[zipcode]": { required: true, zipcode: true},
			"checkout[phone]": { required: true }
        }

    });
	
    //*********************************************************************************************************
    //      SECURE FORM
    //*********************************************************************************************************
    $("#edit_checkout_form").validate({
        // validate the previously selected element when the user clicks out
        onfocusout: function(element) {
            $(element).valid();
        },
        highlight: function(element) {
            $(element).closest('.field').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.field').removeClass('has-error');
        },
		errorPlacement: function(error, element) {
		     if (element.attr("type") == "checkbox")
		       error.appendTo(element.parent());
		     else
		       error.insertAfter(element);
		},
        // validation rules
        rules: {
			"checkout[credit_card][number]": { required: true, minlength: 12, creditcard: true },
			"checkout[credit_card][name]": { required: true},
			"checkout[credit_card][verification_value]": { required: true, number: true, minlength: 3, maxlength: 4 },
			"checkout[email]": { required: true },
			"checkout[first_name]": { required: true },
			"checkout[last_name]": { required: true },
			"checkout[address]": { required: true },
			"checkout[city]": { required: true },
			"checkout[state]": { required: true },
			"checkout[email]": { required: true },
			"checkout[zipcode]": { required: true, zipcode: true},
			"checkout[phone]": { required: true }
        },
        messages: {
			
            "checkout[credit_card][number]": {
              minlength: "format is not valid",
              creditcard: "format is not valid"
            },
            "checkout[credit_card][verification_value]": {
              number: "is not valid",
              minlength: "is not valid",
              maxlength: "is not valid"
            }
			
          // "checkout[credit_card][name]": {
//             required: "first name can't be blank and last name can't be blank"
//           }
        }

    });
    
});
