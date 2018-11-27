package controls 
{
/**
 * ...屏幕栈导航
 * @author Kanon
 */
public class StackScreenNavigator extends ScreenNavigator 
{
	//推入的过渡动画
	private var _pushTransition:Function;
	//退出的过渡动画
	private var _popTransition:Function;
	//屏幕列表栈
	private var stack:Array;
	public function StackScreenNavigator()
	{
		super();
		this.stack = [];
		this._pushTransition = null;
		this._popTransition = null;
	}

	/**
	 * 推入一个屏幕
	 * @param id 屏幕id
	 * @param properties 希望传递的属性
	 */
	public function pushScreen(id:String, properties:*=null):void
	{
		this.stack.push(id);
		this.showScreen(id, this._pushTransition, properties);
	}

	/**
	 * 退出一个屏幕
	 * @param id 屏幕id
	 * @param properties 希望传递的属性
	 */
	public function popScreen(properties:*=null):void
	{
		if(this.stack.length <= 1) return;
		this.stack.pop();
		var id:String = this.stack[this.stack.length - 1];
		this.showScreen(id, this._popTransition, properties);
	}

	/**
	 * 退出一个屏幕
	 * @param properties 
	 */
	public function popToRootScreen(properties:*=null):void
	{
		if(this.stack.length == 0) return;
		var id:String = this.stack[0];
		this.stack.length = 0;
		this.stack.push(id);
		this.showScreen(id, this._popTransition, properties);
	}

	/**
	 * 退出所有屏幕
	 */
	public function popAll():void
	{
		this.stack.length = 0;
		this.clearScreen(this._popTransition);
	}

	/**
	 * 获取栈中屏幕的数量
	 */
	public function stackCount():Number
	{
		return this.stack.length;
	}

	/**
	 * 获取根屏幕的id
	 */
	public function get rootScreenID():String
	{
		return this.stack[0];
	}

	/**
	 * 设置根屏幕的id
	 */
	public function set rootScreenID(id:String):void
	{
		this.stack.length = 0;
		this.stack.push(id);
		this.showScreen(id, null);
	}

	/**
	 * 推入的过渡动画
	 */
	public function get pushTransition():Function
	{
		return this._pushTransition;
	}

	/**
	 * 推入的过渡动画
	 */
	public function set pushTransition(value:Function):void
	{
		this._pushTransition = value;
	}

	/**
	 * 退出的过渡动画
	 */
	public function get popTransition():Function
	{
		return this._popTransition;
	}

	/**
	 * 退出的过渡动画
	 */
	public function set popTransition(value:Function):void
	{
		this._popTransition = value;
	}

	/**
     * 销毁
     * @param isDispose 是否释放screen item的内存
     */
	override public function destroySelf(isDispose:Boolean=false):void
	{
		super.destroySelf(isDispose);
		this.stack.length = 0;
		this.stack = null;
		this._pushTransition = null;
		this._popTransition = null;
		this.removeSelf();
		this.destroy();
	}
	
}
}