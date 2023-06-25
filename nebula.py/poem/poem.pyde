
# TODO: fit txt inti screen:
# TODO: add repulsion forces

 


DEBUG = False
SAVE_IMAGES=False #save each frame to /render folder
subframes = 2 #for motion blur, the more the smoother motion
screeen_size_divider = 4

minFramesStill = 70 #number of frames a glyph sits in its target pos

poem_short = u'''
се
кре
тные мы
сли, 
со
гре
тые в пр
ядях,
все н
айде
но, но 
не ко
нчат в
ыи
ск
ивать па
льцы 
вывод
ят 
из точ
ек род
им
ых созв
ез
дия, 
''' 

poem_whole = u'''
секретные мысли, 
согретые в прядях,
все найдено, но 
не кончат выискивать
пальцы выводят 
из точек родимых созвездия, 
в белом, в ознобе, 
поверхность — текст Брайля, 
прочитан губами, стократно
пальцы сквозь мускул, 
сквозь ребра
в самое пекло укус, 
к источнику влаги, 
к дракону, к ядру, 
к генератору ритма, 
частоты тактовой, 
выдохов форте, синхронных
фортиссимо, пульс общий 
престиссимо, 
обратный отсчет, 
скула — в скулу 
и — до хруста, синус, 
тангейзер, касание, 
рык, клык, в мягкую мочку, 
дыханием рваным 
губы хватать, улавливать
обертона и трястись,
как тогда. 
Легче покинуть тело,
Чем с этого слезть.
Мы больны 
тяжело весьма больны
нами. 
''' 

# poem_t = u'''
# секретные мысли, 
# согретые в прядях,
# все найдено, но 
# не кончат выискивать
# пальцы выводят 
# из точек родимых созвездия, 
# в белом, в ознобе, 
# поверхность — текст Брайля, 
# прочитан губами, стократно
# пальцы сквозь мускул, 
# сквозь ребра
# в самое пекло укус, 
# ''' 


poem_t = poem_whole

letters = []
glyphs = []
bbox = None

lineHeight = 1.62
 
 
poem=None

text_size = 15

f=PFont()
  
# int minFramesStill = 50;
# GComparator aGComparator = new GComparator();

currentLetter = 0
current_frame = 0
number_of_lines = 0


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
        # print('g draw 1', self.pos)
        lastpos = self.pos.copy()
        # print('g draw 1.1', lastpos)
        lastdeg = self.deg
        # print('g draw 1.2')
        self.animate()
        # print('g draw 2')
        
        fill(230, 255//subframes)
        if DEBUG:
            if self.canReuse():
                fill(120, 255//subframes)
            else:
                fill(255, 255//subframes)
                            
        blendMode(ADD)
        if DEBUG:
            pushMatrix()
            translate(self.pos.x , self.pos.y  )
            stroke(255,0,0)
            line(0,0,self.repulsion.x*10, self.repulsion.y*10)
            popMatrix()
                      
        for k in range(subframes):
            # print('g draw 3')
            subframe = float(k) / float(subframes)
            # print('g draw 3.1')
            v = PVector.lerp(self.pos, lastpos, subframe)
            # print('g draw 4', v)
            pushMatrix()
            
            s_x = sin(float(frameCount) / 50.0 + 5.0 * self.pos.y / width)
            s_y = cos(float(frameCount) / 30.0 + 5.0 * self.pos.x / width)
            
            x = (0.6 * height/100.) * s_x
            # print('g draw 5.1', frameCount, x)
            y = (1.2 *height/100.) * s_y
            # print('g draw 5.2', x, y)
            translate(v.x + x, v.y + y)
            
            _angle =radians(lerp(self.deg, lastdeg, subframe))+ s_x * 0.05 - s_y * 0.05
            # print('g draw 5.3', _angle) 
            rotate(_angle)
            # rotate(radians(self.deg) + s_x * 0.05 - s_y * 0.05 )
            # print('g draw 5.4' )
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
                # _distSq = _dir.magSq()
                _dist = _dir.mag()
                                
                if _dist > 0.5:
                    _dir.normalize()
                    if _dist < 1.0:
                        _dist = 1.0
                        
                    _dir.mult(0.03)                     
                    
                    if _dist < width/2:
                        self.repulsion.add(_dir)
                    
                    if _dist > text_size*1.4:
                        if self == g.last_glyph:
                            _dir.mult(20.7)
                            self.repulsion.sub(_dir)
                    
                    
            # print(_dir)
                    
        if self.target is not None:
            dspeed = PVector.sub(self.target.pos, self.pos).mult(0.02)
            dist = self.pos.dist(self.target.pos)
            _mag = dspeed.mag() 
            if _mag > 20:
                dspeed.setMag(20)

            self.speed.add(dspeed)
            

            if dist < 0.4:
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
    
    print('makeLetters 1', len(poem), textWidth )
            
    letters = [None] * len(poem)    
    glyphs = [] #[None] * len(poem)
    
    x = 0.0
    y = 0.0

    maxX = 0.0
    maxY = 0.0
    
    last_glyph = None
    
    print('makeLetters 2', len(poem), textWidth )
    for i in range(len(poem)): 
         
        _char = poem[i]
        w = textWidth(_char)

        letters[i] = Letter(_char)
        letters[i].pos = PVector(x, y)
        # print('makeLetters 3', len(poem), textWidth )
                    
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
        
            
    print('makeLetters 4', len(glyphs), len(letters) )
           
    # Randomizing initial positions
    for g in glyphs:
        # print('makeLetters 3.1', g)
        g.pos = PVector(maxX * randomGaussian(), maxY * abs(randomGaussian()))
        # g.deg = randomGaussian()*300.0

    print('makeLetters bbox:', maxX, maxY)
    return letters, glyphs, PVector(maxX, maxY)



def setup():

    global poem, bbox, text_size, f, number_of_lines, letters, glyphs

    print(2)
    # with open("poem_1.txt", 'r+') as file:
    #     lines = file.readlines()
    # lines = loadStrings("poem_1.txt")
    print(poem_t)
    poem_tmp = poem_t
    # for line in lines:
    #     poem_tmp += line
    #     poem_tmp += "\n"
    # number_of_lines = len(lines)
    # print(lines)
    poem = poem_tmp #.replace("--", "—").replace(" ", " ")

    # size(1080/screeen_size_divider, 1350/screeen_size_divider, JAVA2D)  # Instagram best
    # size(1080/screeen_size_divider, 1350/screeen_size_divider, JAVA2D)  
    size(1080/screeen_size_divider, 1920/screeen_size_divider, JAVA2D) # Instagram best reel 1920
    # textMode(MODEL)
    # size(600, 600)  # testing FPS-optimal
    background(255)
     
    pixelDensity(2)
    frameRate(30)
    smooth(4)
    
    
    
    text_size = height // 45
    f = createFont("Literata-VariableFont_wght.ttf", text_size, True)
    print(f)

    textFont(f, text_size)
    textSize(text_size)
    
    print('setup 3')
    print(makeLetters)
    
    letters, glyphs, bbox = makeLetters(poem)
    
    print('setup 5',  len(letters), len(glyphs), bbox)


def findFreeGlyph(l, glyphs):
    candidate = None
    minDist = 2000*2000
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
    
    if DEBUG:
        print('drawPoem 1', currentLetter, len(letters))
   
    pushMatrix()
    
    new_y_translation = lerp(last_y_translation,  -letters[currentLetter].pos.y + height/3, 0.005)
    
    translate(0, new_y_translation)
    last_y_translation = new_y_translation

    if DEBUG:
        print('drawPoem 1.1')
    
    for g in glyphs:
        g.draw()         
    
    
    if current_frame % 2 == 0 and current_frame > 100:        
        cl = letters[currentLetter] 
        currentLetter = (currentLetter + 1) % len(letters)
              
        cg = findFreeGlyph(cl, glyphs)        
        if cg is not None:           
            cg.setNewTarget(cl)            
            


    popMatrix()
    print('drawPoem 2')

def draw():
    global current_frame
    current_frame = current_frame+1
    # print('draw 1')
    # Arrays.sort(glyphs, aGComparator);
    # glyphs = sorted(glyphs, lambda: g1, g2 : g1.c > g2.c))
    pushMatrix()
    translate((width - bbox.x) / 2, 0) # center text on screen
    
    
    # translate((width - bbox.x) / 2, (height - bbox.y) / 2) # center text on screen
     
    background(0)
    # print('draw 3')
    fill(255, 140)
    
    # print('draw 4')
    drawPoem()

    if frameCount < 3000 and SAVE_IMAGES:
        saveFrame("render/poem_####.png")
    popMatrix()

 
