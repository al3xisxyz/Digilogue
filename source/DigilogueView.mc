using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Math as Math;
using Toybox.Time.Gregorian as Calendar;

class DigilogueView extends Ui.WatchFace {

    private var isAwake;
    private var fontLT;
    private var fontS;
    private var icons;
    
    function initialize() {
        WatchFace.initialize();
    	isAwake = true;
    }

    // Load your resources here
    function onLayout(dc) {
    	fontS = Ui.loadResource(Rez.Fonts.id_font_CaviarDreams);
    	fontLT = Ui.loadResource(Rez.Fonts.id_font_CaviarDreams_LThin);
    	icons = Ui.loadResource(Rez.Fonts.id_font_icons);
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	var clockTime = Sys.getClockTime();
    	var radius = dc.getWidth() / 2;
		
		var date = Calendar.info(Time.now(), Time.FORMAT_LONG);    	
    	var battery = Sys.getSystemStats().battery;
 		var batteryStr = Lang.format("$1$%", [battery.format("%02d")]);
		var hourStr = Lang.format("$1$", [date.hour]); //[info.hour.format("%02d")]
		
		var timeMin = clockTime.min;
     	var timeSec = clockTime.sec;
     	var lengthMin = radius / 1.5;
     	var lengthSec = radius / 1.5;
     	var widthMin = radius / 22;
     	var widthSec = radius / 40;
     	var colorMin = App.getApp().getProperty("MinHandColor");
     	var colorSec = App.getApp().getProperty("SecHandColor");
    	
    	var marks5r1 = radius -15;
    	var marks5r2 = radius;
    	var marks5thick = 0.02;
    	var marks5comp = 12*Math.PI/6;
    	var marks5add = Math.PI/6;
    	var marks1r1 = radius -10;
    	var marks1r2 = radius;
    	var marks1thick = 0.003;
    	var marks1comp = 13*Math.PI/6;
    	var marks1add = Math.PI/30;
 
  		// Clear the screen--------------------------------------------
        dc.setColor(Gfx.COLOR_TRANSPARENT, App.getApp().getProperty("BackgroundColor"));
        dc.clear();

		dc.setColor(App.getApp().getProperty("ForegroundColor"), Gfx.COLOR_TRANSPARENT);

    	// Draw Battery --------------------------------------
 		dc.drawText(radius, radius/2, fontS, batteryStr, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER); 

     	// Draw the date -----------------------------------------
        var dateStr = Lang.format("$1$, $2$ $3$", [date.day_of_week, date.month, date.day]);
   		dc.drawText(radius, radius*1.5, fontS, dateStr, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);    
     	
 		//Draw digital hour ---------------------------------
		dc.drawText(radius, radius, fontLT, hourStr, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
		
		//Draw Bluetooth icon if phone is not connected ---------------------------------
		if (Sys.getDeviceSettings().phoneConnected==false) {
			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
			dc.drawText(radius*1.5, radius, icons, "b", Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
		}
		
		// Draw the hash marks ---------------------------------
    	if (isAwake) {
        	drawMarks(dc, radius, marks1r1, marks1r2, marks1thick, marks1comp, marks1add);
        }
 		drawMarks(dc,radius, marks5r1, marks5r2, marks5thick, marks5comp, marks5add);
    	
 		// Draw hands ------------------------------------------------------------------ 
     	drawHand(dc, radius, timeMin, lengthMin, widthMin, colorMin);
        if (isAwake) {
        	drawHand(dc, radius, timeSec, lengthSec, widthSec, colorSec);
        }
    }
	
    function onHide() {
    }

    function onExitSleep() {
    	isAwake = true;
    }

    function onEnterSleep() {
    	isAwake = false;
    	Ui.requestUpdate;
    }

    function drawMarks(dc,radius, r1, r2, thick, markcomp, markadd) {
        var marks;
        dc.setColor(App.getApp().getProperty("HashmarksColor"), Gfx.COLOR_TRANSPARENT);
        
        for (var i = Math.PI/6; i <= markcomp; i += markadd) {
			marks =	[[radius+r1*Math.sin(i-thick),radius-r1*Math.cos(i-thick)],
					[radius+r2*Math.sin(i-thick),radius-r2*Math.cos(i-thick)],
					[radius+r2*Math.sin(i+thick),radius-r2*Math.cos(i+thick)],
					[radius+r1*Math.sin(i+thick),radius-r1*Math.cos(i+thick)]];

			dc.fillPolygon(marks);
		}
	}
        
	function drawHand(dc,radius, time, length, penwidth, color) {
        var angle = Math.PI/30 * time - Math.PI/2;
        var xPos = radius + length * Math.cos(angle) ;
        var yPos = radius + length * Math.sin(angle) ;
        var endX = radius + 1.55*length * Math.cos(angle) ;
        var endY = radius + 1.55*length * Math.sin(angle) ;       
        dc.setColor(color,Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(penwidth);
        dc.drawLine(xPos, yPos, endX, endY);
    }

}
