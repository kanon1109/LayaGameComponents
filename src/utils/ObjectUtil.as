package utils 
{
/**
 * ...对象工具
 * @author ...Kanon
 */
public class ObjectUtil 
{
	/** 
	 * 对象深度拷贝
	 * @param p Object 源对象
	 * @param c Object 目标对象, 不传则返回新对象, 传则合并属性, 相同名字的属性则会覆盖
	 */
	public static function clone(p:Object, c:Object = null):Object
	{
		var c:Object = c || {};
		for (var i in p) 
		{
			if (typeof p[i] === 'object') 
			{
				c[i] = (p[i].constructor === Array) ? [] : {};
				ObjectUtil.clone(p[i], c[i]);
			} 
			else 
			{
				c[i] = p[i];
			}
		}
		return c;
	}
}
}