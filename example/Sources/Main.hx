package;

import kha.Scheduler;
import kha.System;
import mobile.Mobile;

class Main 
{
	public static function main() 
	{
		Mobile.setup(480, 720);		
		
		System.init('Example', Mobile.screenWidth, Mobile.screenHeight, initialized);
	}
	
	private static function initialized():Void 
	{
		var game = new Example();
		System.notifyOnRender(game.render);
		Scheduler.addTimeTask(game.update, 0, 1 / 60);
	}
}