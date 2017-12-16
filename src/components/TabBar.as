package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Button;
import laya.ui.Image;

/**
 * ...切换标签
 * @author ...Kanon
 */
public class TabBar extends Sprite 
{
	private var normalAry:Array;
	private var selectedAry:Array;
	private var btnAry:Array;
	public function TabBar() 
	{

	}
	
	/**
	 * 初始化
	 * @param	num			数量
	 * @param	gap			间隔
	 * @param	normal		普通状态的资源名字前缀
	 * @param	selected	按下状态的资源名字前缀
	 */
	public function init(num:int, gap:Number, normal:String, selected:String):void
	{
		this.btnAry = [];
		this.normalAry = [];
		this.selectedAry = [];
		for (var i:int = 0; i < num; i++) 
		{
			var normalImg:Image = new Image(normal);
			normalImg.x = i * (normalImg.width + gap);
			this.addChild(normalImg);
			this.normalAry.push(normalImg);
			
			var selectedImg:Image = new Image(selected);
			selectedImg.x = normalImg.x;
			this.addChild(selectedImg);
			this.selectedAry.push(selectedImg);

			var btn:Button = new Button();
			btn.tag = i;
			btn.size(normalImg.width, normalImg.height);
			btn.x = normalImg.x;
			btn.y = normalImg.y;
			btn.on(Event.CLICK, this, btnClickHandler);
			this.addChild(btn);
			this.btnAry.push(btn);
		}
		
		this.resetAllBtn();
	}
	
	private function btnClickHandler(event:Event):void 
	{
		var btn:Button = event.currentTarget as Button;
		var normalImg:Image = this.normalAry[btn.tag];
		var selectedImg:Image = this.selectedAry[btn.tag];
		
		this.resetAllBtn();
		normalImg.visible = false;
		selectedImg.visible = !normalImg.visible;
		btn.mouseEnabled = false;
	}
	
	/**
	 * 重置按钮点击
	 */
	private function resetAllBtn():void
	{
		for (var i:int = 0; i < this.normalAry.length; i++) 
		{
			this.normalAry[i].visible = true;
		}
		
		for (var i:int = 0; i < this.selectedAry.length; i++) 
		{
			this.selectedAry[i].visible = false;
		}
		
		for (var i:int = 0; i < this.btnAry.length; i++) 
		{
			var btn:Button = this.btnAry[i];
			btn.mouseEnabled = true;
		}
	}
	
	/**
	 * 根据索引设置选中
	 * @param	index	索引
	 */
	public function setSelectedByIndex(index:int):void
	{
		if (index < 0 || index > this.selectedAry.length - 1) return;
		this.resetAllBtn();
		this.normalAry[index].visible = false;
		this.selectedAry[index].visible = true;
		var btn:Button = this.btnAry[index];
		btn.mouseEnabled = false;
	}
}
}