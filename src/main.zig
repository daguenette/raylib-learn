const std = @import("std");
const rl = @import("raylib");

// ----------------------------------------------------------
// Types and Structures Definition
// ----------------------------------------------------------

const GameScreen = enum {
    logo,
    title,
    gameplay,
    ending,
};

// ----------------------------------------------------------
// Program main entry point
// ----------------------------------------------------------

pub fn main() !void {
    // Initialization
    const screenWidth: i32 = 800;
    const screenHeight: i32 = 450;

    rl.initWindow(screenWidth, screenHeight, "Project: Blocks Game");

    var screen: GameScreen = .logo; // Current game screen state

    var framesCounter: i32 = 0; // General purpose frames counter
    //var gameResult: i32 = -1; // Game result: 0 - Loose | 1 - Win | -1 - else
    const gamePaused: bool = false; // Game paused state toggle

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
                rl.drawText("Logo Screen", 20, 20, 40, rl.Color.light_gray);
                rl.drawText("WAIT for 3 SECONDS...", 290, 220, 20, rl.Color.gray);
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
                rl.drawRectangle(0, 0, screenWidth, screenHeight, rl.Color.purple);
                rl.drawText("Gameplay Screen", 20, 20, 40, rl.Color.maroon);
                rl.drawText(
                    "Press TAB to JUMP to ENDING SCREEN",
                    120,
                    220,
                    20,
                    rl.Color.maroon,
                );
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
