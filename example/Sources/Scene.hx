package;

import kha.graphics2.Graphics;
import kha.Image;
import kha.Loader;
import mobile.Mobile;

class Scene
{
	var imgBox:Image;
	var sprites:Array<Sprite>;	
	
	public function new() 
	{			
		imgBox = Loader.the.getImage('box');
		sprites = new Array<Sprite>();
		
		// boxes
		sprites.push(new Sprite(0, 0));
		sprites.push(new Sprite(Mobile.width - imgBox.width, 0));
		sprites.push(new Sprite(0, Mobile.height - imgBox.height));
		sprites.push(new Sprite(Mobile.width - imgBox.width, Mobile.height - imgBox.height));
	}
		
	#if js
	public function gameSizeChanged(newWidth:Int, newHeight:Int)
	{
		if (Mobile.actualOrientation == Mobile.PORTRAIT)
		{
			sprites[1].set(newWidth - imgBox.width, 0);
			sprites[2].set(0, newHeight - imgBox.height);
			sprites[3].set(newWidth - imgBox.width, newHeight - imgBox.height);
		}
	}
	#end
	
	public function render(g:Graphics)
	{
		for (spt in sprites)
			g.drawScaledSubImage(imgBox, 0, 0, imgBox.width, imgBox.height, spt.x, spt.y, imgBox.width, imgBox.height);
	}
}