var graffiti;

if (!graffiti) {
    graffiti = {};
    if (!graffiti.RadContextMenu) {
        graffiti.RadContextMenu = {};
    }
}

$(function () {
    graffiti.init();
});

graffiti.init = function () {
}

graffiti.adjustRTL = function() {
    $(".RadGridRTL .rgOptions").each(function (index, value) {
        $(this).parent().prepend(this);
    });
}

var controlIDs = [];
var gridCol;
//var customWidthClassName = '';

graffiti.RadContextMenu.SetCustomWidth = function (sender, width) {
    var container = $("#" + sender.get_id() + "_detached");

    container.addClass('CustomFilterWidth');
    container.css("width", width);
    //customWidthClassName = 'CustomFilterWidth_' + width;
    //container.addClass(customWidthClassName);
}

graffiti.RadContextMenu.OnMenuShowing = function (sender, args) {
    gridCol = args.get_gridColumn();
}

graffiti.RadContextMenu.OnMenuShown = function (sender, args) {
    var container = $("#" + sender.get_id() + "_detached");

    container.find(".rgHCMAnd").hide();
    if (!gridCol._data.FilterCheckListEnableLoadOnDemand) {
        container.find(".rgHCMShow").show();
    }
    else {
        container.find(".rgHCMShow").hide();
    }
}

graffiti.RadContextMenu.OnMenuHiding = function (sender, args) {
    var container = $("#" + sender.get_id() + "_detached");

    $(controlIDs).each(function (i, ID) {
        $find(ID).set_visible(true);
    });
    controlIDs = [];

    container.removeClass('CustomFilterWidth');
    //container.addClass(customWidthClassName);
    //customWidthClassName = '';
}

graffiti.RadContextMenu.Hide = function (sender, condName) {
    var container = $("#" + sender.get_id() + "_detached");
    var names = ["CMB", "TB", "DP", "NTB"];

    for (var i = 0; i < names.length; i++) {
        var pos = condName;
        var control = $telerik.findControl(container[0], "HCFMR" + names[i] + pos);
        if (control && control.get_visible()) {
            var condition = condName == "SecondCond" ? false : !gridCol._data.FilterCheckListEnableLoadOnDemand;
            control.set_visible(condition);

            if (!condition) {
                controlIDs.push(control.get_id());
            }
        }
    }
}
