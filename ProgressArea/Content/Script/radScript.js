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

graffiti.GridCreated = function (sender, args) {
    graffiti.adjustRTL();
    graffiti.hideRadGridHorizonatlScroll();
    graffiti.SetRadGridHeightFull(sender, args);
}

graffiti.adjustRTL = function() {
    $(".RadGridRTL .rgOptions").each(function (index, value) {
        $(this).parent().prepend(this);
    });
}

graffiti.hideRadGridHorizonatlScroll = function () {
    $(".rgDataDiv").addClass("HorizontalScrollOff");
}

graffiti.SetRadGridHeightFull = function (sender, args) {
    var gridHeight = sender.get_element().clientHeight;

    //var parent = $get("gridItemsContainer");
    var parentHeight = document.body.clientHeight;

    var parentHeight = $(window).height();  // my code
    var gridTop = (sender.TopPagerControl) ? (sender.TopPagerControl).offsetTop : ((sender.GridHeaderDiv) ? sender.GridHeaderDiv.offsetTop : 0);
    parentHeight = parentHeight - (gridTop + 10);

    var scrollArea = sender.GridDataDiv;
    var gridTopPagerHeight = (sender.TopPagerControl) ? sender.TopPagerControl.clientHeight : 0;
    var gridHeaderHeight = (sender.GridHeaderDiv) ? sender.GridHeaderDiv.clientHeight : 0;
    var gridDataHeight = sender.get_masterTableView().get_element().clientHeight;
    var gridFooterHeight = (sender.GridFooterDiv) ? sender.GridFooterDiv.clientHeight : 0;
    var gridPagerHeight = (sender.PagerControl) ? sender.PagerControl.clientHeight : 0;

    var itemHeight = $(".rgDataDiv .rgRow").height();
    var nItemsRequested = sender.get_masterTableView().get_pageSize();
    var nDataRows = sender.get_masterTableView().get_dataItems().length;
    if (nItemsRequested > nDataRows) {
        nItemsRequested = nDataRows;
    }
    var itemHeight = gridDataHeight / nItemsRequested;
    var h = parentHeight - gridHeaderHeight - gridPagerHeight - gridTopPagerHeight - gridFooterHeight - 2;
    var nItems = Math.floor(h / itemHeight);
    if (nItems >= nItemsRequested) {
        sender.get_masterTableView().set_pageSize(nItems);
    }
    scrollArea.style.height = (nItems * itemHeight) + "px";

        //if (gridDataHeight < 350 || parentHeight > (gridDataHeight + gridHeaderHeight + gridPagerHeight + gridTopPagerHeight + gridFooterHeight)) {
        //    scrollArea.style.height = gridDataHeight + "px";
        //} else
        //{
        //    scrollArea.style.height = (parentHeight - gridHeaderHeight - gridPagerHeight - gridTopPagerHeight - gridFooterHeight - 2) + "px"
        //}
    //}
}

graffiti.SetRadGridHeightFull_MY = function (sender, args) {
    var xx = window.innerHeight;
    var xxxx = window.clientHeight;
    var windowHeight = $(window).height();
    var windowScrollTop = $(window).scrollTop();
    var outerHeight = window.outerHeight;
    var zz = $(".rgDataDiv").clientHeight;
    var radGridDataPos = $(".rgDataDiv").position();
    var radGridPos = $(".RadGrid").position();
    var zzxx = $(".rgDataDiv").viewportHeight;
    var itemHeight = $(".rgDataDiv .rgRow").height();

    var nItems = Math.floor((windowHeight - (radGridDataPos.top + radGridPos.top)) / itemHeight);
    //var grid = $find('RadGrid1');
    //var masterTableView = grid.get_masterTableView();
    ////var value = $find('<%= RadNumericTextBox1.ClientID %>').get_value();
    ////if (value != "")
    //{
    //    masterTableView.set_pageSize(nItems);
    //    masterTable.rebind();
    //}

    //var pos = document.body.position();
    var xxx = $(document).height();
    viewportHeight = document.body.clientHeight;
    viewportWidth = document.body.clientWidth;

    $(".rgDataDiv").height(windowHeight - (radGridDataPos.top + radGridPos.top));
}


// CheckAll button as in Excel
// Method 1 - store the "Check All" checkbox checked state in a variable when its clicked
//            (for this we bound the onmousedown event handler to it) 
//            and then set the checked state at a later stage in the application
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

// Method 2 - short delay when making the "Check All" checkbox checked/unchecked
// the reason we applied delay is because at the end of the OnClientCheckAllChecking event, 
// grid has automatically unchecked the checkbox, thus overriding our rule.Having a little delay,
// the "Check All" checkbox state will be overridden shortly after the grid has finished its automatic logic
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
