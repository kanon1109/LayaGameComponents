package manager 
{
import controls.ScreenNavigator;
import controls.ScreenNavigatorItem;
import laya.display.Sprite;
/**
 * ...屏幕管理 用于创建单个屏幕导航
 * @author Kanon
 */
public class ScreenManager 
{
	private static var sn:ScreenNavigator;
	public static function init(container:Sprite):void
	{
		if(!container) return;
		ScreenManager.sn = new ScreenNavigator();
		container.addChild(ScreenManager.sn);
		ScreenManager.setSize(Laya.stage.width, Laya.stage.height);
		ScreenManager.pos(0, 0);
	}

	/**
	 * 设置高宽
	 * @param width 宽度
	 * @param height 高度
	 */
	public static function setSize(width:Number, height:Number):void
	{
		if(ScreenManager.sn)
			ScreenManager.sn.size(width, height);
	}

	/**
	 * 移动位置
	 * @param x x坐标
	 * @param y y坐标
	 */
	public static function pos(x:Number, y:Number):void
	{
		if(ScreenManager.sn)
			ScreenManager.sn.pos(x, y);
	}

	/**
	 * 添加一个screen
	 * @param id 屏幕id
	 * @param item screen item
	 */
	public static function addScreen(id:String, item:ScreenNavigatorItem):void
	{
		if(ScreenManager.sn)
			ScreenManager.sn.addScreen(id, item);
	}

	/**
	 * 显示一个screen
	 * @param id 屏幕id
	 * @param transition 过渡效果 
	 */
	public static function showScreen(id:String, transition:Function = null):void
	{
		if(ScreenManager.sn)
			ScreenManager.sn.showScreen(id, transition);
	}

	/**
	 * 移出屏幕
	 * @param transition 过渡
	 */
	public static function clearScreen(transition:Function = null):void
	{
		if(ScreenManager.sn)
			ScreenManager.sn.clearScreen(transition);
	}

	/**
	 * 获取当前的一个screen item对象
	 * @param id 屏幕id
	 */
	public static function getScreen(id:String):ScreenNavigatorItem
	{
		if(ScreenManager.sn)
			return ScreenManager.sn.getScreen(id);
		return null;
	}

	/**
	 * 根据id判断是否存在屏幕
	 * @param id 屏幕id
	 */
	public static function hasScreen(id:String):Boolean
	{
		if(ScreenManager.sn)
			return ScreenManager.sn.hasOwnProperty(id);
		return false;
	}

	/**
	 * 删除一个screen
	 * @param id 屏幕id
	 */
	public static function removeScreen(id:String):ScreenNavigatorItem
	{
		if(ScreenManager.sn)
			return ScreenManager.sn.removeScreen(id);
		return null;
	}

	/**
	 * 销毁
	 * @param isDispose 是否销毁
	 */
	public static function destroySelf(isDispose:Boolean = false):void
	{
		if (ScreenManager.sn)
			ScreenManager.sn.destroySelf(isDispose);
		ScreenManager.sn = null;
	}
}
}