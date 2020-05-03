var px = spr_texpack_demo;
var tps = tpage[tex_page_sprite];
draw_sprite_ext(tps,0, 0,0, 1,1, 0, c_white,0.3);
var tpw = sprite_get_width(tps);
var tph = sprite_get_height(tps);
draw_sprite_stretched(px,0, tpw,0, 1, tph);
draw_sprite_stretched(px,0, 0,tph, tpw + 1, 1);

//
draw_set_font(fnt_texpack_demo);
ds_queue_clear(vis_queue);
ds_queue_enqueue(vis_queue, tpage[tex_page_root]);
var spr = undefined, img = -1;
while (!ds_queue_empty(vis_queue)) {
	var e = ds_queue_dequeue(vis_queue);
	var ex = e[tex_entry_left];
	var ey = e[tex_entry_top];
	var ew = e[tex_entry_width];
	var eh = e[tex_entry_height];
	//
	if (ew > 1 && eh > 1) {
		draw_sprite_stretched(px,0, ex, ey, ew - 1, 1);
		draw_sprite_stretched(px,0, ex, ey + 1, 1, eh - 2);
	}
	//
	//draw_rectangle(ex + 1, ey + 1, ex + ew - 1, ey + eh - 1, true);
	var e_has_custom = array_length_1d(e) > tex_entry_custom + 1;
	if (e_has_custom) {
		draw_text_ext(ex + 3, ey + 3, e[tex_entry_custom], -1, ew - 6);
	}
	var ea = e[tex_entry_node_a];
	if (ea != undefined) ds_queue_enqueue(vis_queue, ea);
	var eb = e[tex_entry_node_b];
	if (eb != undefined) ds_queue_enqueue(vis_queue, eb);
	if (point_in_rectangle(mouse_x, mouse_y, ex, ey, ex + ew - 1, ey + eh - 1)
	&& e_has_custom) {
		spr = e[tex_entry_custom + 1];
		img = e[tex_entry_custom + 2];
	}
}

//
if (spr != undefined) {
	tex_sprite_draw_ext(spr, img, mouse_x, mouse_y, 2, 2, current_time/3, c_white, 1);
}