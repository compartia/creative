
 
DEBUG = False
DEV_MODE = False #set True for better performance: no motion blur, less characters, etc.

SAVE_IMAGES=True #save each frame to /render folder
subframes = 25 #for motion blur, the more the smoother motion
screeen_size_divider = 1

minFramesStill = 70 #number of frames a glyph sits in its target pos

 

lineHeight = 1.62
 
 
text_size = 15

f = None
f2 = None
 


if DEV_MODE: 
    #low res, for performance
    screeen_size_divider = 4
    subframes = 1
    SAVE_IMAGES=False
     
   

def setup():
    
    global text_size, f
     
    size(1080/screeen_size_divider, 1080/screeen_size_divider, JAVA2D) # Instagram best reel 1920
    
    background(20)
     
    pixelDensity(2) #retina
    frameRate(30) #ha ha  ha
    smooth(1)
    
    text_size = height // 10

    f = createFont("../_common/Ubuntu-BI.ttf", text_size, True)
    f2 = createFont("../_common/Ubuntu-BI.ttf", text_size/2, True)

    
      


def get_c(x, y):
    l = PVector(x, y).mag()
    _arg = 7*l / height
    
    r = 120 + 100 * cos (-0.1+_arg)
    g = 120 + 100 * cos (_arg)
    b = 120 + 100 * cos (0.1 + _arg)
    
    return r, g, b

def get_c2(x, y):
    l = PVector(x, y).magSq()
    _arg =  1.7 * l / height
    
    r = 120 + 100 * sin (-0.2+_arg)
    g = 120 + 100 * sin (_arg)
    b = 120 + 100 * sin (0.2 + _arg)
    
    return r, g, b
 
def draw_cir():
    global fr
    pushMatrix()
    translate(width//2, height//2) # center text on screen

    
    noStroke()
    # print('draw 0.1')
    dot_size = 3
    ra = 1
    k = 0.77
    for i in range(60):
        ra = ra + dot_size
        dot_size = ra / 7.0
        # print('draw 0.2', ra)
        ll = 2.0 * 3.14 * ra
        # print('draw 0.2.1', ll) 
        nn = int(round( ll / dot_size))
        # print('draw 0.3', nn, ll) 
        
        pushMatrix()
        rotate (0.04 * cos (fr*0.01))
        angle_inc = 360.0 / nn
        # print('draw 0.30 angle_inc=', angle_inc ) 
        for an in range(nn):
            # _am= ((an + i)* 0.1 * sin ((fr +an*0.5 )*0.01))+fr*0.1
            _am= fr*0.05 + 2 * sin(fr*0.01) * 4 * sin (ra*0.015 + fr*0.1) + (width/2 - ra)*fr*0.001
            # print('draw 0.31', an ) 
            angle = an * angle_inc + (angle_inc/2)*i
            angle+=_am
            # print('draw 0.4', an, sin(angle)) 
            x = ra * sin(radians(angle)) 
            # print('draw 0.5',x) 
            y = ra * cos(radians(angle))
            
            ellipse(int(x), int(y), dot_size*k, dot_size*k);
        popMatrix()
        
    # for x in range(-width, width):
    #     for y in range(-height, height):
            
            
    #         r, g, b = get_c(x, y)
    #         stroke (r, g, b)
    #         line (x, y, x, y-1)
            
            # r, g, b = get_c2(x, y)
            # stroke (r, g, b, 10)
            # line (x, y, x, y-1)
    
    fill(255)
    rotate(radians(-45))
    # print('draw 0')
    
    textFont(f, text_size)
    textSize(text_size)
    
    _tt = 'Z A B O R S K I Y'
    w = textWidth(_tt)
    
    # textFont(f, int(text_size*0.7))
    # textSize(int(text_size*0.7))
    fill(0)
    # text('      D E S I G N', -w/2+2, text_size//20)
    # print('draw 1')
    
    
    fill(255)
    # text(_tt, -w/2, text_size//20)


    if frameCount < 3000 and SAVE_IMAGES:
        if frameCount % 100 == 0:
            print(frameCount)
        saveFrame("render/poem_####.png")
    popMatrix()

fr = 0
def draw():
    global fr
    fr+=1
    alphaa = 70 
    blendMode(NORMAL)
    fill(0, alphaa)
    rect(0,0,width,height)
    # background(0,0,0, 3)
    blendMode(ADD)
    
   
    # for i in range(20):
    translate(2*sin(fr / 20.0) , 1*cos(fr / 30.0))
    fill (255, 0,0, alphaa)
    draw_cir()
    
    # translate(randomGaussian()-0.5,randomGaussian()-0.5)
    translate(4*sin(fr / 20.0) , 3*cos(fr / 50.0))
    fill (0,0,255, alphaa)
    draw_cir()
    
    
    fill (0,255,0, alphaa)
    draw_cir()
