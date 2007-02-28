# scriptedfun.com 1945 Shooting Mechanism Demo
# http://www.scriptedfun.com/
# December 11, 2006
# MIT License

# 1945.bmp
# taken from the Spritelib by Ari Feldman
# http://www.flyingyogi.com/fun/spritelib.html
# Common Public License

import os, pygame
from pygame.locals import *

# game constants
SCREENRECT = Rect(0, 0, 640, 480)

def imgcolorkey(image, colorkey):
    if colorkey is not None:
        if colorkey is -1:
            colorkey = image.get_at((0, 0))
        image.set_colorkey(colorkey, RLEACCEL)
    return image

def load_image(filename, colorkey = None):
    filename = os.path.join('data', filename)
    image = pygame.image.load(filename).convert()
    return imgcolorkey(image, colorkey)

class SpriteSheet:
    def __init__(self, filename):
        self.sheet = load_image(filename)
    def imgat(self, rect, colorkey = None):
        rect = Rect(rect)
        image = pygame.Surface(rect.size).convert()
        image.blit(self.sheet, (0, 0), rect)
        return imgcolorkey(image, colorkey)
    def imgsat(self, rects, colorkey = None):
        imgs = []
        for rect in rects:
            imgs.append(self.imgat(rect, colorkey))
        return imgs

# each type of game object gets an init and an
# update function. the update function is called
# once per frame, and it is when each object should
# change its current position and state

class Plane(pygame.sprite.Sprite):
    guns = [(17, 19), (39, 19)]
    reloadtime = 10
    def __init__(self):
        pygame.sprite.Sprite.__init__(self, self.containers)
        self.rect = self.image.get_rect()
        self.justfired = 0
        self.reloadtimer = 0
    def update(self):
        self.rect.center = pygame.mouse.get_pos()
        self.rect = self.rect.clamp(SCREENRECT)
        if self.reloadtimer > 0:
            self.reloadtimer = self.reloadtimer -1
        firing = pygame.mouse.get_pressed()[0]
        if firing and (not self.justfired or self.reloadtimer == 0):
            self.reloadtimer = self.reloadtime
            for gun in self.guns:
                Shot((self.rect.left + gun[0], self.rect.top + gun[1]))
        self.justfired = firing

class Shot(pygame.sprite.Sprite):
    speed = 20
    def __init__(self, pos):
        pygame.sprite.Sprite.__init__(self, self.containers)
        self.rect = self.image.get_rect()
        self.rect.center = pos
    def update(self):
        self.rect.move_ip(0, -self.speed)
        if self.rect.top < 0:
            self.kill()

def main():
    pygame.init()

    # set the display mode
    winstyle = 0
    bestdepth = pygame.display.mode_ok(SCREENRECT.size, winstyle, 32)
    screen = pygame.display.set_mode(SCREENRECT.size, winstyle, bestdepth)

    # load images, assign to sprite classes
    # (do this before the classes are used, after screen setup)
    spritesheet = SpriteSheet('1945.bmp')

    Shot.image = spritesheet.imgat((48, 176, 9, 20), -1)
    Plane.image = spritesheet.imgat((305, 113, 61, 49), -1)

    # decorate the game window
    pygame.display.set_caption('scriptedfun.com 1945 shooting mechanism demo')

    # initialize game groups
    shots = pygame.sprite.Group()
    all = pygame.sprite.RenderPlain()

    # assign default groups to each sprite class
    Plane.containers = all
    Shot.containers = shots, all

    clock = pygame.time.Clock()

    plane = Plane()

    while 1:

        # get input
        for event in pygame.event.get():
            if event.type == QUIT or (event.type == KEYDOWN and event.key == K_ESCAPE):
                return

        # update all the sprites
        all.update()

        # draw the scene
        screen.fill((0, 0, 0))
        all.draw(screen)
        pygame.display.flip()

        clock.tick(30)

if __name__ == '__main__': main()
