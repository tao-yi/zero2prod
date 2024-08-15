use secrecy::ExposeSecret;
use sqlx::PgPool;
use tracing::info;
use zero2prod::configuration::get_configuration;
use zero2prod::startup::run;
use zero2prod::telemetry::{get_subscriber, init_subscriber};

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let subscriber = get_subscriber("zero2prod".into(), "info".into(), std::io::stdout);
    init_subscriber(subscriber);

    // panic if we can't read configuration
    let configuration = get_configuration().expect("Failed to read configuration.");
    info!("config: {:#?}", configuration);

    // connect_lazy() - it will only try to establish a connection when the pool is used for the first time.
    // No longer async, given that we don't actually try to connect!
    let connection_pool =
        PgPool::connect_lazy(configuration.database.connection_string().expose_secret())
            .expect("Failed to connect to Postgres.");
    let address = format!("127.0.0.1:{}", configuration.application.port);
    let listener = std::net::TcpListener::bind(&address)?;
    run(listener, connection_pool)?.await?;
    Ok(())
}
