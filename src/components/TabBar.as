package components 
{
import laya.display.Sprite;

/**
 * ...切换标签
 * @author ...Kanon
 */
public class TabBar extends Sprite 
{
	private var unselectedAry:Array;
	private var selectedAry:Array;
	public function TabBar() 
	{
		this.unselectedAry = [];
		this.selectedAry = [];
	}
	
	
	public function init(num:int):void
	{
		
	}
	
}
}