/// @description Insert description here
// You can write your code in this editor
draw_sprite_ext(tpage.sprite, 0, 0, 0, 1, 1, 0, -1, 0.3);

//
draw_set_font(fnt_test);
ds_queue_clear(vis_queue);
ds_queue_enqueue(vis_queue, tpage.root);
var spr = undefined, img = -1;
while (!ds_queue_empty(vis_queue)) {
	var e = ds_queue_dequeue(vis_queue);
	draw_rectangle(e.x + 1, e.y + 1, e.x + e.width - 1, e.y + e.height - 1, true);
	if (variable_struct_exists(e, "label")) {
		draw_text_ext(e.x + 3, e.y + 3, e.label, -1, e.width - 6);
	}
	if (e.leafA != undefined) ds_queue_enqueue(vis_queue, e.leafA);
	if (e.leafB != undefined) ds_queue_enqueue(vis_queue, e.leafB);
	if (point_in_rectangle(mouse_x, mouse_y, e.x, e.y, e.x + e.width - 1, e.y + e.height - 1)
	&& variable_struct_exists(e, "sprite")) {
		spr = e.sprite;
		img = e.index;
	}
}

//
if (spr != undefined) {
	spr.drawExt(img, mouse_x, mouse_y, 2, 2, current_time/3, c_white, 1);
}