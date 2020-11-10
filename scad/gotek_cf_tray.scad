// Gotek Floppy Emulator - 5.25" bay
// Written by Michael Berry <michaelaberry@gmail.com>
model_version = "v1.4.0";

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
Gotek
- Move rear gotek supports forward. They're not even close to the holes
- Move middle gotek supports forward by 2mm
- Move rear gotek support backard by 2mm
- Consider printing a raft for the gotek that links the support posts together and puts pins through the mount hols
- Consider narrow supports with triagle braces rather than large circles
- Consider a smaller power LED hole

Rotary Encoder
- move indexing cutout to a flushmount cylinder on the inside wall. (too much stem outside)
- consider recessing the nut by 1mm to better flush the skirt of the knob

CF Adapter
- print support tabs with pins. (flexible mounting with/without screws)

OLED
- build a frame with captive side-walls and plastic pins
- frame may be connected at the top with room for data pins

*/

tray_x = 148;
tray_y = 138;
tray_z = 42;

offset_tray_x = tray_x / 2;
offset_tray_y = tray_y / 2;
offset_tray_z = tray_z / 2;

//Render the main tray
difference() {
    color([0.9, 0.9, 0.9]) cube([tray_x, tray_y, tray_z], center = true);
    // Carve out the inner tray
    translate([0, 3, 3]) {
        cube([tray_x - 6, tray_y, tray_z], center = true);
    }

    // Carve out the mounting holes
    trayMount();
    mirror([tray_x, 0, 0]) trayMount();

    // Save some plastic!
    plasticSaverSides();
    mirror([tray_x, 0, 0]) plasticSaverSides();
    plasticSaverBase();

    // Cutouts for ports and stuff
    frontFace();
}

//Add supports
backSupport();
mirror([tray_x, 0, 0]) backSupport();

cfBoardSupport();
gotekBoardSupport();
lcdSupports();



//translate([offset_tray_x - tray_x-1, offset_tray_y-18, offset_tray_z-32]) rotate([90,90,90]) cheeseHoles(8,10);

//Shape Debugging
//Hardware Preview... remove to print.
translate([53 - offset_tray_x, 29 - offset_tray_y + 1, 10 - offset_tray_z]) {
    //cfAdapterBoard();
}
translate([52 - offset_tray_x, 36 - offset_tray_y - 31, offset_tray_z - 14]) {
    //lcd();
}

translate([offset_tray_x - 42, offset_tray_y - tray_y + 3, 15 - offset_tray_z]) {
    //gotekBoard();
}

translate([offset_tray_x / 4, offset_tray_y - tray_y - 6, 28 - offset_tray_z]) {
    //rotaryEncoder();
}
echo("Model Version", model_version);

//Port cut-outs
module frontFace() {
    //CF Slot
    translate([53 - offset_tray_x, 64 - tray_y, 9.5 - offset_tray_z]) {
        cube([47, 20, 8], center = true);
    }

    //LCD
    translate([52 - offset_tray_x + 6, offset_tray_y - tray_y - 0.5, 29 - offset_tray_z]) {
        //cube([26, 6, 14], center = true);
        //Screen size 14mm tall, 26mm wide (Scale opening to account for bezel)
        rotate([90, 0, 180]) trapezoidalPyramid(19.5, 31.5, 4);
    }

    //USB Port (15mm x 8mm)
    translate([offset_tray_x - 41, offset_tray_y - tray_y - 1, 16 - offset_tray_z]) {
        cube([16, 8, 9], center = false);
    }

    //Buttons (3mm diameter)
    translate([offset_tray_x - 15, offset_tray_y - tray_y + 4, offset_tray_z - tray_z + 3 + 12 + 6]) {
        rotate([90, 0, 0]) cylinder(r = 2.5, h = 10, center = false, $fn = 15);
    }
    translate([offset_tray_x - 8, offset_tray_y - tray_y + 4, offset_tray_z - tray_z + 3 + 12 + 6]) {
        rotate([90, 0, 0]) cylinder(r = 2.5, h = 10, center = false, $fn = 15);
    }
    translate([offset_tray_x - 8, offset_tray_y - tray_y + 4, offset_tray_z - tray_z + 3 + 12 + 13]) {
        rotate([90, 0, 0]) cylinder(r = 2, h = 10, center = false, , $fn = 15);
    }

    //Rotary Encoder
    translate([offset_tray_x / 4, offset_tray_y - tray_y, 28 - offset_tray_z]) {
        union() {
            //shaft
            rotate([90, 0, 0]) cylinder(r = 3.625, h = 10, center = true, $fn = 20);
            translate([0, 2.25, 0]) rotate([90, 0, 0])# cylinder(r = 4.625, h = 2.5, center = true, $fn = 20);

            //index blocks
            translate([0, 2.25, 0])# cube([12, 2.5, 3], center = true);

            //index tab
            //rotate([0, 90, 0]) translate([-6.5, 2, -1.75])# cube([1, 2, 3], center = false);
        }
    }
}


//Supports / Brackets / Mounts "Library"
module lcdSupports() {
    lcd_x = 27.5;
    lcd_y = 3;
    lcd_z = 28;

    mount_x = 4.1;
    mount_y = 1.75;
    mount_z = 3.5;

    translate([52 - offset_tray_x, offset_tray_y - tray_y + lcd_y + mount_y - 0.25, 29 - offset_tray_z - 1]) {

        //Bottom Right (from the front)
        translate([lcd_x / 2 - mount_x / 2, -lcd_y / 2 + mount_y / 2, -lcd_z / 2 + mount_z / 2 - 0.5]) {
            difference() {
                cube([mount_x, mount_y, mount_z], center = true);
                translate([0, 0, 0]) rotate([90, 0, 0])# cylinder(r = 1, h = 3, center = true);
            }
        }

        //Top Right (from the front)
        translate([lcd_x / 2 - mount_x / 2, -lcd_y / 2 + mount_y / 2, lcd_z / 2 - mount_z / 2 - 0.5]) {
            difference() {
                cube([mount_x, mount_y, mount_z+1], center = true);
                translate([0, 0, 0]) rotate([90, 0, 0])# cylinder(r = 1, h = 3, center = true);
            }
        }

        //Top Left (from the front)
        translate([-lcd_x / 2 + mount_x / 2, -lcd_y / 2 + mount_y / 2, lcd_z / 2 - mount_z / 2 - 0.5]) {
            difference() {
                cube([mount_x, mount_y, mount_z+1], center = true);
                translate([-0.5, 0, 0]) rotate([90, 0, 0])# cylinder(r = 1, h = 3, center = true);
            }
        }

        //Bottom Left from the front)
        translate([-lcd_x / 2 + mount_x / 2, -lcd_y / 2 + mount_y / 2, -lcd_z / 2 + mount_z / 2 - 0.5]) {
            difference() {
                cube([mount_x, mount_y, mount_z], center = true);
                translate([-0.5, 0, 0]) rotate([90, 0, 0])# cylinder(r = 1, h = 3, center = true);
            }
        }
    }
}
module cfBoardSupport() {
    // "subtract" 27x37x10 from each side
    translate([3 - offset_tray_x, 3 - offset_tray_y, offset_tray_z - 39]) {
        cube([7, 35, 1], center = false);
    }

    translate([offset_tray_x - 52, 3 - offset_tray_y, offset_tray_z - 39]) {
        cube([8, 35, 1], center = false);
    }
}
module gotekBoardSupport() {
    // "subtract" 27x37x10 from each side
    translate([offset_tray_x - 7.5, 19 - offset_tray_y, offset_tray_z - 39]) {
        cylinder(r = 4, h = 12, center = false, $fn = 30);
    }

    translate([offset_tray_x - 7.5, 72 - offset_tray_y, offset_tray_z - 39]) {
        cylinder(r = 4, h = 12, center = false, $fn = 30);
    }

    translate([offset_tray_x - 7.5, 103 - offset_tray_y, offset_tray_z - 39]) {
        cylinder(r = 4, h = 12, center = false, $fn = 30);
    }

    translate([offset_tray_x - 57, 72 - offset_tray_y, offset_tray_z - 39]) {
        cylinder(r = 4, h = 12, center = false, $fn = 30);
    }

    translate([offset_tray_x - 57, 103 - offset_tray_y, offset_tray_z - 39]) {
        cylinder(r = 4, h = 12, center = false, $fn = 30);
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
        rotate([0, 90, 0]) cylinder(r = 1, h = 10, center = true);
    }
    // - 52mm from the front, 22mm from the bottom 
    translate([offset_tray_x - tray_x, 52 - offset_tray_y, 22 - offset_tray_z]) {
        rotate([0, 90, 0]) cylinder(r = 1, h = 10, center = true);
    }
    // - 132mm from the front, 10mm from the bottom 
    translate([offset_tray_x - tray_x, 132 - offset_tray_y, 10 - offset_tray_z]) {
        rotate([0, 90, 0]) cylinder(r = 1, h = 10, center = true);
    }
    // - 132mm from the front, 22mm from the bottom 
    translate([offset_tray_x - tray_x, 132 - offset_tray_y, 22 - offset_tray_z]) {
        rotate([0, 90, 0]) cylinder(r = 1, h = 10, center = true);
    }
}
module plasticSaverSides() {
    // Sides
    translate([offset_tray_x - tray_x - 1, 20 - offset_tray_y, offset_tray_z - 15]) {
        cube([11, tray_y - 10, 16], center = false);
    }

    translate([offset_tray_x - tray_x - 1, offset_tray_y - 13, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 24, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 35, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 46, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 57, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 68, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 79, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 94, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 105, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 116, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 10);
    translate([offset_tray_x - tray_x - 1, offset_tray_y - 127, offset_tray_z - 32]) rotate([90, 90, 90]) cheeseHoles(8, 14);

    // Fancy angled front
    translate([offset_tray_x - tray_x - 1, 20 - offset_tray_y, offset_tray_z - 15]) {
        //cube([11,tray_y-10,16], center=false);
        rotate([90, 0, 0]) prism(6, 17, 19);

    }
}
module plasticSaverBase() {
    translate([offset_tray_x - 29, offset_tray_y - 30, offset_tray_z - tray_z - 1])
    rotate([0, 0, 90]) cheeseHoles(18, 80);
    translate([offset_tray_x - 75, offset_tray_y - 30, offset_tray_z - tray_z - 1])
    rotate([0, 0, 90]) cheeseHoles(18, 80);
    translate([offset_tray_x - 100, offset_tray_y - 30, offset_tray_z - tray_z - 1])
    rotate([0, 0, 90]) cheeseHoles(18, 80);
    translate([offset_tray_x - 125, offset_tray_y - 30, offset_tray_z - tray_z - 1])
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
    translate([0, -35, 0]) {
        color([0.3, 0, 0]) cube([45, 18, 6], center = true);
    }

}


module gotekBoard() {
    // 38mm x 120mm x 17mm  +  20mm x 61mm x 10mm
    difference() {
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
        //mounting holes
        translate([-16, 69, 0]) cylinder(r = 1.5, h = 12, center = true);
        translate([-16, 100, 0]) cylinder(r = 1.5, h = 12, center = true);

        translate([34, 69, 0]) cylinder(r = 1.5, h = 12, center = true);
        translate([34, 100, 0]) cylinder(r = 1.5, h = 12, center = true);
        translate([34, 17, 0]) cylinder(r = 1.5, h = 12, center = true);
    }
}
module rotaryEncoder() {
    //12mm x 15mm x 7mm 
    //20mm shaft, 7mm diameter
    //12mm x 3mm x 2mm deep indexing cubes

    union() {
        translate([0, 12, 0]) cube([12, 7, 12], center = true);
        rotate([90, 0, 0]) cylinder(r = 3.25, h = 20, center = true);
        translate([0, 8, 0]) cube([12, 2, 3], center = true);
        translate([0, -3, 0]) rotate([90, 0, 0]) color([0.3, 0.3, 0.3]) cylinder(r = 7.25, h = 15, center = true);
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
echo("OpenSCAD Version:", version());