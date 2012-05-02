package{
	import org.flixel.*;
	[SWF(width="960", height="540", backgroundColor="#131c14")]
	[Frame(factoryClass="Preloader")]

	public class Connect4 extends FlxGame{
		public function Connect4(){
			super(480,270,PlayState,2, 60, 60);
			
		}
	}
}

