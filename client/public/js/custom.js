$(document).bind( "mobileinit", function(){
    $.mobile.listview.prototype.options.filterPlaceholder = "Search...";
    $.mobile.allowCrossDomainPages = true; //Doubt this works but just for kicks
});