package effect 
{
import laya.display.Text;
/**
 * ...滚动文本效果
 * @author Kanon
 */
public class TextScroll 
{
	private var txt:Text;
	private var str:String;
	private var index:int;
	public function TextScroll(txt:Text) 
	{
		this.txt = txt;
	}
	
	
	public function show(str:String, delay:int):void
	{
		this.str = str;
		this.index = 0;
		if (this.txt) this.txt.text = "";
		Laya.timer.loop(delay, this, timerHandler);
	}
	
	private function timerHandler():void 
	{
		this.index++;
		if (this.txt) this.txt.text = this.str.substr(0, this.index);
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		if (this.txt)
		{
			this.txt.removeSelf();
			this.txt.destroy();
			this.txt = null;
		}
		Laya.timer.clear(this, timerHandler);
	}
}
}