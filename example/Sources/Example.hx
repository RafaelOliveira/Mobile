package;

import kha.Color;
import kha.Assets;
import kha.Scaler;
import kha.System;
import kha.Image;
import kha.graphics2.Graphics;
import kha.graphics2.ImageScaleQuality;
import kha.Framebuffer;
import mobile.Mobile;

class Example
{
	var backbuffer:Image;
	var g:Graphics;
	var initialized:Bool = false;
	
	var scene:Scene;
	
	#if js
	var imgRotDevice:Image;
	#end

	public function new() 
	{
		Mobile.calcGameSize();
		
		// creates the backbuffer with a size that scales correctly with the screen
		backbuffer = Image.createRenderTarget(Mobile.width, Mobile.height);		
		
		#if js
		Mobile.changeGameSize = changeGameSize;
		#end
		
		g = backbuffer.g2;
		
		Assets.loadEverything(loadingFinished);
	}	
	
	private function loadingFinished():Void 
	{
		initialized = true;
		
		#if js
		if (Mobile.isMobile)
			imgRotDevice = Assets.images.rotate_device;		
		#end			
			
		scene = new Scene();		
	}
		
	public function update():Void 
	{
		#if js
		if (!initialized)
			return;
		
		Mobile.update();
		#end
	}
	
	#if js
	// only html5 checks for changes in the orientation. in desktop browsers
	// a change in the div container will also call this function
	public function changeGameSize(newWidth:Int, newHeight:Int):Void
	{
		backbuffer = Image.createRenderTarget(newWidth, newHeight);
		g = backbuffer.g2;
		
		scene.gameSizeChanged(newWidth, newHeight);	
	}
	#end
	
	public function render(framebuffer:Framebuffer):Void 
	{
		if (!initialized)
			return;
		
		g.begin(true, Color.fromValue(0xffdcdcdc));
		
		#if js
		if (Mobile.isUsingWebGL())
			framebuffer.g2.imageScaleQuality = ImageScaleQuality.High;
		
		// if it's in a mobile browser and is in the incorrect orientation,
		// draw the message to rotate the screen
		if (Mobile.isMobile && Mobile.actualOrientation == Mobile.LANDSCAPE)
		{
			g.clear(Color.White);			
			g.drawImage(imgRotDevice, (Mobile.width / 2) - (imgRotDevice.width / 2), (Mobile.height / 2) - (imgRotDevice.height / 2));			
		}
		else
		#end
			scene.render(g);
		
		g.end();
		
		framebuffer.g2.begin();
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
	}
}