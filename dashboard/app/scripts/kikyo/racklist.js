$(document).ready(function () {
    getRacklist($(".racklist"));
});

function rackOverview (row) {
    return $('<tr class="rackOverview" id="rack:' + row.rack + '"><td class="item rack"><a href="rack.html?rack='+row.rack+'">'+row.rack+'</a></td><td class="rackHosts">'+row.hosts+'</td></tr>');
}

function getRacklist (elem) {
    elem.html("<tr><th>Name</th><th>Number of Hosts</th></tr>");
    $.get("/v1/racklist", function(data){
        $.each(data.rows, function() {
            elem.append(rackOverview(this));
        });
    });
}
