
# TODO: fit txt inti screen:
# TODO: add repulsion forces


# poem_t = u'''
#  секретные мысли, согретые в прядях,
# все найдено, но не кончат выискивать
# пальцы выводят из точек родимых
# созвездия, а из них - предсказания
# в белом, в ознобе, поверхность — текст Брайля, 
# прочитан губами, стократно
# пальцы сквозь мускул, сквозь ребра
# в самое пекло укус, 
# к источнику влаги, 
# к дракону, к ядру, 
# к генератору ритма, такта 
# выдохов форте, синхронных
# фортиссимо, пульс общий престиссимо, 
# обратный отсчет, 
# скула — в скулу 
# и -- до хруста, синус, тангейзер, касание, 
# рык, клык, в мягкую мочку — 
# дыханием рваным 
# губы хватать, улавливать
# обертона и трястись. 
# Как тогда. 
# Легче покинуть тело,
# Чем с этого слезть.
# мы больны 
# тяжело весьма больны
# нами. 
# ''' 

poem_t = u'''
 секретные мысли, согретые в прядях,
все найдено, но не кончат выискивать
пальцы выводят из точек родимых
созвездия, а из них - предсказания''' 


SAVE_IMAGES=False

subframes = 1 #for motion blur, the more the soother

letters = None
glyphs =None

lineHeight = 1.62
text_size = 0
 
poem=None
bbox=PVector ()
text_size = 25

f=PFont()
  
# int minFramesStill = 50;
# GComparator aGComparator = new GComparator();

currentLetter = 0
current_frame = 0
number_of_lines = 0
minFramesStill = 50





class Keyframe:
    def __init__(self):
        self.pos = PVector()
        self.degree = 0.0
        self.scale = 1.0
        
        
class Letter:
    def __init__(self, c):
        self.pos = PVector()
        self.c = c

    def animate(self):
        pass





def animateFromTo(k1, k2, length):
    pass


class Glyph:
    def __init__(self, c):
        self.c=c
        # super().__init__(c)
        self.pos = PVector()
        self.stillFrames = 0
        self.target = None
        self.deg = 0.0
        self.phase = 0.0
         
        self.speed = PVector()
         

    def draw(self):
        # print('g draw 1', self.pos)
        lastpos = self.pos.copy()
        # print('g draw 1.1', lastpos)
        lastdeg = self.deg
        # print('g draw 1.2')
        self.animate()
        # print('g draw 2')
        
        fill(255, 255//subframes)
        blendMode(ADD)
        
        
        
        for k in range(subframes):
            # print('g draw 3')
            subframe = float(k) / float(subframes)
            # print('g draw 3.1')
            v = PVector.lerp(self.pos, lastpos, subframe)
            # print('g draw 4', v)
            pushMatrix()
            
            # print('g draw 5', frameCount, sin)
            x = 10.0 * sin(float(frameCount) / 50.0 + 5.0 * self.pos.y / width)
            # print('g draw 5.1', frameCount, x)
            y = 20.0 * cos(float(frameCount) / 30.0 + 5.0 * self.pos.x / width)
            # print('g draw 5.2', x, y)
            translate(v.x + x, v.y + y)
            
            _angle =radians(lerp(self.deg, lastdeg, subframe))
            # print('g draw 5.3', _angle) 
            rotate(_angle)
            # print('g draw 5.4' )
            text( self.c, 0, 0)
            # print('g draw 6', frameCount, sin)
            popMatrix()

    def setNewTarget(self, t):
        self.target = t

    def animate(self):
        global glyphs
        
        if self.target is None:
            for g in glyphs:
                if g !=self:
                    _dir = PVector.sub(g.pos, self.pos)
                    _distSq = _dir.magSq()
                    _dir.normalize()
                    _dir.div(_distSq+0.001)
                    # _dir.mult(0.001)
                    self.speed.add(_dir)
                    # print(_dir)
                    
        if self.target is not None:
            dspeed = PVector.sub(self.target.pos, self.pos).mult(0.02)
            dist = self.pos.dist(self.target.pos)
            if dspeed.mag() > 20:
                dspeed.setMag(20)

            self.speed.add(dspeed)
            # self.deg += self.pos.x

            if dist < 0.4:
                self.stillFrames += 1
            else:
                self.stillFrames = 0
                
                
            
        else:
            self.stillFrames -= 1
            rnd = 1.0
            # self.speed.x += randomGaussian() * rnd
            # self.speed.y += randomGaussian() * rnd

        self.deg *= 0.991575
        self.speed.mult(0.872)
        self.pos = self.pos.add(self.speed)

    def canReuse(self):
        return self.target is None or self.stillFrames > minFramesStill



def makeLetters(poem):
    global letters, glyphs
    print('makeLetters 1', len(poem) )
            
    letters = [None] * len(poem)
    # print('makeLetters 1.0', len(poem) ) 
    # print('makeLetters 1.1', len(poem), len(letters))
    glyphs = [None] * len(poem)
    # print('makeLetters 1.2', len(poem), len(glyphs))
    x = 0.0
    y = 0.0

    maxX = 0.0
    maxY = 0.0
    
    print('makeLetters 2', x)

    for i in range(len(poem)):        
        _char = poem[i]
        w = textWidth(_char)
        # print('makeLetters 2.1', w)
        letters[i] = Letter(_char)
        
        letters[i].pos = PVector(x, y)

        glyphs[i] = Glyph(_char)
     
        glyphs[i].pos =  letters[i].pos.copy()
    

        if x > maxX:
            maxX = x
           
        if y > maxY:
            maxY = y
            # print('makeLetters 2, maxY=', maxY)
             
        x = x+w
        
        # print('makeLetters 3', x)
        
        if _char == '\n':            
            y = y + (lineHeight * text_size)
            # print('makeLetters 333', _char, x, y)
            x = 0.0
            # print('makeLetters 4433', _char, x, y)
            
        # print('makeLetters 3.1', glyphs[i].pos)
    
        
    # print('makeLetters 3', x)
    # Randomizing initial positions
    for g in glyphs:
        # print('makeLetters 3.1', g)
        g.pos = PVector(maxX * randomGaussian(), maxY * abs(randomGaussian()))
        g.deg = randomGaussian()*300.0

    # print('makeLetters 4', maxX, maxY)
    return PVector(maxX, maxY)



def setup():

    global poem, bbox, text_size, f, number_of_lines

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

    size(1080/2, 1350/2, JAVA2D)  # Instagram best
    textMode(MODEL)
    # size(600, 600)  # testing FPS-optimal
    background(255)
     
    pixelDensity(2)
    frameRate(30)
    smooth(4)
    
    print('setup 3')
    
    text_size = height // 40
    f = createFont("Literata-VariableFont_wght.ttf", text_size, True)
    print(f)

    textFont(f, text_size)
    textSize(text_size)
    
    
    bbox = makeLetters(poem)
    print('setup 5')


def findFreeGlyph(l, glyphs):
    # print('findFreeGlyph 0.1', l.c)
    for g in glyphs:
        # print('findFreeGlyph 0.2', g.c, g.canReuse())
        if g.canReuse() and g.c == l.c:
            return g



last_y_translation =0
 
def drawPoem():
    global last_y_translation
    global glyphs, letters, current_frame, currentLetter
    pushMatrix()
    
    new_y_translation = lerp(last_y_translation,  -letters[currentLetter].pos.y + height/2, 0.005)
    
    translate(0, new_y_translation)
    last_y_translation = new_y_translation
    # print('drawPoem 0')
    
    for g in glyphs:
        g.draw()         
    # print('drawPoem 0.1')

    if current_frame % 3 == 0:
        # print('drawPoem 0.2')
        cl = letters[currentLetter]
        # print('drawPoem 1', cl.c)
        cg = findFreeGlyph(cl, glyphs)
        # print('drawPoem 1.1', cl.c)
        if cg is not None:
            # print('drawPoem 2', cg.c)
            cg.setNewTarget(cl)
            # print('drawPoem 3', cg.c)
            currentLetter = (currentLetter + 1) % len(letters)
             

    popMatrix()


def draw():
    global current_frame
    current_frame = current_frame+1
    # print('draw 1')
    # Arrays.sort(glyphs, aGComparator);
    # glyphs = sorted(glyphs, lambda: g1, g2 : g1.c > g2.c))
    translate((width - bbox.x) / 2, (height - bbox.y) / 2) # ceter text on screen
    # print('draw 2')
    background(0)
    # print('draw 3')
    fill(255, 140)
    
    # print('draw 4')
    drawPoem()

    # if (frameCount < 3000 && SAVE_IMAGES)"
    #     saveFrame("poem_####.png")


 
