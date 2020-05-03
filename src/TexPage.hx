package ;
import gml.Draw;
import gml.assets.Sprite;
import gml.ds.Color;
import gml.ds.Queue;
import gml.gpu.GPU;
import gml.gpu.Surface;

/**
 * ...
 * @author YellowAfterlife
 */
@:keep @:doc class TexPage {
	public var width:Float;
	public var height:Float;
	public var root:TexEntry;
	public var sprite:Sprite = Sprite.defValue;
	public var sprites:Array<TexSprite> = [];
	public var surface:Surface;
	#if !sfgml.modern
	public var custom:Dynamic = null;
	#end
	public function new(w:Int, h:Int) {
		width = w;
		height = h;
		root = new TexEntry(0, 0, w, h);
		surface = new Surface(w, h);
		surface.setTarget();
		Draw.clearAlpha(Color.black, 0);
		surface.resetTarget();
	}
	public function destroy() {
		if (sprite != Sprite.defValue) {
			sprite.destroy();
			sprite = Sprite.defValue;
			for (qs in sprites) {
				for (i in 0 ... qs.count) {
					qs.images[i] = null;
				}
			}
		}
		if (surface != Surface.defValue) {
			surface.destroy();
			surface = Surface.defValue;
		}
	}
	public function add(fname:String, imgNumb:Int, ox:Float, oy:Float):TexSprite {
		if (sprite != Sprite.defValue) throw "This texture page is already finalized";
		var spr = Sprite.load(fname, imgNumb, 0, 0);
		if (spr == Sprite.defValue) return null;
		var sw = spr.width;
		var sh = spr.height;
		var qs = new TexSprite(imgNumb);
		//
		#if sfgml_next
		var ob = GPU.blendMode;
		GPU.setBlendMode(One, Zero);
		#else
		untyped draw_set_blend_mode_ext(bm_one, bm_zero);
		#end
		surface.setTarget();
		for (i in 0 ... imgNumb) {
			var qe = root.insert(sw, sh, ox, oy);
			qs.images[i] = qe;
			if (qe != null) spr.draw(0, qe.x, qe.y);
		}
		#if sfgml_next
		GPU.blendMode = ob;
		#else
		untyped draw_set_blend_mode(bm_normal);
		#end
		surface.resetTarget();
		spr.destroy();
		//
		sprites[sprites.length] = qs;
		return qs;
	}
	public function finalize() {
		if (sprite != Sprite.defValue) throw "This texture page is already finalized";
		sprite = surface.toSprite(0, 0);
		for (i in 0 ... sprites.length) {
			var qs = sprites[i];
			qs.sprite = sprite;
		}
		surface.destroy();
	}
}