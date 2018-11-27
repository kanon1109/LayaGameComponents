package controls 
{
import laya.display.Sprite;
import laya.utils.Tween;
/**
 * ...屏幕导航元素
 * @author Kanon
 */
public class ScreenNavigatorItem 
{
	//屏幕的显示对象
    private var screen:Sprite;
    //属性
    public var properties:*;
    //id
    public var id:String;
	public function ScreenNavigatorItem(screen:Sprite) 
	{
		if(!screen) throw new Error("screen is null");
        this.screen = screen;
	}

    /**
     * 激活
     */
    public function active():void
    {
    }

    /**
     * 去活
     */
    public function deactive():void
    {
    }
    

    /**
     * 获取屏幕数据
     */
    public function getScreen():Sprite
    {
        return this.screen;
    }

    /**
     * 销毁
     * @param isDispose 是否释放screen的内存
     */
    public function destroySelf(isDispose:Boolean = false):void
    {
        if(isDispose && this.screen)
        {
			Tween.clearAll(this.screen);
            this.screen.removeSelf();
            this.screen.destroy();
        }
        this.screen = null;
    }
	
}
}