#define tex_page_init
// Generated at 2020-08-21 22:10:54 (237ms) for v2.2.5+
//{ prototypes
globalvar mq_tex_entry; mq_tex_entry = [undefined, /* 1:left */0, /* 2:top */0, /* 3:width */0, /* 4:height */0, /* 5:xoffset */0, /* 6:yoffset */0, /* 7:node_a */undefined, /* 8:node_b */undefined, /* 9:custom */undefined];
globalvar mq_tex_page; mq_tex_page = [undefined, /* 1:width */0, /* 2:height */0, /* 3:root */undefined, /* 4:sprite */undefined, /* 5:sprites */undefined, /* 6:surface */undefined, /* 7:custom */undefined];
globalvar mq_tex_sprite; mq_tex_sprite = [undefined, /* 1:images */undefined, /* 2:count */0, /* 3:sprite */undefined, /* 4:xoffset */0, /* 5:yoffset */0, /* 6:custom */undefined];
globalvar mq_tex_std_haxe_class; mq_tex_std_haxe_class = [undefined, /* 1:marker */undefined, /* 2:index */0, /* 3:name */undefined, /* 4:superClass */undefined, /* 5:constructor */undefined];
//}
//{ metatype
globalvar tex_std_haxe_type_markerValue; tex_std_haxe_type_markerValue = [];
globalvar mt_tex_entry; mt_tex_entry = tex_std_haxe_class_create(7, "tex_entry");
globalvar mt_tex_page; mt_tex_page = tex_std_haxe_class_create(8, "tex_page");
globalvar mt_tex_sprite; mt_tex_sprite = tex_std_haxe_class_create(9, "tex_sprite");
globalvar mt_tex_std_haxe_class; mt_tex_std_haxe_class = tex_std_haxe_class_create(11, "tex_std_haxe_class");
//}
// tex_entry:
globalvar g_tex_entry_insert_stack; g_tex_entry_insert_stack = ds_stack_create();

//{ tex_entry

#define tex_entry_create
// tex_entry_create(x:real, y:real, w:real, h:real)
var this = [mt_tex_entry];
array_copy(this, 1, mq_tex_entry, 1, 9);
this[@9/* custom */] = undefined;
this[@8/* node_b */] = undefined;
this[@7/* node_a */] = undefined;
this[@6/* yoffset */] = 0;
this[@5/* xoffset */] = 0;
this[@1/* left */] = argument[0];
this[@2/* top */] = argument[1];
this[@3/* width */] = argument[2];
this[@4/* height */] = argument[3];
return this;

#define tex_entry_add
// tex_entry_add(this:tex_entry, imgWidth:real, imgHeight:real)->TexEntry
var this = argument[0], _imgWidth = argument[1], _imgHeight = argument[2];
var _stack = g_tex_entry_insert_stack;
ds_stack_clear(_stack);
ds_stack_push(_stack, this);
while (!ds_stack_empty(_stack)) {
	var _e = ds_stack_pop(_stack);
	if (_e[7/* node_a */] != undefined) {
		if (_e[8/* node_b */] != undefined) ds_stack_push(_stack, _e[8/* node_b */]);
		ds_stack_push(_stack, _e[7/* node_a */]);
		continue;
	} else if (_e[8/* node_b */] != undefined) {
		ds_stack_push(_stack, _e[8/* node_b */]);
		continue;
	}
	var _entryWidth = _e[3/* width */];
	if (_imgWidth > _entryWidth) continue;
	var _entryHeight = _e[4/* height */];
	if (_imgHeight > _entryHeight) continue;
	var _remWidth = _entryWidth - _imgWidth;
	var _remHeight = _entryHeight - _imgHeight;
	if (_remWidth <= _remHeight) {
		_e[@7/* node_a */] = tex_entry_create(_e[1/* left */] + _imgWidth, _e[2/* top */], _remWidth, _imgHeight);
		_e[@8/* node_b */] = tex_entry_create(_e[1/* left */], _e[2/* top */] + _imgHeight, _entryWidth, _remHeight);
	} else {
		_e[@7/* node_a */] = tex_entry_create(_e[1/* left */], _e[2/* top */] + _imgHeight, _imgWidth, _remHeight);
		_e[@8/* node_b */] = tex_entry_create(_e[1/* left */] + _imgWidth, _e[2/* top */], _remWidth, _entryHeight);
	}
	_e[@3/* width */] = _imgWidth;
	_e[@4/* height */] = _imgHeight;
	ds_stack_clear(_stack);
	return _e;
}
return undefined;

//}

//{ tex_page

#define tex_page_create
// tex_page_create(w:int, h:int)
var this = [mt_tex_page];
array_copy(this, 1, mq_tex_page, 1, 7);
var _w = argument[0], _h = argument[1];
this[@7/* custom */] = undefined;
this[@5/* sprites */] = [];
this[@4/* sprite */] = -1;
this[@1/* width */] = _w;
this[@2/* height */] = _h;
this[@3/* root */] = tex_entry_create(0, 0, _w, _h);
this[@6/* surface */] = surface_create(_w, _h);
surface_set_target(this[6/* surface */]);
draw_clear_alpha(0, 0);
surface_reset_target();
return this;

#define tex_page_destroy
// tex_page_destroy(this:tex_page)
var this = argument[0];
if (this[4/* sprite */] != -1) {
	sprite_delete(this[4/* sprite */]);
	this[@4/* sprite */] = -1;
	var __g = 0;
	var __g1 = this[5/* sprites */];
	while (__g < array_length_1d(__g1)) {
		var _qs = __g1[__g];
		++__g;
		var _i = 0;
		for (var __g11 = _qs[2/* count */]; _i < __g11; _i++) {
			tex_std_haxe_boot_wset(_qs[1/* images */], _i, undefined);
		}
	}
}
if (this[6/* surface */] != -1) {
	surface_free(this[6/* surface */]);
	this[@6/* surface */] = -1;
}

#define tex_page_add
// tex_page_add(this:tex_page, fname:string, imgNumb:int, ox:real, oy:real)->TexSprite
var this = argument[0], _imgNumb = argument[2], _ox = argument[3], _oy = argument[4];
if (this[4/* sprite */] != -1) show_error("This texture page is already finalized", false);
var _spr = sprite_add(argument[1], _imgNumb, false, false, 0, 0);
if (_spr == -1) return undefined;
var _sw = sprite_get_width(_spr);
var _sh = sprite_get_height(_spr);
var _qs = tex_sprite_create(_imgNumb, _ox, _oy);
var _ob = gpu_get_blendmode_ext();
gpu_set_blendmode_ext(2, 1);
surface_set_target(this[6/* surface */]);
var _i = 0;
for (var __g1 = _imgNumb; _i < __g1; _i++) {
	var _qe = tex_entry_add(this[3/* root */], _sw, _sh);
	tex_std_haxe_boot_wset(_qs[1/* images */], _i, _qe);
	if (_qe != undefined) {
		_qe[@5/* xoffset */] = _ox;
		_qe[@6/* yoffset */] = _oy;
		draw_sprite(_spr, _i, _qe[1/* left */], _qe[2/* top */]);
	}
}
gpu_set_blendmode_ext(_ob);
surface_reset_target();
sprite_delete(_spr);
tex_std_haxe_boot_wset(this[5/* sprites */], array_length_1d(this[5/* sprites */]), _qs);
return _qs;

#define tex_page_finalize
// tex_page_finalize(this:tex_page)
var this = argument[0];
if (this[4/* sprite */] != -1) show_error("This texture page is already finalized", false);
var __this = this[6/* surface */];
this[@4/* sprite */] = sprite_create_from_surface(__this, 0, 0, surface_get_width(__this), surface_get_height(__this), false, false, 0, 0);
var _i = 0;
for (var __g1 = array_length_1d(this[5/* sprites */]); _i < __g1; _i++) {
	var _qs = tex_std_haxe_boot_wget(this[5/* sprites */], _i);
	_qs[@3/* sprite */] = this[4/* sprite */];
}
surface_free(this[6/* surface */]);

//}

//{ tex_sprite

#define tex_sprite_create
// tex_sprite_create(count:int, xofs:real, yofs:real)
var this = [mt_tex_sprite];
array_copy(this, 1, mq_tex_sprite, 1, 6);
var _count = argument[0];
this[@6/* custom */] = undefined;
this[@3/* sprite */] = -1;
this[@2/* count */] = _count;
this[@4/* xoffset */] = argument[1];
this[@5/* yoffset */] = argument[2];
this[@1/* images */] = array_create(_count, undefined);
return this;

#define tex_sprite_set_offset
// tex_sprite_set_offset(this:tex_sprite, xo:real, yo:real)
var this = argument[0];
var _dx = argument[1] - this[4/* xoffset */];
var _dy = argument[2] - this[5/* yoffset */];
var _i = 0;
for (var __g1 = this[2/* count */]; _i < __g1; _i++) {
	var _e = tex_std_haxe_boot_wget(this[1/* images */], _i);
	if (_e != undefined) {
		_e[@5/* xoffset */] += _dx;
		_e[@6/* yoffset */] += _dy;
	}
}

#define tex_sprite_draw
// tex_sprite_draw(this:tex_sprite, subimg:real, x:real, y:real)
var this = argument[0];
var _i = (argument[1] | 0) % this[2/* count */];
if (_i < 0) _i += this[2/* count */];
var _e = tex_std_haxe_boot_wget(this[1/* images */], _i);
if (_e == undefined) return 0;
draw_sprite_part(this[3/* sprite */], 0, _e[1/* left */], _e[2/* top */], _e[3/* width */], _e[4/* height */], argument[2] - _e[5/* xoffset */], argument[3] - _e[6/* yoffset */]);

#define tex_sprite_draw_ext
// tex_sprite_draw_ext(this:tex_sprite, subimg:real, x:real, y:real, scaleX:real, scaleY:real, rot:real, col:Color, alpha:real)
var this = argument[0], _scaleX = argument[4], _scaleY = argument[5], _rot = argument[6], _col = argument[7];
var _i = (argument[1] | 0) % this[2/* count */];
if (_i < 0) _i += this[2/* count */];
var _e = tex_std_haxe_boot_wget(this[1/* images */], _i);
if (_e == undefined) return 0;
var _rx = lengthdir_x(1, _rot);
var _ry = lengthdir_y(1, _rot);
var _ox = -_e[5/* xoffset */] * _scaleX;
var _oy = -_e[6/* yoffset */] * _scaleY;
draw_sprite_general(this[3/* sprite */], 0, _e[1/* left */], _e[2/* top */], _e[3/* width */], _e[4/* height */], argument[2] + _rx * _ox - _ry * _oy, argument[3] + _ry * _ox + _rx * _oy, _scaleX, _scaleY, _rot, _col, _col, _col, _col, argument[8]);

#define tex_sprite_draw_part
// tex_sprite_draw_part(this:tex_sprite, subimg:real, left:real, top:real, width:real, height:real, x:real, y:real)
var this = argument[0];
var _i = (argument[1] | 0) % this[2/* count */];
if (_i < 0) _i += this[2/* count */];
var _e = tex_std_haxe_boot_wget(this[1/* images */], _i);
if (_e == undefined) return 0;
draw_sprite_part(this[3/* sprite */], 0, _e[1/* left */] + argument[2], _e[2/* top */] + argument[3], argument[4], argument[5], argument[6], argument[7]);

#define tex_sprite_draw_part_ext
// tex_sprite_draw_part_ext(this:tex_sprite, subimg:real, left:real, top:real, width:real, height:real, x:real, y:real, sx:real, sy:real, rot:real, c:Color, a:real)
var this = argument[0], _rot = argument[10], _c = argument[11];
var _i = (argument[1] | 0) % this[2/* count */];
if (_i < 0) _i += this[2/* count */];
var _e = tex_std_haxe_boot_wget(this[1/* images */], _i);
if (_e == undefined) return 0;
var _rx = lengthdir_x(1, _rot);
var _ry = lengthdir_y(1, _rot);
draw_sprite_general(this[3/* sprite */], 0, _e[1/* left */] + argument[2], _e[2/* top */] + argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], _rot, _c, _c, _c, _c, argument[12]);

#define tex_sprite_draw_general
// tex_sprite_draw_general(this:tex_sprite, subimg:real, left:real, top:real, width:real, height:real, x:real, y:real, sx:real, sy:real, rot:real, c:Color, c:Color, c:Color, c:Color, a:real)
var this = argument[0], _rot = argument[10];
var _i = (argument[1] | 0) % this[2/* count */];
if (_i < 0) _i += this[2/* count */];
var _e = tex_std_haxe_boot_wget(this[1/* images */], _i);
if (_e == undefined) return 0;
var _rx = lengthdir_x(1, _rot);
var _ry = lengthdir_y(1, _rot);
draw_sprite_general(this[3/* sprite */], 0, _e[1/* left */] + argument[2], _e[2/* top */] + argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], _rot, argument[11], argument[12], argument[13], argument[14], argument[15]);

//}

//{ tex_std.haxe.class

#define tex_std_haxe_class_create
// tex_std_haxe_class_create(id:int, name:string)
var this = ["mt_tex_std_haxe_class"];
array_copy(this, 1, mq_tex_std_haxe_class, 1, 5);
this[@4/* superClass */] = undefined;
this[@1/* marker */] = tex_std_haxe_type_markerValue;
this[@2/* index */] = argument[0];
this[@3/* name */] = argument[1];
return this;

//}

//{ tex_std.haxe.boot

#define tex_std_haxe_boot_wget
// tex_std_haxe_boot_wget(arr:array<T>, index:int)->T
var _arr = argument[0], _index = argument[1];
return _arr[_index];

#define tex_std_haxe_boot_wset
// tex_std_haxe_boot_wset(arr:array<T>, index:int, value:T)
var _arr = argument[0], _index = argument[1];
_arr[@_index] = argument[2];

//}
