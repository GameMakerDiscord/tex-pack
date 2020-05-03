package ;
import gml.Mathf;
import gml.NativeArray;
import gml.assets.Sprite;
import gml.ds.Color;

/**
 * ...
 * @author YellowAfterlife
 */
@:doc @:keep class TexSprite {
	public var images:Array<TexEntry>;
	public var count:Int;
	public var sprite:Sprite = Sprite.defValue;
	#if !sfgml.modern
	public var custom:Dynamic = null;
	#end
	//
	public function new(count:Int) {
		this.count = count;
		images = NativeArray.create(count, null);
	}
	public function draw(subimg:Float, x:Float, y:Float) {
		var i:Int = Std.int(subimg) % count;
		if (i < 0) i += count;
		var e = images[i];
		if (e == null) return;
		sprite.drawPart(0, e.x, e.y, e.width, e.height, x - e.origX, y - e.origY);
	}
	public function drawExt(subimg:Float, x:Float, y:Float, scaleX:Float, scaleY:Float, rot:Float, col:Color, alpha:Float) {
		var i:Int = Std.int(subimg) % count;
		if (i < 0) i += count;
		var e = images[i];
		if (e == null) return;
		var rx = Mathf.ldx(1, rot);
		var ry = Mathf.ldy(1, rot);
		var ox = -e.origX * scaleX;
		var oy = -e.origY * scaleY;
		sprite.drawGeneral(0,
			e.x, e.y,
			e.width, e.height,
			x + rx * ox - ry * oy,
			y + ry * ox + rx * oy,
			scaleX, scaleY, rot,
			col, col, col, col, alpha);
	}
}