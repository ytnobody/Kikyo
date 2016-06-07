$(document).ready(function(){
    if (Object.keys(location.paramObject).length > 0) {
        searchHost(location.paramObject, $('.result'));
        fillInForm(location.paramObject, $('.hostSearchForm'));
    }
});

function hostOverview (row) {
    return $(
        '<tr class="hostOverview">'+
          '<td class="item name">'+row.name+'</td>'+
          '<td class="item rack">'+row.rack+' / '+row.unit+' / '+row.size+'</td>'+
          '<td class="item hwid">'+row.hwid+'</td>'+
          '<td class="item ip">'+row.ip+'</td>'+
        '</tr>'
    );
}

function searchHost (cond, elem) {
    elem.html('<tr><th>Name</th><th>Rack / Unit / Size</th><th>HWID</th><th>IP</th></tr>');
    $.get('/v1/search', cond, function(data) {
        $.each(data.rows, function(i, val){
            elem.append(hostOverview(val));
        });
    });
}

function fillInForm (params, elem) {
    $.each(params, function(k, v){
        elem.find('input[name='+k+']').val(v);
    });
}
