use zero2prod::{
    configuration::{self, get_configuration},
    run,
};

#[tokio::main]
async fn main() -> std::io::Result<()> {
    // panic if we can't read configuration
    let configuration = get_configuration().expect("Failed to read configuration.");
    let address = format!("127.0.0.1:{}", configuration.application_port);
    let listener = std::net::TcpListener::bind(&address)?;
    run(listener)?.await
}
