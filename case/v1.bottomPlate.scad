var_side="left"; // ["left","right"]

module circumference() {
    render(convexity = 2)
        difference() {
            minkowski() {
                linear_extrude(height = 0.1, convexity = 10)
                    import (file = "./svgs/case-boundary.svg");
                cylinder(r=1,h=0.1);
            }
            linear_extrude(height = 0.2, convexity = 10)
                import (file = "./svgs/case-boundary.svg");
        }
}

module bottomPlate(mirror=false, height=4.5) {
    mirror(mirror ? [1,0,0] : [0,0,0])
    translate([0,0,-height - 1.6]) {
        intersection() {
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
                        cylinder(r1=3,r2=1.6,h=height-2,$fn=4);
                    }
                    minkowski() {
                        circumference();
                        cylinder(r=4,h=2);
                    }
                }
                minkowski() {
                    linear_extrude(height = 3, convexity = 10)
                        import (file = "./svgs/holes.svg");
                    cylinder(r=0.4,h=height-3,$fn=20);
                }
            }
            difference() {
                linear_extrude(height = 10, convexity = 10)
                    import (file = "./svgs/case-boundary.svg");
                render(convexity = 2)
                    minkowski() {
                        circumference();
                        cylinder(r=0.3,h=10);
                    }
                }
            }
        }
}

bottomPlate(var_side != "left");
