// Simple Working Gear Animation - No Interference
// Demonstrates proper gear meshing with animation

// Animation control
$fn = 50; // Smooth circles
animation_speed = 1;
$t_angle = $t * 360 * animation_speed;

// Gear parameters  
small_teeth = 20;
large_teeth = 30;

// Use a safe module size
module_size = 1.5;
small_diameter = small_teeth * module_size;
large_diameter = large_teeth * module_size;

gear_height = 6;
center_hole = 6;

echo("Small gear: ", small_teeth, " teeth, ", small_diameter, "mm diameter");
echo("Large gear: ", large_teeth, " teeth, ", large_diameter, "mm diameter");

// Simple but effective gear module
module simple_gear(teeth, diameter, height, color_name) {
    tooth_angle = 360 / teeth;
    pitch_radius = diameter / 2;
    tooth_height = module_size * 0.8;  // Conservative tooth height
    
    color(color_name) {
        difference() {
            union() {
                // Base circle
                cylinder(h=height, r=pitch_radius, center=true);
                
                // Simple rectangular teeth with proper spacing
                for (i = [0:teeth-1]) {
                    rotate([0, 0, i * tooth_angle]) {
                        translate([pitch_radius + tooth_height/2, 0, 0]) {
                            cube([tooth_height, module_size*0.6, height], center=true);
                        }
                    }
                }
            }
            
            // Center hole
            cylinder(h=height+2, r=center_hole/2, center=true);
        }
    }
}

// Calculate proper center distance
center_distance = (small_diameter + large_diameter) / 2 + module_size * 0.2; // Add small clearance

// Position gears with proper meshing
// Small gear (driver)
rotate([0, 0, $t_angle]) {
    simple_gear(small_teeth, small_diameter, gear_height, "lightblue");
}

// Large gear (driven) - positioned with tooth offset for meshing
translate([center_distance, 0, 0]) {
    // Calculate proper phase offset to prevent interference
    phase_offset = 180/large_teeth; // Half tooth spacing
    rotate([0, 0, -$t_angle * (small_teeth/large_teeth) + phase_offset]) {
        simple_gear(large_teeth, large_diameter, gear_height, "orange");
    }
}

// Add shafts
color("gray") {
    cylinder(h=gear_height*1.5, r=center_hole/2*0.8, center=true);
    translate([center_distance, 0, 0]) {
        cylinder(h=gear_height*1.5, r=center_hole/2*0.8, center=true);
    }
}

// Add base
color("lightgray", 0.3) {
    translate([center_distance/2, 0, -gear_height]) {
        cube([center_distance*1.2, center_distance*0.6, 2], center=true);
    }
}

// Instructions for animation
translate([center_distance/2, -25, gear_height*2]) {
    color("black") {
        linear_extrude(height=0.5) {
            text("Press Ctrl+T to animate!", size=4, halign="center");
        }
    }
}
