
 
DEBUG = False
DEV_MODE = True

SAVE_IMAGES=True #save each frame to /render folder
subframes = 25 #for motion blur, the more the smoother motion
screeen_size_divider = 2

minFramesStill = 70 #number of frames a glyph sits in its target pos


poem_prod = u'''
Секретные мысли,
согретые в прядях, все 
найдено, все же, 
настойчивый дактиль,
не кончит выискивать 
в точках родимых созвездия, 
в белом, в ознобе, язык 
мокрой спикулой 
чертит артерии, 
кожа — текст Брайля,
губами прочитан стократно,
пульс общий, обратный 
отсчет, темп — престиссимо.
Тянутся пальцы
к источнику влаги,
к дракону, к ядру, 
к генератору ритма
синхронных биений и вы-
дохов экзотермических 
форте, фортиссимо, 
в самое пекло, укус,
через мускул, сквозь ребра,
до хруста, скула льнет 
к скуле, совпадение, тел 
излучение, рык 
в шелк, клык 
в левую мочку,
дыханием рваным удержан
губ крик, 
вой, весь мир — волна, 
трепет пневмы 
в обертонах.
Это было тогда.
''' 


 
poem_t = poem_prod

letters = []
glyphs = []
bbox = None

lineHeight = 1.62
 
 


text_size = 15

f=PFont()
  
currentLetter = 0
current_frame = 0
number_of_lines = 0

ATTRACTION_MAG = 20.0


if DEV_MODE: 
    #low res, for performance
    screeen_size_divider = 4
    subframes = 1
    SAVE_IMAGES=False
    poem_t = poem_prod[0:100]

poem = None

#-------------------------
class Letter:
    def __init__(self, c):
        self.pos = PVector()
        self.c = c
#-------------------------
class Glyph:
    def __init__(self, c):
        
        # super().__init__(c)
        
        self.c = c
        self.last_glyph = None
        
        self.pos = PVector()
        self.stillFrames = 0
        self.target = None
        self.deg = 0.0
        self.phase = 0.0
         
        self.speed = PVector()
        self.repulsion = PVector()
        
        
    
    def draw(self):
        lastpos = self.pos.copy()
        lastdeg = self.deg
        self.animate()
        
        fill(230, 255//subframes)
        if DEBUG:
            if self.canReuse():
                fill(120, 255//subframes)
            else:
                fill(255, 255//subframes)
                            
        blendMode(ADD)
        if DEBUG: #render repulsion vector for debugging
            pushMatrix()
            translate(self.pos.x , self.pos.y  )
            stroke(255,0,0)
            line(0,0,self.repulsion.x*10, self.repulsion.y*10)
            popMatrix()
                      
        for k in range(subframes):
            subframe = float(k) / float(subframes)
            v = PVector.lerp(self.pos, lastpos, subframe)
            pushMatrix()
            
            s_x = sin(float(frameCount) / 50.0 + 5.0 * self.pos.y / width)
            s_y = cos(float(frameCount) / 30.0 + 5.0 * self.pos.x / width)
            
            x = (0.6 * height/100.) * s_x
            y = (1.2 *height/100.) * s_y             
            translate(v.x + x, v.y + y)
            
            _angle =radians(lerp(self.deg, lastdeg, subframe))+ s_x * 0.05 - s_y * 0.05
            rotate(_angle) 
            text( self.c, 0, 0)
            

            popMatrix()

    def setNewTarget(self, t):
        self.target = t

    def animate(self):         
        global glyphs, text_size

        # repulsion ----------------------------
        self.repulsion = PVector(0,0)
        for g in glyphs:
            if g !=self:
                _dir = PVector.sub( self.pos, g.pos)
                # _distSq = _dir.magSq() #TODO: try repulsion ~ inverse square dist
                _dist = _dir.mag()
                                
                if _dist > 0.5: #no hyperforce at small distances
                    _dir.normalize()
                    if _dist < 1.0:
                        _dist = 1.0 #no hyperforce at small distances )
                        
                    _dir.mult(0.03) #TODO: tune, see ATTRACTION_MAG          
                    
                    if _dist < width/2:
                        self.repulsion.add(_dir)
                    
                    if _dist > text_size * 1.4 and self == g.last_glyph: 
                        _dir.mult(ATTRACTION_MAG)
                        self.repulsion.sub(_dir)

                    
        if self.target is not None:
            dspeed = PVector.sub(self.target.pos, self.pos).mult(0.02)
            dist = self.pos.dist(self.target.pos)
            _mag = dspeed.mag() 
            if _mag > 20:
                dspeed.setMag(20) #speedlimit, sorry letters

            self.speed.add(dspeed)
            
            if dist < 0.4: #has came to desired pos
                self.stillFrames += 1
            else:
                self.stillFrames = 0
                
            if _mag < 20:
                _mag = 0
                
            self.repulsion.mult( _mag )                
            
        else:
            self.stillFrames -= 1
            rnd = 0.2
            # self.speed.x += randomGaussian() * rnd
            # self.speed.y += randomGaussian() * rnd

        self.speed.add(self.repulsion) 
        
        _deg_inc = self.speed.mag() * 5.
        # self.deg += 
        if self.speed.x < 0:
           self.deg -=_deg_inc
        else:
            self.deg += _deg_inc
        
        self.deg *= 0.7575
        if self.c in [u"а", u"о",u"у",u"е",u"ю"]:
            self.speed.mult(0.8) 
        else:
            self.speed.mult(0.8)
            
        self.pos = self.pos.add(self.speed)
        
        if self.stillFrames > minFramesStill*1.2:
            self.target = None

    def canReuse(self):
        return self.target is None or self.stillFrames > minFramesStill



#------------------------------------------------------------------------------------------------
def makeLetters(poem):
            
    letters = [None] * len(poem)    
    glyphs = [] #[None] * len(poem)
    
    x = 0.0
    y = 0.0

    maxX = 0.0
    maxY = 0.0
    
    last_glyph = None
    
     
    for i in range(len(poem)): 
         
        _char = poem[i]
        w = textWidth(_char)

        letters[i] = Letter(_char)
        letters[i].pos = PVector(x, y)
         
                    
        if not (_char == ' ' or _char== '\n'):
            _g = Glyph(_char) 
            _g.pos = letters[i].pos.copy()
            _g.last_glyph = last_glyph
            
            glyphs.append(_g)
            last_glyph = _g
    
        if x > maxX:
            maxX = x           
        if y > maxY:
            maxY = y
            
        x = x+w
         
        if _char == '\n':            
            y = y + (lineHeight * text_size) 
            x = 0.0
                
           
    # Randomizing initial positions
    for g in glyphs:         
        g.pos = PVector(maxX * randomGaussian(), maxY * abs(randomGaussian()))
         
    return letters, glyphs, PVector(maxX, maxY)



def setup():
    
    global poem, poem_t, bbox, text_size, f, number_of_lines, letters, glyphs

    # with open("poem_1.txt", 'r+') as file: #TODO: DOES not work with non-ascii (
    #     lines = file.readlines()
    # lines = loadStrings("poem_1.txt")  #TODO:  DOES not work with non-ascii (
    
    poem = poem_t.replace("--", "—").replace(" ", " ")
    print(poem_t)      
    size(1080/screeen_size_divider, 1920/screeen_size_divider, JAVA2D) # Instagram best reel 1920
    
    background(20)
     
    pixelDensity(2) #retina
    frameRate(30) #ha ha  ha
    smooth(4)
    
    text_size = height // 45

    f = createFont("../_common/Literata-VariableFont_wght.ttf", text_size, True)

    textFont(f, text_size)
    textSize(text_size)
    
    
    letters, glyphs, bbox = makeLetters(poem)
    
    print('setup done:',  len(letters), len(glyphs), bbox)


def findFreeGlyph(l, glyphs):
    candidate = None
    minDist = 2000*2000 
    #finding just nearest available for moving
    #TODO: try to find one with bes alligned speed vector, so it starts smoothly
    for g in glyphs:
        if g.canReuse() and g.c == l.c:
            _d = l.pos.dist(g.pos)
            if _d < minDist: 
                minDist = _d
                candidate = g
    return candidate



last_y_translation =0
 
def drawPoem():
    
    global last_y_translation
    global glyphs, letters, current_frame, currentLetter
        
   
    pushMatrix()
    
    new_y_translation = lerp(last_y_translation,  -letters[currentLetter].pos.y + height/3, 0.005)
    
    translate(0, new_y_translation)
    last_y_translation = new_y_translation

    
    for g in glyphs:
        g.draw()         
    
    
    if current_frame % 2 == 0 and current_frame > 100:        
        cl = letters[currentLetter] 
        currentLetter = (currentLetter + 1) % len(letters)
              
        cg = findFreeGlyph(cl, glyphs)        
        if cg is not None:           
            cg.setNewTarget(cl)            
            

    popMatrix()
     

def draw():
    global current_frame
    current_frame = current_frame+1    
    pushMatrix()
    translate((width - bbox.x) / 2, 0) # center text on screen
    scale(0.8) #TODO: calculate it on text size
    
     
    background(0)
    
    fill(255, 140)
    
    
    drawPoem()

    if frameCount < 4000 and SAVE_IMAGES:
        if frameCount % 100 == 0:
            print(frameCount)
        saveFrame("render/poem_####.png")
    popMatrix()

 
