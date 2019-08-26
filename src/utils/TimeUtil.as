package utils 
{
/**
 * ...时间工具
 * @author ...Kanon
 */
public class TimeUtil 
{
	/**
	 * 计算月份ID
	 * @param d 指定计算日期
	 * @returns 月ID
	 */
	public static function monthId(d:Date = null):Number
	{
		d = d?d:new Date();
		var y:Number = d.getFullYear();
		var m:Number = d.getMonth() + 1;
		var g:String = m < 10 ? "0":"";
		return parseInt(y + g + m);
	}
	
	/**
	 * 计算日期ID
	 * @param d 指定计算日期
	 * @returns 日期ID
	 */
	public static function dateId(t:Date = null):Number
	{
		t = t?t:new Date();
		var m:Number = t.getMonth() + 1;
		var a:String = m < 10 ? "0":"";
		var d:Number = t.getDate();
		var b:String = d < 10 ? "0":"";
		return parseInt(t.getFullYear() + a + m + b + d);
	}
	
	/**
	 * 计算周ID
	 * @param d 指定计算日期
	 * @returns 周ID
	 */
	public static function weekId(d:Date = null, first:Boolean = true):Number
	{
		d = d?d:new Date();
		var c:Date = new Date();
		c.setTime(d.getTime());
		c.setDate(1);
		c.setMonth(0);//当年第一天
		
		var year:Number = c.getFullYear();
		var firstDay:Number = c.getDay();
		if (firstDay == 0)
		{
			firstDay = 7;
		}
		var max:Boolean;
		if (firstDay <= 4) 
		{
			max = firstDay > 1;
			c.setDate(c.getDate() -(firstDay-1));
		}
		else
		{
			c.setDate(c.getDate()+ 7-firstDay+1);
		}
		var num:Number = TimeUtil.diffDay(d, c, false);
		if (num < 0) 
		{
			c.setDate(1);c.setMonth(0);//当年第一天
			c.setDate(c.getDate() - 1);
			return TimeUtil.weekId(c, false);
		}
		var week:Number = num / 7;
		var weekIdx:Number = Math.floor(week) + 1;
		if (weekIdx == 53) 
		{
			c.setTime(d.getTime());
			c.setDate(c.getDate() - 1);
			var endDay:Number = c.getDay();
			if (endDay == 0)
			{
				endDay = 7;
			}
			if (first && (!max || endDay < 4)) 
			{
				c.setFullYear(c.getFullYear() + 1);
				c.setDate(1); c.setMonth(0);//当年第一天
				return TimeUtil.weekId(c, false);
			}
		}
		var g:String = weekIdx > 9 ? "":"0";
		var s:String = year + "00" + g + weekIdx;//加上00防止和月份ID冲突
		return parseInt(s);
	}
	
	/**
	 * 计算俩日期时间差，如果a比b小，返回负数
	 */
	public static function diffDay(a:Date, b:Date, fixOne:Boolean = false):Number
	{
		var x:Number = (a.getTime() - b.getTime()) / 86400000;
		return fixOne ? Math.ceil(x) : Math.floor(x);
	}
	
	/**
	 * 获取本周一 凌晨时间
	 */
	public static function getFirstDayOfWeek(d:Date = null):Date
	{
		d = d ? d : new Date();
		var day:Number = d.getDay() || 7;
		return new Date(d.getFullYear(), d.getMonth(), d.getDate() + 1 - day, 0, 0, 0, 0);
	}
	
	/**
	 * 获取当日凌晨时间
	 */
	public static function getFirstOfDay(d:Date = null):Date
	{
		var date:Date = d ? d : new Date();
		date.setHours(0);
		return date;
	}
	
	/**
	 * 获取次日凌晨时间
	 */
	public static function getNextFirstOfDay(d:Date = null):Date
	{
		return new Date(TimeUtil.getFirstOfDay(d).getTime() + 86400000);
	}
	
	/**
	 * 格式化日期
	 * @returns 2018-12-12
	 */
	public static function formatDate(date:Date):String
	{
		var y:Number = date.getFullYear();  
		var m:Number = date.getMonth() + 1;  
		var mStr:String = m < 10 ? '0' + m : m.toString();  
		var d:Number = date.getDate();  
		var dStr:String = d < 10 ? ('0' + d) : d.toString();  
		return y + '-' + mStr + '-' + dStr;  
	}
	
	/**
	 * 格式化日期和时间
	 * @returns 2018-12-12 12:12:12
	 */
	public static function formatDateTime(date:Date):String
	{
		var y:Number = date.getFullYear();  
		var m:Number = date.getMonth() + 1;
		var mStr:String = m < 10 ? ('0' + m) : m.toString();  
		var d:Number = date.getDate();  
		var dStr:String = d < 10 ? ('0' + d) : d.toString();  
		var h:Number = date.getHours();  
		var i:Number = date.getMinutes();  
		var iStr:String = i < 10 ? ('0' + i) : i.toString();  
		var s:Number = date.getSeconds();  
		var sStr:String = s < 10 ? ('0' + s) : s.toString();  
		return y + '-' + mStr + '-' + dStr + ' ' + h + ':' + iStr + ":" + sStr;
	}
}
}