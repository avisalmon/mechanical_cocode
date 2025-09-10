// Advanced Gear Train with Multiple Mechanical Interactions
// Demonstrates cascading gear influence and complex motion

// Animation speed control
animation_speed = 2;
$t_angle = $t * 360 * animation_speed;

// Gear specifications
gear1_teeth = 20;  // Driver gear
gear2_teeth = 30;  // Intermediate gear  
gear3_teeth = 15;  // Final driven gear

// Calculate diameters (module = 2mm for larger, more visible gears)
module_size = 2;
gear1_diameter = gear1_teeth * module_size;
gear2_diameter = gear2_teeth * module_size; 
gear3_diameter = gear3_teeth * module_size;

gear_height = 8;
center_hole = 10;

echo("=== GEAR TRAIN ANALYSIS ===");
echo("Gear 1 (Driver): ", gear1_teeth, " teeth, ", gear1_diameter, "mm diameter");
echo("Gear 2 (Intermediate): ", gear2_teeth, " teeth, ", gear2_diameter, "mm diameter"); 
echo("Gear 3 (Output): ", gear3_teeth, " teeth, ", gear3_diameter, "mm diameter");
echo("Overall ratio: ", (gear1_teeth/gear2_teeth) * (gear2_teeth/gear3_teeth), ":1");

// Improved gear module with better tooth profile
module advanced_gear(teeth, diameter, height, shaft_color="gray") {
    tooth_angle = 360 / teeth;
    outer_radius = diameter/2 + module_size*0.6;
    
    difference() {
        union() {
            // Main gear body with slight taper for realism
            cylinder(h=height, r1=diameter/2*1.02, r2=diameter/2*0.98, center=true);
            
            // Improved gear teeth
            for (i = [0:teeth-1]) {
                rotate([0, 0, i * tooth_angle]) {
                    translate([diameter/2, 0, 0]) {
                        linear_extrude(height=height, center=true, convexity=10) {
                            // More realistic involute approximation
                            polygon([
                                [-module_size*0.7, -module_size*0.4],
                                [module_size*0.7, -module_size*0.3],
                                [module_size*0.7, module_size*0.3],
                                [-module_size*0.7, module_size*0.4]
                            ]);
                        }
                    }
                }
            }
        }
        
        // Center hole
        cylinder(h=height+2, r=center_hole/2, center=true);
    }
    
    // Shaft
    color(shaft_color) {
        cylinder(h=height*2, r=center_hole/2*0.85, center=true);
    }
}

// Calculate center distances
center_distance_12 = (gear1_diameter + gear2_diameter) / 2;
center_distance_23 = (gear2_diameter + gear3_diameter) / 2;

// GEAR 1: Driver gear (INPUT) - Blue
color("lightblue") {
    rotate([0, 0, $t_angle]) {
        advanced_gear(gear1_teeth, gear1_diameter, gear_height, "blue");
        
        // Add input indicator
        translate([0, 0, gear_height/2 + 2]) {
            color("blue") {
                rotate([0, 0, $t_angle]) {
                    linear_extrude(height=1) {
                        text("INPUT", size=4, halign="center");
                    }
                }
            }
        }
    }
}

// GEAR 2: Intermediate gear (TRANSMITS POWER) - Orange
translate([center_distance_12, 0, 0]) {
    color("orange") {
        // Gear 2 rotation is CONTROLLED by Gear 1
        rotate([0, 0, -$t_angle * (gear1_teeth/gear2_teeth)]) {
            advanced_gear(gear2_teeth, gear2_diameter, gear_height, "darkorange");
            
            // Show power transmission
            translate([0, 0, gear_height/2 + 2]) {
                color("orange") {
                    rotate([0, 0, -$t_angle * (gear1_teeth/gear2_teeth)]) {
                        linear_extrude(height=1) {
                            text("TRANSMIT", size=3, halign="center");
                        }
                    }
                }
            }
        }
    }
}

// GEAR 3: Output gear (DRIVEN BY GEAR 2) - Green
translate([center_distance_12, center_distance_23, 0]) {
    color("lightgreen") {
        // Gear 3 rotation is CONTROLLED by Gear 2's rotation
        gear2_angle = -$t_angle * (gear1_teeth/gear2_teeth);
        gear3_angle = -gear2_angle * (gear2_teeth/gear3_teeth);
        
        rotate([0, 0, gear3_angle]) {
            advanced_gear(gear3_teeth, gear3_diameter, gear_height, "green");
            
            // Show output
            translate([0, 0, gear_height/2 + 2]) {
                color("green") {
                    rotate([0, 0, gear3_angle]) {
                        linear_extrude(height=1) {
                            text("OUTPUT", size=3, halign="center");
                        }
                    }
                }
            }
        }
    }
}

// Show mechanical coupling lines
color("red", 0.5) {
    // Connection 1-2
    translate([center_distance_12/2, 0, gear_height*1.5]) {
        cube([center_distance_12*0.9, 2, 1], center=true);
    }
    
    // Connection 2-3  
    translate([center_distance_12, center_distance_23/2, gear_height*1.5]) {
        cube([2, center_distance_23*0.9, 1], center=true);
    }
}

// Power flow arrows
color("red") {
    // Arrow 1 -> 2
    translate([center_distance_12/2, 5, gear_height*1.5]) {
        rotate([0, 0, 0]) {
            linear_extrude(height=1) {
                polygon([[0,0], [3,1], [3,-1]]);
            }
        }
    }
    
    // Arrow 2 -> 3
    translate([center_distance_12-5, center_distance_23/2, gear_height*1.5]) {
        rotate([0, 0, 90]) {
            linear_extrude(height=1) {
                polygon([[0,0], [3,1], [3,-1]]);
            }
        }
    }
}

// Base plate showing the mechanical system
color("lightgray", 0.3) {
    translate([center_distance_12/2, center_distance_23/2, -gear_height*1.2]) {
        cube([center_distance_12*1.3, center_distance_23*1.3, 3], center=true);
    }
}

// Title
translate([center_distance_12/2, -25, gear_height*2]) {
    color("black") {
        linear_extrude(height=1) {
            text("MECHANICAL GEAR TRAIN", size=5, halign="center");
        }
    }
    translate([0, -8, 0]) {
        color("darkblue") {
            linear_extrude(height=1) {
                text("Each gear CONTROLS the next", size=3, halign="center");
            }
        }
    }
}
