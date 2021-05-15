//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application;

class StringView extends WatchUi.View {

    var common;
    var language;
    var greeting;
    var food;
    var drink;
    var commonLabel;
    var languageLabel;
    var greetingLabel;
    var foodLabel;
    var drinkLabel;

    var font = Graphics.FONT_SMALL;
    var lineSpacing = Graphics.getFontHeight(font);
    var centerY = 60; // Default taken from previous hard coded values

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        common = WatchUi.loadResource( Rez.Strings.common );
        language = WatchUi.loadResource( Rez.Strings.language );
        greeting = WatchUi.loadResource( Rez.Strings.greeting );
        food = WatchUi.loadResource( Rez.Strings.food );
        drink = WatchUi.loadResource( Rez.Strings.drink);
        commonLabel = WatchUi.loadResource( Rez.Strings.common_label );
        languageLabel = WatchUi.loadResource( Rez.Strings.language_label );
        greetingLabel = WatchUi.loadResource( Rez.Strings.greeting_label );
        foodLabel = WatchUi.loadResource( Rez.Strings.food_label );
        drinkLabel = WatchUi.loadResource( Rez.Strings.drink_label );

        centerY = (dc.getHeight() / 2) - (lineSpacing / 2);
    }

    function onUpdate(dc) {
        dc.setColor( Graphics.COLOR_BLACK, Graphics.COLOR_BLACK );
        dc.clear();
        dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );

        dc.drawText( 85, centerY - (2 * lineSpacing), font, commonLabel,   Graphics.TEXT_JUSTIFY_RIGHT );
        dc.drawText( 85, centerY - (1 * lineSpacing), font, languageLabel, Graphics.TEXT_JUSTIFY_RIGHT );
        dc.drawText( 85, centerY,                     font, greetingLabel, Graphics.TEXT_JUSTIFY_RIGHT );
        dc.drawText( 85, centerY + (1 * lineSpacing), font, foodLabel,     Graphics.TEXT_JUSTIFY_RIGHT );
        dc.drawText( 85, centerY + (2 * lineSpacing), font, drinkLabel,    Graphics.TEXT_JUSTIFY_RIGHT );

        dc.drawText( 95, centerY - (2 * lineSpacing), font, common,   Graphics.TEXT_JUSTIFY_LEFT );
        dc.drawText( 95, centerY - (1 * lineSpacing), font, language, Graphics.TEXT_JUSTIFY_LEFT );
        dc.drawText( 95, centerY,                     font, greeting, Graphics.TEXT_JUSTIFY_LEFT );
        dc.drawText( 95, centerY + (1 * lineSpacing), font, food,     Graphics.TEXT_JUSTIFY_LEFT );
        dc.drawText( 95, centerY + (2 * lineSpacing), font, drink,    Graphics.TEXT_JUSTIFY_LEFT );
    }

}

//! Watch Face Page class
class StringApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        return [ new StringView() ];
    }
}
