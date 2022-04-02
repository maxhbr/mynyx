side="left"; // ["left","right"]

module bottomPlate(mirror=false) {
    mirror(mirror ? [1,0,0] : [0,0,0])
    translate([0,0,-4 - 1.6]) {
        difference() {
            union() {
                difference() {
                    linear_extrude(height = 1.5, convexity = 10)
                        import (file = "./svgs/case-boundary.svg");
                    translate([0,0,1])
                        linear_extrude(height = 1, convexity = 10)
                        import (file = "./svgs/switches.svg");
                }
                minkowski() {
                    linear_extrude(height = 2, convexity = 10)
                        import (file = "./svgs/holes.svg");
                    cylinder(r1=3,r2=1.6,h=2,$fn=4);
                }
            }
            minkowski() {
                linear_extrude(height = 3, convexity = 10)
                    import (file = "./svgs/holes.svg");
                cylinder(r=0.4,h=1,$fn=20);
            }
            render(convexity = 2)
                minkowski() {
                    difference() {
                        minkowski() {
                            linear_extrude(height = 0.1, convexity = 10)
                                import (file = "./svgs/case-boundary.svg");
                            cylinder(r=1,h=0.1);
                        }
                        linear_extrude(height = 0.2, convexity = 10)
                            import (file = "./svgs/case-boundary.svg");
                    }
                    cylinder(r=0.3,h=4);
                }
        }
    }
}

bottomPlate(side != "left");
