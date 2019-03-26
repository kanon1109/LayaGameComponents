package sample 
{
import utils.TimeUtil;
import laya.display.Text;
/**
 * ...日期类测试
 * @author ...Kanon
 */
public class TimeUtilTest extends SampleBase 
{
	private var txt:Text;
	public function TimeUtilTest() 
	{
		super();
		
	}

	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "TimeUtilTest";
		this.txt = new Text();
		this.txt.fontSize = 25;
		this.txt.color = "#FFFFFF";
		this.txt.text = "this is time util";
		this.txt.width = 450;
		this.txt.x = (Laya.stage.designWidth - this.txt.width) / 2;
		this.txt.y = 160;
		this.txt.wordWrap = true;
		this.addChild(this.txt);

		trace("monthId =", TimeUtil.monthId());
		trace("dateId =", TimeUtil.dateId());
		trace("weekId =", TimeUtil.weekId());
		trace("diffDay =", TimeUtil.diffDay(new Date(2019, 2, 26), new Date(2019, 2, 22)));
		trace("getFirstDayOfWeek =", TimeUtil.getFirstDayOfWeek().toDateString());
		trace("getFirstOfDay =", TimeUtil.getFirstOfDay().toDateString());
		trace("getNextFirstOfDay =", TimeUtil.getNextFirstOfDay().toDateString());
		trace("formatDate =", TimeUtil.formatDate(new Date(2019, 2, 26)));
		trace("formatDateTime =", TimeUtil.formatDateTime(new Date(2019, 2, 26)));
	}
	
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