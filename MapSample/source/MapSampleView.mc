using Toybox.WatchUi as Ui;

class MapSampleView extends Ui.View {

    private var mMenuPushed;
    private var mText = "Hello";

    function initialize() {
        View.initialize();
        mMenuPushed = false;
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        if( Ui has :MapView ) {
            if( mMenuPushed == false ) {
                Ui.pushView(new Rez.Menus.MainMenu(), new MapSampleMenuDelegate(), Ui.SLIDE_UP);
                mMenuPushed = true;
            }
            else {
                Ui.popView(Ui.SLIDE_UP);
            }
        }
        else {
            mText = "Cartography not \navailable on \ncurrent Device";
        }
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mText, Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
