# tex-pack
This is a small extension that allows you to combine multiple images into texture pages at runtime through a bin packing algorithm.
![image](https://user-images.githubusercontent.com/731492/80915674-8ec4ef00-8d5c-11ea-93dc-d9ae511f4551.png)

## Example (<=2.2)
```gml
tpage = tex_page_create(1024, 1024);
one = tex_page_add(tpage, "one.png", 1, 64, 64);
two = tex_page_add(tpage, "two.png", 2, 64, 64);
tex_page_finalize(tpage);

// ... later, to draw:
tex_sprite_draw(one, 0, x, y);
tex_sprite_draw_ext(two, 1, x, y, 2, 2, current_time / 3, c_white, 1);
```

## Example (>=2.3)
```gml
tpage = new TexPage(1024, 1024);
one = tpage.add("one.png", 1, 64, 64);
two = tpage.add("two.png", 2, 64, 64);
tpage.finalize();

// ... later, to draw:
one.draw(0, x, y);
two.drawExt(1, x, y, 2, 2, current_time / 3, c_white, 1);
```

## Compiling Haxe->GML

- Install [Haxe](https://haxe.org/)
- Install sfhx via  
  `haxelib git sfhx https://github.com/YellowAfterlife/sfhx`
- Install sfgml via  
  `haxelib git sfgml https://github.com/YellowAfterlife/sfgml`
- Do `haxe binpack.hxml` to compile all versions.

This will update all 3 GameMaker projects.

## Approach
Since packing happens at runtime, the approach used is one of the simplest possible -
the algorithm finds the first child-less rectangular node in the tree that can fit an image,
marks it as a container for it, and divides it into three - now-image-sized node itself,
and two children filling the remaining space:
```
+-------+    +---+---+
|       |    | E |   |
|   E   | -> +---+ B +
|       |    | A |   |
+-------+    +-------+
```
Split direction depends on remaining width/height after subtracting image size.

I do not know the algorithm name off-hand as this is loosely based on an example I made for someone in 2012.

## Authors, license
Vadim ["YellowAfterlife"](https://yal.cc) Dyachenko

[MIT license](https://en.wikipedia.org/wiki/MIT_License)
