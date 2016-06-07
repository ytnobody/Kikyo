$(document).ready(function () {
    $(".rackname").text(location.paramObject.rack);
    getRack($(".rack"), location.paramObject.rack);
});

function rackOverview (unitID, row) {
    if (row != null) {
        return $(
            '<tr class="unit" id="unit:'+ unitID +'">'+
              '<td class="unitID">'+unitID+'</td>'+
              '<td class="item name"><a href="/app/search.html?name='+row.name+'">'+row.name+'</a></td>'+
              '<td class="item ip">'+row.ip+'</td>'+
            '</tr>'
        );
    } else {
        return $('<tr class="unit" id="unit:'+ unitID +'"><td class="unitID">'+unitID+'</td><td class="name">-</td><td class="ip">-</td></tr>');
    }
}

function getRack (elem, rackname) {
    elem.html("<tr><th>UnitID</th><th>Name</th><th>IP</th></tr>");
    $.get("/v1/rack/"+rackname, function(data){
        $.each(data.rows, function(i, val) {
            elem.append(rackOverview(42-i, val));
        });
    });
}
