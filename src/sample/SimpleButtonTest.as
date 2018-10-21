package sample 
{
	import components.SimpleButton;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
/**
 * ...按钮测试
 * @author Kanon
 */
public class SimpleButtonTest extends SampleBase 
{
	private var btn1:SimpleButton;
	private var btn2:SimpleButton;
	private var btn3:SimpleButton;
	public function SimpleButtonTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "SimpleButton";
		
		var arr:Array = [];
		arr.push({url:"res/btn.png", type:Loader.IMAGE});
		arr.push({url:"res/btnSelected.png", type:Loader.IMAGE});
		arr.push({url:"res/btnDisable.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.btn1 = new SimpleButton("res/btn.png", 
									 null,
									 null, 
									 "单个按钮");
		
		this.btn2 = new SimpleButton("res/btn.png",
									 "res/btnSelected.png",
									 "res/btnDisable.png", 
									 "多态按钮");
									 
		this.btn3 = new SimpleButton("res/btn.png", 
									 "res/btnSelected.png",
									 "res/btnDisable.png", 
									 "不启用");
									 
		this.addChild(this.btn1);
		this.addChild(this.btn2);
		this.addChild(this.btn3);
		
		this.btn1.x = 200;
		this.btn1.y = 450;
		
		this.btn2.x = this.btn1.x + this.btn1.width + 50;
		this.btn3.x = this.btn2.x + this.btn2.width + 50;
		this.btn2.y = this.btn1.y;
		this.btn3.y = this.btn2.y;
		
		this.btn1.disable = true;
		this.btn3.disable = true;
		
		this.btn2.on(Event.CLICK, this, btnClickHandler);
	}
	
	private function btnClickHandler():void 
	{
		this.btn1.disable = false;
	}
	
	/**
	 * 销毁
	 */
	override public function destroySelf():void 
	{
		if (this.btn1)
		{
			this.btn1.destroySelf();
			this.btn1 = null;
		}
		if (this.btn2)
		{
			this.btn2.off(Event.CLICK, this, btnClickHandler);
			this.btn2.destroySelf();
			this.btn2 = null;
		}
		if (this.btn3)
		{
			this.btn3.destroySelf();
			this.btn3 = null;
		}
		super.destroySelf();
	}
}
}