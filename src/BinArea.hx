package ;

/**
 * ...
 * @author YellowAfterlife
 */
@:doc @:keep class BinArea {
	public var width:Float;
	public var height:Float;
	public var node:BinNode;
	public function new(w:Float, h:Float) {
		width = w;
		height = h;
		node = new BinNode(0, 0, w, h);
	}
}