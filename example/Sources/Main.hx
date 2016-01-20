package;

import kha.Scheduler;
import kha.System;
import mobile.Mobile;

class Main 
{
	public static function main() 
	{
		// saves the base resolution and check if is in a mobile browser or desktop (on js)
		// then adjust the canvas size to use all the screen in mobile, or the size of the div container on desktop
		Mobile.setup(480, 720);		
		
		// Initialize Kha passing the size of the canvas or the screen in mobile devices
		System.init('Example', Mobile.screenWidth, Mobile.screenHeight, initialized);
	}
	
	private static function initialized():Void 
	{
		var game = new Example();
		System.notifyOnRender(game.render);
		Scheduler.addTimeTask(game.update, 0, 1 / 60);
	}
}