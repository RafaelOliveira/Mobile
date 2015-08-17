package mobile;

#if js
import kha.Image;
import kha.Loader;
import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
#else
import kha.Sys;
#end

class Mobile
{
	public static var baseWidth:Int;
	public static var baseHeight:Int;
	
	public static var width:Int;
	public static var height:Int;
	
	#if js
	public inline static var PORTRAIT:Int = 1;
	public inline static var LANDSCAPE:Int = 2;
	
	private static var orWidth:Int;
	private static var orHeight:Int;
	
	public static var actualOrientation:Int;
	public static var correctOrientation:Int;
	
	public static var container:DivElement;
	public static var canvas:CanvasElement;
	
	public static var isMobile:Bool;
	public static var scaleFactor:Float;
	public static var changeGameSize:Int->Int->Void;
	#end
	
	public static function setup(baseWidth:Int, baseHeight:Int) 
	{
		Mobile.baseWidth = baseWidth;
		Mobile.baseHeight = baseHeight;
		
		#if js
		if (baseWidth < baseHeight)
			correctOrientation = PORTRAIT;
		else
			correctOrientation = LANDSCAPE;		

		isMobile = checkIsMobile();
		setupCanvas();
		
		actualOrientation = getOrientation();
		
		orWidth = canvas.clientWidth;
		orHeight = canvas.clientHeight;
		#end
	}
	
	#if js
	static function checkIsMobile():Bool
	{
		var mobile = ['iphone', 'ipad', 'android', 'blackberry', 'nokia', 'opera mini', 'windows mobile', 'windows phone', 'iemobile'];
		for (i in 0...mobile.length)
		{
			if (Browser.navigator.userAgent.toLowerCase().indexOf(mobile[i].toLowerCase()) > 0)
				return true;
		}

		return false;
	}
	
	static function setupCanvas()
	{
		container = cast Browser.document.getElementById('game-container');
		canvas = cast Browser.document.getElementById('khanvas');

		if (isMobile)
		{
			setHtmlBodyFullscreen();
			
			var w = Browser.window.innerWidth;
			var h = Browser.window.innerHeight;
			
			container.style.width = '${w}px';
			container.style.height = '${h}px';
			
			canvas.style.width = '${w}px';
			canvas.style.height = '${h}px';
			canvas.width = w;
			canvas.height = h;
		}
		else
		{
			var w = container.clientWidth;
			var h = container.clientHeight;
			
			canvas.style.width = '${w}px';
			canvas.style.height = '${h}px';
			canvas.width = w;
			canvas.height = h;
		}
	}
	
	static function setHtmlBodyFullscreen()
	{
		Browser.document.body.style.margin = '0px';
		Browser.document.body.style.padding = '0px';
		Browser.document.body.style.height = '100%';
		Browser.document.body.style.overflow = 'hidden';
		
		Browser.document.documentElement.style.margin = '0px';
		Browser.document.documentElement.style.padding = '0px';
		Browser.document.documentElement.style.height = '100%';
		Browser.document.documentElement.style.overflow = 'hidden';
	}
	#end
	
	public static function calcGameSize()
	{
		#if js
		scaleFactor = getScaleFactor();

		width = Math.ceil(canvas.width / scaleFactor);
		height = Math.ceil(canvas.height / scaleFactor);
		#else
		var ratioX:Float = 0;
		var ratioY:Float = 0;
		
		ratioX = Sys.pixelWidth / baseWidth;
		ratioY = Sys.pixelHeight / baseHeight;
		
		var scaleFactor = Math.min(ratioX, ratioY);
		
		width = Std.int(Math.ceil(Sys.pixelWidth / scaleFactor));
		height = Std.int(Math.ceil(Sys.pixelHeight / scaleFactor));
		#end
	}
	
	#if js
	static function getScaleFactor():Float
	{
		var ratioX:Float = 0;
		var ratioY:Float = 0;
		var orientation = getOrientation();

		if (isMobile)
		{
			if (orientation == correctOrientation)
			{
				ratioX = canvas.width / baseWidth;
				ratioY = canvas.height / baseHeight;
			}
			else
			{
				ratioX = canvas.width / baseHeight;
				ratioY = canvas.height / baseWidth;
			}
		}
		else
		{
			ratioX = canvas.width / baseWidth;
			ratioY = canvas.height / baseHeight;
		}

        return Math.min(ratioX, ratioY);
	}
	
	private static function getOrientation()
	{
		if (canvas.width < canvas.height)
			return PORTRAIT;
		else
			return LANDSCAPE;
	}
	
	public static function update()
	{
		if (isMobile && (orWidth != Browser.window.innerWidth || orHeight != Browser.window.innerHeight))
		{
			var w = Browser.window.innerWidth;
			var h = Browser.window.innerHeight;

			container.style.width = '${w}px';
			container.style.height = '${h}px';

			updateCanvas(w, h);
		}
		else if (!isMobile && (orWidth != container.clientWidth || orHeight != container.clientHeight))
			updateCanvas(container.clientWidth, container.clientHeight);
	}
	
	static function updateCanvas(w:Int, h:Int)
	{
		canvas.style.width = '${w}px';
		canvas.style.height = '${h}px';
		canvas.width = w;
		canvas.height = h;

		if (kha.Sys.gl != null)
			kha.Sys.gl.viewport(0, 0, w, h);

		orWidth = w;
		orHeight = h;

		calcGameSize();
		
		actualOrientation = getOrientation();

		if (changeGameSize != null)
			changeGameSize(width, height);
	}
	
	public static function createHtmlButton(id:String, x:Float, y:Float, w:Int, h:Int, url:String, onClickFunc:Void->Void = null)
	{
		var htmlBt = Browser.document.createAnchorElement();
		htmlBt.id = id;
		htmlBt.href = url;
		htmlBt.target = '_blank';
		htmlBt.style.display = 'block';
		htmlBt.style.width = '${w * scaleFactor}px';
		htmlBt.style.height = '${h * scaleFactor}px';
		htmlBt.style.position = 'absolute';
		htmlBt.style.left = '${(x * scaleFactor) + canvas.offsetLeft}px';
		htmlBt.style.top = '${(y * scaleFactor)  + canvas.offsetTop}px';
		htmlBt.addEventListener('click', function()
		{
			if (onClickFunc != null)
				onClickFunc();
		});
		Browser.document.body.appendChild(htmlBt);
	}
	
	public static function removeHtmlButton(id:String)
	{
		var htmlBt = Browser.document.getElementById(id);
		Browser.document.body.removeChild(htmlBt);
	}
	#end
}