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
		protected var bestMove:Move;

		protected var gridWidth:int;
		protected var gridHeight:int;
		
		[Embed(source = "data/sass.txt", mimeType = "application/octet-stream" )] protected var Sass:Class;
		
		public function Connect4AI(Game:PlayState){
			logic = Game;
			board = logic.grid;
			grid = board.grid;
			// store local copies so we don't incur the cost of a method call during recursion
			gridWidth = board.gridWidth;
			gridHeight = board.gridHeight;
			
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
		
		//basic Minimax AI, using Point to store the location/score.
		public function minMax(Player:int, Depth:int, MaxDepth:int):Point {
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
				grid[y - 1][j] = Player;
				//var pieceLoc:Point = new Point(j,y - 1); 
				
				
				//check for a winning move
				var curMove:Point = new Point();
				curMove.x = slotValue(j, y - 1)*(Player==2?1:-1);
				curMove.y = j;
				
				// If we've got a win for either side, or we've reached the max depth, set next move's score
				// if not, do the recursive call
				if (curMove.x==-100||Depth==MaxDepth||curMove.x ==100) {
					nextMove.x = curMove.x;
				}else {
					var tm:Point = minMax(3-Player, Depth + 1, MaxDepth);
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
		/*
		public function alphaBeta():Move {
			return null;
		}
		
		public function miniMax(CurrentPlayer:int, Depth:int, Cutoff:int):Move {
			var bestMove:Move = new Move(0,-Infinity); 
			
			for (var j:int = 0; j < gridWidth;++j) {
				// if can't move here, bail out
				if (grid[0][j] != 0) 
					continue;
				var y:int = 0;
				while (y < gridHeight && grid[y][j] == 0)  {
					++y;
				}
				grid[y - 1][j] = CurrentPlayer;
				var curMove:Move = new Move();
				var winningMove:Object = board.checkVictory();
				if (winningMove) {
					curMove.value = winningMove.winner == 1? -100:100;
					curMove.location = j;
				}
				
				
				y = 0;
				while (y < board.gridHeight && grid[y][j] == 0)  {
					++y;
				}
				grid[y][j] = 0;
			}
			return bestMove;
		}*/
		
		public function slotValue(X:int, Y:int):int {
			var value:int = 0;
			var tempConnect:int;
			
			for (var i:int = -1;i<=1;++i) {
				for (var j:int = -1;j<=1;++j) {
					if (i == 0 && j == 0) continue;
					if(Y+i>=0&&Y+i<gridHeight&&X+j>=0&&X+j<gridWidth)
					if (grid[Y+i][X+j] != 0) {
						tempConnect = 1;
						
						while (Y + i * tempConnect >= 0 && 
						Y + i * tempConnect < gridHeight &&
						X + j * tempConnect >= 0 &&
						X + j * tempConnect < gridWidth
						&& grid[Y + i * tempConnect][X + j * tempConnect] == grid[Y][X]) {
							++tempConnect
						};
						value += (tempConnect == 4?100:0) + (tempConnect == 3?10:0) + (tempConnect == 2?1:0);
						
					}
				}
			}
			
			return value;
		}
		
		
 
		public function smartMove():Number {
			var move:Point = minMax(2,0,3);
			if (curSass >= sass.length) {
				curSass = 0;
			}
			logic.compTalk.say(sass[curSass++]);
			// if miniMax didn't return anything worthwhile, take a random move
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

internal class Move {
	public var value:int;
	public var location:int;
	
	function Move(Value:int=0, Location:int=0) {
		value = Value;
		location = Location;
	}
}

