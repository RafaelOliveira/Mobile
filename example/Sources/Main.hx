package;

import kha.Starter;

class Main 
{
	public static function main() 
	{
		mobile.Mobile.setup(480, 720);		
		
		var starter = new Starter();
		starter.start(new Example());
	}
}