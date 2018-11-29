package sample 
{
import effect.TextScroll;
import laya.display.Text;
/**
 * ...滚动文本测试
 * @author Kanon
 */
public class TextScrollTest extends SampleBase 
{
	private var ts:TextScroll;
	private var txt:Text;
	public function TextScrollTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "TextScrollTest";
		this.txt = new Text();
		this.txt.fontSize = 25;
		this.txt.color = "#FFFFFF";
		this.txt.text = "this is text scroll";
		this.txt.width = 450;
		this.txt.x = (Laya.stage.designWidth - this.txt.width) / 2;
		this.txt.y = 160;
		this.txt.wordWrap = true;
		this.addChild(this.txt);
		
		this.ts = new TextScroll(this.txt);
		this.ts.show("武将等级与装备等级的上限是根据玩家等级的高低而限制的，玩家等级越高，相对武将等级与装备等级的上限也就越高。", 100);
	}
	
	override public function destroySelf():void 
	{
		super.destroySelf();
		if (this.ts)
		{
			this.ts.destroy();
			this.ts = null;
		}
		
		if (this.txt)
		{
			this.txt.removeSelf();
			this.txt.destroy();
			this.txt = null;
		}
	}
}
}