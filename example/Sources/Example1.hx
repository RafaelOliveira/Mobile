package;

import kha.Color;
import kha.Game;
import kha.Loader;
import kha.Scaler;
import kha.Sys;
import kha.Image;
import kha.graphics2.Graphics;
import kha.Configuration;
import kha.Framebuffer;
import kha.LoadingScreen;

#if (js || sys_android || sys_android_native || sys_ios)
import mobile.Mobile;
#end

class Example1 extends Game 
{
	var backbuffer:Image;
	var g:Graphics;
	
	var scene:Scene;
	
	#if js
	var imgRotDevice:Image;
	#end

	public function new() 
	{
		super('Example1');
	}

	override public function init():Void 
	{
		// calculate the new size if is a mobile target, or use the one from project.kha
		#if (js || sys_android || sys_android_native || sys_ios)
		Mobile.calcGameSize();
		backbuffer = Image.createRenderTarget(Mobile.width, Mobile.height);
		#else
		backbuffer = Image.createRenderTarget(width, height);
		#end
		
		#if js
		Mobile.changeGameSize = changeGameSize;
		#end
		
		g = backbuffer.g2;
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom('base', roomLoaded);	
	}
	
	private function roomLoaded():Void 
	{
		#if js
		if (Mobile.isMobile)
			imgRotDevice = Loader.the.getImage('rotate_device');
		
		if (kha.Sys.gl != null)
		#end
			cast(g, kha.graphics4.Graphics2).setBilinearFiltering(true);
			
		scene = new Scene();
		
		Configuration.setScreen(this);
	}
	
	#if js
	override public function update():Void 
	{
		Mobile.update();		
	}
	
	// only html5 checks for changes in the orientation. in desktop browsers
	// a change in the div container will also call this function
	public function changeGameSize(newWidth:Int, newHeight:Int):Void
	{
		backbuffer = Image.createRenderTarget(newWidth, newHeight);
		g = backbuffer.g2;
		
		if (kha.Sys.gl != null)
			cast(g, kha.graphics4.Graphics2).setBilinearFiltering(true);
		
		scene.gameSizeChanged(newWidth, newHeight);	
	}
	#end
	
	override public function render(frame:Framebuffer):Void 
	{
		g.begin(true, Color.fromValue(0xffdcdcdc));
		
		#if js
		if (Mobile.isMobile && Mobile.actualOrientation == Mobile.LANDSCAPE)
		{
			g.clear(Color.White);
			g.color = Color.White;
			
			g.drawScaledSubImage(imgRotDevice, 0, 0, imgRotDevice.width, imgRotDevice.height, 
								(Mobile.width / 2) - (imgRotDevice.width / 2), (Mobile.height / 2) - (imgRotDevice.height / 2),
								imgRotDevice.width, imgRotDevice.height);
		}
		else
		#end
			scene.render(g);
		
		g.end();
		
		startRender(frame);
		Scaler.scale(backbuffer, frame, Sys.screenRotation);
		endRender(frame);
	}
}