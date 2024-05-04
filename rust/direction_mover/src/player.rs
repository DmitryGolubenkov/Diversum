use crate::position::Position;
use crate::Direction;

pub struct Player {
    pub position: Position,
}

impl Player {
    pub fn go(&mut self, direction: Direction) {
        match direction {
            Direction::Up => self.position.y += 1,
            Direction::Down => self.position.y -= 1,
            Direction::Left => self.position.x -= 1,
            Direction::Right => self.position.x += 1,
        }
    }

    pub fn print_state(&mut self) {
        println!("Position is {0}", self.position);
    }
}
