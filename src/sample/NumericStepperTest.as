package sample 
{
import components.NumericStepper;
import laya.net.Loader;
import laya.utils.Handler;
/**
 * ...计数器测试
 * @author Kanon
 */
public class NumericStepperTest extends SampleBase 
{
	private var ns:NumericStepper;
	public function NumericStepperTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "NumericStepper";
		var arr:Array = [];
		arr.push({url:"res/inputBg.png", type:Loader.IMAGE});
		arr.push({url:"res/numericStepperBg.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	
	private function loadImgComplete():void
	{
		this.ns = new NumericStepper("res/numericStepperBg.png", 
									 "res/numericStepperBg.png", 
									 "res/inputBg.png", 20, "#FFFFFF", 3);
		this.ns.x = 100;
		this.ns.y = 200;
		this.ns.maxValue = 100;
		this.ns.minValue = -1;
		this.ns.value = this.ns.minValue;
		this.ns.step = 2;
		this.addChild(this.ns);
	}
	
	/**
	 * 销毁
	 */
	override public function destroySelf():void 
	{
		if (this.ns)
		{
			this.ns.destroySelf();
			this.ns = null;
		}
		super.destroySelf();
	}
	
}
}