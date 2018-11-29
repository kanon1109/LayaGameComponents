package components
{
import components.scroll.ScrollView;
import laya.display.Text;
/**
* ...滚动文本
* @author Kanon
*/
public class ScrollText extends ScrollView
{
	private var txt:Text;
	private const offsetHeight:Number = 5;
	public function ScrollText()
	{
		super();
		this.isHorizontal = false;
		this.txt = new Text();
		this.txt.wordWrap = true;
		this.addToContent(this.txt);
	}
	
	/**
	 * 设置可见高宽
	 * @param	width	宽度
	 * @param	height	高度
	 */
	override public function setViewSize(width:Number, height:Number):void 
	{
		super.setViewSize(width, height);
		if (this.txt)
			this.txt.width = width;
	}
	
	/**
	 * 获取原生文本
	 */
	public function get nativeText():Text
	{
		return this.txt;
	}
	
	/**
	 * 获取文本
	 */
	public function get text():String
	{
		return this.txt.text;
	}
	
	/**
	 * 设置文本
	 */
	public function set text(str:String):void
	{
		if (this.txt)
		{
			this.txt.text = str;
			this.setContentSize(this.width, this.txt.height + this.offsetHeight);
		}
	}
	
	/**
	 * 销毁
	 */
	override public function destroySelf():void 
	{
		super.destroySelf();
		if (this.txt)
		{
			this.txt.removeSelf();
			this.txt.destroy();
			this.txt = null;
		}
	}
}

}