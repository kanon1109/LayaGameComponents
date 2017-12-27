package components 
{
import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Image;

/**
 * ...页数组件
 * @author ...Kanon
 */
public class PageIndicator extends Sprite 
{
	//间隔
	private var gap:Number;
	//当前选中的索引
	private var _selectedIndex:int = 0;
	//图片数组
	private var normalArr:Array;
	private var selectedArr:Array;
	//页数
	private var pageCount:int;
	public function PageIndicator(normalSkin:String, selectedSkin:String, pageCount:int, gap:Number = 30) 
	{
		this.normalArr = [];
		this.selectedArr = [];
		this.pageCount = pageCount;
		this.gap = gap;
		for (var i:int = 0; i < this.pageCount; i++) 
		{
			var normalImg:Image = new Image(normalSkin);
			var selectedImg:Image = new Image(selectedSkin);
			
			normalImg.anchorX = .5;
			normalImg.anchorY = .5;
			
			selectedImg.anchorX = .5;
			selectedImg.anchorY = .5;
			
			normalImg.x = i * gap;
			selectedImg.x = normalImg.x;
			selectedImg.y = normalImg.y;
			selectedImg.visible = false;
			
			this.addChild(normalImg);
			this.addChild(selectedImg);
			
			this.normalArr.push(normalImg);
			this.selectedArr.push(selectedImg);
			
			normalImg.tag = i;
			normalImg.on(Event.CLICK, this, pageClickHandler);
		}
		this.selectedIndex = 0;
	}
	
	/**
	 * 重置
	 */
	private function reset():void
	{
		var length:int = this.normalArr.length;
		for (var i:int = 0; i < length; i++) 
		{
			var normalImg:Image = this.normalArr[i];
			normalImg.visible = true;
		}
		length = this.selectedArr.length;
		for (i = 0; i < length; i++) 
		{
			var selectedImg:Image = this.selectedArr[i];
			selectedImg.visible = false;
		}
	}
	
	private function pageClickHandler(event:Event):void 
	{
		this.reset();
		var normalImg:Image = event.currentTarget as Image;
		var index:int = normalImg.tag;
		if (index > this.selectedIndex) this.selectedIndex++;
		else if (index < this.selectedIndex) this.selectedIndex--;
	}
	
	/**
	 * 销毁所有图片
	 */
	private function removeAllImg():void
	{
		for (var i:int = this.normalArr.length - 1; i >= 0; --i) 
		{
			var img:Image = this.normalArr[i];
			img.destroy();
			img.removeSelf();
			this.normalArr.splice(i, 1);
		}
		
		for (i = this.selectedArr.length - 1; i >= 0; --i) 
		{
			var img:Image = this.selectedArr[i];
			img.destroy();
			img.removeSelf();
			this.selectedArr.splice(i, 1);
		}
	}
	
	/**
	 * 销毁自己
	 */
	public function destroySelf():void
	{
		this.removeAllImg();
		this.destroy();
		this.removeSelf();
	}
	
	/**
	 * 当前选中的index
	 */
	public function get selectedIndex():int {return _selectedIndex; };
	public function set selectedIndex(value:int):void 
	{
		_selectedIndex = value;
		if (_selectedIndex < 0) _selectedIndex = 0;
		if (_selectedIndex > this.pageCount - 1) _selectedIndex = this.pageCount - 1;
		
		var normalImg:Image = this.normalArr[_selectedIndex];
		var selectedImg:Image = this.selectedArr[_selectedIndex];
		
		trace(_selectedIndex);
		normalImg.visible = false;
		selectedImg.visible = !normalImg.visible;
	}
}
}