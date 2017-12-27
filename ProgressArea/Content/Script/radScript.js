﻿var graffiti;

window.onbeforeunload = function () {
    Graffiti_CloseEvent.SaveLogout.SaveLogoffInf();

    alert ("Web browser is closed!");
};

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

// CheckAll button as in Excel
// Method 1
var checkedState = false;
graffiti.FilterListBoxLoad = function (sender, args) {
    var checkAllCheckBox = sender.get_checkAllCheckBox();
    var checkAllItem = $(checkAllCheckBox).parents("li").first();
    checkAllItem.on("mousedown", function (event) {
        checkedState = checkAllCheckBox.checked;
    });
}
graffiti.CheckAllChecked = function (sender, args) {
    var allItems = sender.get_items();
    for (var i = 0; i < allItems.get_count(); i++) {
        var item = items.getItem(i);
        item.set_checked(!checkedState && item.get_visible());
    }
    sender.get_checkAllCheckBox().checked = !checkedState;
}

// Method 2
graffiti.OnClientCheckAllChecking = function(sender, args) {
    args.set_cancel(true);
    var target = $telerik.$(args.get_domEvent().target); // get a reference to the element that was targeted by the click event
    var checkAllCheckBox = sender.get_checkAllCheckBox(); // get a reference to the "Check All" checkbox
    var allItems = sender.get_items(); // get all the items from the checklistbox
    var IsCheckAllChecked = false;
    if (target.is("label") && !checkAllCheckBox.checked || target.is(".rlbCheckAllItemsCheckBox") && checkAllCheckBox.checked) { // condition to check whether the target element fo the click event is the "Check All" checkbox input or the label
        IsCheckAllChecked = true;
        allItems.forEach(function (item) {
            item.set_checked(item.get_visible());
            //if ($telerik.$(item.get_element()).is(":visible")) {
            //    item.check();
            //} else {
            //    item.uncheck();
            //}
        });
    } else {
        sender.uncheckItems(allItems); // uncheck all items
    }
    setTimeout(function () { checkAllCheckBox.checked = IsCheckAllChecked; }, 10);
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
