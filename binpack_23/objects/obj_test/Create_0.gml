/// @description Insert description here
// You can write your code in this editor
tpage = new TexPage(2048, 1024);
var f = file_find_first("items/*.png", 0);
items = {};
for (; f != ""; f = file_find_next()) {
	var name = filename_change_ext(f, "");
	var sp = tpage.add("items/" + f, 1, 0, 0);
	for (var i = 0; i < sp.count; i++) {
		var img = sp.images[i];
		if (img != undefined) {
			// debug only
			img.label = string_digits(name);
			img.index = i;
			img.sprite = sp;
			img.origX = img.width / 2;
			img.origY = img.height / 2;
		} else {
			show_debug_message("Can't fit " + name + " image " + string(i));
		}
	}
	variable_struct_set(items, name, sp);
}
file_find_close();
surface_save(tpage.surface, "surf.png");
tpage.finalize();
//show_debug_message(items);
vis_queue = ds_queue_create();