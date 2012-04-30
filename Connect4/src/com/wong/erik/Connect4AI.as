package com.wong.erik 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Erik
	 */
	public class Connect4AI 
	{
		protected var board:	Grid; 
		protected var grid:		Array; 
		protected var logic:PlayState;
		protected var sass:		Array;
		protected var curSass:	int;
		
		[Embed(source = "data/sass.txt", mimeType = "application/octet-stream" )] protected var Sass:Class;
		
		public function Connect4AI(Game:PlayState){
			logic = Game;
			board = logic.grid;
			grid = board.grid;
			
			var sText:String = new Sass();
			var rawSass:Array = sText.split("\r\n");
			sass = new Array();
			var ti:int = 0;
			curSass = 0;
			
			while(rawSass.length>0) {
				ti = Math.random() * rawSass.length;
				sass.push(rawSass.splice(ti, 1));
			}
		
		}
		
		//___________________________________________________________
		//——————————————————————————————————————————————————— METHODS
		
		//basic minmax AI, using Point to store the location/score.
		public function minMax(PlayersTurn:Boolean, Depth:int, MaxDepth:int):Point {
			var bestMove:Point = new Point(-Infinity,0);
			if (Depth%2==1)
				bestMove.x *= -1;
			var nextMove:Point = new Point();
			
			//make a move in each column
			for (var j:int=0;j<board.gridWidth;++j ) {
				nextMove.y = j;
				//if this column is full, skip it
				if (grid[0][j]!=0) 
					continue;
				
				//place the piece on top of any existing pieces 
				var y:int = 0;
				while (y < board.gridHeight && grid[y][j] == 0)  {
					++y;
				}
				//put the current player's piece into the grid
				grid[y - 1][j] = PlayersTurn?1:2;
				//var pieceLoc:Point = new Point(j,y - 1); 
				
				//check for a winning move
				var curMove:Point = new Point();
				var winningMove:Object = board.checkVictory();
				if (winningMove) {
					curMove.x = (winningMove.winner==1?-100:100);
				}
				
				
				// If we've got a win for either side, or we've reached the max depth, set next move's score
				// if not, do the recursive call
				if (curMove.x==-100||Depth==MaxDepth||curMove.x ==100) {
					nextMove.x = curMove.x;
				}else {
					var tm:Point = minMax(!PlayersTurn, Depth + 1, MaxDepth);
					nextMove.x = tm.x;
				}
				//figure out if this move is better than what we have
				if (Depth % 2 == 0 && nextMove.x > bestMove.x) {
					bestMove.y = nextMove.y;
					bestMove.x = nextMove.x;
				}else if (Depth % 2 == 1 && nextMove.x < bestMove.x) {
					bestMove.x = nextMove.x;
					bestMove.y = nextMove.y;
				}
				//remove the piece we put earlier
				y = 0;
				while (y < board.gridHeight && grid[y][j] == 0)  {
					++y;
				}
				grid[y][j] = 0;
			}
			return bestMove;
		}
 

		
		public function smartMove():Number {
			var move:Point = minMax(false, 0,3);
			if (curSass > sass.length) {
				curSass = 0;
			}
			logic.compTalk.say(sass[curSass++]);
			// if minMax didn't return anything worthwhile, take a random move
			if (move.x == 0 && move.y == 0) {
				dumbMove();
			}else{
				logic.takeTurn(move.y);
			}
			return 0;
		}
		
		public function dumbMove():Number {
			var possibleMoves:Vector.<int> = board.findOpenMoves();
			logic.takeTurn(possibleMoves[int(possibleMoves.length*Math.random())]);
			return 0;
		}
		
		
		
	}
	
}

