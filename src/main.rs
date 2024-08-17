use sqlx::postgres::PgPoolOptions;
use std::time::Duration;
use tracing::info;
use zero2prod::configuration::{get_configuration, ApplicationSettings};
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
    let connection_pool = PgPoolOptions::new()
        .max_connections(1000)
        .acquire_timeout(Duration::from_secs(2))
        .connect_with(configuration.database.with_db())
        .await
        .expect("Failed to connect to Postgres.");

    let ApplicationSettings { host, port } = configuration.application;
    let address = format!("{}:{}", host, port);
    let listener = std::net::TcpListener::bind(&address)?;
    run(listener, connection_pool)?.await?;
    Ok(())
}
