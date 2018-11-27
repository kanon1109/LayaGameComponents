package manager 
{
import controls.ScreenNavigatorItem;
import controls.StackScreenNavigator;
import laya.display.Sprite;
/**
 * ...屏幕管理 用于创建单个屏幕导航
 * @author Kanon
 */
public class StackScreenManager 
{
	private static var sn:StackScreenNavigator;
	public static function init(container:Sprite):void
	{
		if(!container) return;
		StackScreenManager.sn = new StackScreenNavigator();
		container.addChild(StackScreenManager.sn);
		StackScreenManager.setSize(Laya.stage.width, Laya.stage.height);
		StackScreenManager.pos(0, 0);
	}

	/**
	 * 设置高宽
	 * @param width 宽度
	 * @param height 高度
	 */
	public static function setSize(width:Number, height:Number):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.size(width, height);
	}

	/**
	 * 移动位置
	 * @param x x坐标
	 * @param y y坐标
	 */
	public static function pos(x:Number, y:Number):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.pos(x, y);
	}

	/**
	 * 添加一个screen
	 * @param id 屏幕id
	 * @param item screen item
	 */
	public static function addScreen(id:String, item:ScreenNavigatorItem):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.addScreen(id, item);
	}

	/**
	 * 推入一个屏幕
	 * @param id 屏幕id
	 * @param properties 希望传递的属性
	 */
	public static function pushScreen(id:String, properties:*=null):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.pushScreen(id, properties);
	}

	/**
	 * 退出一个屏幕
	 * @param id 屏幕id
	 * @param properties 希望传递的属性
	 */
	public static function popScreen(properties:*=null):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.popScreen(properties);
	}

	/**
	 * 退出一个屏幕
	 * @param properties 
	 */
	public static function popToRootScreen(properties:*=null):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.popToRootScreen(properties);
	}

	/**
	 * 获取栈中屏幕的数量
	 */
	public static function stackCount():Number
	{
		if(StackScreenManager.sn)
			return StackScreenManager.sn.stackCount();
		return null;
	}

	/**
	 * 推入的过渡动画
	 */
	public static function get pushTransition():Function
	{
		if(StackScreenManager.sn)
			return StackScreenManager.sn.pushTransition;
		return null;
	}

	/**
	 * 推入的过渡动画
	 */
	public static function set pushTransition(value:Function):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.pushTransition = value;
	}

	/**
	 * 退出的过渡动画
	 */
	public static function get popTransition():Function
	{
		if(StackScreenManager.sn)
			return StackScreenManager.sn.popTransition;
		return null;
	}

	/**
	 * 退出的过渡动画
	 */
	public static function set popTransition(value:Function):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.popTransition = value;
	}

	/**
	 * 获取根屏幕的id
	 */
	public static function get rootScreenID():String
	{
		if(StackScreenManager.sn)
			return StackScreenManager.sn.rootScreenID;
		return null;
	}

	/**
	 * 设置根屏幕的id
	 */
	public static function set rootScreenID(id:String):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.rootScreenID = id;
	}

	/**
	 * 移出屏幕
	 * @param transition 过渡
	 */
	public static function clearScreen(transition:Function = null):void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.clearScreen(transition);
	}

	/**
	 * 获取当前的一个screen item对象
	 * @param id 屏幕id
	 */
	public static function getScreen(id:String):ScreenNavigatorItem
	{
		if(StackScreenManager.sn)
			return StackScreenManager.sn.getScreen(id);
		return null;
	}

	/**
	 * 根据id判断是否存在屏幕
	 * @param id 屏幕id
	 */
	public static function hasScreen(id:String):Boolean
	{
		if(StackScreenManager.sn)
			return StackScreenManager.sn.hasOwnProperty(id);
		return false;
	}

	/**
	 * 删除一个screen
	 * @param id 屏幕id
	 */
	public static function removeScreen(id:String):ScreenNavigatorItem
	{
		if(StackScreenManager.sn)
			return StackScreenManager.sn.removeScreen(id);
		return null;
	}

	/**
	 * 退出所有
	 */
	public static function popAll():void
	{
		if(StackScreenManager.sn)
			StackScreenManager.sn.popAll();
	}

	/**
	 * 销毁
	 * @param isDispose 是否销毁
	 */
	public static function destroySelf(isDispose:Boolean = false):void
	{
		if (StackScreenManager.sn)
			StackScreenManager.sn.destroySelf(isDispose);
		StackScreenManager.sn = null;
	}
	
}
}