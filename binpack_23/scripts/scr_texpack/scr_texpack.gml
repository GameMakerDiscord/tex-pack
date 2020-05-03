// Generated at 2020-05-03 11:01:04 (238ms) for v2.3+
//{ metatype
globalvar binp_haxe_type_markerValue; binp_haxe_type_markerValue = [];
globalvar mt_TexEntry; mt_TexEntry = new binp_haxe_class(-1, "TexEntry", TexEntry);
globalvar mt_TexPage; mt_TexPage = new binp_haxe_class(-1, "TexPage", TexPage);
globalvar mt_TexSprite; mt_TexSprite = new binp_haxe_class(-1, "TexSprite", TexSprite);
globalvar mt_binp_haxe_class; mt_binp_haxe_class = new binp_haxe_class(-1, "binp_haxe_class", binp_haxe_class);
//}

//{ TexEntry

function TexEntry() constructor {
	/// TexEntry(l_x:real, l_y:real, w:real, h:real)
	/// @param l_x:real
	/// @param l_y:real
	/// @param w:real
	/// @param h:real
	var this = self;
	static width = undefined;
	static height = undefined;
	static origX = undefined;
	static origY = undefined;
	static leafA = undefined;
	static leafB = undefined;
	static insert = method(undefined, TexEntry_insert);
	this.leafB = undefined;
	this.leafA = undefined;
	this.origY = 0;
	this.origX = 0;
	this.x = argument[0];
	this.y = argument[1];
	this.width = argument[2];
	this.height = argument[3];
	static __class__ = mt_TexEntry;
}

function TexEntry_insert() {
	/// TexEntry_insert(w:real, h:real, ox:real, oy:real)->TexEntry
	/// @param w:real
	/// @param h:real
	/// @param ox:real
	/// @param oy:real
	var this = self, w = argument[0], h = argument[1], ox = argument[2], oy = argument[3];
	if (this.leafA != undefined || this.leafB != undefined) {
		var q;
		if (this.leafA != undefined) {
			q = this.leafA.insert(w, h, ox, oy);
			if (q != undefined) return q;
		}
		if (this.leafB != undefined) {
			q = this.leafB.insert(w, h, ox, oy);
			if (q != undefined) return q;
		}
		return undefined;
	}
	if (w > this.width) return undefined;
	if (h > this.height) return undefined;
	var qw = this.width - w;
	var qh = this.height - h;
	if (qw <= qh) {
		this.leafA = new TexEntry(this.x + w, this.y, qw, h);
		this.leafB = new TexEntry(this.x, this.y + h, this.width, qh);
	} else {
		this.leafA = new TexEntry(this.x, this.y + h, w, qh);
		this.leafB = new TexEntry(this.x + w, this.y, qw, this.height);
	}
	this.width = w;
	this.height = h;
	this.origX = ox;
	this.origY = oy;
	return this;
}

//}

//{ TexPage

function TexPage() constructor {
	/// TexPage(w:int, h:int)
	/// @param w:int
	/// @param h:int
	var this = self;
	static width = undefined;
	static height = undefined;
	static root = undefined;
	static sprite = undefined;
	static sprites = undefined;
	static surface = undefined;
	static destroy = method(undefined, TexPage_destroy);
	static add = method(undefined, TexPage_add);
	static finalize = method(undefined, TexPage_finalize);
	var w = argument[0], h = argument[1];
	this.sprites = [];
	this.sprite = -1;
	this.width = w;
	this.height = h;
	this.root = new TexEntry(0, 0, w, h);
	this.surface = surface_create(w, h);
	surface_set_target(this.surface);
	draw_clear_alpha(0, 0);
	surface_reset_target();
	static __class__ = mt_TexPage;
}

function TexPage_destroy() {
	/// TexPage_destroy()
	var this = self;
	if (this.sprite != -1) {
		sprite_delete(this.sprite);
		this.sprite = -1;
		var _g = 0;
		var _g1 = this.sprites;
		while (_g < array_length(_g1)) {
			var qs = _g1[_g];
			_g++;
			var i = 0;
			for (var _g11 = qs.count; i < _g11; i++) {
				qs.images[@i] = undefined;
			}
		}
	}
	if (this.surface != -1) {
		surface_free(this.surface);
		this.surface = -1;
	}
}

function TexPage_add() {
	/// TexPage_add(fname:string, imgNumb:int, ox:real, oy:real)->TexSprite
	/// @param fname:string
	/// @param imgNumb:int
	/// @param ox:real
	/// @param oy:real
	var this = self, imgNumb = argument[1];
	if (this.sprite != -1) throw "This texture page is already finalized";
	var spr = sprite_add(argument[0], imgNumb, false, false, 0, 0);
	if (spr == -1) return undefined;
	var sw = sprite_get_width(spr);
	var sh = sprite_get_height(spr);
	var qs = new TexSprite(imgNumb);
	var ob = gpu_get_blendmode_ext();
	gpu_set_blendmode_ext(2, 1);
	surface_set_target(this.surface);
	var i = 0;
	for (var _g1 = imgNumb; i < _g1; i++) {
		var qe = this.root.insert(sw, sh, argument[2], argument[3]);
		qs.images[@i] = qe;
		if (qe != undefined) draw_sprite(spr, 0, qe.x, qe.y);
	}
	gpu_set_blendmode_ext(ob);
	surface_reset_target();
	sprite_delete(spr);
	this.sprites[@array_length(this.sprites)] = qs;
	return qs;
}

function TexPage_finalize() {
	/// TexPage_finalize()
	var this = self;
	if (this.sprite != -1) throw "This texture page is already finalized";
	var _this = this.surface;
	this.sprite = sprite_create_from_surface(_this, 0, 0, surface_get_width(_this), surface_get_height(_this), false, false, 0, 0);
	var i = 0;
	for (var _g1 = array_length(this.sprites); i < _g1; i++) {
		this.sprites[i].sprite = this.sprite;
	}
	surface_free(this.surface);
}

//}

//{ TexSprite

function TexSprite() constructor {
	/// TexSprite(count:int)
	/// @param count:int
	var this = self;
	static images = undefined;
	static count = undefined;
	static sprite = undefined;
	static draw = method(undefined, TexSprite_draw);
	static drawExt = method(undefined, TexSprite_drawExt);
	var count = argument[0];
	this.sprite = -1;
	this.count = count;
	this.images = array_create(count, undefined);
	static __class__ = mt_TexSprite;
}

function TexSprite_draw() {
	/// TexSprite_draw(subimg:real, l_x:real, l_y:real)
	/// @param subimg:real
	/// @param l_x:real
	/// @param l_y:real
	var this = self;
	var i = (argument[0] | 0) % this.count;
	if (i < 0) i += this.count;
	var e = this.images[i];
	if (e == undefined) return 0;
	draw_sprite_part(this.sprite, 0, e.x, e.y, e.width, e.height, argument[1] - e.origX, argument[2] - e.origY);
}

function TexSprite_drawExt() {
	/// TexSprite_drawExt(subimg:real, l_x:real, l_y:real, scaleX:real, scaleY:real, rot:real, col:Color, alpha:real)
	/// @param subimg:real
	/// @param l_x:real
	/// @param l_y:real
	/// @param scaleX:real
	/// @param scaleY:real
	/// @param rot:real
	/// @param col:Color
	/// @param alpha:real
	var this = self, scaleX = argument[3], scaleY = argument[4], rot = argument[5], col = argument[6];
	var i = (argument[0] | 0) % this.count;
	if (i < 0) i += this.count;
	var e = this.images[i];
	if (e == undefined) return 0;
	var rx = lengthdir_x(1, rot);
	var ry = lengthdir_y(1, rot);
	var ox = -e.origX * scaleX;
	var oy = -e.origY * scaleY;
	draw_sprite_general(this.sprite, 0, e.x, e.y, e.width, e.height, argument[1] + rx * ox - ry * oy, argument[2] + ry * ox + rx * oy, scaleX, scaleY, rot, col, col, col, col, argument[7]);
}

//}

//{ binp.haxe.class

function binp_haxe_class() constructor {
	// binp_haxe_class(l_id:int, name:string, ?l_constructor:dynamic)
	var this = self;
	static superClass = undefined;
	static constructor = undefined;
	static marker = undefined;
	static index = undefined;
	static name = undefined;
	var l_constructor;
	if (argument_count > 2) l_constructor = argument[2]; else l_constructor = undefined;
	this.superClass = undefined;
	this.marker = binp_haxe_type_markerValue;
	this.index = argument[0];
	this.name = argument[1];
	this.constructor = l_constructor;
	static __class__ = "class";
}

//}


