$(document).ready(function(){
    if (location.paramObject.id) {
        $.get('/v1/host/'+location.paramObject.id, function(data){
            fillInForm(data.host, $('.hostForm')[0]);
        });
    }
    $('form.hostForm').submit(function(){
        var param = new Object;
        $.each(this.elements, function(i, e){
            if (e.name) {
                if (e.name == "id" && e.value == "") {
                    // nothing.
                }
                else {
                    param[e.name] = e.value;
                }
            }
        });
        if (isValid(param)) {
            registerHost(param);
        }
        return false;
    });
});

function isValid (param) {
    var required = ['rack', 'unit', 'status'];
    var invalid = 0;
    $.each(required, function(i, k){
        if (param[k] == "") {
            invalid = 1;
        }
    });
    return invalid ? false : true;
}

function registerHost (param) {
    var rack = param.rack;
    var unit = param.unit;
    delete param.rack;
    delete param.unit;
    $.ajax({
        type: "POST",
        url: "/v1/rack/"+ rack + "/" + unit,
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(param),
        error: function(xhr, stat, err) {
            var errorMessage = xhr.responseJSON.message
            alert('Could not register. '+ errorMessage);
        },
        success: function(data) {
            location.href = "/app/rack.html?rack="+ data.host.rack;
        }
    });
}
