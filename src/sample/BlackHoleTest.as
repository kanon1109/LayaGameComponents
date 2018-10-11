package sample 
{
import components.SimpleButton;
import effect.BlackHole;
import laya.display.Sprite;
import laya.events.Event;
import laya.net.Loader;
import laya.resource.Texture;
import laya.ui.Image;
import laya.ui.Label;
import laya.utils.Handler;
import laya.utils.Tween;
import utils.Random;
/**
 * ...黑洞测试
 * @author Kanon
 */
public class BlackHoleTest extends SampleBase 
{
	private var addBtn:SimpleButton;
	private var sptArr:Array
	private var holeList:Array;
	private var txt:Label;
	public function BlackHoleTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "BlackHole";
		
		this.sptArr = [];
		this.holeList = [];
		
		this.txt = new Label("click stage");
		this.txt.color = "FFFFFF";
		this.txt.fontSize = 25;
		this.addChild(this.txt);
		this.txt.x = (stage.width - this.txt.displayWidth) / 2;
		this.txt.y = (stage.height - this.txt.displayHeight) / 2;

		var arr:Array = [];
		arr.push( { url:"res/blackHole.png", type:Loader.IMAGE } );
		arr.push({url:"res/btn.png", type:Loader.IMAGE});
		arr.push({url:"res/role.png", type:Loader.IMAGE});

		Laya.loader.load(arr, Handler.create(this, function():void
		{
			this.addBtn = new SimpleButton("res/btn.png", null, null, "添加物品");
			this.addChild(this.addBtn);
			this.addBtn.x = Laya.stage.width / 2;
			this.addBtn.y = Laya.stage.height - 100;
			this.addBtn.on(Event.CLICK, this, addBtnClickHandler);
			this.addBtnClickHandler();
			Laya.stage.on(Event.MOUSE_DOWN, this, onMouseDownHandler);
			this.frameLoop(1, this, loop);
			
		}), null, Loader.IMAGE)
	}
	
	private function addBtnClickHandler():void 
	{
		var tex:Texture = Laya.loader.getRes("res/role.png");
		var num:int = Random.randint(10, 20);
		for (var i:int = 1; i <= num; i++) 
		{
			var sp:Image = new Image();
			sp.source = tex;
			sp.pivotX = sp.width / 2;
			sp.pivotY = sp.height / 2;
			sp.x = Random.randnum(0, Laya.stage.width);
			sp.y = Random.randnum(0, Laya.stage.height);
			this.sptArr.push(sp);
			this.addChild(sp);
		}
	}
	
	private function loop():void 
	{
		var length:int = this.holeList.length;
		for (var i:int = length - 1; i >= 0; --i) 
		{
			var bh:BlackHole = this.holeList[i];
			if (bh) bh.update();
		}
	}
	
	private function onMouseDownHandler(event:Event):void 
	{
		var bh:BlackHole = new BlackHole(10, 300);
		bh.duration = 4000;
		bh.addHole(event.stageX, event.stageY);
		bh.addSubstanceList(this.sptArr);
		bh.inHoleCallBackHandler = Handler.create(this, function(spt:Sprite):void
		{
			var length:int = this.sptArr.length;
			for (var i:int = length - 1; i >= 0; --i) 
			{
				var s:Sprite = this.sptArr[i];
				if (s && s == spt) 
				{
					this.sptArr.splice(i, 1);
					break;
				}
			}
			spt.removeSelf();
			spt.destroy();
		}, null, false);
		
		bh.workOverCallBackHandler = Handler.create(this, function():void
		{
			//缩小效果
			var hold:Image = bh.useData;
			if (hold) Tween.to(hole, { scaleX:0, scaleY:0 }, 200);
		}, null, false);

		bh.overCallBackHandler = Handler.create(this, function():void
		{
			//删除
			var length:int = this.holeList.length;
			for (var i:int = length - 1; i >= 0; --i) 
			{
				var b:BlackHole = this.holeList[i];
				if (b && b == bh) 
				{
					var hold:Image = b.useData;
					if (hold)
					{
						Tween.clearAll(hold);
						hold.removeSelf();
						hold.destroy();
						b.useData = null;
					}
					b.destroy();
					this.holeList.splice(i, 1);
					break;
				}
			}
		}, null, false);
		
		this.holeList.push(bh);
		
		var hole:Image = new Image();
		hole.source = Laya.loader.getRes("res/blackHole.png");
		hole.pivotX = hole.width / 2;
		hole.pivotY = hole.height / 2;
		hole.x = event.stageX;
		hole.y = event.stageY;
		hole.scaleX = 0;
		hole.scaleY = 0;
		this.addChild(hole);
		bh.useData = hole;
		
		Tween.to(hole, { scaleX:1, scaleY:1 }, 200);
		Tween.to(hole, { rotation:360, repeat: -1 }, 2000, null, Handler.create(this, tweenCompleteHandler, [hole]));		
	}
	
	private function tweenCompleteHandler(hole:Image):void
	{
		hole.rotation = 0;
		Tween.to(hole, { rotation:360, repeat: -1 }, 2000, null, Handler.create(this, tweenCompleteHandler, [hole]));		
	}
	
	override public function destroySelf():void 
	{
		var length:int = this.holeList.length;
		for (var i:int = length - 1; i >= 0; --i) 
		{
			var bh:BlackHole = this.holeList[i];
			if (bh) 
			{
				var hold:Image = bh.useData;
				if (hold)
				{
					Tween.clearAll(hold);
					hold.removeSelf();
					hold.destroy();
					bh.useData = null;
				}
				bh.destroy();
			}
			this.holeList.splice(i, 1);
		}
		this.holeList = null;
		
		length = this.sptArr.length;
		for (i = length - 1; i >= 0; --i) 
		{
			var spt:Sprite = this.sptArr[i];
			if (spt) 
			{
				spt.removeSelf();
				spt.destroy();
			}
			this.sptArr.splice(i, 1);
		}
		this.sptArr = null;
		
		if (this.addBtn)
		{
			this.addBtn.off(Event.MOUSE_DOWN, this, addBtnClickHandler);
			this.addBtn.destroySelf();
			this.addBtn = null;
		}
		
		if (this.txt)
		{
			this.txt.removeSelf()
			this.txt.destroy();
			this.txt = null;
		}
		this.clearTimer(this, loop);
		Laya.stage.off(Event.MOUSE_DOWN, this, onMouseDownHandler);
		super.destroySelf();
	}
}
}