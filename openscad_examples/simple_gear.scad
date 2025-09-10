// OpenSCAD Getting Started Example
// This demonstrates basic AI co-coding concepts for mechanical design

// Parameters - easily adjustable for different designs
gear_teeth = 20;
gear_radius = 30;
gear_height = 5;
tooth_depth = 3;

// Main gear module
module gear() {
    difference() {
        // Main gear body
        cylinder(h=gear_height, r=gear_radius, center=true);
        
        // Center hole
        cylinder(h=gear_height+1, r=5, center=true);
    }
    
    // Add gear teeth
    for (i = [0:gear_teeth-1]) {
        rotate([0, 0, i * 360/gear_teeth]) {
            translate([gear_radius, 0, 0]) {
                cube([tooth_depth, 2, gear_height], center=true);
            }
        }
    }
}

// Create the gear
gear();

// Add a second gear for demonstration
translate([70, 0, 0]) {
    rotate([0, 0, 180/gear_teeth]) {  // Offset for proper meshing
        gear();
    }
}

echo("Generated gear with ", gear_teeth, " teeth and radius ", gear_radius, "mm");
