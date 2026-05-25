include <openscad-utilities/common.scad>
use <keyboard case.scad>

name = "";

if (name == "bottom_right")
    rotate(90)
        bottom_right();
else if (name == "bottom_left")
    rotate(90)
        bottom_left();
else if (name == "top_right")
    rotate([180, 0, 90])
        top_right();
else if (name == "top_left")
    rotate([180, 0, 90])
        top_left();
else if (name == "electronics_cover_right")
    rotate([180, 0, 90])
        electronics_cover_right();
else if (name == "electronics_cover_left")
    rotate([180, 0, 90])
        electronics_cover_left();
