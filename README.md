# tex-pack
This is a small extension that allows you to combine multiple images into texture pages at runtime through a bin packing algorithm.
![image](https://user-images.githubusercontent.com/731492/80915674-8ec4ef00-8d5c-11ea-93dc-d9ae511f4551.png)

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
