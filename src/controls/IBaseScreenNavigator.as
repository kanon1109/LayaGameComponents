package controls 
{
/**
 * ...基础导航接口
 * @author Kanon
 */
public interface IBaseScreenNavigator 
{
	/**
	 * 添加一个screen
	 * @param id 屏幕id
	 * @param item screen item
	 */
	function addScreen(id:String, item:ScreenNavigatorItem):void; 

	/**
	 * 获取当前的一个screen item对象
	 * @param id 屏幕id
	 */
	function getScreen(id:String):ScreenNavigatorItem;

	/**
	 * 根据id判断是否存在屏幕
	 * @param id 屏幕id
	 */
	function hasScreen(id:String):Boolean;

	/**
	 * 显示一个screen
	 * @param id 屏幕id
	 * @param transition 过渡方法
	 * @param properties 自定义属性
	 */
	function showScreen(id:String, transition:Function=null, properties:*=null):void;

	/**
	 * 移出当前的screen
	 * @param transition 过渡方法
	 */
	function clearScreen(transition:Function=null):void;

	/**
	 * 删除一个screen
	 * @param id 屏幕id
	 */
	function removeScreen(id:String):ScreenNavigatorItem;

	/**
     * 销毁
     * @param isDispose 是否释放screen item的内存
     */
	function destroySelf(isDispose:Boolean=false):void;
}
}