jQuery.validator.addMethod(
    "dateUS",
    function (value, element) {
        var check = false;
        var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
        if (re.test(value)) {
            var adata = value.split('/');
            var mm = parseInt(adata[0], 10);
            var dd = parseInt(adata[1], 10);
            var yyyy = parseInt(adata[2], 10);
            var xdata = new Date(yyyy, mm - 1, dd);
            if ((xdata.getFullYear() == yyyy) && (xdata.getMonth() == mm - 1) && (xdata.getDate() == dd))
                check = true;
            else
                check = false;
        } else
            check = false;
        return this.optional(element) || check;
    },
    "Please enter a date in the format mm/dd/yyyy"
);

jQuery.validator.addMethod(
    "extension",
    function (value, element, param) {
        param = typeof param === "string" ? param.replace(/,/g, '|') : "png|jpe?g|gif";
        return this.optional(element) || value.match(new RegExp(".(" + param + ")$", "i"));
    },
    jQuery.format("Please enter a value with a valid extension.")
);

jQuery.validator.addMethod(
    "daterange",
    function (value, element) {
        if (this.optional(element)) {
            return true;
        }
        var startDate = Date.parse('1753-01-01'),
        endDate = Date.parse('9999-12-31'),
        enteredDate = Date.parse(value);

        if (isNaN(enteredDate)) return false;

        return ((startDate <= enteredDate) && (enteredDate <= endDate));

    },
    "Date is out of range"
);