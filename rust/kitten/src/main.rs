use std::env;
use std::fs;
use std::io::BufRead;
use std::io::BufReader;
use std::io::BufWriter;
use std::io::Read;
use std::io::Write;
use std::process;
fn main() {
    // collect args from cli environment
    let args: Vec<String> = env::args().collect();

    if args.len() == 1 {
        eprintln!("ERROR: not enough arguments!");
        process::exit(1)
    }

    

    // get file path
    let file_path = &args[1];
    if args.len() > 2 {
        let unoptimized = &args[2];

        if unoptimized == "--unoptimized" {
            // simple implementation - read to string. Good luck with 1gb files consuming 1 gb of ram
            simple_print(file_path);
            process::exit(0);
        }

    }

    stream_print(&file_path);
}

fn stream_print(file_path: &str) {
    // Open file for read
    let file = match fs::File::open(file_path) {
        Ok(f) => f,
        Err(err) => {
            eprintln!("{}", err);
            process::exit(1);
        }
    };

    // Create buffer
    let mut reader = BufReader::new(file);

    // Create console writer
    let stdout = std::io::stdout();
    let mut writer = BufWriter::new(stdout.lock());

    let mut buffer = Vec::new();

    loop {
        // clear buffer
        buffer.clear();

        // read some bytes
        let bytes_read = reader
            .by_ref()
            .take(1024)
            .read_until(0, &mut buffer)
            .expect("Error during reading file!");
        if bytes_read == 0 {
            break;
        }

        writer.write_all(&buffer).expect("Oops, error during writing");
    }
}

fn simple_print(path: &String) {
    let contents = match fs::read_to_string(path) {
        Ok(c) => c,
        Err(err) => {
            eprintln!("{}", err);
            process::exit(1);
        }
    };
    print!("{}", contents);
}
