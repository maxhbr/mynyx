module switchPlate() {
    difference() {
        union() {
            translate([0,0,2]) {
                difference() {
                    union() {
                        linear_extrude(height = 3, convexity = 10)
                            import (file = "./switch-boundary.svg");
                    }
                    minkowski() {
                        union() {
                            linear_extrude(height = 1.5, convexity = 10)
                                import (file = "./switches-small.svg");
                            hull() {
                                linear_extrude(height = 1.5, convexity = 10)
                                    import (file = "./stabs.svg");
                            }
                        }
                        translate([0,0,-1])
                            cylinder(r=1.5,h=1,$fn=20);
                    }
                }
            }
            minkowski() {
                translate([0,0,0])
                    linear_extrude(height = 4, convexity = 10)
                    import (file = "./holes-no-mcu.svg");
                translate([0,0,0])
                    cylinder(r=1.5,h=1,$fn=20);
            }
        }
        linear_extrude(height = 5, convexity = 10)
            import (file = "./holes-no-mcu.svg");
        linear_extrude(height = 5, convexity = 10)
            import (file = "./switches.svg");

    }
}

module bottomPlate() {
    difference() {
        translate([0,0,0])
            linear_extrude(height = 1.5, center = true, convexity = 10)
            import (file = "./case-boundary.svg");
        translate([0,0,0])
            linear_extrude(height = 15, center = true, convexity = 10)
            import (file = "./holes.svg");
    }
}

translate([0,0,0])
    switchPlate();
