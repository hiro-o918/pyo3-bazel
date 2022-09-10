use std::env;
use std::path::PathBuf;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    let echo_proto = PathBuf::from(
        env::var("ECHO_V1_PROTO").unwrap_or_else(|_| "../proto/v1/echo_v1.proto".to_string()),
    );
    let proto_root = env::var("PROTO_ROOT").map_or_else(
        |_| PathBuf::from("../proto"),
        |p| PathBuf::from(p).parent().unwrap().to_owned(),
    );

    tonic_build::configure()
        .build_server(true)
        .file_descriptor_set_path(out_dir.join("echo_v1.bin"))
        .compile(&[echo_proto], &[proto_root])?;
    Ok(())
}
