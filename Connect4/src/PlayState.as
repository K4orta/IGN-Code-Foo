package{
	import com.wong.erik.Connect4AI;
	import com.wong.erik.Grid;
	import com.wong.erik.K4Dialog;
	import com.wong.erik.Token;
	import flash.geom.Point;
	import org.flixel.*;

	public class PlayState extends FlxState{
		public static var link:		PlayState;
		public var tokens:			FlxGroup	= new FlxGroup();
		public var metaGroup:		FlxGroup 	= new FlxGroup();
		public var particles:		FlxGroup 	= new FlxGroup();
		public var boardGfx:		FlxSprite;
		public var floorBlock:		FlxObject;
		public var playersTurn:		Boolean;
		public var gameInProgress: 	Boolean;
		public var player:			int 		= 1;
		public var computer:		int 		= 2;
		public var grid:			Grid;
		public var ai:				Connect4AI;
		public var moveCoolDown:	Number 		= 0;
		public var secondsBetweenMoves:Number 	= 1.4;
		public var timers:			Array	= new Array();
		public var compTalk:		K4Dialog;
		
		public var messages:FlxGroup = new FlxGroup();
		public var sparks:FlxEmitter = new FlxEmitter(0,0,100);
		public var sparksOrange:FlxEmitter = new FlxEmitter(0,0,100);
		
		[Embed(source = "com/wong/erik/data/grid.png")] protected var ImgGrid:Class;
		[Embed(source = "com/wong/erik/data/sparkParts.png")] private var ImgSparks:Class;
		[Embed(source = "com/wong/erik/data/sparkPartsOrange.png")] private var ImgOrange:Class;
		
		override public function create():void{
			// Set the stage
			link = this;
			FlxG.mouse.show();
			FlxG.bgColor = 0xff131c14;
			boardGfx = new FlxSprite(0, 0, ImgGrid);
			playersTurn = true;
			
			// Add an invisible block to collide the token sprites off of.
			floorBlock = new FlxObject(0, 0, 224, 32);
			add(floorBlock);
			floorBlock.x = 128;
			floorBlock.y = 231;
			floorBlock.immovable = true;
			
			// add graphics to stage
			add(tokens);
			add(particles);
			add(boardGfx);
			add(messages);
			boardGfx.x = 128;
			boardGfx.y = 39;
			
			//particles
			sparksOrange.setXSpeed(-300,300);
			sparksOrange.setYSpeed( -300, 300);
			sparksOrange.bounce = .1;
			sparksOrange.makeParticles(ImgOrange, 100, 16, true);
			sparksOrange.gravity = 300;
			particles.add(sparksOrange);
			
			sparks.setXSpeed(-300,300);
			sparks.setYSpeed( -300, 300);
			sparks.bounce = .3;
			sparks.gravity = 300;
			sparks.makeParticles(ImgSparks, 100, 16, true);
			particles.add(sparks);
			
			//add tokens and invisible block to collision group
			metaGroup.add(tokens);
			metaGroup.add(floorBlock);
			
			
			// set the game board
			grid = new Grid();
			
			// hook the AI 
			ai = new Connect4AI(this);
			gameInProgress = true;
			compTalk = new K4Dialog("Booting. Please wait.... Loading sass.txt.... sass.txt loaded into memory.... Waiting for your move......",1,360,10);
			add(compTalk);
			
		}
		
		// Main Loop
		override public function update():void{
			super.update();
			FlxG.collide(metaGroup);
			FlxG.collide(metaGroup,particles);
			if (moveCoolDown<=0) {
				if (!playersTurn && gameInProgress) {
					ai.smartMove();
				}
			}else {
				moveCoolDown -= FlxG.elapsed;
			}
			
			if (moveCoolDown<=0&&playersTurn&&FlxG.mouse.justPressed()) {
				var moveX:int = int((FlxG.mouse.x) / 32) - 4;
				if(moveX>=0&&moveX<7)
					takeTurn(moveX, -32);
			}
			
			for (var i:int = 0; i < timers.length;++i ) {
				timers[i].time -= FlxG.elapsed;
				if (timers[i].time <= 0) {
					timers[i].func();
					timers.splice(i,1);
				}
				
			}
		}
		
		public function wait(Time:Number, Func:Function):uint {
			timers.push({"time":Time, "func":Func});
			return timers.length-1;
		}
		
		// Places a piece and ends the player's turn
		public function takeTurn(X:int, Y:Number = -32):void {
			//make sure there is space for this token first
			
			if(grid.grid[0][X]==0){
				var tkn:Token = new Token((X+4)*32, Y);
				tkn.play(playersTurn?"White":"Black");
				tokens.add(tkn);
			
				var pnt:Point = grid.placeMove(X, playersTurn?player:computer);
				tkn.gridX = pnt.x;
				tkn.gridY = pnt.y;
				var win:Object = grid.checkVictory();
				if (win) {
					endInVictory(win);
				}else if (!grid.anyOpenMoves()) {
					endInDraw();
				}
				playersTurn = !playersTurn;
				moveCoolDown = playersTurn?secondsBetweenMoves*.2:secondsBetweenMoves;
				
			}
		}
		
		public function endInDraw():void {
			messages.add(new FlxText(20, FlxG.height -20, 100, "It's a draw!"));
			gameInProgress = false;
			wait(4,reset);
		}
		
		public function reset():void {
			grid.reset();
			gameInProgress = true;
			playersTurn = true;
			for (var a:String in tokens.members) {
				tokens.members[a].kill();
			}
			tokens.members = new Array();
			for (a in messages.members) {
				messages.members[a].kill();
			}
			messages.members = new Array();
			messages.add(new FlxText(20, FlxG.height -20, 100, "Game reset"));
			compTalk.say("Let's play again... Your turn");
			wait(3, clearMessages);
		}
		
		public function clearMessages():void {
			for (var a:String in messages.members) {
				messages.members[a].kill();
			}
			messages.members = new Array();
		}
		
		public function endInVictory(Win:Object):void {
			gameInProgress = false;
			var winningToken:Token;
				//winningToken = findTokenByLocation(win.x, win.y);
				for (var i:int = 0; i < 4;++i ) {
					winningToken = findTokenByLocation(Win.x + Win.dir.x * -i, Win.y + Win.dir.y * -i);
					if (winningToken) winningToken.play("Win");
				}
			if (Win.winner == 1) {
				messages.add(new FlxText(20, FlxG.height -20, 100, "You won!"));
				compTalk.say("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
			}else {
				messages.add(new FlxText(20, FlxG.height -20, 100, "Oh no!"));
				compTalk.say("lol");
			}
			for (var a:String in tokens.members) {
				wait(Math.random() * 3, tokens.members[a].explode);
				tokens.members[a].immovable = false;
				tokens.members[a].acceleration.y = 400;
				tokens.members[a].elasticity = .3;
				tokens.members[a].lifeTime = 8 * FlxG.framerate;
				
			}
			wait(4,reset);
		}
		
		public function findTokenByLocation(X:int, Y:int):Token {
			for(var a:String in tokens.members) {
				
				if (tokens.members[a] && tokens.members[a].gridX == X && tokens.members[a].gridY == Y) {
					return tokens.members[a];
				}
			}
			return null;
		}
		
		public function spark(X:Number, Y:Number):void {
			sparks.x = X;
			sparks.y = Y
			sparks.start(true, .5, 0.1, 8);
		}
		
		public function orangeSpark(X:Number, Y:Number):void {
			sparksOrange.x = X;
			sparksOrange.y = Y;
			sparksOrange.start(true, .7, 0.1, 16);
		}
			
	
	}
}

