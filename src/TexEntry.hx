package ;
import gml.Draw;
import gml.Mathf;
import gml.assets.Sprite;
import gml.ds.Color;
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
	public var leafA:TexEntry = null;
	public var leafB:TexEntry = null;
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
	
	public function insert(w:Float, h:Float, ox:Float, oy:Float):TexEntry {
		//
		if (leafA != null || leafB != null) {
			var q:TexEntry;
			if (leafA != null) {
				q = leafA.insert(w, h, ox, oy);
				if (q != null) return q;
			}
			if (leafB != null) {
				q = leafB.insert(w, h, ox, oy);
				if (q != null) return q;
			}
			return null;
		}
		
		// can we fit?
		if (w > width) return null;
		if (h > height) return null;
		
		//
		var qw = width - w;
		var qh = height - h;
		if (qw <= qh) {
			leafA = new TexEntry(x + w, y, qw, h);
			leafB = new TexEntry(x, y + h, width, qh);
		} else {
			leafA = new TexEntry(x, y + h, w, qh);
			leafB = new TexEntry(x + w, y, qw, height);
		}
		width = w;
		height = h;
		origX = ox;
		origY = oy;
		return this;
	}
}