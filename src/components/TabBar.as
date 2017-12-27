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
	private var pressedImgAry:Array;
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
	 * @param	normalSkin			普通状态的资源
	 * @param	selectedSkin		选中状态的资源
	 * @param	pressedSkin			按下状态的资源
	 * @param	dsableSkin			不启用时的状态
	 * @param	clickCallBack		点击回调
	 * @param	dsableClickCallBack	点击屏蔽回调
	 */
	public function init(num:int, 
						gap:Number, 
						normalSkin:String, 
						selectedSkin:String, 
						pressedSkin:String = "",
						dsableSkin:String = "", 
						clickCallBack:Handler = null, 
						dsableClickCallBack:Handler = null):void
	{
		this.btnAry = [];
		this.normalImgAry = [];
		this.pressedImgAry = [];
		this.selectedImgAry = [];
		this.dsableImgAry = [];
		this.dsableAry = [];
		
		this.tabClickHandler = clickCallBack;
		this.tabDsableClickHandler = dsableClickCallBack;
		for (var i:int = 0; i < num; i++) 
		{
			var normalImg:Image = new Image(normalSkin);
			normalImg.x = i * (normalImg.width + gap);
			this.addChild(normalImg);
			this.normalImgAry.push(normalImg);
			
			var selectedImg:Image = new Image(selectedSkin);
			selectedImg.x = normalImg.x;
			this.addChild(selectedImg);
			this.selectedImgAry.push(selectedImg);
			
			if (pressedSkin)
			{
				var pressedImg:Image = new Image(pressedSkin);
				pressedImg.x = normalImg.x;
				this.addChild(pressedImg);
				this.pressedImgAry.push(pressedImg);
			}
			
			if (dsableSkin)
			{
				var dsableImg:Image = new Image(dsableSkin);
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
			btn.on(Event.MOUSE_DOWN, this, btnMouseDownHandler);
			btn.on(Event.MOUSE_OUT, this, btnMouseOutHandler);
			this.addChild(btn);
			this.btnAry.push(btn);
			this.dsableAry.push(false);
		}
		this.resetAllBtn();
	}
	
	private function btnMouseOutHandler(event:Event):void 
	{
		if (this.pressedImgAry.length > 0)
		{
			var btn:Button = event.currentTarget as Button;
			var index:int = btn.tag;
			var normalImg:Image = this.normalImgAry[index];
			var pressedImg:Image = this.pressedImgAry[index];
			normalImg.visible = true;
			pressedImg.visible = false;
		}
	}
	
	private function btnMouseDownHandler(event:Event):void 
	{
		if (this.pressedImgAry.length > 0)
		{
			var btn:Button = event.currentTarget as Button;
			var index:int = btn.tag;
			var normalImg:Image = this.normalImgAry[index];
			var pressedImg:Image = this.pressedImgAry[index];
			normalImg.visible = false;
			pressedImg.visible = true;
		}
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
		
		length = this.pressedImgAry.length;
		for (i = 0; i < length; i++) 
		{
			if (!this.dsableAry[i])
				this.pressedImgAry[i].visible = false;
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
		this.normalImgAry[index].visible = !flag;
		this.selectedImgAry[index].visible = false;
		this.dsableImgAry[index].visible = flag;
		this.dsableAry[index] = flag;
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		var length:int = this.normalImgAry.length;
		var img:Image;
		for (var i:int = 0; i < length; i++) 
		{
			img = this.normalImgAry[i];
			img.destroy();
			img.removeSelf();
		}
		
		length = this.selectedImgAry.length;
		for (i = 0; i < length; i++) 
		{
			img = this.selectedImgAry[i];
			img.destroy();
			img.removeSelf();
		}
		
		length = this.pressedImgAry.length;
		for (i = 0; i < length; i++) 
		{
			img = this.pressedImgAry[i];
			img.destroy();
			img.removeSelf();
		}
		
		length = this.dsableImgAry.length;
		for (i = 0; i < length; i++) 
		{
			img = this.dsableImgAry[i];
			img.destroy();
			img.removeSelf();
		}
		
		length = this.btnAry.length;
		for (i = 0; i < length; i++) 
		{
			var btn:Button = this.btnAry[i];
			btn.off(Event.CLICK, this, btnClickHandler);
			btn.off(Event.MOUSE_DOWN, this, btnMouseDownHandler);
			btn.off(Event.MOUSE_OUT, this, btnMouseOutHandler);
			img.destroy();
			btn.removeSelf();
		}
		
		this.normalImgAry = null;
		this.selectedImgAry = null;
		this.dsableImgAry = null;
		this.btnAry = null;
		
		this.tabClickHandler = null;
		this.tabDsableClickHandler = null;
		this.removeSelf();
		this.destroy();
	}
}
}