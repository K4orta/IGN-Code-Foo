package com.wong.erik 
{
	import flash.geom.Point;
	import JSON;
	/**
	 * ...
	 * @author Erik
	 */
	
	 
	public class Grid {
		protected var _gridWidth:int = 7;
		protected var _gridHeight:int = 6;
		public var grid:Array;
		
		public function Grid() {
			// Set up a 2D Array to hold the tokens 
			
			grid = new Array(_gridHeight);
			for (var i:int = 0; i < grid.length;++i ) {
				grid[i] = new Array(_gridWidth);
				for (var j:int = 0; j < grid[i].length;++j ) {
					grid[i][j] = 0;
				}
			}
		}
		
		//___________________________________________________________
		//——————————————————————————————————————————————————— METHODS
		
		public function reset():void {
			for (var i:int = 0; i < grid.length;++i ) {
				for (var j:int = 0; j < grid[i].length;++j ) {
					grid[i][j] = 0;
				}
			}
		}
		
		public function placeMove(X:int, TokenOwner:int):Point {
			var i:int = 0;
			while(i<_gridHeight){
				if (i+1>=_gridHeight || grid[i + 1][X] != 0) {
					grid[i][X] = TokenOwner;
					return new Point(X,i);
				}else {
					++i;
				}
			}
			
			return null;
			//trace(JSON.stringify(grid));
		}
		
		public function findOpenMoves():Vector.<int> {
			var open:Vector.<int> = new Vector.<int>();
			for (var j:int = 0; j < _gridWidth;++j ) {
				if (grid[0][j]==0) {
					open.push(j);
				}
			}
			return open;
		}
		
		public function anyOpenMoves():Boolean {
			for (var j:int = 0; j < _gridWidth;++j ) {
				if (grid[0][j]==0) {
					return true;
				}
			}
			return false;
		}
		
		// Much more simple check victory 
		public function checkVictory():Object {
			// Check for a column
			for (var i:int=0;i<3;++i) {
				for (var j:int=0;j<_gridWidth;++j) {
					if (grid[i][j]!=0&&grid[i+1][j]==grid[i][j]&&grid[i+2][j]==grid[i][j]&&grid[i+3][j]==grid[i][j]) {
						return { "x":j, "y":i, "dir":new Point(0,1), "winner":grid[i][j] };
					}
				}
			}
			// Check for a row
			for (i=0;i<_gridHeight;++i) {
				for (j=0;j<4;++j) {
					if (grid[i][j]!=0&&grid[i][j+1]==grid[i][j]&&grid[i][j+2]==grid[i][j]&&grid[i][j+3]==grid[i][j]) {
						return { "x":j, "y":i, "dir":new Point(1,0), "winner":grid[i][j] };
					}
				}
			}
			
			// Check diagonal [\]
			for (i=0;i<3;++i) {
				for (j=0;j<4;++j) {
					if (grid[i][j]!=0&&grid[i+1][j+1]==grid[i][j]&&grid[i+2][j+2]==grid[i][j]&&grid[i+3][j+3]==grid[i][j]) {
						return { "x":j, "y":i, "dir":new Point(1,1), "winner":grid[i][j] };
					}
				}
			}
			
			// Check reversed diagonal [/]
			for (i=0;i<3;++i) {
				for (j=_gridWidth-1;j>3;--j) {
					if (grid[i][j]!=0&&grid[i+1][j-1]==grid[i][j]&&grid[i+2][j-2]==grid[i][j]&&grid[i+3][j-3]==grid[i][j]) {
						return { "x":j, "y":i, "dir":new Point(-1,1), "winner":grid[i][j] };
					}
				}
			}
			
			return null;
		}
		
		
		
		//___________________________________________________________
		//————————————————————————————————————————— GETTERS / SETTERS
		
		public function get gridWidth():int { return _gridWidth; }
		public function get gridHeight():int { return _gridHeight; }
	}

}