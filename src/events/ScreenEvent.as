package events 
{
/**
 * ...屏幕过渡事件
 * @author Kanon
 */
public class ScreenEvent 
{
	//过渡开启
	public static const TRANSITION_START:String = "transitionStart";
	//过渡结束
	public static const TRANSITION_COMPLETE:String = "transitionComplete";

	//进入过渡开启
	public static const TRANSITION_IN_START:String = "transitionInStart";
	//进入过渡结束
	public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";

	//退出过渡开启
	public static const TRANSITION_OUT_START:String = "transitionOutStart";
	//退出过渡结束
	public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
}
}