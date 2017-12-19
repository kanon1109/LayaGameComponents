package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Button;
import laya.ui.Image;
import laya.utils.Handler;

/**
 * ...切换标签
 * @author ...Kanon
 */
public class TabBar extends Sprite 
{
	private var normalImgAry:Array;
	private var selectedImgAry:Array;
	private var btnAry:Array;
	private var dsableImgAry:Array;
	private var dsableAry:Array;
	//点击回调
	public var tabClickHandler:Handler;
	//屏蔽回调
	public var tabDsableClickHandler:Handler;
	public function TabBar() 
	{

	}
	
	/**
	 * 初始化
	 * @param	num					数量
	 * @param	gap					间隔
	 * @param	normal				普通状态的资源名字前缀
	 * @param	selected			按下状态的资源名字前缀
	 * @param	dsable				不启用时的状态
	 * @param	clickCallBack		点击回调
	 * @param	dsableClickCallBack	点击屏蔽回调
	 */
	public function init(num:int, 
						gap:Number, 
						normal:String, 
						selected:String, 
						dsable:String = "", 
						clickCallBack:Handler = null, 
						dsableClickCallBack:Handler = null):void
	{
		this.btnAry = [];
		this.normalImgAry = [];
		this.selectedImgAry = [];
		this.dsableImgAry = [];
		this.dsableAry = [];
		
		this.tabClickHandler = clickCallBack;
		this.tabDsableClickHandler = dsableClickCallBack;
		for (var i:int = 0; i < num; i++) 
		{
			var normalImg:Image = new Image(normal);
			normalImg.x = i * (normalImg.width + gap);
			this.addChild(normalImg);
			this.normalImgAry.push(normalImg);
			
			var selectedImg:Image = new Image(selected);
			selectedImg.x = normalImg.x;
			this.addChild(selectedImg);
			this.selectedImgAry.push(selectedImg);
			
			if (dsable)
			{
				var dsableImg:Image = new Image(dsable);
				dsableImg.x = normalImg.x;
				this.addChild(dsableImg);
				this.dsableImgAry.push(dsableImg);
			}
			
			var btn:Button = new Button();
			btn.tag = i;
			btn.size(normalImg.width, normalImg.height);
			btn.x = normalImg.x;
			btn.y = normalImg.y;
			btn.on(Event.CLICK, this, btnClickHandler);
			this.addChild(btn);
			this.btnAry.push(btn);
			this.dsableAry.push(false);
		}
		this.resetAllBtn();
	}
	
	private function btnClickHandler(event:Event):void 
	{
		var btn:Button = event.currentTarget as Button;
		this.setSelectedByIndex(btn.tag);
	}
	
	/**
	 * 重置按钮点击
	 */
	private function resetAllBtn():void
	{
		var length:int = this.normalImgAry.length;
		for (var i:int = 0; i < length; i++) 
		{
			if (!this.dsableAry[i])
				this.normalImgAry[i].visible = true;
		}
		
		length = this.selectedImgAry.length;
		for (i = 0; i < length; i++) 
		{
			if (!this.dsableAry[i])
				this.selectedImgAry[i].visible = false;
		}
		
		length = this.dsableImgAry.length;
		for (i = 0; i < length; i++) 
		{
			if (!this.dsableAry[i])
				this.dsableImgAry[i].visible = false;
		}
		
		length = this.btnAry.length;
		for (i = 0; i < length; i++) 
		{
			var btn:Button = this.btnAry[i];
			btn.mouseEnabled = true;
		}
	}
	
	/**
	 * 设置选中状态的位置偏移
	 * @param	x	x偏移
	 * @param	y	y偏移
	 */
	public function setSelectedPosOffset(x:Number, y:Number):void
	{
		var length:int = this.selectedImgAry.length;
		for (var i:int = 0; i < length; i++) 
		{
			var selectedImg:Image = this.selectedImgAry[i];
			selectedImg.x += x;
			selectedImg.y += y;
		}
	}
	
	/**
	 * 根据索引设置选中
	 * @param	index	索引
	 */
	public function setSelectedByIndex(index:int):void
	{
		if (index < 0 || index > this.selectedImgAry.length - 1) return;
		if (!this.dsableAry[index])
		{
			this.resetAllBtn();
			this.normalImgAry[index].visible = false;
			this.selectedImgAry[index].visible = true;
			var btn:Button = this.btnAry[index];
			btn.mouseEnabled = false;
			if (this.tabClickHandler)
				this.tabClickHandler.runWith(index);
		}
		else
		{
			if (this.tabDsableClickHandler)
				this.tabDsableClickHandler.runWith(index);
		}
	}
	
	/**
	 * 根据索引设置是否启用
	 * @param	index		索引
	 * @param	flag		是否启用
	 */
	public function setDsableByIndex(index:int, flag:Boolean):void
	{
		if (index < 0 || index > this.dsableImgAry.length - 1) return;
		this.normalImgAry[index].visible = false;
		this.selectedImgAry[index].visible = false;
		this.dsableImgAry[index].visible = true;
		var btn:Button = this.btnAry[index];
		btn.mouseEnabled = true;
		this.dsableAry[index] = true;
	}
}
}