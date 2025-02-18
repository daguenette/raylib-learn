const std = @import("std");
const rl = @import("raylib");

// ----------------------------------------------------------
// Useful values definitions
// ----------------------------------------------------------

const PLAYER_LIFES: i32 = 5;
const BRICKS_LINES: i32 = 5;
const BRICKS_PER_LINE: i32 = 20;
const BRICKS_POSITION_Y: i32 = 50;

// ----------------------------------------------------------
// Types and Structures Definition
// ----------------------------------------------------------

const GameScreen = enum {
    logo,
    title,
    gameplay,
    ending,
};

const Player = struct {
    position: rl.Vector2,
    speed: rl.Vector2,
    size: rl.Vector2,
    lifes: usize,
};

const Ball = struct {
    position: rl.Vector2,
    speed: rl.Vector2,
    radius: f32,
    active: bool,
};

const Brick = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    bounds: rl.Rectangle,
    active: bool,
};

// ----------------------------------------------------------
// Program main entry point
// ----------------------------------------------------------

pub fn main() !void {
    // Initialization
    const screenWidth: i32 = 800;
    const screenHeight: i32 = 450;
    rl.initWindow(screenWidth, screenHeight, "Project: Blocks Game");

    // Game required variables (resources)
    var screen: GameScreen = .logo;
    var framesCounter: i32 = 0;
    //var gameResult: i32 = -1;
    const gamePaused: bool = false;

    // Initialize player
    const player = Player{
        .position = rl.Vector2.init(screenWidth / 2, screenHeight * 7 / 8),
        .speed = rl.Vector2.init(8.0, 0.0),
        .size = rl.Vector2.init(100, 24),
        .lifes = PLAYER_LIFES,
    };

    // Initialize ball
    const radius: f32 = 10.0;
    const ball = Ball{
        .radius = radius,
        .active = false,
        .speed = rl.Vector2.init(4.0, 4.0),
        .position = rl.Vector2.init(
            player.position.x + player.size.x / 2,
            player.position.y - radius * 2,
        ),
    };

    // Initialize bricks
    var bricks: [BRICKS_LINES][BRICKS_PER_LINE]Brick = undefined;
    for (0..BRICKS_LINES) |j| {
        const J: f32 = @floatFromInt(j);
        for (0..BRICKS_PER_LINE) |i| {
            const I: f32 = @floatFromInt(i);
            bricks[j][i].size = rl.Vector2.init(screenWidth / BRICKS_PER_LINE, 20);
            bricks[j][i].position = rl.Vector2.init(
                I * bricks[j][i].size.x,
                J * bricks[j][i].size.y + BRICKS_POSITION_Y,
            );
            bricks[j][i].bounds = rl.Rectangle.init(
                bricks[j][i].position.x,
                bricks[j][i].position.y,
                bricks[j][i].size.x,
                bricks[j][i].size.y,
            );
            bricks[j][i].active = true;
        }
    }

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        switch (screen) {
            GameScreen.logo => {
                framesCounter += 1;
                if (framesCounter > 180) {
                    screen = GameScreen.title;
                    framesCounter = 0;
                }
            },
            GameScreen.title => {
                framesCounter += 1;
                if (rl.isKeyPressed(.tab)) {
                    screen = GameScreen.gameplay;
                }
            },
            GameScreen.gameplay => {
                if (!gamePaused) {}

                if (rl.isKeyPressed(.tab)) {
                    screen = GameScreen.ending;
                }
            },
            GameScreen.ending => {
                framesCounter += 1;
                if (rl.isKeyPressed(.tab)) {
                    screen = GameScreen.title;
                }
            },
        }

        rl.beginDrawing();
        rl.clearBackground(rl.Color.ray_white);

        switch (screen) {
            GameScreen.logo => {
                rl.drawText("LOGO SCREEN", 20, 20, 40, rl.Color.light_gray);
            },
            GameScreen.title => {
                rl.drawRectangle(0, 0, screenWidth, screenHeight, rl.Color.green);
                rl.drawText("Title Screen", 20, 20, 40, rl.Color.dark_green);
                rl.drawText(
                    "Press TAB to JUMP to GAMEPLAY SCREEN",
                    120,
                    220,
                    20,
                    rl.Color.light_gray,
                );
            },
            GameScreen.gameplay => {
                rl.drawRectangle(
                    @intFromFloat(player.position.x),
                    @intFromFloat(player.position.y),
                    @intFromFloat(player.size.x),
                    @intFromFloat(player.size.y),
                    rl.Color.black,
                );
                rl.drawCircleV(ball.position, ball.radius, rl.Color.maroon);

                for (0..BRICKS_LINES) |j| {
                    for (0..BRICKS_PER_LINE) |i| {
                        if (bricks[j][i].active) {
                            if ((i + j) % 2 == 0) {
                                rl.drawRectangle(
                                    @intFromFloat(bricks[j][i].position.x),
                                    @intFromFloat(bricks[j][i].position.y),
                                    @intFromFloat(bricks[j][i].size.x),
                                    @intFromFloat(bricks[j][i].size.y),
                                    rl.Color.gray,
                                );
                            } else {
                                rl.drawRectangle(
                                    @intFromFloat(bricks[j][i].position.x),
                                    @intFromFloat(bricks[j][i].position.y),
                                    @intFromFloat(bricks[j][i].size.x),
                                    @intFromFloat(bricks[j][i].size.y),
                                    rl.Color.dark_gray,
                                );
                            }
                        }
                    }
                }

                for (0..player.lifes) |i| {
                    const I: f32 = @floatFromInt(i);
                    rl.drawRectangle(
                        @intFromFloat(20 + 40 * I),
                        screenHeight - 30,
                        35,
                        10,
                        rl.Color.light_gray,
                    );
                }

                if (gamePaused) {
                    rl.drawText(
                        "Game Paused",
                        screenWidth / 2 - rl.measureText("Game Paused", 40) / 2,
                        screenHeight / 2 + 60,
                        40,
                        rl.Color.gray,
                    );
                }
            },
            GameScreen.ending => {
                rl.drawRectangle(0, 0, screenWidth, screenHeight, rl.Color.blue);
                rl.drawText("ENDING SCREEN", 20, 20, 40, rl.Color.dark_blue);
                rl.drawText(
                    "PRESS TAB to RETURN to TITLE SCREEN",
                    120,
                    220,
                    20,
                    rl.Color.dark_blue,
                );
            },
        }

        rl.endDrawing();
    }

    rl.closeWindow();
}
