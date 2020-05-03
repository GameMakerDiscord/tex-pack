package ;
import gml.Draw;
import gml.ds.Color;
import gml.gpu.GPU;

/**
 * ...
 * @author YellowAfterlife
 */
@:doc @:keep class BinNode {
	@:remove public var x:Float;
	@:remove public var y:Float;
	public var width:Float;
	public var height:Float;
	public var a:BinNode = null;
	public var b:BinNode = null;
	//
	public function new(x:Float, y:Float, w:Float, h:Float) {
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
	}
	
	/*public function draw(rx:Float, ry:Float, depth:Float) {
		Draw.color = Color.fromHSV((depth * 47) % 255, 220, 255);
		var vx = rx + x;
		var vy = ry + y;
		Draw.rectangle(vx + 1, vy + 1, vx + width - 2, vy + height - 2, true);
		GPU.halign = Center;
		GPU.valign = Middle;
		Draw.text(vx + width / 2, vy + height / 2, text);
		if (a != null) a.draw(rx, ry, depth + 1);
		if (b != null) b.draw(rx, ry, depth + 1);
	}*/
	
	public function insert(w:Float, h:Float, s:String):BinNode {
		var q:BinNode;
		if (a != null || b != null) {
			if (a != null) {
				q = a.insert(w, h, s);
				if (q != null) return q;
			}
			if (b != null) {
				q = b.insert(w, h, s);
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
			a = new BinNode(x + w, y, qw, h);
			b = new BinNode(x, y + h, width, qh);
		} else {
			a = new BinNode(x, y + h, w, qh);
			b = new BinNode(x + w, y, qw, height);
		}
		width = w;
		height = h;
		text = s;
		return this;
	}
	
	public function getArea():Float {
		var area = width * height;
		if (a != null) area += a.getArea();
		if (b != null) area += b.getArea();
		return area;
	}
}