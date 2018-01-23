package sample 
{
import components.scroll.Cell;
import components.scroll.ListView;
import components.scroll.PageView;
import components.scroll.ScrollView;
import components.scroll.TableView;
import laya.display.Sprite;
import laya.events.Event;
import laya.net.Loader;
import laya.ui.Image;
import laya.ui.Label;
import laya.utils.Handler;
/**
 * ...滚轮组件测试容器
 * @author ...Kanon
 */
public class ListViewTest extends SampleBase
{
	private var label:Label;
	private var pageLabel:Label;
	private var indexLabel:Label;
	private var pageIndexLabel:Label;
	private var scrollList:ListView;
	private var scroll:ScrollView;
	private var tableView:TableView;
	private var pageView:PageView;
	private var itemList:Array;
	private var count:int;

	public function ListViewTest() 
	{
		super();
	}
	
	override public function init():void 
	{
		super.init();
		this.titleLabel.text = "listView scrollView tableView pageView";
		var arr:Array = [];
		arr.push({url:"res/itemBg.png", type:Loader.IMAGE});
		Laya.loader.load(arr, Handler.create(this, loadImgComplete), null, Loader.IMAGE);
	}
	
	private function loadImgComplete():void
	{
		this.count = 50;
		
		this.scrollList = new ListView();
		this.scrollList.setViewSize(100, 200);
		this.scrollList.gap = 10;
		this.scrollList.x = 20;
		this.scrollList.y = 100;
		this.scrollList.isShowDebug = true;
		this.addChild(this.scrollList);
		for (var i:int = 0; i < this.count; i++) 
		{
			this.scrollList.addToContent(new Image("res/itemBg.png"));
		}
		
		this.scroll = new ScrollView();
		this.scroll.setViewSize(100, 200);
		this.scroll.setContentSize(100, 1800);
		this.scroll.x = this.scrollList.x + 120;
		this.scroll.y = this.scrollList.y;
		this.scroll.isShowDebug = true;
		this.scroll.isHorizontal = false;
		this.addChild(this.scroll);
		for (i = 0; i < this.count; i++) 
		{
			var img:Image = new Image("res/itemBg.png");
			img.x = i * 2;
			img.y = i * 60;
			this.scroll.addToContent(img);
		}
		this.count = 50
		this.updateData();

		this.tableView = new TableView();
		this.tableView.initTable(this.itemList.length, false, 212, 200, 50 + 3, 50 + 3);
		this.tableView.x = this.scroll.x + 120;
		this.tableView.y = this.scrollList.y;
		this.tableView.isShowDebug = true;
		this.tableView.updateTableCellHandler = new Handler(this, updateTableCellHandler);
		this.tableView.onCellClickHandler = new Handler(this, onCellClickHandler);
		//this.tableView.isHorizontal = false;
		this.addChild(this.tableView);

		this.pageView = new PageView();
		this.pageView.init(this.itemList.length, true, 220, 200, 50 + 3, 50 + 3);
		this.pageView.x = this.tableView.x + 240;
		this.pageView.y = this.scrollList.y;
		this.pageView.isShowDebug = true;
		//this.pageView.isHorizontal = true;
		this.pageView.updateTableCellHandler = new Handler(this, updatePageViewCellHandler);
		this.pageView.updatePageCellHandler = new Handler(this, updatePageCellHandler);
		this.pageView.onCellClickHandler = new Handler(this, onPageCellClickHandler);
		this.addChild(this.pageView);
		
		this.label = new Label();
		this.label.color = "#FF0000";
		this.label.fontSize = 20;
		this.label.y = 30;
		this.addChild(this.label);
		this.label.text = "数量:" + this.count;
		
		this.indexLabel = new Label();
		this.indexLabel.color = "#FF0000";
		this.indexLabel.fontSize = 20;
		this.indexLabel.x = this.scroll.x + 120;
		this.indexLabel.y = this.scrollList.y - 30;
		this.addChild(this.indexLabel);
		this.indexLabel.text = "index: 0";
		
		
		var txt1:Label = new Label("有限列表");
		txt1.color = "#FFFFFF";
		txt1.fontSize = 20;
		txt1.x = this.scrollList.x;
		txt1.y = this.scrollList.y + this.scrollList.height + 10;
		this.addChild(txt1);
		
		var txt2:Label = new Label("滚动容器");
		txt2.color = txt1.color;
		txt2.fontSize = txt1.fontSize;
		txt2.x = this.scroll.x;
		txt2.y = this.scroll.y + this.scroll.height + 10;
		this.addChild(txt2);
		
		var txt3:Label = new Label("无限滚动表格");
		txt3.color = txt1.color;
		txt3.fontSize = txt1.fontSize;
		txt3.x = this.tableView.x;
		txt3.y = this.tableView.y + this.tableView.height + 10;
		this.addChild(txt3);
		
		var txt4:Label = new Label("无限滚动翻页表格");
		txt4.color = txt1.color;
		txt4.fontSize = txt1.fontSize;
		txt4.x = this.pageView.x;
		txt4.y = this.pageView.y + this.pageView.height + 10;
		this.addChild(txt4);
		
		this.pageLabel = new Label();
		this.pageLabel.color = "#FF0000";
		this.pageLabel.fontSize = 20;
		this.addChild(this.pageLabel);
		this.pageLabel.x = this.pageView.x;
		this.pageLabel.y = this.pageView.y - 30;
		this.pageLabel.text = "第0页";
		
		this.pageIndexLabel = new Label();
		this.pageIndexLabel.color = "#FF0000";
		this.pageIndexLabel.fontSize = 20;
		this.pageIndexLabel.x = this.pageLabel.x + this.pageLabel.width + 10;
		this.pageIndexLabel.y = this.pageLabel.y ;
		this.addChild(this.pageIndexLabel);
		this.pageIndexLabel.text = "index: 0";
	}
	
	private function updatePageViewCellHandler(cell:Cell):void 
	{
		var label:Label;
		var bg:Image;
		if (!cell.getChildByName("txt"))
		{
			bg = new Image("res/itemBg.png");
			cell.addChild(bg);
			bg.x = 3;
			bg.y = 3;
			label = new Label();
			label.name = "txt";
			label.fontSize = 24;
			label.color = "#FF0000";
			cell.addChild(label);
		}
		else
		{
			label = cell.getChildByName("txt") as Label;
		}
		var itemVo:ItemVo = this.itemList[cell.index];
		label.text = cell.index.toString();
	}
	
	private function onCellClickHandler(cell:Cell):void 
	{
		this.indexLabel.text = "index: " + cell.index.toString();
	}
	
	private function onPageCellClickHandler(cell:Cell):void 
	{
		this.pageIndexLabel.text = "index: " + cell.index.toString();
	}

	private function updatePageCellHandler():void 
	{
		this.pageLabel.text = "第" + this.pageView.curPageIndex + "页";
	}
	
	private function updateTableCellHandler(cell:Cell):void 
	{
		var label:Label;
		var bg:Image;
		if (!cell.getChildByName("txt"))
		{
			bg = new Image("res/itemBg.png");
			cell.addChild(bg);
			bg.x = 3;
			bg.y = 3;
			label = new Label();
			label.name = "txt";
			label.fontSize = 24;
			label.color = "#FF0000";
			cell.addChild(label);
		}
		else
		{
			label = cell.getChildByName("txt") as Label;
		}
		var itemVo:ItemVo = this.itemList[cell.index];
		label.text = cell.index.toString();
	}
	
	private function updateData():void
	{
		this.itemList = [];
		for (var i:int = 0; i < this.count; i++) 
		{
			var itemVo:ItemVo = new ItemVo();
			itemVo.index = i;
			itemVo.name = "item" + (i + 1);
			this.itemList.push(itemVo);
		}
	}
	
	/**
	 * 销毁
	 */
	override public function destroySelf():void
	{
		if (this.tableView)
		{
			this.tableView.destroySelf();
			this.tableView = null;
		}
		
		if (this.pageView)
		{
			this.pageView.destroySelf();
			this.pageView = null;
		}
		
		if (this.scrollList)
		{
			this.scrollList.destroySelf();
			this.scrollList = null;
		}
		
		if (this.scroll)
		{
			this.scroll.destroySelf();
			this.scroll = null;
		}
		
		if (this.pageLabel)
		{
			this.pageLabel.removeSelf();
			this.pageLabel = null;
		}
		
		if (this.label)
		{
			this.label.removeSelf();
			this.label = null;
		}
		
		this.removeChildren();
		super.destroySelf();
	}
}
}

class ItemVo
{
	public var index:int;
	public var name:String;
}