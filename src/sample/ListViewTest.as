package sample 
{
import laya.display.Sprite;
/**
 * ...滚轮组件测试容器
 * @author ...Kanon
 */
public class ListViewTest extends SampleBase
{
	public function ListViewTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "listView tableView scrollView pageView";
	}
	
	/**
	 * 销毁
	 */
	override public function destroy():void
	{
		super.destroy();
	}
}
}