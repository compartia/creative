PVector lorentz(float space1, float time1, float v) {
        
    float r = sqrt((space1 + 200) * (space1 + 200) + (time1 + 200) * (time1 + 200)) / 60;        
    time1 += 2 * cos(anim * 8 + time1 / 30.);

    time1 += 5 * cos(anim * 2 + r);
    space1 += 5 * sin(anim * 2 + r);

    return new PVector(space1, time1);
}
