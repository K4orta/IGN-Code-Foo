package com.wong.erik 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Erik Wong
	 */
	public class K4Dialog extends FlxGroup 
	{
		protected var cpm:int;
		protected var prog:Number;
		protected var totalTime:Number;
		protected var step:Number;
		public var finalText:FlxText;
		public var targetText:String;
	
		public var xy:FlxPoint = new FlxPoint(0,0);
		
		public function K4Dialog(ShowText:String, TextSpeed:Number=-1, X:Number=0, Y:Number=0) {
			super();
			
			finalText = new FlxText((FlxG.width * .5) - (ShowText.length * 11 * .5), 0, 110, "");
			finalText.setFormat(null, 8, 0x365821, "left", 0);
			finalText.x = X;
			finalText.y = Y;
			finalText.alignment = "left";
			finalText.scrollFactor.x = finalText.scrollFactor.y = 0;
			add(finalText);
			xy.x = X;
			xy.y = Y;
			targetText = ShowText;
			if (TextSpeed > 0) {
				//hider.reset(TextSpeed*1000);
				
			}
			
		}

		
		public function say(ShowText:String, TextSpeed:Number=-1):void {
			finalText.kill();
			
			finalText = new FlxText((FlxG.width * .5) - (ShowText.length * 11 * .5), 0, 110, "");
			finalText.setFormat(null, 8, 0x365821, "left", 0);
			finalText.scrollFactor.x = finalText.scrollFactor.y = 0;
			add(finalText);
			targetText =ShowText;
			finalText.x = xy.x;
			finalText.y = xy.y;
			if (TextSpeed > 0) {
				
				
			}
		}
		
		override public function update():void {
			super.update();
			if (finalText.text.length < targetText.length) {
				finalText.text += targetText.charAt(finalText.text.length);
			}
			/*if (hider.hasExpired) {
				kill();
			}*/
		}
	}

}