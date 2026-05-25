include <openscad-utilities/common.scad>

switch_cut_size = 14;
switch_cut_margin = 5;
switch_spacing = switch_cut_size + switch_cut_margin;
wall_thickness = 2.5;
plate_thickness = 1.5;
pcb_wall_space = 1.5;

teensy_x_dimension = 25;
outer_row_y_offset = 4.7625;

outer_column_x_offset = 4.7752;
middle_column_x_offset = 1.5977;
inner_column_x_offset = 2.8702;

case_body_x = teensy_x_dimension + 5 * switch_spacing + outer_column_x_offset + pcb_wall_space + wall_thickness;
case_body_y = 7 * switch_spacing + 2 * outer_row_y_offset + 2 * wall_thickness + 2 * pcb_wall_space;
thumb_size = 3 * switch_spacing + 2 * wall_thickness + 2 * pcb_wall_space;

surface_d = 3;
corner_d = 9;

height = 7.5 + 2 * plate_thickness;
electronics_cover_height = 4.5;
port_height = 7;

center_x = teensy_x_dimension + 2 * switch_spacing + middle_column_x_offset/2;
center_y = 3 * switch_spacing + 2 * outer_row_y_offset + wall_thickness + pcb_wall_space;

thumb_offset_x = center_x + 60.714092;
thumb_offset_y = center_y + 78.638974;

front_coordinates = [[center_x, center_y], 
                   [center_x + 48.4631, center_y - 62.7380],
                   [center_x + 66.1671, center_y + 33.6050], 
                   [center_x + 74.2441, center_y + 85.1412], 
                   [center_x + 30.0736, center_y + 79.3754]];                    
back_coordinates = [[center_x - 54.4576, center_y + 20.828], 
                   [center_x - 54.4576, center_y + 71.6284], 
                   [center_x - 54.4576, center_y - 62.103]];
coordinates = concat(front_coordinates, back_coordinates);

screw_passthrough_rad = 1.1;
screw_head_d = 4.2;

bottom_screw_post_height = 4;
top_screw_post_height = 3.5;

trrs_offset = center_y + 52.5784;
usb_offset = center_y + 1.3975;

trrs_notch_width = 17.5514 + 1;
usb_notch_width = 11.887 + 1;

if($preview) {
    left_assembly(explode = true);
}

module left_assembly(explode = false) {
    explode_dist = explode ? 20 : 0;

    bottom_left();
    translate([0, 0, explode_dist])
        top_left();
    translate([0, 0, 2 * explode_dist])
        electronics_cover_left();
}

module bottom_left() {
    difference() {
        union() {
            difference() {
                case_shell(15);
                translate([-1, -1, port_height]) {
                    cube([500, 500, 10]); 
                }
                translate([0, 0, bottom_screw_post_height + plate_thickness + 0.001]) {
                    case_skirt(wall_thickness/2, wall_thickness + 0.001, 10);
                }                         
            }
            bottom_screw_posts();
        }
        place_at_coordinates(coordinates) {
            rotate([180, 0, 0])
                countersink(shaft_diameter = 2 * screw_passthrough_rad, head_size = screw_head_d, 1.5);
        }
        translate([0, trrs_offset, port_height]) {
            rotate([0, 90, 0]){
                cylinder(r=3, h=10, center=true);
            }
        }
        translate([wall_thickness, trrs_offset, port_height]) {
            cube([wall_thickness, trrs_notch_width, port_height], center=true);
        }
        translate([wall_thickness, usb_offset, port_height]) {
            cube([wall_thickness, usb_notch_width, port_height], center=true);
        }
    }   
}

module bottom_right() {
    mirror([0, 1, 0]) {
        difference() {
            bottom_left();
            translate([0, usb_offset, 7]) {
                usb_cutout();
            }
        }
    }
}

module top_left() {
    union() {
        difference() {
            union() {
                case_shell(height);
                difference() {
                    top_screw_posts();
                    translate([0, 0, port_height - top_screw_post_height + wall_thickness/2]) {
                        case_skirt(-2 * wall_thickness, wall_thickness - 0.001, top_screw_post_height);
                    }
                }
                translate([teensy_x_dimension, wall_thickness, height - top_screw_post_height - plate_thickness]) {
                    cube([1, case_body_y - 2*wall_thickness, top_screw_post_height]);
                }
            }
            translate([-1, -1, height - top_screw_post_height - plate_thickness - 10 - 0.001]) {
                cube([500, 500, 10]); 
            }
            translate([0, 0, port_height - wall_thickness/2 - 1]) {
                case_skirt(- 0.001,  wall_thickness/2, wall_thickness/2 + 1);
            }
            translate([-1, -1]) {
                cube([teensy_x_dimension + 1.001, case_body_y + 2, 20]); 
            }  
            screw_holes(front_coordinates, height - 1);
            key_cutouts();    
        }                   
        translate([teensy_x_dimension - 1, surface_d/2 + 4, height - 1.001]) {
            cube([1, case_body_y - surface_d - 8, 1]);
        }
        top_back_screw_posts();      
    }
}

module top_right() {
    mirror([0, 1, 0]) {
        top_left();
    }
}

module electronics_cover_left() {
    difference() {
        union() {
            difference() {
                union() {
                    top_cover_rectangle(0, 0, 0);
                    case_rectangle(height, 0, 0);
                }
                top_cover_rectangle(plate_thickness, wall_thickness, 1);
                translate([-1, -1, height - top_screw_post_height - plate_thickness - 10 - 0.001]) {
                    cube([500, 500, 10]); 
                }
                translate([teensy_x_dimension, -1, height + 0.001 - 10]) {
                    cube([500, 500, 10]); 
                }
                hull() {
                    translate([teensy_x_dimension - 6, wall_thickness + 1.5, height - 10]) {
                        cube([10, case_body_y - 2 * wall_thickness - 3, 10]); 
                    }
                    translate([teensy_x_dimension - 6, wall_thickness, height - plate_thickness - top_screw_post_height]) {
                        cube([10, case_body_y - 2 * wall_thickness, top_screw_post_height]); 
                    }
                }
                translate([0, 0, port_height - wall_thickness/2 - 1.001]) {
                    case_skirt(-0.001,  wall_thickness/2, wall_thickness/2 + 1);
                }                                 
            }
            place_at_coordinates(back_coordinates) {
                translate([0, 0, height]) {
                    cylinder(r=3,h=electronics_cover_height - plate_thickness);
                }
            }
        }
        translate([0, trrs_offset, 7]) {
            rotate([0,90,0]){
                cylinder(r=3, h=10, center=true);
            }
        }
        screw_holes(back_coordinates, height + electronics_cover_height - 1);
        translate([wall_thickness - 0.001, trrs_offset, 7]) {
            cube([wall_thickness, 10.3, 7], center=true);
        }
    }
    
    module top_cover_rectangle(height_offset, edge_offset, xOffset) {
        translate([edge_offset, edge_offset, height_offset]) {
            roundedCube(teensy_x_dimension - edge_offset - xOffset, case_body_y - 2 * edge_offset, height + electronics_cover_height - 2 * height_offset, corner_d, surface_d);
        }
    }
}

module electronics_cover_right() {
    mirror([0, 1, 0]) {
        difference() {
            electronics_cover_left();
            translate([0, usb_offset, 7]) {
                hull() {
                    usb_cutout();
                    translate([0, 0, -5]) {
                        usb_cutout();
                    }
                }
            }
        }
    }
}
    
module case_shell(height) {
    difference() {
        case_base(height, 0, 0);
        case_base(height, plate_thickness, wall_thickness);
    }
}    
    
module case_base(height, height_offset, edge_offset) {
    union() {
        case_rectangle(height, height_offset, edge_offset);
        translate([thumb_offset_x, thumb_offset_y, height_offset]){
            rotate(-25) {
                translate([-thumb_size/2 + edge_offset, -1.5 * thumb_size + edge_offset, 0]){
                    roundedCube(thumb_size - 2 * edge_offset, 2*thumb_size - 2 * edge_offset, height - 2 * height_offset, corner_d, surface_d);
                }
            }
        }
    }
}

module case_rectangle(height, height_offset, edge_offset) {
     translate([edge_offset, edge_offset, height_offset]) {
        roundedCube(case_body_x - 2 * edge_offset, case_body_y - 2 * edge_offset, height - 2 * height_offset, corner_d, surface_d, true);
    }
}

module case_skirt(outerOffset, innerOffset, height) {
    difference() {
        linear_extrude(height = height) {
            projection(cut = false) {
                case_base(height, 0, outerOffset);
            }
        }
        translate([0, 0, -0.001]){
            linear_extrude(height = height + 0.002) {
                projection(cut = false) {
                    case_base(height, 0, innerOffset);
                }
            }
        }
    }    
}

module screw_holes(coordinates, height) {
    screw_bind_rad = 0.85;
    for(coordinate = coordinates) {
        translate(coordinate) {
            cylinder(r=screw_bind_rad, h=height);
        }
    }
}

module key_cutouts() {
    translate([center_x + middle_column_x_offset, center_y + switch_cut_margin/2, 0]) {    
        key_cutout(2*switch_spacing + outer_column_x_offset, - 3 * switch_spacing);
        for(i = [-2 : 2]) {
            if(i < 2) {
                key_cutout(i * switch_spacing + outer_column_x_offset, -outer_row_y_offset - 3 * switch_spacing);
                key_cutout(i * switch_spacing + inner_column_x_offset, 2 * switch_spacing);
            }
            key_cutout(i * switch_spacing + outer_column_x_offset, -2 * switch_spacing);
            key_cutout(i * switch_spacing + middle_column_x_offset, -switch_spacing);
            key_cutout(i * switch_spacing, 0);
            key_cutout(i * switch_spacing + middle_column_x_offset, switch_spacing);        
        }              
        inner_column_y_offset_1 = 4.7625;
        inner_column_y_offset_2 = inner_column_y_offset_1 + 9.5278;
        translate([inner_column_x_offset, 0, 0]) {        
            key_cutout(-2 * switch_spacing, 3 * switch_spacing);
            key_cutout(-switch_spacing + inner_column_y_offset_1, 3 * switch_spacing);
            key_cutout(inner_column_y_offset_2, 3 * switch_spacing);
        }
    }
    translate([thumb_offset_x, thumb_offset_y, 0]){
        rotate(-25) {
            translate([-switch_cut_size/2 , -switch_cut_size/2 , 0]) {
                for(i = [-1 : 1]) {
                    key_cutout(i * switch_spacing, switch_spacing);
                }
                key_cutout(-switch_spacing, 0);
                key_cutout(switch_spacing/2, 0);
                key_cutout(switch_spacing/2, -switch_spacing);
            }
        }
    }

    module key_cutout(x, y) {
        translate([x, y, 0]) {
            cube([switch_cut_size, switch_cut_size, 2 * height]);
        }
    }
}

module usb_cutout() {
    top_width = 7.7;
    bottom_width = 6.7;
    height = 3.9;
    rad = 0.7;
    cut_depth = 10;

    rotate([0, 90, 0])
        translate([0, 0, -cut_depth/2])
            linear_extrude(cut_depth)
                hull() {
                    translate([-height/2, -top_width/2])
                        rounded_square_2([height/2 + rad, top_width], r = rad);
                    translate([0, -bottom_width/2])
                        rounded_square_2([height/2, bottom_width], r = rad);
                }
}

module bottom_screw_posts() {
    place_at_coordinates(coordinates) {
        translate([0, 0, plate_thickness]) {
            union() {
                cylinder(r=3,h=bottom_screw_post_height);
                cylinder(r=4,h=2);
            }  
        }
    }
}

module top_screw_posts() {
    place_at_coordinates(coordinates) {
        translate([0, 0, height - plate_thickness - top_screw_post_height]) {
            difference() {
                union() {
                    translate([0, 0, -top_screw_post_height + top_screw_post_height]) {
                        cylinder(r=3,h=top_screw_post_height);
                    }
                    translate([0, 0, 0]) {
                        cylinder(r=3.5,h=top_screw_post_height);
                    }
                }
            }      
        }
    }
}

module top_back_screw_posts() {
    post_r = 3.5;
    place_at_coordinates(back_coordinates) {
        difference() {
            union() {
                hull() {
                    translate([0, 0, height - top_screw_post_height - plate_thickness]) {
                        cylinder(r=post_r,h=top_screw_post_height + plate_thickness);
                    }
                    translate([15.75, -post_r, height - top_screw_post_height - plate_thickness]) {
                        cube([1, 2 * post_r, top_screw_post_height]);
                    }
                    translate([18.5, -post_r, height - 1]) {
                        cube([1, 2 * post_r, 1]);
                    }
                }
                translate([0, 0, height - plate_thickness -top_screw_post_height]) {
                    cylinder(r=3,h=top_screw_post_height);
                }
            }
            fix_preview()
                union() {
                    cylinder(r=screw_passthrough_rad,h=height);
                    translate([3, -post_r + 1, height/2 - 1]) {
                        cube([20, 2 * post_r - 2, height/2]);
                    }
                }
        }
    }
}

module roundedCube(x, y, z, corner_d = 0.001, surface_d = 0.001, use_special_corner = false) {
    hull() {
        translate([x - corner_d/2, y - corner_d/2, 0]) {
            rounded_cylinder_2(z, corner_d, surface_d/2);
        }
        translate([corner_d/2, y - corner_d/2, 0]) {
            rounded_cylinder_2(z, corner_d, surface_d/2);
        }
        if(use_special_corner) {
            specialCornerDia = 27;
            translate([x - specialCornerDia/2, specialCornerDia/2, 0]) {
                rounded_cylinder_2(z, specialCornerDia, surface_d/2);
            }
        }
        else {
            translate([x - corner_d/2, corner_d/2, 0]) {
                rounded_cylinder_2(z, corner_d, surface_d/2);
            }
        }
        translate([corner_d/2, corner_d/2, 0]) {
            rounded_cylinder_2(z, corner_d, surface_d/2);
        }
    }
}

module place_at_coordinates(coordinates) {
    for(coordinate = coordinates)
        translate(coordinate)
            children();
}
