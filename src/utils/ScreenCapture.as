package utils 
{
import laya.display.Sprite;
import laya.renders.Render;
import laya.resource.HTMLCanvas;
import laya.resource.Texture;
import laya.utils.Browser;
/**
 * ...截屏工具
 * @author Kanon
 */
public class ScreenCapture 
{
	/**
	 * 截取后保存在纹理中
	 * @param	sp			需要截屏的显示对象
	 * @param	width		截取宽度
	 * @param	height		截取高度
	 * @return	纹理
	 */
	public static function catureAsTextrue(sp:Sprite, width:Number, height:Number):Texture
	{
		if (!sp || Render.isConchApp) return null;
		var htmlCanvas:HTMLCanvas = sp.drawToCanvas(width, height, 0, 0);
		return new Texture(htmlCanvas);
	}
	
	/**
	 * 截取一个尺寸的屏幕
	 * @param	width	截取宽度
	 * @param	height	截取高度
	 * @return	截取后存入一个sprite
	 */
	public static function catureAsSize(width:Number, height:Number):Sprite
	{
		if (Laya.stage)
		{
			var texture:Texture = catureAsTextrue(Laya.stage, width, height);
			if (!texture) return null;
			var spt:Sprite = new Sprite();
			spt.width = width;
			spt.height = height;
			spt.graphics.drawTexture(texture);
			return spt;
		}
		return null;
	}
	
	/**
	 * 全屏截取
	 * @return	截取后存入一个sprite
	 */
	public static function cature():Sprite
	{
		return catureAsSize(Laya.stage.width, Laya.stage.height);
	}
	
	/**
	 * 截取后保存数据
	 * @param	sp			需要截屏的显示对象
	 * @param	width		截取宽度
	 * @param	height		截取高度
	 * @return	图片数据
	 */
	public static function catureAsData(sp:Sprite, width:Number, height:Number):*
	{
		if (!sp || Render.isConchApp) return null;
		var htmlCanvas:HTMLCanvas = sp.drawToCanvas(width, height, 0, 0);
		//获取<canvas>对象
		var canvas:* = htmlCanvas.getCanvas();
		if (!canvas) return null;
		return canvas.toDataURL();
	}
	
	/**
	 * 设备上截图
	 * @param	name	图片名称
	 * @param	dir		路径（默认根目录）
	 * @param	isPng	是否是png
	 */
	public static function catureAsDevice(name:String, dir:String = "/sdcard", isPng:Boolean = true):void
	{
		var conch:* = Browser.window["conch"];
		if(conch)
		{
			conch.captureScreen(function(arrayBuff, width, height):void 
			{
				if (isPng)
					conch.saveAsPng(arrayBuff, width, height, dir + "/" + name +".png");
				else
					conch.saveAsJpeg(arrayBuff, width, height, dir + "/" + name +".jpg");
			});
		}
	}
}
}