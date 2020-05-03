package ;
import gml.Mathf;
import gml.NativeArray;
import gml.assets.Sprite;
import gml.ds.Color;

/**
 * Represents a sprite on a texture page.
 * @dmdPath ["", "Sprites", 1]
 * @author YellowAfterlife
 */
@:doc @:keep class TexSprite {
	
	/**
	 * An array of texture page entries for each sprite frame.  
	 * If something couldn't fit, an item may be `undefined`.
	 */
	public var images:Array<TexEntry>;
	
	/** (read-only) The number of subimages. */
	public var count:Int;
	
	/** Once [finalized](TexPage.finalize), holds the actual (GameMaker) sprite. */
	public var sprite:Sprite = Sprite.defValue;
	
	/** (read-only) Sprite's origin X. */
	public var xoffset:Float;
	
	/** (read-only) Sprite's origin Y. */
	public var yoffset:Float;
	
	/**
	 * Updates the origin of the sprite.
	 */
	public function setOffset(xo:Float, yo:Float):Void {
		var dx = xo - xoffset;
		var dy = yo - yoffset;
		for (i in 0 ... count) {
			var e = images[i];
			if (e != null) {
				e.xoffset += dx;
				e.yoffset += dy;
			}
		}
	}
	
	#if !sfgml.modern
	/**
	 * Can be used as a starting offset for custom properties.
	 * @dmdPrefix ---
	 */
	public var custom:Dynamic = null;
	#end
	
	/**
	 * Generally you shouldn't have to instantiate sprites manually.
	 */
	public function new(count:Int, xofs:Float, yofs:Float) {
		this.count = count;
		this.xoffset = xofs;
		this.yoffset = yofs;
		images = NativeArray.create(count, null);
	}
	
	/**
	 * Equivalent of `draw_sprite`
	 * @dmdPrefix Drawing functions:
	 */
	public function draw(subimg:Float, x:Float, y:Float) {
		var i:Int = Std.int(subimg) % count;
		if (i < 0) i += count;
		var e = images[i];
		if (e == null) return;
		sprite.drawPart(0, e.left, e.top, e.width, e.height, x - e.xoffset, y - e.yoffset);
	}
	
	/** Equivalent of `draw_sprite_ext` */
	public function drawExt(subimg:Float, x:Float, y:Float, scaleX:Float, scaleY:Float, rot:Float, col:Color, alpha:Float) {
		var i:Int = Std.int(subimg) % count;
		if (i < 0) i += count;
		var e = images[i];
		if (e == null) return;
		var rx = Mathf.ldx(1, rot);
		var ry = Mathf.ldy(1, rot);
		var ox = -e.xoffset * scaleX;
		var oy = -e.yoffset * scaleY;
		sprite.drawGeneral(0,
			e.left, e.top,
			e.width, e.height,
			x + rx * ox - ry * oy,
			y + ry * ox + rx * oy,
			scaleX, scaleY, rot,
			col, col, col, col, alpha
		);
	}
	
	/** Equivalent of `draw_sprite_part` */
	public function drawPart(subimg:Float, left:Float, top:Float, width:Float, height:Float, x:Float, y:Float) {
		var i:Int = Std.int(subimg) % count;
		if (i < 0) i += count;
		var e = images[i];
		if (e == null) return;
		sprite.drawPart(0, e.left + left, e.top + top, width, height, x, y);
	}
	
	/** Equivalent of `draw_sprite_part_ext`, except with angle, because why not. */
	public function drawPartExt(subimg:Float, left:Float, top:Float, width:Float, height:Float,
		x:Float, y:Float, sx:Float, sy:Float, rot:Float,
		c:Color, a:Float
	) {
		var i:Int = Std.int(subimg) % count;
		if (i < 0) i += count;
		var e = images[i];
		if (e == null) return;
		var rx = Mathf.ldx(1, rot);
		var ry = Mathf.ldy(1, rot);
		sprite.drawGeneral(0,
			e.left + left, e.top + top, width, height,
			x, y, sx, sy, rot,
			c, c, c, c, a
		);
	}
	
	/** Equivalent of `draw_sprite_general` */
	public function drawGeneral(subimg:Float, left:Float, top:Float, width:Float, height:Float,
		x:Float, y:Float, sx:Float, sy:Float, rot:Float,
		c1:Color, c2:Color, c3:Color, c4:Color, a:Float
	) {
		var i:Int = Std.int(subimg) % count;
		if (i < 0) i += count;
		var e = images[i];
		if (e == null) return;
		var rx = Mathf.ldx(1, rot);
		var ry = Mathf.ldy(1, rot);
		sprite.drawGeneral(0,
			e.left + left, e.top + top, width, height,
			x, y, sx, sy, rot,
			c1, c2, c3, c4, a
		);
	}
}