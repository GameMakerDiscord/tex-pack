tpage = tex_page_create(2048, 1024);
var f = file_find_first("items/*.png", 0);
for (; f != ""; f = file_find_next()) {
	var name = filename_change_ext(f, "");
	var sp = tex_page_add(tpage, "items/" + f, 1, 0, 0);
	var images = sp[tex_sprite_images];
	for (var i = 0; i < sp[tex_sprite_count]; i++) {
		var img = images[i];
		if (img != undefined) {
			img[@tex_entry_xoffset] = img[tex_entry_width] / 2;
			img[@tex_entry_yoffset] = img[tex_entry_height] / 2;
			img[@tex_entry_custom] = string_digits(name);
			img[@tex_entry_custom + 1] = sp;
			img[@tex_entry_custom + 2] = i;
		} else {
			show_debug_message("Can't fit " + name + " image " + string(i));
		}
	}
}
file_find_next();
tex_page_finalize(tpage);
vis_queue = ds_queue_create();