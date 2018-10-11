package effect 
{
import laya.display.Sprite;
import laya.utils.Handler;
import utils.MathUtil;
/**
 * ...黑洞效果
 * 黑洞持续时间结束后会进入衰减期，衰减期内不会发生吸入。
 * @author Kanon
 */
public class BlackHole
{
	//引力
	private var g:Number;
	//黑洞作用半径范围
	private var range:Number;
	//旋转的角速度
	private var angleSpeed:Number;
	//物质列表存放被吸引的物质
	private var subList:Array;
	//黑洞位置
	private var posX:Number;
	private var posY:Number;
	//是否开启黑洞
	private var isStart:Boolean;
	//是否结束
	private var isOver:Boolean;
	//最短距离
	private var minDis:int = 15;
	//摩擦力
	private var f:Number = .99;
	//持续时间（毫秒）
	private var _duration:int;
	//结束后缓动时间（毫秒）
	private var overDuration:int = 2000;
	//-------public--------
	//存放用户数据
	public var useData:*;
	//进入黑洞后的回调
	public var inHoleCallBackHandler:Handler;
	//黑洞作用结束后的回调
	public var workOverCallBackHandler:Handler;
	//黑洞效果结束后的回调
	public var overCallBackHandler:Handler;
	public function BlackHole(g:Number = 10, 
							  range:Number = 400, 
							  angleSpeed:Number = 5, 
							  duration:int = 2000) 
	{
		this.g = g;
		this.f = f;
		this.range = range;
		this.angleSpeed = angleSpeed;
		this.duration = duration;
	}
	
	/**
	 * 添加黑洞
	 * @param	x	黑洞位置x
	 * @param	y	黑洞位置y
	 */
	public function addHole(x:Number, y:Number):void
	{
		this.posX = x;
		this.posY = y;
		this.isStart = true;
		this.isOver = false;
	}
	
	/**
	 * 添加被吸引的物质列表
	 * @param	ary		物质列表
	 */
	public function addSubstanceList(ary:Array):void
	{
		this.subList = ary;
	}
	
	/**
	 * 更新
	 */
	public function update():void
	{
		if (!this.isStart) return;
		if (!this.subList) return;
		var length:int = this.subList.length;
		var spt:Sprite;
		var dis:Number;
		for (var i:int = length - 1; i >= 0; i--) 
		{
			spt = this.subList[i];
			dis = MathUtil.distance(this.posX, this.posY, spt.x, spt.y);
			if (dis <= range)
			{
				var speed:Number = this.g * (1 - dis / range);
				if (!this.isOver)
				{
					if (dis <= this.minDis) 
					{
						//小于最短距离
						//这里外部可能将物体销毁，所以循环下面不做处理。
						if (this.inHoleCallBackHandler)
							this.inHoleCallBackHandler.runWith(spt);
						continue;
					}
					if (speed > dis) speed = dis;
				}
				else
				{
					//黑洞生命周期结束
					speed = 0;
					this.angleSpeed = this.angleSpeed * this.f;
				}
				//如果在影响范围内
				var dx:Number = spt.x - this.posX; 
				var dy:Number = spt.y - this.posY;
				var radians:Number = Math.atan2(dy, dx);
				var vx:Number = speed * Math.cos(radians);
				var vy:Number = speed * Math.sin(radians);
				spt.x -= vx;
				spt.y -= vy;
				//算出角速度
				radians += Math.PI / 2;
				vx = this.angleSpeed * Math.cos(radians);
				vy = this.angleSpeed * Math.sin(radians);
				spt.x += vx;
				spt.y += vy;
				var angle:Number = radians / Math.PI * 180;
				spt.rotation = angle;
			}
		}
	}
	
	private function workCompleteHandler():void 
	{
		//黑洞吸引结束
		this.isOver = true;
		if (this.workOverCallBackHandler)
			this.workOverCallBackHandler.run();
	}
	
	private function overTimerCompleteHandler():void 
	{
		//黑洞结束
		this.isStart = false;
		if (this.overCallBackHandler)
			this.overCallBackHandler.run();
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.inHoleCallBackHandler = null;
		this.workOverCallBackHandler = null;
		this.overCallBackHandler = null;
		this.useData = null;
		this.subList = null;
	}
	
	public function get duration():int{ return _duration; }
	public function set duration(value:int):void 
	{
		_duration = value;
		Laya.timer.once(_duration, this, workCompleteHandler);
		Laya.timer.once(_duration + this.overDuration, this, overTimerCompleteHandler);
	}
}
}




