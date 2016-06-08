$(document).ready(function(){
    if (Object.keys(location.paramObject).length > 0) {
        searchHost(location.paramObject, $('.result'));
        fillInForm(location.paramObject, $('.hostSearchForm')[0]);
    }
});

function hostOverview (row) {
    var isVirtual = row.virtual_id > 0 ? '<span class="label label-success">Virtual</span>' : '';
    return $(
        '<tr class="hostOverview">'+
          '<td class="item name"><a href="/app/input.html?id='+row.id+'">'+row.name + isVirtual+'</a></td>'+
          '<td class="item rack">'+row.rack+' / '+row.unit+' / '+row.size+'</td>'+
          '<td class="item hwid">'+row.hwid+'</td>'+
          '<td class="item status">'+row.status+'</td>'+
          '<td class="item ip">'+row.ip+'</td>'+
        '</tr>'
    );
}

function searchHost (cond, elem) {
    elem.html('<tr><th>Name</th><th>Rack / Unit / Size</th><th>HWID</th><th>Status</th><th>IP</th></tr>');
    $.get('/v1/search', cond, function(data) {
        $.each(data.rows, function(i, val){
            elem.append(hostOverview(val));
        });
    });
}

