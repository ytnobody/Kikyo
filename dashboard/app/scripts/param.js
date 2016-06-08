$(document).ready(function(){
    setParam();
});

function setParam () {
    var arg = new Object;
    var pair=location.search.substring(1).split('&');
    for(var i=0;pair[i];i++) {
        var kv = pair[i].split('=');
        arg[kv[0]]=kv[1];
    }
    location.paramObject = arg;
};

function fillInForm (params, elem) {
    $.each(params, function(k, v){
        if (elem[k]) {
            elem[k].value = v;
        }
    });
}
