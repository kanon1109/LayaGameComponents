package components 
{
import laya.display.Sprite;
import laya.display.Text;
import laya.events.Event;
import laya.ui.Image;
import laya.ui.Label;
import laya.ui.Styles;
import laya.ui.UIUtils;

/**
 * ...简单按钮只有一态的按钮
 * @author ...Kanon
 */
public class SimpleButton extends Sprite 
{
	//标签
	public var tag:*;
	private var normalImg:Image;
	private var titleTxt:Text;
	public function SimpleButton(normal:String, label:String = "")
	{
		this.normalImg = new Image(normal);
		this.normalImg.mouseEnabled = false;
		this.addChild(this.normalImg);
		this.size(this.normalImg.width, this.normalImg.height);
		this.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
		this.on(Event.MOUSE_UP, this, onMouseUpHandler);
		this.label = label;
	}
	
	/**
	 * 创建文本
	 */
	private function createText():void
	{
		if (!this.titleTxt)
		{
			this.titleTxt = new Text();
			this.titleTxt.overflow = Text.HIDDEN;
			this.titleTxt.align = "center";
			this.titleTxt.valign = "middle";
			this.titleTxt.width = this.width;
			this.titleTxt.height = this.height;
		}
	}

	/**
	 * 按钮的文本内容。
	 */
	public function get label():String
	{
		return this.titleTxt ? this.titleTxt.text : null;
	}
	
	/**
	 * 实则按钮的文本内容
	 */
	public function set label(value:String):void 
	{
		if (!this.titleTxt && !value) return;
		this.createText();
		if (this.titleTxt.text != value)
		{
			value && !this.titleTxt.parent && this.addChild(this.titleTxt);
			this.titleTxt.text = (value + "").replace(/\\n/g, "\n");
		}
	}
	
	/**
	 * 表示按钮文本标签的边距。
	 */
	public function get labelPadding():String 
	{
		this.createText();
		return this.titleTxt.padding.join(",");
	}
	
	public function set labelPadding(value:String):void 
	{
		this.createText();
		this.titleTxt.padding = UIUtils.fillArray(Styles.labelPadding, value, Number);
	}
	
	/**
	 * 表示按钮文本标签的字体大小。
	 * @see laya.display.Text.fontSize()
	 */
	public function get labelSize():int 
	{
		this.createText();
		return this.titleTxt.fontSize;
	}
	
	public function set labelSize(value:int):void
	{
		this.createText();
		this.titleTxt.fontSize = value
	}

	/**
	 * 表示按钮各个状态下的文本颜色。
	 */
	public function get labelColors():String 
	{
		this.createText();
		return this.titleTxt.color;
	}
	
	public function set labelColors(value:String):void
	{
		this.createText();
		this.titleTxt.color = value;
	}
	
	/**
	 * <p>描边宽度（以像素为单位）。</p>
	 * 默认值0，表示不描边。
	 * @see laya.display.Text.stroke()
	 */
	public function get labelStroke():Number
	{
		this.createText();
		return this.titleTxt.stroke;
	}
	
	public function set labelStroke(value:Number):void
	{
		this.createText();
		this.titleTxt.stroke = value
	}
	
	/**
	 * <p>描边颜色，以字符串表示。</p>
	 * 默认值为 "#000000"（黑色）;
	 * @see laya.display.Text.strokeColor()
	 */
	public function get labelStrokeColor():String
	{
		this.createText();
		return this.titleTxt.strokeColor;
	}
	
	public function set labelStrokeColor(value:String):void 
	{
		this.createText();
		this.titleTxt.strokeColor = value
	}
	
	/**
	 * 表示按钮文本标签是否为粗体字。
	 * @see laya.display.Text.bold()
	 */
	public function get labelBold():Boolean 
	{
		this.createText();
		return this.titleTxt.bold;
	}
	
	public function set labelBold(value:Boolean):void 
	{
		this.createText();
		this.titleTxt.bold = value;
	}
	
	/**
	 * 表示按钮文本标签的字体名称，以字符串形式表示。
	 * @see laya.display.Text.font()
	 */
	public function get labelFont():String 
	{
		this.createText();
		return this.titleTxt.font;
	}
	
	public function set labelFont(value:String):void
	{
		this.createText();
		this.titleTxt.font = value;
	}
	
	/**标签对齐模式，默认为居中对齐。*/
	public function get labelAlign():String
	{
		this.createText()
		return this.titleTxt.align;
	}
	
	public function set labelAlign(value:String):void 
	{
		this.createText()
		this.titleTxt.align = value;
	}
	
	/**
	 * 按钮文本标签 <code>Text</code> 控件。
	 */
	public function get text():Text
	{
		this.createText();
		return this.titleTxt;
	}
	
	private function onMouseUpHandler():void 
	{
		this.normalImg.scale(1, 1, false);
		this.normalImg.x = 0;
		this.normalImg.y = 0;
		if (this.titleTxt)
		{
			this.titleTxt.scale(1, 1, false);
			this.titleTxt.x = 0;
			this.titleTxt.y = 0;
		}
	}
	
	private function onMouseDownHandler():void 
	{
		this.normalImg.scale(.95, .95, false);
		this.normalImg.x = (1 - this.normalImg.scaleX) * this.normalImg.width / 2;
		this.normalImg.y = (1 - this.normalImg.scaleY) * this.normalImg.height / 2;
		if (this.titleTxt)
		{
			this.titleTxt.scale(.95, .95, false);
			this.titleTxt.x = (1 - this.titleTxt.scaleX) * this.titleTxt.width / 2;
			this.titleTxt.y = (1 - this.titleTxt.scaleY) * this.titleTxt.height / 2;
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		if (this.normalImg)
		{
			this.normalImg.removeSelf();
			this.normalImg = null;
		}
		
		if (this.text)
		{
			this.text.removeSelf();
			this.text = null;
		}
		
		this.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
		this.off(Event.MOUSE_UP, this, onMouseUpHandler);
		
		this.destroy();
		this.removeSelf();
	}
	
}
}