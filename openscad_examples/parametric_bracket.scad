// Parametric Bracket Example
// Demonstrates AI-assisted parametric design

// Design parameters (easily modified for different requirements)
bracket_width = 40;
bracket_height = 30;
bracket_depth = 15;
wall_thickness = 3;
hole_diameter = 6;
mounting_holes = 2;

module parametric_bracket() {
    difference() {
        // Main bracket body
        union() {
            // Vertical wall
            cube([bracket_width, wall_thickness, bracket_height]);
            
            // Horizontal base
            cube([bracket_width, bracket_depth, wall_thickness]);
            
            // Reinforcement corner
            hull() {
                cube([wall_thickness, wall_thickness, wall_thickness]);
                cube([wall_thickness, bracket_depth, wall_thickness]);
                cube([bracket_width, wall_thickness, wall_thickness]);
            }
        }
        
        // Mounting holes in vertical wall
        for (i = [0:mounting_holes-1]) {
            translate([bracket_width/2 + (i-0.5)*20, -1, bracket_height/2]) {
                rotate([-90, 0, 0]) {
                    cylinder(h=wall_thickness+2, d=hole_diameter);
                }
            }
        }
        
        // Mounting holes in base
        for (i = [0:mounting_holes-1]) {
            translate([bracket_width/2 + (i-0.5)*20, bracket_depth/2, -1]) {
                cylinder(h=wall_thickness+2, d=hole_diameter);
            }
        }
    }
}

// Generate the bracket
parametric_bracket();

// Display parameters
echo("Bracket dimensions: ", bracket_width, "x", bracket_depth, "x", bracket_height, "mm");
echo("Wall thickness: ", wall_thickness, "mm");
echo("Hole diameter: ", hole_diameter, "mm");
