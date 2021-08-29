$fn = 60;
seed = 23718906;

plate_r = 100;
plate_h = 6;

base_ir = 18;
base_ih = 10;
base_or = 100;
base_oh = 4;

mound_or = 24;
mound_ir = 8;
mound_h = 18;

u_edge_h = 6;
u_edge_w = 2;
u_edge_ir = plate_r - (u_edge_h + u_edge_w);
u_edge_or = plate_r - u_edge_w;

l_edge_h = (plate_h + u_edge_h) - 3;
l_edge_ir = plate_r - 7;

major_n = 6;
major_r = 360 / major_n;

cable_w = 5;

pole_h = 20;
pole_r = 6.33/2 * 1.02;
pole_d = 3;

offsets = [
    25,
    45,
    70,
];

//tree_plate();
tree_base();
//pole_hole();

module tree_base() {
    difference() {
        union() {
            hull() {
                cylinder(r=base_ir, h=base_ih);
                cylinder(r=base_or, h=base_oh);
            }
            mound();
        }
        cable_slots();
        translate([0,0,pole_h+pole_d])
            pole();
    }
}

module tree_plate() {
    difference() {
        plate_body();
        cable_slots();
        slot_corners();
        difference() {
            union() {
                top_bowl();
                top_boundary();
            }
            mound();
        }
        translate([0,0,mound_h-pole_d])
            pole();
    }
}

module mound() {
    hull() {
        cylinder(r=mound_or, h=plate_h);
        cylinder(r=mound_ir, h=mound_h);
    }
}

module pole_hole() {
    difference() {
        cylinder(r=pole_r*2, h=pole_d*3);
        translate([0,0,pole_d])
        pole();
    }
}

module pole() {
    translate([0,0,-pole_h])
    cylinder(r=pole_r, h=pole_h);
}

module plate_body() {
    union() {
        hull() {
            cylinder(r=l_edge_ir, h=l_edge_h);
            translate([0,0,l_edge_h])
                cylinder(r=plate_r, h=3*plate_h);
        }
    }
}

module cable_slots() {
    for (i = [0:len(offsets)-1]) {
        rotate([0,0,major_r / pow(2,i)])
        wrotate([0,0,major_r/pow(2,i)], major_n*pow(2,i))
        translate([-2.5,offsets[i],-5*plate_h])
            cube([cable_w,plate_r,plate_h*10]);
    }
}

module top_bowl() {
    hull() {
        translate([0,0,plate_h])
            cylinder(r=u_edge_ir, h=plate_h);
        translate([0,0,plate_h+u_edge_h])
            cylinder(r=u_edge_or, h=plate_h);
    }
}

module top_boundary() {
    translate([0,0,plate_h+u_edge_h])
        cylinder(r=plate_r*1.1, h=10*plate_h);
}

module slot_corners() {
    wrotate([0,0,360/24], 24)
        translate([plate_r+6,0,0])
        rotate([0,0,45])
        cube([20,20,40], center=true);
}


module wrotate(r=[0,0,90], n=1) {
    union() {
        for (i = [0:n-1]) {
            rotate(r*i) {
                children();
            }
        }
    }
}


module rcolor() {
    union() {
        for (i = [0:$children-1]) {
            color(rands(0,1,3, i+seed)) {
                children(i);
            }
        }
    }
}
