// draw the texture page:
var px = spr_texpack_demo;
draw_sprite_ext(tpage.sprite, 0, 0, 0, 1, 1, 0, -1, 0.3);
var tpw = sprite_get_width(tpage.sprite);
var tph = sprite_get_height(tpage.sprite);
draw_sprite_stretched(px,0, tpw,0, 1, tph);
draw_sprite_stretched(px,0, 0,tph, tpw + 1, 1);

//
draw_set_font(fnt_texpack_demo);
ds_queue_clear(vis_queue);
ds_queue_enqueue(vis_queue, tpage.root);
var spr = undefined, img = -1;
while (!ds_queue_empty(vis_queue)) {
	var e = ds_queue_dequeue(vis_queue);
	if (e.width > 1 && e.height > 1) {
		draw_sprite_stretched(px,0, e.x, e.y, e.width - 1, 1);
		draw_sprite_stretched(px,0, e.x, e.y + 1, 1, e.height - 2);
	}
	if (variable_struct_exists(e, "label")) {
		draw_text_ext(e.x + 3, e.y + 3, e.label, -1, e.width - 6);
	}
	if (e.nodeA != undefined) ds_queue_enqueue(vis_queue, e.nodeA);
	if (e.nodeB != undefined) ds_queue_enqueue(vis_queue, e.nodeB);
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