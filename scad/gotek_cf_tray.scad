// Gotek Floppy Emulator - 5.25" bay
// Written by Michael Berry <michaelaberry@gmail.com> and Joe Legeckis <thejml@gmail.com>
model_version = "v1.7.4";

// Features: 
//  - CF / IDE Card mount
//  - 1.2" OLED Display
//  - Gotek Floppy emulator ports
//  - Rotary Encoder

//Overall Drive size
// Z - 42mm (42.3mm max)
// X - 148mm (148.7mm max)
// Y - 138mm (flexible, min 136mm)

/* 
TODO:
Gotek: 
  back to middle: 21mm middle to front: 50mm pegs: 2.75mm 
  peg spread: 50mm
  front peg to front panel: 17mm

Rotary Encoder
- move indexing cutout to a flushmount cylinder on the inside wall. (too much stem outside)
- consider recessing the nut by 1mm to better flush the skirt of the knob

CF Adapter

- print support tabs with pins. (flexible mounting with/without screws)

OLED
- build a frame with captive side-walls and plastic pins
- frame may be connected at the top with room for data pins

*/

screw_insert_diameter = 3.2;

tray_x_front = 149;
tray_x = 146;
tray_y = 138;
tray_z = 42;

offset_tray_x_front = tray_x_front / 2;
offset_tray_x = tray_x / 2;
offset_tray_y = tray_y / 2;
offset_tray_z = tray_z / 2;

front_thickness = 3;

cf_adapter_location = [3 - offset_tray_x, front_thickness - offset_tray_y, offset_tray_z - 39];

//Render the main tray
module tray() {
    difference() {
        union() {
            translate([0,-offset_tray_y+front_thickness/2,0]) {
                color([1, 0.9, 0.9]) cube([tray_x_front, front_thickness, tray_z], center = true);
            }
            color([0.9, 0.9, 0.9]) cube([tray_x, tray_y, tray_z], center = true);
        }
        union() {
            // Carve out the inner tray
            translate([0, 3, 3]) {
                cube([tray_x - 6, tray_y, tray_z], center = true);
            }
        }
    }
}
 
difference() {
    union() {
        tray(); 
 
        // Support the sides on the back.
        backSupport();
        mirror([tray_x, 0, 0]) backSupport();
    
        // Rotary Encoder
        translate([offset_tray_x/4, offset_tray_y - tray_y, 28 - offset_tray_z]) {
            rotaryEncoderSupport(front_thickness,false);
        }

        // Support for CF, Gotek, LCD, and CF
        gotekBoardSupport(false);
        lcdSupports(false);
        cfBoardSupport(cf_adapter_location,false); 
    }
    union() {
        // Carve out the mounting holes
        trayMount();
        mirror([tray_x, 0, 0]) trayMount();

        translate([offset_tray_x / 4, offset_tray_y - tray_y, 28 - offset_tray_z]) {
            rotaryEncoderSupport(front_thickness,true);
        }

        // Save some plastic!
        plasticSaverSides();
        mirror([tray_x, 0, 0]) plasticSaverSides();
        plasticSaverBase();
        cfBoardSupport(cf_adapter_location, true);
        gotekBoardSupport(true);
        lcdSupports(true);

    }
}

echo("Model Version", model_version);

//Supports / Brackets / Mounts "Library"
module lcdSupports(do_deletes) {
    lcd_x = 27.5;
    lcd_y = 3;
    lcd_z = 28;

    mount_x = 4.1;
    mount_y = 1.75;
    mount_z = 3.5;
    thickness = 5;
    support_diameter = 3;

    bottom_to_display     = 9.8;
    overall_display_width = 28;
    overall_display_height= 28;

    // Screw holes x = 23.4mm
    // Screw holes z = 24mm
    // Screw Sizes = 2mm
    // https://www.amazon.com/gp/product/B09JWN8K99/ref=ewc_pr_img_1?smid=A1JX4L5CBS4J9K&th=1
    if (do_deletes==false) {
        color([0.8,0.4,0]) {
            translate([offset_tray_x-tray_x+37, offset_tray_y - tray_y + front_thickness+thickness, -7]) {
                translate([0,0,0]) cube([overall_display_width,2,bottom_to_display],center = false); 
                translate([overall_display_width,0-(thickness),0]) cube([2,thickness+2,bottom_to_display],center = false); 
                translate([-2,0-(thickness),0]) cube([2,thickness+2,bottom_to_display],center = false); 
                translate([-2,0-(thickness),-0.6]) cube([overall_display_width+4,thickness+2,0.6],center = false); 
            }
        }
    }
    if (do_deletes==true) {
        //LCD
        translate([51 - offset_tray_x + 6, offset_tray_y - tray_y - 0.5, 29 - offset_tray_z]) {
            //cube([26, 6, 14], center = true);
            //Screen size 14mm tall, 26mm wide (Scale opening to account for bezel)
            rotate([90, 0, 180]) trapezoidalPyramid(19.5, 31.5, 4);
        }
    } 
}

module cfBoardSupport(location, do_deletes) {
    /*  7mm to front
        24mm front to back support width
        93mm side to side support width
        2.5mm pegs
        CF Width: 48 
        Board right side to CF: 23 
        peg center to side: 3
    */
    support_width = 8;
    support_height = 2;
    cf_space = 2;
    cf_width = 43;
    cf_height = 4;
    cf_depth = 36.5;
    // Overall Placement
    translate(location) {
        color([0.8,0.65,0.5]) {
            if (do_deletes==false) {
                union() {
                    // Fake CF is 3mm up from botom of board... for Uncomment for Testing:
                    // CF is 43mm wide, sticks past the front of the PCB by 15mm out of 36.5mm deep and 3mm thick
                    // It's up 3mm from the bottom of the PCB. 
                    // Left to right, the CF starts at 28mm to 71mm out of 99mm PCB Width
                    translate([0,0,0]) {
                        cube([support_width, 35, support_height], center = false);
                    }

                    translate([93, 0, 0]) {
                        cube([support_width, 35, support_height], center = false);
                    }
                }
            } else {
                union() {
                    translate([  0+support_width/2,  7, -1]) cylinder(d = screw_insert_diameter, h = 3.5, $fn=36, center = false);
                    translate([ 93+support_width/2,  7, -1]) cylinder(d = screw_insert_diameter, h = 3.5, $fn=36, center = false);
                    translate([  0+support_width/2, 31, -1]) cylinder(d = screw_insert_diameter, h = 3.5, $fn=36, center = false);
                    translate([ 93+support_width/2, 31, -1]) cylinder(d = screw_insert_diameter, h = 3.5, $fn=36, center = false);

                    //CF Slot
                    translate([28-cf_space,-6,3+support_height-cf_space]) {
                        cube([cf_width+cf_space*2, 6.5+front_thickness, cf_height+cf_space*2], center = false);
                    }
                }
            } 
        }
    }
}

module gotekBoardSupport(do_deletes) {
    support_diameter = 8;
    support_height = 11.5;
    location = [offset_tray_x-7.5,21-offset_tray_y,offset_tray_z-tray_z+3];

    translate(location) {
        if (do_deletes==false) {
            color([0.0,0.7,1]) {
                difference() {
                    union() {
                        translate([-55,-8+front_thickness,0]) {
                            cube([60,88,support_height], center=false);
                        }
                        rotate([0,0,180]) translate([45,-100-front_thickness,0]) prism(10,20,support_height);
                        rotate([0,0,180]) translate([-5,-100-front_thickness,0]) prism(10,20,support_height);
                    }
                    union() {
                        translate([-45,-10+front_thickness,-1]) {
                            cube([40,100,support_height+2], center=false);
                        }
                        translate([-65,-17+front_thickness,-1]) {
                            cube([60,60,support_height+2], center=false);
                        }
                    }
                }
            } //color
        } else {
            //USB Port (15mm x 8mm)  [offset_tray_x_front - 41, offset_tray_y - tray_y, 16 - offset_tray_z]
            // USB Port 
            translate([-32.2, -22.5, support_height+2]) {
                color([1,0,0]) cube([15, 11, 9], center = false);
            }

            //Buttons (3mm diameter) XXX Fix These Locations Then re-enable the 'else'
            translate([   0,  -10.5, support_height+5]) {
                rotate([90, 0, 0]) cylinder(r = 2.5, h = 12, center = false, $fn = 15);
            }
            translate([  -8,  -10.5, support_height+5]) {
                rotate([90, 0, 0]) cylinder(r = 2.5, h = 12, center = false, $fn = 15);
            }
            // LED
            translate([   -0,  -10.5, support_height+12]) {
                rotate([90, 0, 0]) cylinder(r = 2, h = 12, center = false, , $fn = 15);
            }

            union() {
                translate([0,0,12-3.9]) {
                    // Front screw
                    translate([  0,  0, 0]) cylinder(d = screw_insert_diameter, h =  4, $fn=36, center = false);
                    // Middle screws
                    translate([  0, 50, 0]) cylinder(d = screw_insert_diameter, h =  4, $fn=36, center = false);
                    translate([-50, 50, 0]) cylinder(d = screw_insert_diameter, h =  4, $fn=36, center = false);
                    // Back Screws
                    translate([  0, 71, 0]) cylinder(d = screw_insert_diameter, h =  4, $fn=36, center = false);
                    translate([-50, 71, 0]) cylinder(d = screw_insert_diameter, h =  4, $fn=36, center = false);
                } 
            }
        }
    } // translate
}

module rotaryEncoderSupport(front_thickness,do_deletes) {
    shaft_screw_length      = 5.3;
    shaft_nut_thickness     = 1.5;
    shaft_diameter          = 7;
    support_width           = 12;

    if (do_deletes==false) {
        union() {
            // translate([-support_width/2,front_thickness,-support_width/2]) {
            //     cube([support_width, shaft_screw_length-front_thickness, support_width], center = false);
            // }
            color([0,1,0]) {
            rotate([-90,0,0]) translate([0,0,0.01]) cylinder(h=shaft_screw_length, d=support_width, $fn=36);
            rotate([-90,0,0]) translate([0,0,front_thickness]) support_torus(support_width/2+front_thickness,shaft_screw_length-front_thickness);
        } }
   } else {
        union() {
            translate([0,shaft_screw_length+1.1,0]) {
                rotate([90,0,0]) cylinder(h=shaft_screw_length+1.2, d=shaft_diameter, $fn=36, center = false);
            }
            // Index Block
            translate([0, shaft_screw_length, 0]) cube([support_width+front_thickness*2, 2.5, 3], center = true);
        }
   }
            
}

module backSupport() {
    translate([19 - offset_tray_x, offset_tray_y - 3, 3 - offset_tray_z]) {
        rotate([0, 0, 90]) prism(3, 17, 19);
    }
}

module trayMount() {
    
        // - 52mm from the front, 10mm from the bottom
        translate([offset_tray_x - tray_x, 52 - offset_tray_y, 10 - offset_tray_z]) {
            rotate([0, 90, 0]) cylinder(d = screw_insert_diameter, h = 10, center = true, $fn=18);
        }
        // - 52mm from the front, 22mm from the bottom 
        translate([offset_tray_x - tray_x, 52 - offset_tray_y, 22 - offset_tray_z]) {
            rotate([0, 90, 0]) cylinder(d = screw_insert_diameter, h = 10, center = true, $fn=18);
        }
        // - 132mm from the front, 10mm from the bottom 
        translate([offset_tray_x - tray_x, 132 - offset_tray_y, 10 - offset_tray_z]) {
            rotate([0, 90, 0]) cylinder(d = screw_insert_diameter, h = 10, center = true, $fn=18);
        }
        // - 132mm from the front, 22mm from the bottom 
        translate([offset_tray_x - tray_x, 132 - offset_tray_y, 22 - offset_tray_z]) {
            rotate([0, 90, 0]) cylinder(d = screw_insert_diameter, h = 10, center = true, $fn=18);
        }
    
}

module plasticSaverSides() {
    // Sides
    translate([offset_tray_x - tray_x - 1, 20 - offset_tray_y, offset_tray_z - 15]) {
        cube([11, tray_y - 10, 16], center = false);
    }

    // translate([offset_tray_x - tray_x - 1, offset_tray_y - 16, offset_tray_z - 30]) rotate([90, 90, 90]) cheeseHoles(15, 4);
    // //translate([offset_tray_x - tray_x - 1, offset_tray_y - 24, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    // translate([offset_tray_x - tray_x - 1, offset_tray_y - 36, offset_tray_z - 30]) rotate([90, 90, 90]) cheeseHoles(15, 4);
    // //translate([offset_tray_x - tray_x - 1, offset_tray_y - 46, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    // translate([offset_tray_x - tray_x - 1, offset_tray_y - 56, offset_tray_z - 30]) rotate([90, 90, 90]) cheeseHoles(15, 4);
    // //translate([offset_tray_x - tray_x - 1, offset_tray_y - 68, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    // translate([offset_tray_x - tray_x - 1, offset_tray_y - 76, offset_tray_z - 30]) rotate([90, 90, 90]) cheeseHoles(15, 4);
    // //translate([offset_tray_x - tray_x - 1, offset_tray_y - 94, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    // translate([offset_tray_x - tray_x - 1, offset_tray_y - 105, offset_tray_z - 30]) rotate([90, 90, 90]) cheeseHoles(15, 4);
    // //translate([offset_tray_x - tray_x - 1, offset_tray_y - 116, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    // translate([offset_tray_x - tray_x - 1, offset_tray_y - 125, offset_tray_z - 30]) rotate([90, 90, 90]) cheeseHoles(15, 4);

    // Fancy angled front
    translate([offset_tray_x - tray_x - 1, 20.1 - offset_tray_y, offset_tray_z - 15]) {
        //cube([11,tray_y-10,16], center=false);
        rotate([90, 0, 0]) prism(6, 17, 19);

    }
}
module plasticSaverBase() {
    translate([offset_tray_x - 29, offset_tray_y - 30, offset_tray_z - tray_z - 1])
    rotate([0, 0, 90]) cheeseHoles(18, 80);
    translate([offset_tray_x - 76, offset_tray_y - 30, offset_tray_z - tray_z - 1])
    rotate([0, 0, 90]) cheeseHoles(18, 80);
    translate([offset_tray_x - 99, offset_tray_y - 30, offset_tray_z - tray_z - 1])
    rotate([0, 0, 90]) cheeseHoles(18, 80);
    translate([offset_tray_x - 122, offset_tray_y - 30, offset_tray_z - tray_z - 1])
    rotate([0, 0, 90]) cheeseHoles(18, 80);
}

//Fitment model "library"
module lcd() {
    //screen 26x14 (x3)
    lcd_x = 27.5;
    lcd_y = 3;
    lcd_z = 28;

    mount_x = 4.1;
    mount_y = 1.75;
    mount_z = 3.5;

    difference() {
        cube([lcd_x, lcd_y, lcd_z], center = true);
        translate([0, 0, 1]) cube([23.5, 5, 12.5], center = true);

        translate([lcd_x / 2 - mount_x / 2, -lcd_y / 2 + mount_y / 2, -lcd_z / 2 + mount_z / 2])# cube([mount_x, mount_y, mount_z], center = true);
        translate([lcd_x / 2 - mount_x / 2, -lcd_y / 2 + mount_y / 2, lcd_z / 2 - mount_z / 2])# cube([mount_x, mount_y, mount_z], center = true);
        translate([-lcd_x / 2 + mount_x / 2, -lcd_y / 2 + mount_y / 2, lcd_z / 2 - mount_z / 2])# cube([mount_x, mount_y, mount_z], center = true);
        translate([-lcd_x / 2 + mount_x / 2, -lcd_y / 2 + mount_y / 2, -lcd_z / 2 + mount_z / 2])# cube([mount_x, mount_y, mount_z], center = true);
    }
}

module cfAdapterBoard() {
    cf_x = 99;
    cf_y = 52;
    cf_z = 12;

    difference() {
        // "cube" 99x, 52y, 12z
        cube([cf_x, cf_y, cf_z], center = true);

        // "subtract" 27x37x10 from each side
        translate([-37, -10, 2]) {
            cube([27, 37, 10], center = true);
        }

        translate([37, -10, 2]) {
            cube([27, 37, 10], center = true);
        }

        // "subtract" 47x37x4 from top
        translate([0, -10, 5]) {
            cube([47, 37, 4], center = true);
        }

    }
    // "cf slot" - 27 from each side, 47 wide, 7 tall, 2 from bottom
    // Card is 3 from bottom of pcb, to 7.5 from bottom of pcb
    translate([0, -35, 0]) {
        color([0.3, 0, 0]) cube([45, 18, 6], center = true);
    }
    
}


module gotekBoard(do_deletes) {
    //   back to middle: 21mm 
    //   middle to front: 50mm 
    //   pegs: 2.75mm 
    //   peg spread: 50mm
    //   front peg to front panel: 17mm

    // 38mm x 120mm x 17mm  +  20mm x 61mm x 10mm
//    difference() {
        union() {
            //main circuit board
            cube([39, 120, 2], center = false);
            translate([-20, 59, 0]) cube([20, 61, 2], center = false);

            //usb port
            translate([2, -1, 2]) color([0.6, 0.6, 0.6]) cube([14, 14, 7], center = false);
            translate([3, -9, 3]) color([0, 0, 0.2]) cube([12, 10, 5], center = false);

            //Up button
            translate([27.5, 3, 6]) rotate([90, 0, 0]) color([0, 0, 0]) cylinder(r = 1.5, h = 10, center = false, $fn = 15);
            translate([27.5, 3, 6]) cube([7, 6, 7], center = true);

            //down button
            translate([34.5, 3, 6]) rotate([90, 0, 0]) color([0, 0, 0]) cylinder(r = 1.5, h = 10, center = false, $fn = 15);
            translate([34.5, 3, 6]) cube([7, 6, 7], center = true);

            //power LED
            translate([34.5, 3, 13]) rotate([90, 0, 0]) color([0, 1, 0]) cylinder(r = 1.5, h = 7, center = false, $fn = 12);
        }
}

module rotaryEncoder() {
    //12mm x 15mm x 7mm 
    //20mm shaft, 7mm diameter
    //12mm x 3mm x 2mm deep indexing cubes

    union() {
        translate([0, 12, 0]) cube([12, 7, 12], center = true);
        rotate([90, 0, 0]) cylinder(r = 3.5, h = 20, $fn=36, center = true);
        translate([0, 8, 0]) cube([12, 2, 3], center = true);
        translate([0, -3, 0]) rotate([90, 0, 0]) color([0.3, 0.3, 0.3]) cylinder(r = 7.25, h = 15, $fn = 36, center = true);
    }
}

//Shapes "library"
module cheeseHoles(d, l, h = 5) {
    //make a stretched cylinder with diameter 'd' and length 'l'
    union() {
        cylinder(r = d / 2, h = h, center = false, $fn = 25);
        translate([-l, -(d / 2), 0]) cube([l, d, h], center = false);
        translate([-l, 0, 0]) cylinder(r = d / 2, h = h, center = false);
    }
}

module trapezoidalPyramid(l, w, d) {
    pitch = 0;

    union() {
        difference() {
            rotate([0, 0, 45])
            cylinder(d1 = sqrt(pow(l, 2) * 2), d2 = pitch, h = 10, $fn = 4);

            translate([0, 0, d])
            linear_extrude(height = 14)
            square([l, l], center = true);
        }

        translate([abs(l - w) / 2, 0, 0]) {
            difference() {
                rotate([0, 0, 45])
                cylinder(d1 = sqrt(pow(l, 2) * 2), d2 = pitch, h = 10, $fn = 4);

                translate([0, 0, d])
                linear_extrude(height = 14)
                square([l, l], center = true);
            }
        }

        translate([abs(l - w), 0, 0]) {
            difference() {
                rotate([0, 0, 45])
                cylinder(d1 = sqrt(pow(l, 2) * 2), d2 = pitch, h = 10, $fn = 4);

                translate([0, 0, d])
                linear_extrude(height = 14)
                square([l, l], center = true);
            }
        }
    }
}

module prism(l, w, h) {
    polyhedron(
        points = [
            [0, 0, 0],
            [l, 0, 0],
            [l, w, 0],
            [0, w, 0],
            [0, w, h],
            [l, w, h]
        ],
        faces = [
            [0, 1, 2, 3],
            [5, 4, 3, 2],
            [0, 4, 5, 1],
            [0, 3, 4],
            [5, 2, 1]
        ]
    );

    /*
    // preview unfolded (do not include in your function
    z = 0.08;
    separation = 2;
    border = .2;
    translate([0, w + separation, 0])
    cube([l, w, z]);
    translate([0, w + separation + w + border, 0])
    cube([l, h, z]);
    translate([0, w + separation + w + border + h + border, 0])
    cube([l, sqrt(w * w + h * h), z]);
    translate([l + border, w + separation + w + border + h + border, 0])
    polyhedron(
        points = [
            [0, 0, 0],
            [h, 0, 0],
            [0, sqrt(w * w + h * h), 0],
            [0, 0, z],
            [h, 0, z],
            [0, sqrt(w * w + h * h), z]
        ],
        faces = [
            [0, 1, 2],
            [3, 5, 4],
            [0, 3, 4, 1],
            [1, 4, 5, 2],
            [2, 5, 3, 0]
        ]
    );
    translate([0 - border, w + separation + w + border + h + border, 0])
    polyhedron(
        points = [
            [0, 0, 0],
            [0 - h, 0, 0],
            [0, sqrt(w * w + h * h), 0],
            [0, 0, z],
            [0 - h, 0, z],
            [0, sqrt(w * w + h * h), z]
        ],
        faces = [
            [1, 0, 2],
            [5, 3, 4],
            [0, 1, 4, 3],
            [1, 2, 5, 4],
            [2, 0, 3, 5]
        ]
    );
    */
}

module torus(r1,r2,fn=36) {
    rotate_extrude(convexity = 10, $fn=fn)
    translate([r1, 0, 0])
    circle(r = r2, $fn=fn);
}

module support_torus(r1,r2,fn=36) {
    difference() {
        cylinder(r = r1,h=r2);
        union() {
            rotate_extrude(convexity = 10, $fn=fn)
            translate([r1, r2, 0])
            circle(r = r2, $fn=fn);
        }
    }
}

echo("OpenSCAD Version:", version());