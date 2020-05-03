package ;
import gml.Draw;
import gml.Mathf;
import gml.assets.Sprite;
import gml.ds.Color;
import gml.ds.Queue;
import gml.ds.Stack;
import gml.gpu.GPU;

/**
 * ...
 * @author YellowAfterlife
 */
@:doc @:keep class TexEntry {
	#if sfgml.modern
	// declaring static X/Y is not allowed as of now
	@:remove public var x:Float;
	@:remove public var y:Float;
	#else
	public var x:Float;
	public var y:Float;
	#end
	public var width:Float;
	public var height:Float;
	public var origX:Float = 0;
	public var origY:Float = 0;
	public var nodeA:TexEntry = null;
	public var nodeB:TexEntry = null;
	#if !sfgml.modern
	public var custom:Dynamic = null;
	#end
	//
	public function new(x:Float, y:Float, w:Float, h:Float) {
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
	}
	
	@:noDoc private static var insertStack:Stack<TexEntry> = new Stack();
	public function insert(imgWidth:Float, imgHeight:Float, ox:Float, oy:Float):TexEntry {
		var stack = insertStack;
		stack.clear();
		stack.push(this);
		while (!stack.isEmpty()) {
			var e = stack.pop();
			
			// if this has child nodes, it means that it is filled
			// and we will look into those instead:
			if (e.nodeA != null) {
				if (e.nodeB != null) stack.push(e.nodeB);
				stack.push(e.nodeA);
				continue;
			} else if (e.nodeB != null) {
				// under normal circumstances, there should not be situations
				// where your node only has one child attached.
				stack.push(e.nodeB);
				continue;
			}
			
			// make sure we fit:
			var entryWidth = e.width;
			if (imgWidth > entryWidth) continue;
			var entryHeight = e.height;
			if (imgHeight > entryHeight) continue;
			
			// subdivide:
			var remWidth = entryWidth - imgWidth;
			var remHeight = entryHeight - imgHeight;
			if (remWidth <= remHeight) {
				// +---+---+
				// | E | A |
				// +---+---+
				// |   B   |
				// +-------+
				e.nodeA = new TexEntry(e.x + imgWidth, e.y, remWidth, imgHeight);
				e.nodeB = new TexEntry(e.x, e.y + imgHeight, entryWidth, remHeight);
			} else {
				// +---+---+
				// | E |   |
				// +---+ B +
				// | A |   |
				// +-------+
				e.nodeA = new TexEntry(e.x, e.y + imgHeight, imgWidth, remHeight);
				e.nodeB = new TexEntry(e.x + imgWidth, e.y, remWidth, entryHeight);
			}
			e.width = imgWidth;
			e.height = imgHeight;
			e.origX = ox;
			e.origY = oy;
			stack.clear();
			return e;
		}
		return null;
	}
}