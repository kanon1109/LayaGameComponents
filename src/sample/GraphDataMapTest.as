package sample 
{
import components.GraphDataMap;
import laya.events.Event;
import utils.Random;
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
		this.gdm.duration = 200;
		this.gdm.isShowAnim = false;
		this.gdm.dataPointRadius = 1;
		this.gdm.drawGraph([5, 2, 4, 3, 3]);
		
		stage.on(Event.CLICK, this, clickHandler);
	}
	
	private function clickHandler():void 
	{
		this.gdm.drawGraph([Random.randint(1, 5), Random.randint(1, 5), Random.randint(0, 5), Random.randint(0, 5), Random.randint(1, 5)]);
	}
	
	override public function destroySelf():void 
	{
		stage.off(Event.CLICK, this, clickHandler);
		if (this.gdm)
		{
			this.gdm.destroySelf();
			this.gdm = null;
		}
		super.destroySelf();
	}
}
}