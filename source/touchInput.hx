// made by Matheus Silver
package;

import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxG;

class TouchInput
{
	public static var prevTouched:Int = 1;

	public static function touch(thing:Dynamic, thingID:Int):String
	{
		var touchOrder:String = '';

		for (touch in FlxG.touches.list){
			if (touch.overlaps(thing) && touch.justPressed && prevTouched == thingID)
				touchOrder = 'second';
			else if (touch.overlaps(thing) && touch.justPressed){
				prevTouched = thingID;
				touchOrder = 'first';
			}
		}
		return touchOrder;
	}

	public static function simpleTouch(thing:Dynamic):Bool
	{
		for (touch in FlxG.touches.list){
			if (touch.overlaps(thing) && touch.justPressed)
				return true;
		}
		return false;
	}
}