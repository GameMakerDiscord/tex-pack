// Generated at 2020-05-03 21:21:35 (306ms) for v2.3+
//{ metatype
globalvar tex_std_haxe_type_markerValue; tex_std_haxe_type_markerValue = [];
globalvar mt_TexEntry; mt_TexEntry = new tex_std_haxe_class(-1, "TexEntry", TexEntry);
globalvar mt_TexPage; mt_TexPage = new tex_std_haxe_class(-1, "TexPage", TexPage);
globalvar mt_TexSprite; mt_TexSprite = new tex_std_haxe_class(-1, "TexSprite", TexSprite);
globalvar mt_tex_std_haxe_class; mt_tex_std_haxe_class = new tex_std_haxe_class(-1, "tex_std_haxe_class", tex_std_haxe_class);
//}

//{ TexEntry

function TexEntry() constructor {
	/// TexEntry(l_x:real, l_y:real, w:real, h:real)
	/// @param l_x:real
	/// @param l_y:real
	/// @param w:real
	/// @param h:real
	var this = self;
	static left = undefined;
	static top = undefined;
	static width = undefined;
	static height = undefined;
	static xoffset = undefined;
	static yoffset = undefined;
	static nodeA = undefined;
	static nodeB = undefined;
	static add = method(undefined, TexEntry_add);
	this.nodeB = undefined;
	this.nodeA = undefined;
	this.yoffset = 0;
	this.xoffset = 0;
	this.left = argument[0];
	this.top = argument[1];
	this.width = argument[2];
	this.height = argument[3];
	static __class__ = mt_TexEntry;
}

function TexEntry_add() {
	/// TexEntry_add(imgWidth:real, imgHeight:real)->TexEntry
	/// @param imgWidth:real
	/// @param imgHeight:real
	var this = self, imgWidth = argument[0], imgHeight = argument[1];
	var stack = g_TexEntry_insertStack;
	ds_stack_clear(stack);
	ds_stack_push(stack, this);
	while (!ds_stack_empty(stack)) {
		var e = ds_stack_pop(stack);
		if (e.nodeA != undefined) {
			if (e.nodeB != undefined) ds_stack_push(stack, e.nodeB);
			ds_stack_push(stack, e.nodeA);
			continue;
		} else if (e.nodeB != undefined) {
			ds_stack_push(stack, e.nodeB);
			continue;
		}
		var entryWidth = e.width;
		if (imgWidth > entryWidth) continue;
		var entryHeight = e.height;
		if (imgHeight > entryHeight) continue;
		var remWidth = entryWidth - imgWidth;
		var remHeight = entryHeight - imgHeight;
		if (remWidth <= remHeight) {
			e.nodeA = new TexEntry(e.left + imgWidth, e.top, remWidth, imgHeight);
			e.nodeB = new TexEntry(e.left, e.top + imgHeight, entryWidth, remHeight);
		} else {
			e.nodeA = new TexEntry(e.left, e.top + imgHeight, imgWidth, remHeight);
			e.nodeB = new TexEntry(e.left + imgWidth, e.top, remWidth, entryHeight);
		}
		e.width = imgWidth;
		e.height = imgHeight;
		ds_stack_clear(stack);
		return e;
	}
	return undefined;
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
	var this = self, imgNumb = argument[1], ox = argument[2], oy = argument[3];
	if (this.sprite != -1) throw "This texture page is already finalized";
	var spr = sprite_add(argument[0], imgNumb, false, false, 0, 0);
	if (spr == -1) return undefined;
	var sw = sprite_get_width(spr);
	var sh = sprite_get_height(spr);
	var qs = new TexSprite(imgNumb, ox, oy);
	var ob = gpu_get_blendmode_ext();
	gpu_set_blendmode_ext(2, 1);
	surface_set_target(this.surface);
	var i = 0;
	for (var _g1 = imgNumb; i < _g1; i++) {
		var qe = this.root.add(sw, sh);
		qs.images[@i] = qe;
		if (qe != undefined) {
			qe.xoffset = ox;
			qe.yoffset = oy;
			draw_sprite(spr, 0, qe.left, qe.top);
		}
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
	/// TexSprite(count:int, xofs:real, yofs:real)
	/// @param count:int
	/// @param xofs:real
	/// @param yofs:real
	var this = self;
	static images = undefined;
	static count = undefined;
	static sprite = undefined;
	static xoffset = undefined;
	static yoffset = undefined;
	static setOffset = method(undefined, TexSprite_setOffset);
	static draw = method(undefined, TexSprite_draw);
	static drawExt = method(undefined, TexSprite_drawExt);
	static drawPart = method(undefined, TexSprite_drawPart);
	static drawPartExt = method(undefined, TexSprite_drawPartExt);
	static drawGeneral = method(undefined, TexSprite_drawGeneral);
	var count = argument[0];
	this.sprite = -1;
	this.count = count;
	this.xoffset = argument[1];
	this.yoffset = argument[2];
	this.images = array_create(count, undefined);
	static __class__ = mt_TexSprite;
}

function TexSprite_setOffset() {
	/// TexSprite_setOffset(xo:real, yo:real)
	/// @param xo:real
	/// @param yo:real
	var this = self;
	var dx = argument[0] - this.xoffset;
	var dy = argument[1] - this.yoffset;
	var i = 0;
	for (var _g1 = this.count; i < _g1; i++) {
		var e = this.images[i];
		if (e != undefined) {
			e.xoffset += dx;
			e.yoffset += dy;
		}
	}
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
	draw_sprite_part(this.sprite, 0, e.left, e.top, e.width, e.height, argument[1] - e.xoffset, argument[2] - e.yoffset);
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
	var ox = -e.xoffset * scaleX;
	var oy = -e.yoffset * scaleY;
	draw_sprite_general(this.sprite, 0, e.left, e.top, e.width, e.height, argument[1] + rx * ox - ry * oy, argument[2] + ry * ox + rx * oy, scaleX, scaleY, rot, col, col, col, col, argument[7]);
}

function TexSprite_drawPart() {
	/// TexSprite_drawPart(subimg:real, left:real, top:real, width:real, height:real, l_x:real, l_y:real)
	/// @param subimg:real
	/// @param left:real
	/// @param top:real
	/// @param width:real
	/// @param height:real
	/// @param l_x:real
	/// @param l_y:real
	var this = self;
	var i = (argument[0] | 0) % this.count;
	if (i < 0) i += this.count;
	var e = this.images[i];
	if (e == undefined) return 0;
	draw_sprite_part(this.sprite, 0, e.left + argument[1], e.top + argument[2], argument[3], argument[4], argument[5], argument[6]);
}

function TexSprite_drawPartExt() {
	/// TexSprite_drawPartExt(subimg:real, left:real, top:real, width:real, height:real, l_x:real, l_y:real, sx:real, sy:real, rot:real, c:Color, a:real)
	/// @param subimg:real
	/// @param left:real
	/// @param top:real
	/// @param width:real
	/// @param height:real
	/// @param l_x:real
	/// @param l_y:real
	/// @param sx:real
	/// @param sy:real
	/// @param rot:real
	/// @param c:Color
	/// @param a:real
	var this = self, rot = argument[9], c = argument[10];
	var i = (argument[0] | 0) % this.count;
	if (i < 0) i += this.count;
	var e = this.images[i];
	if (e == undefined) return 0;
	var rx = lengthdir_x(1, rot);
	var ry = lengthdir_y(1, rot);
	draw_sprite_general(this.sprite, 0, e.left + argument[1], e.top + argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], rot, c, c, c, c, argument[11]);
}

function TexSprite_drawGeneral() {
	/// TexSprite_drawGeneral(subimg:real, left:real, top:real, width:real, height:real, l_x:real, l_y:real, sx:real, sy:real, rot:real, c:Color, c:Color, c:Color, c:Color, a:real)
	/// @param subimg:real
	/// @param left:real
	/// @param top:real
	/// @param width:real
	/// @param height:real
	/// @param l_x:real
	/// @param l_y:real
	/// @param sx:real
	/// @param sy:real
	/// @param rot:real
	/// @param c:Color
	/// @param c:Color
	/// @param c:Color
	/// @param c:Color
	/// @param a:real
	var this = self, rot = argument[9];
	var i = (argument[0] | 0) % this.count;
	if (i < 0) i += this.count;
	var e = this.images[i];
	if (e == undefined) return 0;
	var rx = lengthdir_x(1, rot);
	var ry = lengthdir_y(1, rot);
	draw_sprite_general(this.sprite, 0, e.left + argument[1], e.top + argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], rot, argument[10], argument[11], argument[12], argument[13], argument[14]);
}

//}

//{ tex_std.haxe.class

function tex_std_haxe_class() constructor {
	// tex_std_haxe_class(l_id:int, name:string, ?l_constructor:dynamic)
	var this = self;
	static superClass = undefined;
	static constructor = undefined;
	static marker = undefined;
	static index = undefined;
	static name = undefined;
	var l_constructor;
	if (argument_count > 2) l_constructor = argument[2]; else l_constructor = undefined;
	this.superClass = undefined;
	this.marker = tex_std_haxe_type_markerValue;
	this.index = argument[0];
	this.name = argument[1];
	this.constructor = l_constructor;
	static __class__ = "class";
}

//}

// TexEntry:
globalvar g_TexEntry_insertStack; g_TexEntry_insertStack = ds_stack_create();

