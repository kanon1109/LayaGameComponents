package sample 
{
import controls.ScreenNavigatorItem;
import laya.display.Sprite;
import laya.events.Event;
import laya.net.Loader;
import laya.utils.Handler;
import manager.StackScreenManager;
import motion.Slide;
/**
 * ...屏幕导航测试
 * @author Kanon
 */
public class ScreenNavigatorTest extends SampleBase 
{
	
	public function ScreenNavigatorTest() 
	{
		super();
	}
	
	/**
	 * 初始化
	 */
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "ScreenNavigatorTest";
		var arr:Array = [];
		arr.push( { url:"res/btn.png", type:Loader.IMAGE } );
		Laya.loader.load(arr, Handler.create(this, function():void
		{
			trace("inini");
			var screen1:Screen = new Screen("screen 1", "#62CCFF");
			var screen2:Screen = new Screen("screen 2", "#FD64FD");
			var screen3:Screen = new Screen("screen 3", "#ED749E");
			var screen4:Screen = new Screen("root screen", "#9FEA77");
			
			screen1.nextBtn.on(Event.CLICK, this, function():void
			{
				StackScreenManager.pushScreen("screen2");
			});
			
			screen1.prevBtn.on(Event.CLICK, this, function():void
			{
				StackScreenManager.popScreen();
			});
			
			screen2.nextBtn.on(Event.CLICK, this, function():void
			{
				StackScreenManager.pushScreen("screen3");
			});
			
			screen2.prevBtn.on(Event.CLICK, this, function():void
			{
				StackScreenManager.popScreen();
			});
			
			screen3.nextBtn.on(Event.CLICK, this, function():void
			{
				StackScreenManager.popToRootScreen();
			});
			
			screen3.prevBtn.on(Event.CLICK, this, function():void
			{
				StackScreenManager.popScreen();
			});
			
			screen4.nextBtn.on(Event.CLICK, this, function():void
			{
				StackScreenManager.pushScreen("screen1");
			});
			
			screen4.prevBtn.on(Event.CLICK, this, function():void
			{
				StackScreenManager.popScreen();
			});
			
			StackScreenManager.init(Sprite(this));
			StackScreenManager.addScreen("screen1", new ScreenNavigatorItem(screen1));
			StackScreenManager.addScreen("screen2", new ScreenNavigatorItem(screen2));
			StackScreenManager.addScreen("screen3", new ScreenNavigatorItem(screen3));
			StackScreenManager.addScreen("screen4", new ScreenNavigatorItem(screen4));
			StackScreenManager.rootScreenID = "screen4";
			StackScreenManager.pushTransition = Slide.createSlideLeftTransition();
			StackScreenManager.popTransition = Slide.createSlideRightTransition();
			
		}), null, Loader.IMAGE);
	}
	
	override public function destroySelf():void 
	{
		StackScreenManager.destroySelf(true);
		super.destroySelf();
	}
}
}
import components.SimpleButton;
import laya.display.Sprite;
import laya.ui.Label;
class Screen extends Sprite
{	
	private var label:Label;
	public var nextBtn:SimpleButton;
	public var prevBtn:SimpleButton;
	private var bg:Sprite;
	public function Screen(name:String, color:*)
	{
		this.bg = new Sprite();
		this.bg.graphics.drawRect(0, 0, Laya.stage.width, Laya.stage.height, color);
		this.addChild(this.bg);
		
		this.label = new Label(name);
		this.label.x = 20;
		this.label.y = 80;
		this.label.fontSize = 50;
		this.label.color = "#FFFF00";
		this.addChild(this.label);
		
		this.nextBtn = new SimpleButton("res/btn.png");
		this.nextBtn.label = "下一个场景";
		this.nextBtn.y = 200;
		this.addChild(this.nextBtn);
		
		this.prevBtn = new SimpleButton("res/btn.png");
		this.prevBtn.x = Laya.stage.width - this.prevBtn.width;
		this.prevBtn.y = 200;
		this.prevBtn.label = "上一个场景";
		this.addChild(this.prevBtn);
	}
	
	/**
	 * 销毁
	 */
	public function destroySelf():void
	{
		this.label.removeSelf();
		this.label.destroy();
		this.label = null;
		
		this.nextBtn.destroySelf();
		this.nextBtn = null;
		
		this.nextBtn.destroySelf();
		this.nextBtn = null;
		
		this.bg.removeSelf();
		this.bg.destroy();
		this.nextBtn = null;
	}
}