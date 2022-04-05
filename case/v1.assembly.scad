include <v1.bottomPlate.scad>
include <v1.switchPlate.scad>

module pcb() {
    difference() {
        color("green", 0.2)
            translate([0,0,-1.6])
                linear_extrude(height = 1.6, convexity = 10)
                import (file = "./svgs/case-boundary.svg");
        translate([0,0,0])
            linear_extrude(height = 15, center = true, convexity = 10)
            import (file = "./svgs/holes.svg");
    }
}

if ($preview) {
    pcb();
}

