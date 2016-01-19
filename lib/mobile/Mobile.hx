package mobile;

#if js
import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
import kha.Image;
import kha.SystemImpl;
#else
import kha.System;
#end

class Mobile
{
	/** The base width of the game */
	public static var baseWidth:Int;
	
	/** The base height of the game */
	public static var baseHeight:Int;
	
	/** The width of the backbuffer that is scaled */
	public static var width:Int;
	
	/** The height of the backbuffer that is scaled */
	public static var height:Int;
	
	/** The actual width of the screen */
	public static var screenWidth(get, null):Int;
	
	/** The actual height of the screen */
	public static var screenHeight(get, null):Int;
	
	/** 
	 * The scaling factor of the backbuffer of the game
	 * in relation with the actual screen
	 */
	public static var scaleFactor:Float;
	
	#if js
	/** Indicator of the portrait orientation */
	public inline static var PORTRAIT:Int = 1;
	
	/** Indicator of the landscape orientation */
	public inline static var LANDSCAPE:Int = 2;	
	
	/** 
	 * The actual orientation of the screen. Only used in js
	 * because in mobile generally the screen orientation is locked
	 */
	public static var actualOrientation:Int;
	
	/** 
	 * The correct orientation of the game, based on the base width and height of the game. 
	 * Only used in js because in mobile generally the screen orientation is locked
	 */
	public static var correctOrientation:Int;
	
	/** A div element that is the container of the game canvas (js) */
	public static var container:DivElement;
	
	/** The canvas element of the game (js) */
	public static var canvas:CanvasElement;
	
	/** Indicates if the game is running in a mobile browser or desktop (js) */
	public static var isMobile:Bool;	
	
	 /** A function that is called when the canvas size has changed (js) */
	public static var changeGameSize:Int->Int->Void;
	
	private static var orWidth:Int;
	private static var orHeight:Int;
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
		
		ratioX = System.pixelWidth / baseWidth;
		ratioY = System.pixelHeight / baseHeight;
		
		scaleFactor = Math.min(ratioX, ratioY);
		
		width = Std.int(Math.ceil(System.pixelWidth / scaleFactor));
		height = Std.int(Math.ceil(System.pixelHeight / scaleFactor));
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

		if (isUsingWebGL())
			SystemImpl.gl.viewport(0, 0, w, h);			

		orWidth = w;
		orHeight = h;

		calcGameSize();
		
		actualOrientation = getOrientation();

		if (changeGameSize != null)
			changeGameSize(width, height);
	}
	
	/**
	 * Creates a transparent html link with a rectangular size, that opens a url and call a function callback.
	 * The button is resized according to the scale factor of the game.
	 */
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
	
	/**
	 * Removes the html link from the screen
	 */
	public static function removeHtmlButton(id:String)
	{
		var htmlBt = Browser.document.getElementById(id);
		Browser.document.body.removeChild(htmlBt);
	}
	
	inline public static function isUsingWebGL():Bool
	{
		return (SystemImpl.gl != null);
	}
	#end
	
	static function get_screenWidth():Int 
	{
		#if js
		return canvas.clientWidth;
		#else
		return System.pixelWidth;
		#end
	}
	
	static function get_screenHeight():Int 
	{
		#if js
		return canvas.clientHeight;
		#else
		return System.pixelHeight;
		#end
	}
}