class Vec3 extends PVector implements Comparable<Vec3> {

    @Override
    public int compareTo(Vec3 o) {
        if (this == o)
            return 0;
        if (this.z == o.z)
            return 0;
        return this.z - o.z > 0 ? 1 : -1;
    }

    Vec3() {
        super();
    }

    Vec3(float x, float y) {
        super(x, y);
    }

    Vec3(float x, float y, float z) {
        super(x, y, z);
    }

    Vec3(PVector v) {
        super();
        set(v);
    }

    String toString() {
        return String.format("[ %+.2f, %+.2f, %+.2f ]", x, y, z);
    }

    PVector rotate(float angle) {
        return rotateZ(angle);
    }

    boolean nearlySame(Vec3 o) {
        float eps = 0.001;
        return Math.abs(this.x - o.x) < eps && Math.abs(this.y - o.y) < eps && Math.abs(this.z - o.z) < eps;
    }

    PVector rotateX(float angle) {
        float cosa = cos(angle);
        float sina = sin(angle);
        float tempy = y;
        y = cosa * y - sina * z;
        z = cosa * z + sina * tempy;
        return this;
    }

    PVector rotateY(float angle) {
        float cosa = cos(angle);
        float sina = sin(angle);
        float tempz = z;
        z = cosa * z - sina * x;
        x = cosa * x + sina * tempz;
        return this;
    }

    PVector rotateZ(float angle) {
        float cosa = cos(angle);
        float sina = sin(angle);
        float tempx = x;
        x = cosa * x - sina * y;
        y = cosa * y + sina * tempx;
        return this;
    }
}
