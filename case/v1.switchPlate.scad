side="left"; // ["left","right"]

module switchPlate(mirror=false) {
    mirror(mirror ? [1,0,0] : [0,0,0]) {
        difference() {
            union() {
                translate([0,0,2]) {
                    difference() {
                        union() {
                            linear_extrude(height = 3, convexity = 10)
                                import (file = "./svgs/switch-boundary.svg");
                            linear_extrude(height = 3, convexity = 10)
                                import (file = "./svgs/case-boundary.svg");
                        }

                        linear_extrude(height = 3, convexity = 10)
                            import (file = "./svgs/mcu.svg");
                        minkowski() {
                            union() {
                                linear_extrude(height = 1.5, convexity = 10)
                                    import (file = "./svgs/switches-small.svg");
                                hull() {
                                    linear_extrude(height = 1.5, convexity = 10)
                                        import (file = "./svgs/stabs.svg");
                                }
                            }
                            translate([0,0,-1])
                                cylinder(r=1.7,h=1,$fn=20);
                        }
                    }
                }
                minkowski() {
                    translate([0,0,0])
                        linear_extrude(height = 4, convexity = 10)
                        import (file = "./svgs/holes-no-mcu.svg");
                    translate([0,0,0])
                        cylinder(r=1.5,h=1,$fn=20);
                }
            }
            linear_extrude(height = 5, convexity = 10)
                import (file = "./svgs/holes-no-mcu.svg");
            linear_extrude(height = 5, convexity = 10)
                import (file = "./svgs/switches.svg");

        }
        difference() {
            coneH=4;
            minkowski() {
                translate([0,0,-coneH/2])
                    linear_extrude(height = 10-coneH, center=true, convexity = 10)
                    import (file = "./svgs/case-boundary.svg");
                cylinder(h=4, r1=2, r2=1);
            }
            linear_extrude(height = 10, center=true, convexity = 10)
                import (file = "./svgs/case-boundary.svg");
        }
    }
}

switchPlate(side != "left");


