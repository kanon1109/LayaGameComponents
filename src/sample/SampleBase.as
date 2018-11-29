package sample 
{
import laya.display.Sprite;
import laya.ui.Label;

/**
 * ...列子基类
 * @author ...Kanon
 */
public class SampleBase extends Sprite 
{
	protected var titleLabel:Label;
	public function SampleBase() 
	{
	}
	
	/**
	 * 初始化
	 */
	public function init():void
	{
		if (!this.titleLabel)
		{
			this.titleLabel = new Label();
			this.titleLabel.color = "#FFFFFF";
			this.titleLabel.fontSize = 30;
			this.titleLabel.x = 5;
			this.titleLabel.bold = true;
		}
		this.addChild(this.titleLabel);
	}
	
	public function destroySelf():void
	{
		trace("destroySelf")
		trace(titleLabel)
		trace("-----------")
		if (this.titleLabel)
		{
			this.titleLabel.removeSelf();
			this.titleLabel = null;
		}
		this.removeSelf();
	}
}
}