package;

import kha.Starter;

class Main 
{
	public static function main() 
	{
		#if (js || sys_android || sys_android_native || sys_ios)
		mobile.Mobile.setup(480, 720);
		#end
		
		var starter = new Starter();
		starter.start(new Example1());
	}
}

// https://openclipart.org/detail/201851/two-color-ball
// https://openclipart.org/detail/29250/crate-front