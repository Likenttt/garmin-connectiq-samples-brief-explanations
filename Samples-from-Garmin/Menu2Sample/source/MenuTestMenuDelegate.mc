//
// Copyright 2018 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

// This is the menu input delegate for the main menu of the application
class Menu2TestMenu2Delegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if( item.getId().equals("toggle") ) {
            // When the toggle menu item is selected, push a new menu that demonstrates
            // left and right toggles with automatic substring toggles.
            var toggleMenu = new WatchUi.Menu2({:title=>"Toggles"});
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Item 1", {:enabled=>"Left Toggle: on", :disabled=>"Left Toggle: off"}, "left", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Item 2", {:enabled=>"Right Toggle: on", :disabled=>"Right Toggle: off"}, "right", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            toggleMenu.addItem(new WatchUi.ToggleMenuItem("Item 3", {:enabled=>"Toggle: on", :disabled=>"Toggle: off"}, "default", true, null));
            WatchUi.pushView(toggleMenu, new Menu2SampleSubMenuDelegate(), WatchUi.SLIDE_UP );
        } else if ( item.getId().equals("check") ) {
            // When the check menu item is selected, push a new menu that demonstrates
            // left and right checkbox menu items
            var checkMenu = new WatchUi.CheckboxMenu({:title=>"Checkboxes"});
            checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 1", "Left Check", "left", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 2", "Right Check", "right", false, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            checkMenu.addItem(new WatchUi.CheckboxMenuItem("Item 3", "Check", "default", true, null));
            WatchUi.pushView(checkMenu, new Menu2SampleSubMenuDelegate(), WatchUi.SLIDE_UP );
        } else if( item.getId().equals("icon") ) {
            // When the icon menu item is selected, push a new menu that demonstrates
            // left and right custom icon menus
            var iconMenu = new WatchUi.Menu2({:title=>"Icons"});
            var drawable1 = new CustomIcon();
            var drawable2 = new CustomIcon();
            var drawable3 = new CustomIcon();
            iconMenu.addItem(new WatchUi.IconMenuItem("Icon 1", drawable1.getString(), "left", drawable1, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
            iconMenu.addItem(new WatchUi.IconMenuItem("Icon 2", drawable2.getString(), "right", drawable2, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
            iconMenu.addItem(new WatchUi.IconMenuItem("Icon 3", drawable3.getString(), "default", drawable3, null));
            WatchUi.pushView(iconMenu, new Menu2SampleSubMenuDelegate(), WatchUi.SLIDE_UP );
        } else if( item.getId().equals("custom") ) {
            // When the custom menu item is selected, push a new menu that demonstrates
            // custom menus
            var customMenu = new WatchUi.Menu2({:title=>"Custom Menus"});
            customMenu.addItem(new WatchUi.MenuItem("Basic Drawables", null, :basic, null));
            customMenu.addItem(new WatchUi.MenuItem("Images", null, :images, null));
            customMenu.addItem(new WatchUi.MenuItem("Wrap Out", null, :wrap, null));
            WatchUi.pushView(customMenu, new Menu2SampleCustomDelegate(), WatchUi.SLIDE_UP );
        } else {
            WatchUi.requestUpdate();
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SampleSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        // For IconMenuItems, we will change to the next icon state.
        // This demonstates a custom toggle operation using icons.
        // Static icons can also be used in this layout.
        if(item instanceof IconMenuItem) {
            item.setSubLabel(item.getIcon().nextState());
        }
        WatchUi.requestUpdate();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

    function onDone() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

//This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SampleCustomDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var id = item.getId();

        // Create/push the custom menus
        if(id == :basic) {
            pushBasicCustom();
        } else if(id == :images) {
            pushImagesCustom();
        } else if(id == :wrap) {
            pushWrapCustom();
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}


// This is the custom Icon drawable. It fills the icon space with a color to
// to demonstrate its extents. It changes color each time the next state is
// triggered, which is done when the item is selected in this application.
class CustomIcon extends WatchUi.Drawable {
    // This constant data stores the color state list.
    const mColors = [Graphics.COLOR_RED, Graphics.COLOR_ORANGE, Graphics.COLOR_YELLOW, Graphics.COLOR_GREEN, Graphics.COLOR_BLUE, Graphics.COLOR_PURPLE];
    const mColorStrings = ["Red", "Orange", "Yellow", "Green", "Blue", "Violet"];
    var mIndex;

    function initialize() {
        Drawable.initialize({});
        mIndex = 0;
    }

    // Advance to the next color state for the drawable
    function nextState() {
        mIndex++;
        if(mIndex >= mColors.size()) {
            mIndex = 0;
        }

        return mColorStrings[mIndex];
    }

    // Return the color string for the menu to use as it's sublabel
    function getString() {
        return mColorStrings[mIndex];
    }

    // Set the color for the current state and use dc.clear() to fill
    // the drawable area with that color
    function draw(dc) {
        var color = mColors[mIndex];
        dc.setColor(color, color);
        dc.clear();
    }
}
