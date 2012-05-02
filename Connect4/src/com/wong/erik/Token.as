package com.wong.erik 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Erik
	 */
	public class Token extends FlxSprite {
		[Embed(source = "data/tokens.png")] protected var ImgToken:Class;
		public var lifeTime:uint;
		public var gridX:uint;
		public var gridY:uint;
		public var exploding:Boolean=false;
		public function Token(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) {
			super(X, Y, SimpleGraphic);
			loadGraphic(ImgToken, true, false, 32, 32);
			addAnimation("Black",[0]);
			addAnimation("White", [1]);
			addAnimation("Win",[2]);
			// Gravity
			acceleration.y = 400;
			elasticity = .3;
			
			lifeTime = 4 * FlxG.framerate;
		}
		
		// Main Loop
		override public function update():void {
			super.update();
			
			if (!immovable) {
				if (!exploding && lifeTime < 1 || (isTouching(DOWN) && FlxU.abs(velocity.y)<2)) {
					acceleration.y = 0;
					immovable = true;
					velocity.y = 0;
					elasticity = 0;
					// if anything weird happens with the collision physics, reset this pice to the correct possition
					y = int(gridY*32+39);
				}else {
					--lifeTime;
				}
			}
		}
		
		public function explode():void {
			if (_curAnim.name == "Win") {
				PlayState.link.orangeSpark(x+width*.5,y+height*.5);
			}else {
				PlayState.link.spark(x+width*.5,y+height*.5);
			}
			kill();
		}
		
		
		
	}

}