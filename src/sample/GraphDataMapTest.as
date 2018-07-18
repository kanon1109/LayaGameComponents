package sample 
{
import components.GraphDataMap;
/**
 * ...图形数据图测试
 * @author ...Kanon
 */
public class GraphDataMapTest extends SampleBase 
{
	private var gdm:GraphDataMap;
	public function GraphDataMapTest() 
	{
		super()
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "GraphDataMap";
		
		this.gdm = new GraphDataMap();
		this.gdm.x = 300;
		this.gdm.y = 200;
		this.addChild(this.gdm);
		this.gdm.showDraw = true;
		this.gdm.count = 5;
		this.gdm.maxValue = 5;
		this.gdm.drawGraph([5, 2, 4, 3, 3]);
	}
	
	override public function destroySelf():void 
	{
		if (this.gdm)
		{
			this.gdm.destroySelf();
			this.gdm = null;
		}
		super.destroySelf();
	}
}
}