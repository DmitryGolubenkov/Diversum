mod direction;
mod player;
mod position;

use crate::direction::Direction;
use crate::player::Player;
use crossterm::cursor;
use crossterm::event::{read, Event, KeyCode};
use crossterm::terminal::{Clear, ClearType::All};
use crossterm::ExecutableCommand;
use std::io::stdout;

fn main() {
    println!("Started!");
    let mut player = Player {
        position: position::Position { x: 0, y: 0 },
    };

    loop {
        // Get pressed key and move player
        let current_direction = get_direction();

        player.go(current_direction);

        // clear console

        _ = stdout().execute(Clear(All));
        _ = stdout().execute(cursor::MoveToPreviousLine(1));

        player.print_state();
    }
}

fn get_direction() -> Direction {
    let direction = loop {
        match read() {
            Ok(event) => match event {
                Event::Key(key_event) => match key_event.code {
                    KeyCode::Char('W') | KeyCode::Char('w') => break Direction::Up,
                    KeyCode::Char('S') | KeyCode::Char('s') => break Direction::Down,
                    KeyCode::Char('A') | KeyCode::Char('a') => break Direction::Left,
                    KeyCode::Char('D') | KeyCode::Char('d') => break Direction::Right,
                    KeyCode::Char('Q') | KeyCode::Char('q') => panic!("Expected quit"),
                    _ => continue,
                },
                _ => continue, // Ignore
            },
            Err(err) => {
                println!("Oops, Error reading values: {:?}", err);
                continue;
            }
        }
    };

    return direction;
}
