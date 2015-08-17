package;

import kha.graphics2.Graphics;
import kha.Image;
import kha.Loader;

#if (js || sys_android || sys_android_native || sys_ios)
import mobile.Mobile;
#end

class Scene
{
	var imgBox:Image;
	var sprites:Array<Sprite>;
	
	var gameWidth:Int;
	var gameHeight:Int;
	
	public function new() 
	{
		// this check is only necessary if you are compiling to desktop.
		// otherwise you can always use Mobile.width/height for the game size
		#if (js || sys_android || sys_android_native || sys_ios)
		gameWidth = Mobile.width;
		gameHeight = Mobile.height;
		#else
		gameWidth = kha.Game.the.width;
		gameHeight = kha.Game.the.height;
		#end
		
		imgBox = Loader.the.getImage('box');
		sprites = new Array<Sprite>();
		
		// boxes
		sprites.push(new Sprite(0, 0));
		sprites.push(new Sprite(gameWidth - imgBox.width, 0));
		sprites.push(new Sprite(0, gameHeight - imgBox.height));
		sprites.push(new Sprite(gameWidth - imgBox.width, gameHeight - imgBox.height));
	}
		
	#if js
	public function gameSizeChanged(newWidth:Int, newHeight:Int)
	{
		if (Mobile.actualOrientation == Mobile.PORTRAIT)
		{
			gameWidth = newWidth;
			gameHeight = newHeight;
			
			sprites[1].set(gameWidth - imgBox.width, 0);
			sprites[2].set(0, gameHeight - imgBox.height);
			sprites[3].set(gameWidth - imgBox.width, gameHeight - imgBox.height);
		}
	}
	#end
	
	public function render(g:Graphics)
	{
		for (spt in sprites)
			g.drawScaledSubImage(imgBox, 0, 0, imgBox.width, imgBox.height, spt.x, spt.y, imgBox.width, imgBox.height);
	}
}