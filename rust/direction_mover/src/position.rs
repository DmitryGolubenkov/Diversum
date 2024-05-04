use std::fmt;
use std::fmt::{Display, Formatter};

pub struct Position {
    pub x: i32,
    pub y: i32,
}

impl Display for Position {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        write!(f, "x: {0}, y: {1}", self.x, self.y)
    }
}
