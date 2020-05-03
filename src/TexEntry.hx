package ;
import gml.Draw;
import gml.Mathf;
import gml.assets.Sprite;
import gml.ds.Color;
import gml.ds.Queue;
import gml.ds.Stack;
import gml.gpu.GPU;

/**
 * Represents an individual image on a texture page.
 * @dmdPath ["", "Texture page entries", 1]
 * @author YellowAfterlife
 */
@:doc @:keep class TexEntry {
	
	/** @dmdPrefix The following define a rectangle within the texture page: */
	public var left:Float;
	public var top:Float;
	public var width:Float;
	public var height:Float;
	
	/** @dmdPrefix The following define the subimage's origin: */
	public var xoffset:Float = 0;
	public var yoffset:Float = 0;
	
	/** @dmdPrefix The following hold the child nodes (if any): */
	public var nodeA:TexEntry = null;
	public var nodeB:TexEntry = null;
	#if !sfgml.modern
	/**
	 * Can be used as a starting offset for custom properties.
	 * @dmdPrefix ---
	 */
	public var custom:Dynamic = null;
	#end
	//
	public function new(x:Float, y:Float, w:Float, h:Float) {
		this.left = x;
		this.top = y;
		this.width = w;
		this.height = h;
	}
	
	@:noDoc private static var insertStack:Stack<TexEntry> = new Stack();
	
	/**
	 * Tries to allocate a spot of given dimensions in this or child nodes.
	 * 
	 * Returns the texture page entry that was chosen.
	 * 
	 * If there is no free spot, returns `undefined`.
	 * @dmdPrefix ---
	 */
	public function add(imgWidth:Float, imgHeight:Float):TexEntry {
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
				e.nodeA = new TexEntry(e.left + imgWidth, e.top, remWidth, imgHeight);
				e.nodeB = new TexEntry(e.left, e.top + imgHeight, entryWidth, remHeight);
			} else {
				// +---+---+
				// | E |   |
				// +---+ B +
				// | A |   |
				// +-------+
				e.nodeA = new TexEntry(e.left, e.top + imgHeight, imgWidth, remHeight);
				e.nodeB = new TexEntry(e.left + imgWidth, e.top, remWidth, entryHeight);
			}
			e.width = imgWidth;
			e.height = imgHeight;
			stack.clear();
			return e;
		}
		return null;
	}
}