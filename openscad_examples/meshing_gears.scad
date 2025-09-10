// Meshing Gear System: 20-tooth and 30-tooth gears
// Demonstrates precise gear ratios and mechanical movement

// Gear parameters
small_teeth = 20;
large_teeth = 30;
large_diameter = 50; // mm

// Calculate module (tooth size) from large gear
module_size = large_diameter / large_teeth;
small_diameter = small_teeth * module_size;

// Gear dimensions
gear_height = 6; // mm
tooth_height = 2.25 * module_size; // Standard gear tooth height
center_hole = 8; // mm

echo("Small gear: ", small_teeth, " teeth, diameter: ", small_diameter, "mm");
echo("Large gear: ", large_teeth, " teeth, diameter: ", large_diameter, "mm");
echo("Module size: ", module_size, "mm");
echo("Center distance: ", (small_diameter + large_diameter)/2, "mm");

// Gear module with proper involute approximation and clearance
module gear(teeth, diameter, height) {
    tooth_angle = 360 / teeth;
    // Proper gear calculations
    pitch_radius = diameter/2;
    addendum = module_size * 1.0;  // Height of tooth above pitch circle
    dedendum = module_size * 1.25; // Depth below pitch circle (with clearance)
    
    outer_radius = pitch_radius + addendum;
    root_radius = pitch_radius - dedendum;
    
    difference() {
        union() {
            // Main gear body (pitch circle)
            cylinder(h=height, r=pitch_radius, center=true);
            
            // Gear teeth - properly spaced
            for (i = [0:teeth-1]) {
                rotate([0, 0, i * tooth_angle]) {
                    translate([pitch_radius, 0, 0]) {
                        // Improved tooth profile with proper clearance
                        linear_extrude(height=height, center=true) {
                            polygon([
                                [-addendum, -module_size*0.4],
                                [addendum*0.8, -module_size*0.3],  // Slightly narrower at tip
                                [addendum*0.8, module_size*0.3],
                                [-addendum, module_size*0.4]
                            ]);
                        }
                    }
                }
            }
        }
        
        // Remove material at tooth roots for proper clearance
        difference() {
            cylinder(h=height+1, r=pitch_radius, center=true);
            cylinder(h=height+2, r=root_radius, center=true);
        }
        
        // Center hole
        cylinder(h=height+1, r=center_hole/2, center=true);
        
        // Keyway
        translate([0, 0, 0]) {
            cube([center_hole/3, center_hole*1.5, height+1], center=true);
        }
    }
}

// Animation parameter (0 to 360 degrees)
// The gears influence each other through proper gear ratio calculations
$t_angle = $t * 360 * 4; // Increased speed for better visualization ($t goes from 0 to 1)

// Calculate center distance for proper meshing
center_distance = (small_diameter + large_diameter) / 2;

// Small gear (20 teeth) - DRIVER gear (rotates at base speed)
rotate([0, 0, $t_angle]) {
    color("lightblue") {
        gear(small_teeth, small_diameter, gear_height);
    }
}

// Large gear (30 teeth) - DRIVEN gear (influenced by small gear)
translate([center_distance, 0, 0]) {
    // MECHANICAL INTERACTION: Large gear rotation is CONTROLLED by small gear
    // Add tooth offset to prevent interference (half tooth spacing)
    tooth_offset = 180/large_teeth;  // Half tooth angle for proper meshing
    rotate([0, 0, -$t_angle * (small_teeth/large_teeth) + tooth_offset]) {
        color("orange") {
            gear(large_teeth, large_diameter, gear_height);
        }
    }
}

// Add gear shafts for visualization
color("gray") {
    cylinder(h=gear_height*2, r=center_hole/2*0.9, center=true);
    // Add rotation indicator on small gear shaft
    translate([center_hole/2*0.7, 0, gear_height/2]) {
        color("red") {
            rotate([0, 0, $t_angle]) {
                cube([center_hole/4, center_hole/8, 1], center=true);
            }
        }
    }
}

translate([center_distance, 0, 0]) {
    color("gray") {
        cylinder(h=gear_height*2, r=center_hole/2*0.9, center=true);
        // Add rotation indicator on large gear shaft
        translate([center_hole/2*0.7, 0, gear_height/2]) {
            color("green") {
                rotate([0, 0, -$t_angle * (small_teeth/large_teeth)]) {
                    cube([center_hole/4, center_hole/8, 1], center=true);
                }
            }
        }
    }
}

// Add visual connection line showing mechanical coupling
color("yellow", 0.7) {
    translate([center_distance/2, 0, gear_height*1.5]) {
        cube([center_distance*0.8, 1, 0.5], center=true);
        // Add text annotation
        translate([0, 0, 2]) {
            color("black") {
                linear_extrude(height=0.5) {
                    text("MECHANICAL COUPLING", size=3, halign="center");
                }
            }
        }
    }
}

// Add base plate to show mounting
color("lightgray", 0.3) {
    translate([center_distance/2, 0, -gear_height]) {
        cube([center_distance*1.5, center_distance*0.8, 2], center=true);
    }
}
