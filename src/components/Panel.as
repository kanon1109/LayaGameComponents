package components 
{
import laya.display.Sprite;
import laya.ui.Image;
import laya.ui.Label;
/**
 * ...面板
 * @author ...Kanon
 */
public class Panel extends Sprite 
{
	//标题文本
	public var titleTxt:Label;
	//内容文本
	public var contentTxt:Label;
	//标题图片
	private var titleBg:Image;
	//底图
	private var contentBg:Image;
	public function Panel(contentSkin:String, contentStr:String = "", titleSkin:String = "" , titleStr:String = "") 
	{
		this.contentBg = new Image(contentSkin);
		this.addChild(this.contentBg);
		
		this.titleBg = new Image(titleSkin);
		this.addChild(this.titleBg);
		this.contentBg.y = this.titleBg.height;
		
		this.titleTxt = new Label(titleStr);
		this.titleTxt.color = "#FFFFFF"
		this.titleTxt.align = "center";
		this.titleTxt.valign = "middle";
		this.titleTxt.fontSize = 30;
		this.titleTxt.x = (this.titleBg.width - this.titleTxt.width) / 2;
		this.titleTxt.y = (this.titleBg.height - this.titleTxt.height) / 2;
		this.addChild(this.titleTxt);
		
		this.contentTxt = new Label(contentStr);
		this.contentTxt.color = "#FFFFFF"
		this.contentTxt.align = "center";
		this.contentTxt.valign = "middle";
		this.contentTxt.fontSize = 25;
		this.contentTxt.x = (this.contentBg.width - this.contentTxt.width) / 2;
		this.contentTxt.y = this.contentBg.y + (this.contentBg.height - this.contentTxt.height) / 2;
		this.addChild(this.contentTxt);
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		if (this.titleBg)
		{
			this.titleBg.removeSelf();
			this.titleBg.destroy();
			this.titleBg = null;
		}
		
		if (this.contentBg)
		{
			this.contentBg.removeSelf();
			this.contentBg.destroy();
			this.contentBg = null;
		}
		
		if (this.titleTxt)
		{
			this.titleTxt.removeSelf();
			this.titleTxt.destroy();
			this.titleTxt = null;
		}
		
		if (this.contentTxt)
		{
			this.contentTxt.removeSelf();
			this.contentTxt.destroy();
			this.contentTxt = null;
		}
		
		this.destroy();
		this.removeSelf();
	}
}
}