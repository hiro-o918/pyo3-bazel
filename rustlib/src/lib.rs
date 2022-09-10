use anyhow::Result;
use echo::v1::{echo_server, EchoRequest, EchoResponse};
pub mod echo {
    pub mod v1 {
        tonic::include_proto!("echo.v1");
        #[allow(dead_code)]
        pub const FILE_DESCRIPTOR_SET: &[u8] = tonic::include_file_descriptor_set!("echo_v1");
    }
}

pub struct Service {}

#[tonic::async_trait]
impl echo_server::Echo for Service {
    async fn echo(
        &self,
        request: tonic::Request<EchoRequest>,
    ) -> Result<tonic::Response<EchoResponse>, tonic::Status> {
        let request = request.into_inner();
        Ok(tonic::Response::new(EchoResponse {
            message: request.message,
        }))
    }
}
