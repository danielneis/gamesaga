#! /usr/bin/env python

# scriptedfun.com 1945
# http://www.scriptedfun.com/
# June 5, 2006
# MIT License

# 1945.bmp
# taken from the Spritelib by Ari Feldman
# http://www.flyingyogi.com/fun/spritelib.html
# Common Public License

import math, os, pygame, random
from pygame.locals import *

# game constants
SCREENRECT = Rect(0, 0, 640, 480)

def load_sound(filename):
    filename = os.path.join('data', filename)
    return pygame.mixer.Sound(filename)

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

class Arena:
    speed = 1
    enemyprob = 22
    def __init__(self, enemies, shots):
        w = SCREENRECT.width
        h = SCREENRECT.height
        self.tileside = self.oceantile.get_height()
        self.counter = 0
        self.ocean = pygame.Surface((w, h + self.tileside)).convert()
        for x in range(w/self.tileside):
            for y in range(h/self.tileside + 1):
                self.ocean.blit(self.oceantile, (x*self.tileside, y*self.tileside))
        self.enemies = enemies
        self.shots = shots
    def offset(self):
        self.counter = (self.counter - self.speed) % self.tileside
        return (0, self.counter, SCREENRECT.width, SCREENRECT.height)
    def update(self):
        # decreasing enemyprob increases the
        # probability of new enemies appearing
        if not random.randrange(self.enemyprob):
            Enemy()
        for enemy in pygame.sprite.groupcollide(self.shots, self.enemies, 1, 1).keys():
            Explosion(enemy)

# each type of game object gets an init and an
# update function. the update function is called
# once per frame, and it is when each object should
# change its current position and state

class Plane(pygame.sprite.Sprite):
    crect = (14, 1, 29, 39)
    guns = [(17, 19), (39, 19)]
    animcycle = 1
    reloadtime = 15
    def __init__(self, arena, obstacles):
        pygame.sprite.Sprite.__init__(self, self.containers)
        self.oninvincible()
        self.image = self.images[0]
        self.counter = 0
        self.maxcount = len(self.images)*self.animcycle
        self.rect = self.image.get_rect()
        self.arena = arena
        self.obstacles = obstacles
        self.justfired = 0
        self.reloadtimer = 0
    def oninvincible(self):
        self.images = self.transparents
        self.invincible = True
    def offinvincible(self):
        self.images = self.opaques
        self.invincible = False
    def update(self):
        self.rect.center = pygame.mouse.get_pos()
        self.rect = self.rect.clamp(SCREENRECT)
        self.counter = (self.counter + 1) % self.maxcount
        self.image = self.images[self.counter/self.animcycle]
        if self.reloadtimer > 0:
            self.reloadtimer = self.reloadtimer -1
        firing = pygame.mouse.get_pressed()[0]
        if firing and (not self.justfired or self.reloadtimer == 0):
            if self.invincible:
                self.offinvincible()
            self.reloadtimer = self.reloadtime
            for gun in self.guns:
                Shot((self.rect.left + gun[0], self.rect.top + gun[1]))
        self.justfired = firing
        # shrink rect for collision detection
        if not self.invincible:
            oldrect = self.rect
            self.rect = Rect(*self.crect)
            self.rect.topleft = (oldrect.left + self.crect[0], oldrect.top + self.crect[1])
            if pygame.sprite.spritecollide(self, self.obstacles, 1):
                self.oninvincible()
                Planeexplosion(self)
            self.rect = oldrect
        self.arena.update()

class Shot(pygame.sprite.Sprite):
    speed = 9
    def __init__(self, pos):
        pygame.sprite.Sprite.__init__(self, self.containers)
        self.rect = self.image.get_rect()
        self.rect.center = pos
    def update(self):
        self.rect.move_ip(0, -self.speed)
        if self.rect.top < 0:
            self.kill()

class Bomb(pygame.sprite.Sprite):
    speed = 5
    def __init__(self, gun):
        pygame.sprite.Sprite.__init__(self, self.containers)
        self.rect = self.image.get_rect()
        self.rect.centerx = gun[0]
        self.rect.centery = gun[1]
        self.setfp()
        angle = math.atan2(self.plane.rect.centery - gun[1], self.plane.rect.centerx - gun[0])
        self.fpdy = self.speed * math.sin(angle)
        self.fpdx = self.speed * math.cos(angle)
    def setfp(self):
        """use whenever usual integer rect values are adjusted"""
        self.fpx = self.rect.centerx
        self.fpy = self.rect.centery
    def setint(self):
        """use whenever floating point rect values are adjusted"""
        self.rect.centerx = self.fpx
        self.rect.centery = self.fpy
    def update(self):
        self.fpx = self.fpx + self.fpdx
        self.fpy = self.fpy + self.fpdy
        self.setint()
        if not SCREENRECT.contains(self.rect):
            self.kill()

class Enemy(pygame.sprite.Sprite):
    gun = (16, 19)
    animcycle = 2
    speed = 3
    shotprob = 350
    def __init__(self):
        pygame.sprite.Sprite.__init__(self, self.containers)
        self.images = random.choice(self.imagesets)
        self.image = self.images[0]
        self.counter = 0
        self.maxcount = len(self.images)*self.animcycle
        self.rect = self.image.get_rect()
        self.rect.left = random.randrange(SCREENRECT.width - self.rect.width)
        self.rect.bottom = SCREENRECT.top
    def update(self):
        self.rect.move_ip(0, self.speed)
        self.counter = (self.counter + 1) % self.maxcount
        self.image = self.images[self.counter/self.animcycle]
        if self.rect.top > SCREENRECT.bottom:
            self.kill()
        if not random.randrange(self.shotprob):
            Bomb((self.rect.left + self.gun[0], self.rect.top + self.gun[1]))

class Explosion(pygame.sprite.Sprite):
    animcycle = 4
    def __init__(self, enemy):
        pygame.sprite.Sprite.__init__(self, self.containers)
        self.image = self.images[0]
        self.counter = 0
        self.maxcount = len(self.images)*self.animcycle
        self.rect = self.image.get_rect()
        self.rect.center = enemy.rect.center
    def update(self):
        self.image = self.images[self.counter/self.animcycle]
        self.counter = self.counter + 1
        if self.counter == self.maxcount:
            self.kill()

class Planeexplosion(pygame.sprite.Sprite):
    animcycle = 4
    def __init__(self, plane):
        pygame.sprite.Sprite.__init__(self, self.containers)
        self.image = self.images[0]
        self.counter = 0
        self.maxcount = len(self.images)*self.animcycle
        self.rect = self.image.get_rect()
        self.rect.center = plane.rect.center
    def update(self):
        self.image = self.images[self.counter/self.animcycle]
        self.counter = self.counter + 1
        if self.counter == self.maxcount:
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

    Arena.oceantile = spritesheet.imgat((268, 367, 32, 32))
    Shot.image = spritesheet.imgat((48, 176, 9, 20), -1)
    Bomb.image = spritesheet.imgat((278, 113, 13, 13), -1)
    Plane.opaques = spritesheet.imgsat([(305, 113, 61, 49),
                                        (305, 179, 61, 49),
                                        (305, 245, 61, 49)],
                                       -1)
    Plane.transparents = spritesheet.imgsat([(305, 113, 61, 49),
                                             (305, 179, 61, 49),
                                             (305, 245, 61, 49)],
                                            -1)
    for image in Plane.transparents:
        image.set_alpha(85)
    Explosion.images = spritesheet.imgsat([(70, 169, 32, 32),
                                           (103, 169, 32, 32),
                                           (136, 169, 32, 32),
                                           (169, 169, 32, 32),
                                           (202, 169, 32, 32),                                           
                                           (235, 169, 32, 32)],
                                          -1)

    Planeexplosion.images = spritesheet.imgsat([(4, 301, 65, 65),
                                                (70, 301, 65, 65),
                                                (136, 301, 65, 65),
                                                (202, 301, 65, 65),
                                                (268, 301, 65, 65),
                                                (334, 301, 65, 65),
                                                (400, 301, 65, 65)],
                                               -1)

    # 0 - "dark" green
    # 1 - white
    # 2 - "light" green
    # 3 - blue
    # 4 - orange
    Enemy.imagesets = [
        spritesheet.imgsat([(4, 466, 32, 32), (37, 466, 32, 32), (70, 466, 32, 32)], -1),
        spritesheet.imgsat([(103, 466, 32, 32), (136, 466, 32, 32), (169, 466, 32, 32)], -1),
        spritesheet.imgsat([(202, 466, 32, 32), (235, 466, 32, 32), (268, 466, 32, 32)], -1),
        spritesheet.imgsat([(301, 466, 32, 32), (334, 466, 32, 32), (367, 466, 32, 32)], -1),
        spritesheet.imgsat([(4, 499, 32, 32), (37, 499, 32, 32), (70, 499, 32, 32)], -1)
        ]

    # decorate the game window
    pygame.display.set_caption('scriptedfun.com 1945')

    # initialize game groups
    shots = pygame.sprite.Group()
    bombs = pygame.sprite.Group()
    enemies = pygame.sprite.Group()
    obstacles = pygame.sprite.Group()
    islands = pygame.sprite.RenderPlain()
    all = pygame.sprite.RenderPlain()

    # assign default groups to each sprite class
    Plane.containers = all
    Shot.containers = shots, all
    Enemy.containers = enemies, obstacles, all
    Bomb.containers = bombs, obstacles, all
    Explosion.containers = all
    Planeexplosion.containers = all

    clock = pygame.time.Clock()

    # initialize our starting sprites
    arena = Arena(enemies, shots)
    plane = Plane(arena, obstacles)
    Bomb.plane = plane

    while 1:

        # get input
        for event in pygame.event.get():
            if event.type == QUIT or (event.type == KEYDOWN and event.key == K_ESCAPE):
                return
        keystate = pygame.key.get_pressed()

        # update all the sprites
        all.update()

        # draw the scene
        screen.blit(arena.ocean, (0, 0), arena.offset())
        islands.draw(screen)
        all.draw(screen)
        pygame.display.flip()

        # cap the framerate
        clock.tick(60)

if __name__ == '__main__': main()
