use anyhow::{Context, Result};
use echo::v1::{echo_server, EchoRequest, EchoResponse};
use lightgbm::{Booster, Dataset};
use serde_json::json;

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

pub fn train_lightgbm() -> Result<Vec<f64>> {
    let data = vec![
        vec![1.0, 0.1, 0.2, 0.1],
        vec![0.7, 0.4, 0.5, 0.1],
        vec![0.9, 0.8, 0.5, 0.1],
        vec![0.2, 0.2, 0.8, 0.7],
        vec![0.1, 0.7, 1.0, 0.9],
    ];
    let label = vec![0.0, 0.0, 0.0, 1.0, 1.0];
    let dataset = Dataset::from_mat(data.clone(), label).unwrap();
    let params = json! {
       {
            "num_iterations": 3,
            "objective": "binary",
            "metric": "auc"
        }
    };
    let bst = Booster::train(dataset, &params).unwrap();
    let predictions = bst
        .predict(data)
        .context("failed to predict")?
        .into_iter()
        .flatten()
        .collect();
    Ok(predictions)
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_train_lightgbm() {
        let actual = train_lightgbm().unwrap();
        let expect = vec![0.4, 0.4, 0.4, 0.4, 0.4];
        assert_eq!(actual, expect);
    }
}
