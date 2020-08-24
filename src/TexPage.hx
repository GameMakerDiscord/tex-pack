package ;
import gml.Draw;
import gml.assets.Sprite;
import gml.ds.Color;
import gml.ds.Queue;
import gml.gpu.GPU;
import gml.gpu.Surface;

/**
 * A texture page is a top-level object that holds sprites and texture pages inside.
 * @dmdPath ["", "Texture pages", 0]
 * @author YellowAfterlife
 */
@:keep @:doc class TexPage {
	
	/** Read-only; holds the width of this texture page */
	public var width:Float;
	
	/** Read-only; holds the height of this texture page */
	public var height:Float;
	
	/** Holds the top-level texture page entry node */
	public var root:TexEntry;
	
	/** Once [finalized](finalize), holds the generated sprite */
	public var sprite:Sprite = Sprite.defValue;
	
	/** An array of [sprites](TexSprite) belonging to this texture page. */
	public var sprites:Array<TexSprite> = [];
	
	/** The temporary surface holding the sprites. Is destroyed on [finalize]. */
	public var surface:Surface;
	
	#if !sfgml.modern
	/**
	 * Can be used as a starting offset for custom properties.
	 */
	public var custom:Dynamic = null;
	#end
	
	/**
	 * Creates a new, empty texture page of specified size.
	 */
	public function new(w:Int, h:Int) {
		width = w;
		height = h;
		root = new TexEntry(0, 0, w, h);
		surface = new Surface(w, h);
		surface.setTarget();
		Draw.clearAlpha(Color.black, 0);
		surface.resetTarget();
	}
	
	/**
	 * Destroys the texture page and any associated resources.  
	 * Don't forget to destroy your texture pages when you are done using them!
	 */
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
	
	/**
	 * Basically `sprite_add`, but for texture pages.
	 */
	public function add(fname:String, imgNumb:Int, ox:Float, oy:Float):TexSprite {
		if (sprite != Sprite.defValue) throw "This texture page is already finalized";
		var spr = Sprite.load(fname, imgNumb, 0, 0);
		if (spr == Sprite.defValue) return null;
		var sw = spr.width;
		var sh = spr.height;
		var qs = new TexSprite(imgNumb, ox, oy);
		//
		#if sfgml_next
		var ob = GPU.blendMode;
		GPU.setBlendMode(One, Zero);
		#else
		untyped draw_set_blend_mode_ext(bm_one, bm_zero);
		#end
		//
		surface.setTarget();
		for (i in 0 ... imgNumb) {
			var qe = root.add(sw, sh);
			qs.images[i] = qe;
			if (qe != null) {
				qe.xoffset = ox;
				qe.yoffset = oy;
				spr.draw(i, qe.left, qe.top);
			}
		}
		//
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
	
	/**
	 * Creates the actual texture page sprite and destroys the temporary surface.
	 * 
	 * You need to finalize before you can draw sprites.
	 */
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