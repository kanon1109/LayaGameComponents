package controls 
{
import events.ScreenEvent;
import laya.display.Sprite;
/**
 * ...屏幕导航
 * @author Kanon
 */
public class ScreenNavigator extends Sprite implements IBaseScreenNavigator
{
	//存放屏幕数据的字典
	protected var screens:Object;
	//屏幕容器
	protected var screenContainer:Sprite = null;
	//当前活跃屏幕的id
	protected var activeScreenID:String = "";
	//当前活跃的屏幕
	protected var activeScreen:Sprite = null;
	//上一个屏幕
	protected var previousScreenInTransition:Sprite = null;
	//是否在过渡
	protected var isTransitionActive:Boolean;
	public function ScreenNavigator()
	{
		super();
		this.screenContainer = this;
		this.screens = {};
		this.activeScreen = null;
		this.previousScreenInTransition = null;
		this.isTransitionActive = false;
	}

	/**
	 * 添加一个screen
	 * @param id 屏幕id
	 * @param item screen item
	 */
	public function addScreen(id:String, item:ScreenNavigatorItem):void
	{
		if(this.screens.hasOwnProperty(id)) 
			throw new Error("Screen with id '" + id + "' already defined. Cannot add two screens with the same id.");
		this.screens[id] = item;
		item.id = id;
		//设置高宽
		var screen:Sprite = item.getScreen();
		screen.size(this.width, this.height);
	}

	/**
	 * 显示一个screen
	 * @param id 屏幕id
	 * @param transition 过渡方法
	 * @param properties 自定义属性
	 */
	public function showScreen(id:String, transition:Function = null, properties:*=null):void
	{
		if(!this.screens.hasOwnProperty(id)) return;
		if(id == this.activeScreenID) return;
		if(this.isTransitionActive) return;

		//保存当前未切换的screen
		this.previousScreenInTransition = this.activeScreen;
		//处理当前未切换的screen的状态
		if(this.screens.hasOwnProperty(this.activeScreenID))
		{
			var prevItem:ScreenNavigatorItem = this.screens[this.activeScreenID];
			prevItem.deactive();//去活
		}

		//获取当前的屏幕item
		this.activeScreenID = id;
		var item:ScreenNavigatorItem = this.screens[id];
		item.properties = properties;
		item.active();//激活
		//获取当前屏幕显示对象
		this.activeScreen = item.getScreen();
		if(this.activeScreen) 
		{
			this.activeScreen.event(ScreenEvent.TRANSITION_IN_START);
			this.screenContainer.addChild(this.activeScreen);
		}
		if(this.previousScreenInTransition)
			this.previousScreenInTransition.event(ScreenEvent.TRANSITION_OUT_START);
		//发送过渡开始事件
		this.event(ScreenEvent.TRANSITION_START);
		//处理当前屏幕出现效果
		this.isTransitionActive = true;
		this.startTransition(transition);
	}

	/**
	 * 开启过渡
	 * @param transition 过渡效果回调
	 */
	protected function startTransition(transition:Function):void
	{
		if(transition != null)
			transition.call(this, this.previousScreenInTransition, this.activeScreen, this.transitionComplete);
		else
			this.transitionComplete();
	}

	/**
	 * 过渡结束
	 */
	protected function transitionComplete():void
	{
		if(this.activeScreen)
			this.activeScreen.event(ScreenEvent.TRANSITION_IN_COMPLETE);

		if(this.previousScreenInTransition)
		{
			this.previousScreenInTransition.event(ScreenEvent.TRANSITION_OUT_COMPLETE);
			this.screenContainer.removeChild(this.previousScreenInTransition);
		}
		this.previousScreenInTransition = null;
		this.isTransitionActive = false;
		//发送过渡结束事件
		this.event(ScreenEvent.TRANSITION_COMPLETE);
	}

	/**
	 * 获取当前的一个screen item对象
	 * @param id 屏幕id
	 */
	public function getScreen(id:String):ScreenNavigatorItem
	{
		if(this.screens.hasOwnProperty(id))
			return this.screens[id];
		return null;
	}
	
	/**
	 * 根据id判断是否存在屏幕
	 * @param id 屏幕id
	 */
	public function hasScreen(id:String):Boolean
	{
		return this.screens.hasOwnProperty(id);
	}

	/**
	 * 删除一个screen
	 * @param id 屏幕id
	 */
	public function removeScreen(id:String):ScreenNavigatorItem
	{
		var item:ScreenNavigatorItem;
		if(this.screens.hasOwnProperty(id))
		{
			item = this.screens[id];
			delete this.screens[id];
		}
		return item
	}

	/**
	 * 移出当前的screen
	 * @param transition 过渡方法
	 */
	public function clearScreen(transition:Function = null):void
	{
		if(this.isTransitionActive) return;
		//保存当前未切换的screen
		this.previousScreenInTransition = this.activeScreen;
		//处理当前未切换的screen的状态
		if(this.screens.hasOwnProperty(this.activeScreenID))
		{
			var prevItem:ScreenNavigatorItem = this.screens[this.activeScreenID];
			prevItem.deactive();//去活
		}
		this.isTransitionActive = true;
		//播放当前屏幕移出效果
		this.startTransition(transition);
		this.activeScreen = null;
		this.activeScreenID = null;
	}

	/**
     * 销毁
     * @param isDispose 是否释放screen item的内存
     */
	public function destroySelf(isDispose:Boolean=false):void
	{
		for (var key:String in this.screens) 
		{
			if (this.screens.hasOwnProperty(key)) 
			{
				var item:ScreenNavigatorItem = this.screens[key];
				item.destroySelf(isDispose);
			}
		}
		this.screens = null;
		this.screenContainer.removeSelf();
		this.screenContainer.destroy();
		this.screenContainer = null;
		this.activeScreen = null;
		this.previousScreenInTransition = null;
		
		this.removeSelf();
		this.destroy();
	}
	
}
}